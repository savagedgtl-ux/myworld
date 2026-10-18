import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as logger from 'firebase-functions/logger';
import { db, FieldValue, messaging, REGION, Timestamp } from '../lib/admin';
import { nextOccurrence, RepeatRule } from '../lib/recurrence';

const TEXT: Record<string, { title: string; generic: string; due: string }> = {
  sr: { title: 'MyWorld+ podsetnik', generic: 'Imaš podsetnik koji zahteva pažnju.', due: 'Rok: ' },
  en: { title: 'MyWorld+ reminder', generic: 'You have a reminder that needs attention.', due: 'Due: ' },
  de: { title: 'MyWorld+ Erinnerung', generic: 'Du hast eine Erinnerung, die Aufmerksamkeit braucht.', due: 'Fällig: ' },
  fr: { title: 'Rappel MyWorld+', generic: 'Vous avez un rappel qui demande votre attention.', due: 'Échéance : ' },
  es: { title: 'Recordatorio de MyWorld+', generic: 'Tienes un recordatorio que requiere tu atención.', due: 'Vence: ' },
  ru: { title: 'Напоминание MyWorld+', generic: 'У вас есть напоминание, требующее внимания.', due: 'Срок: ' },
};

async function recipientsFor(r: FirebaseFirestore.DocumentData): Promise<string[]> {
  const ids = new Set<string>([r.ownerUid]);
  if (r.familyId && r.privacyLevel !== 'private') {
    const members = await db.collection('families').doc(r.familyId).collection('members').where('status', '==', 'active').get();
    for (const m of members.docs) {
      if (r.privacyLevel === 'family' || (r.sharedWith ?? []).includes(m.id)) ids.add(m.id);
    }
  }
  return [...ids];
}

async function notify(uid: string, r: FirebaseFirestore.DocumentData, reminderId: string) {
  const user = await db.collection('users').doc(uid).get();
  const pref = user.get('preferredLanguage');
  const lang = typeof pref === 'string' && Object.hasOwn(TEXT, pref) ? pref : 'sr';
  // Default is a generic text so lock-screen previews never reveal private details.
  const showDetails = user.get('notificationPreview') === 'detailed';
  const t = TEXT[lang];
  const devices = await db.collection('users').doc(uid).collection('devices').get();
  // Firebase Installation IDs (direct-send targets registered by the app).
  const fids = devices.docs.map((d) => d.get('fid')).filter(Boolean);
  if (fids.length === 0) return;

  const res = await messaging().sendEachForMulticast({
    fids,
    notification: { title: t.title, body: showDetails ? String(r.title).slice(0, 120) : t.generic },
    data: { type: 'reminder', reminderId },
    android: { priority: 'high', notification: { channelId: 'reminders' } },
    apns: { payload: { aps: { sound: 'default' } } },
  });
  // Clean up dead tokens.
  await Promise.all(res.responses.map((x, i) => {
    const code = x.error?.code ?? '';
    if (code.includes('not-registered') || code.includes('invalid-registration') || code.includes('invalid-argument')) {
      return devices.docs[i].ref.delete();
    }
    return null;
  }));
}

/**
 * Sends due reminders. Idempotent: each occurrence has a key
 * (reminderId:nextNotifyAt) claimed in a transaction before sending, so a retried
 * or overlapping run never sends the same occurrence twice.
 */
export const dispatchReminders = onSchedule({ schedule: 'every 5 minutes', region: REGION, retryCount: 0 }, async () => {
  const now = Date.now();
  const due = await db.collection('reminders')
    .where('status', '==', 'active').where('nextNotifyAt', '<=', Timestamp.fromMillis(now)).limit(500).get();

  let sent = 0;
  for (const doc of due.docs) {
    const claimed = await db.runTransaction(async (tx) => {
      const fresh = await tx.get(doc.ref);
      const r = fresh.data();
      if (!r || r.status !== 'active' || !r.nextNotifyAt || r.nextNotifyAt.toMillis() > now) return null;
      const key = `${doc.id}:${r.nextNotifyAt.toMillis()}`;
      if (r.lastSentKey === key) return null;

      const lead = Number(r.leadTimeMinutes ?? 0) * 60_000;
      const next = nextOccurrence(r.dueAt.toMillis(), (r.repeatRule ?? 'none') as RepeatRule, r.timezone || 'UTC', now + lead);
      const update: Record<string, unknown> = { lastSentKey: key, lastSentAt: FieldValue.serverTimestamp() };
      if (next != null) {
        update.dueAt = Timestamp.fromMillis(next);
        update.nextNotifyAt = Timestamp.fromMillis(next - lead);
      } else {
        update.nextNotifyAt = null;
      }
      tx.update(doc.ref, update);
      return r;
    });
    if (!claimed) continue;
    try {
      for (const uid of await recipientsFor(claimed)) await notify(uid, claimed, doc.id);
      sent++;
    } catch (e) {
      // At-most-once delivery: we prefer a missed push over a duplicate.
      logger.error('reminder_send_failed', { reminderId: doc.id, error: String(e) });
    }
  }
  logger.info('reminders_dispatched', { candidates: due.size, sent });
});
