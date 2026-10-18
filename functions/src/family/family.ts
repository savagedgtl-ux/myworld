import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { randomBytes, timingSafeEqual } from 'node:crypto';
import { audit, callableOpts, db, FieldValue, requireAuth, sha256, str, Timestamp } from '../lib/admin';
import { getEntitlement, recomputeEntitlement, recomputeUsage } from '../lib/entitlements';
import { INVITATION_TTL_DAYS, PLANS } from '../plans';

const INVITE_BASE = process.env.INVITE_LINK_BASE || 'https://myworld-b0330.web.app/invite';
const MAX_FAILED_ATTEMPTS = 5;
const COLLECTIONS_WITH_PRIVACY = ['documents', 'assets', 'vehicles', 'vehicleRecords', 'reminders', 'walletCards', 'businessCards'];

async function memberDoc(fid: string, uid: string) {
  return db.collection('families').doc(fid).collection('members').doc(uid).get();
}

async function requireManager(fid: string, uid: string) {
  const m = await memberDoc(fid, uid);
  if (!m.exists || m.get('status') !== 'active' || !['owner', 'admin'].includes(m.get('role'))) {
    throw new HttpsError('permission-denied', 'not_family_manager');
  }
  return m;
}

async function familyCapacity(fid: string): Promise<number> {
  const fam = await db.collection('families').doc(fid).get();
  const ent = await getEntitlement(fam.get('planOwnerUid'));
  return PLANS[ent.planId].isFamily ? PLANS[ent.planId].maxFamilyMembers : 0;
}

/**
 * When a member leaves or is removed, their records stop being visible to
 * the family (reverted to private) and they are removed from others' sharedWith.
 */
async function detachMemberData(fid: string, uid: string) {
  for (const col of COLLECTIONS_WITH_PRIVACY) {
    const own = await db.collection(col).where('ownerUid', '==', uid).where('familyId', '==', fid).get();
    let batch = db.batch();
    let n = 0;
    for (const d of own.docs) {
      batch.update(d.ref, { familyId: null, privacyLevel: 'private', sharedWith: [], updatedAt: FieldValue.serverTimestamp() });
      if (++n % 400 === 0) { await batch.commit(); batch = db.batch(); }
    }
    const sharedToThem = await db.collection(col).where('familyId', '==', fid).where('sharedWith', 'array-contains', uid).get();
    for (const d of sharedToThem.docs) {
      batch.update(d.ref, { sharedWith: FieldValue.arrayRemove(uid) });
      if (++n % 400 === 0) { await batch.commit(); batch = db.batch(); }
    }
    await batch.commit();
  }
}

export const createFamily = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const name = str((req.data as any)?.name, 60, 'name');
  const ent = await recomputeEntitlement(uid);
  if (ent.familyId) throw new HttpsError('failed-precondition', 'already_in_family');
  if (!ent.canCreateFamily) throw new HttpsError('permission-denied', 'family_plan_required');

  const famRef = db.collection('families').doc();
  await db.runTransaction(async (tx) => {
    const user = await tx.get(db.collection('users').doc(uid));
    if (user.get('activeFamilyId')) throw new HttpsError('failed-precondition', 'already_in_family');
    tx.set(famRef, {
      familyId: famRef.id, name, ownerUid: uid, planOwnerUid: uid, status: 'active', memberCount: 1,
      createdAt: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp(),
    });
    tx.set(famRef.collection('members').doc(uid), {
      uid, role: 'owner', status: 'active', joinedAt: FieldValue.serverTimestamp(), invitedBy: null,
      displayName: user.get('displayName') ?? null, permissions: { manageMembers: true, manageProfiles: true },
    });
    tx.update(user.ref, { activeFamilyId: famRef.id });
  });
  await recomputeEntitlement(uid);
  await recomputeUsage(famRef.id);
  await audit('family_created', uid, { familyId: famRef.id });
  return { familyId: famRef.id };
});

export const createInvitation = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const data = (req.data ?? {}) as { familyId?: string; email?: string };
  const fid = str(data.familyId, 128, 'familyId');
  const email = data.email ? str(data.email, 254, 'email').toLowerCase() : null;
  if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) throw new HttpsError('invalid-argument', 'invalid_email');

  await requireManager(fid, uid);
  const ent = await recomputeEntitlement(uid);
  if (!ent.canInviteMembers) throw new HttpsError('permission-denied', 'family_plan_required');

  const capacity = await familyCapacity(fid);
  const [active, pending] = await Promise.all([
    db.collection('families').doc(fid).collection('members').where('status', '==', 'active').count().get(),
    db.collection('familyInvitations').where('familyId', '==', fid).where('status', '==', 'pending').get(),
  ]);
  const livePending = pending.docs.filter((d) => d.get('expiresAt').toMillis() > Date.now()).length;
  if (active.data().count + livePending >= capacity) throw new HttpsError('resource-exhausted', 'family_full');

  const token = randomBytes(32).toString('base64url');
  const ref = db.collection('familyInvitations').doc();
  await ref.set({
    familyId: fid, invitedBy: uid, targetEmail: email, tokenHash: sha256(token), status: 'pending',
    failedAttempts: 0, expiresAt: Timestamp.fromMillis(Date.now() + INVITATION_TTL_DAYS * 86400_000),
    createdAt: FieldValue.serverTimestamp(), acceptedAt: null,
  });
  await audit('invitation_created', uid, { familyId: fid, invitationId: ref.id, hasEmail: email != null });
  // The plaintext token is returned once and never stored.
  return { invitationId: ref.id, link: `${INVITE_BASE}?i=${ref.id}&t=${token}`, expiresInDays: INVITATION_TTL_DAYS };
});

export const revokeInvitation = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const id = str((req.data as any)?.invitationId, 128, 'invitationId');
  const inv = await db.collection('familyInvitations').doc(id).get();
  if (!inv.exists) throw new HttpsError('not-found', 'invitation_not_found');
  await requireManager(inv.get('familyId'), uid);
  await inv.ref.update({ status: 'revoked' });
  await audit('invitation_revoked', uid, { invitationId: id });
  return { ok: true };
});

/** Lets the invitee see which family invited them before accepting. */
export const previewInvitation = onCall(callableOpts, async (req) => {
  requireAuth(req);
  const { invitationId, token } = (req.data ?? {}) as { invitationId?: string; token?: string };
  const inv = await db.collection('familyInvitations').doc(str(invitationId, 128, 'invitationId')).get();
  if (!inv.exists || !tokenMatches(inv.get('tokenHash'), str(token, 128, 'token'))) {
    throw new HttpsError('not-found', 'invitation_invalid');
  }
  if (inv.get('status') !== 'pending' || inv.get('expiresAt').toMillis() < Date.now()) {
    throw new HttpsError('failed-precondition', 'invitation_expired');
  }
  const fam = await db.collection('families').doc(inv.get('familyId')).get();
  const inviter = await db.collection('users').doc(inv.get('invitedBy')).get();
  return { familyName: fam.get('name'), inviterName: inviter.get('displayName') ?? null };
});

function tokenMatches(hash: string, token: string): boolean {
  const a = Buffer.from(hash, 'hex');
  const b = Buffer.from(sha256(token), 'hex');
  return a.length === b.length && timingSafeEqual(a, b);
}

export const respondToInvitation = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const { invitationId, token, accept } = (req.data ?? {}) as { invitationId?: string; token?: string; accept?: boolean };
  const invRef = db.collection('familyInvitations').doc(str(invitationId, 128, 'invitationId'));
  const tok = str(token, 128, 'token');
  const email = String(req.auth?.token?.email ?? '').toLowerCase();
  const emailVerified = req.auth?.token?.email_verified === true;

  const pre = await invRef.get();
  if (!pre.exists) throw new HttpsError('not-found', 'invitation_invalid');
  if (!tokenMatches(pre.get('tokenHash'), tok)) {
    const attempts = Number(pre.get('failedAttempts') ?? 0) + 1;
    await invRef.update({ failedAttempts: attempts, ...(attempts >= MAX_FAILED_ATTEMPTS ? { status: 'revoked' } : {}) });
    throw new HttpsError('not-found', 'invitation_invalid');
  }
  const fid: string = pre.get('familyId');
  const capacity = accept ? await familyCapacity(fid) : 0;

  await db.runTransaction(async (tx) => {
    const inv = await tx.get(invRef);
    if (inv.get('status') !== 'pending') throw new HttpsError('failed-precondition', 'invitation_used');
    if (inv.get('expiresAt').toMillis() < Date.now()) {
      tx.update(invRef, { status: 'expired' });
      return;
    }
    const target = inv.get('targetEmail');
    if (target && (!emailVerified || target !== email)) throw new HttpsError('permission-denied', 'invitation_email_mismatch');

    if (!accept) {
      tx.update(invRef, { status: 'declined', respondedBy: uid, acceptedAt: null });
      return;
    }
    const userRef = db.collection('users').doc(uid);
    const famRef = db.collection('families').doc(fid);
    const [user, fam, existing] = await Promise.all([
      tx.get(userRef), tx.get(famRef), tx.get(famRef.collection('members').doc(uid)),
    ]);
    if (user.get('activeFamilyId')) throw new HttpsError('failed-precondition', 'already_in_family');
    if (!fam.exists || fam.get('status') !== 'active') throw new HttpsError('failed-precondition', 'family_inactive');
    if (Number(fam.get('memberCount') ?? 0) >= capacity) throw new HttpsError('resource-exhausted', 'family_full');
    if (existing.exists && existing.get('status') === 'active') throw new HttpsError('already-exists', 'already_member');

    tx.set(famRef.collection('members').doc(uid), {
      uid, role: 'member', status: 'active', joinedAt: FieldValue.serverTimestamp(), invitedBy: inv.get('invitedBy'),
      displayName: user.get('displayName') ?? null, permissions: { manageMembers: false, manageProfiles: false },
    });
    tx.update(famRef, { memberCount: FieldValue.increment(1), updatedAt: FieldValue.serverTimestamp() });
    tx.update(userRef, { activeFamilyId: fid });
    tx.update(invRef, { status: 'accepted', acceptedAt: FieldValue.serverTimestamp(), acceptedBy: uid });
  });

  const after = await invRef.get();
  if (after.get('status') === 'expired') throw new HttpsError('failed-precondition', 'invitation_expired');
  if (accept) {
    await recomputeEntitlement(uid);
    await recomputeUsage(fid);
    await audit('member_joined', uid, { familyId: fid });
  }
  return { status: after.get('status'), familyId: accept ? fid : null };
});

async function removeFromFamily(fid: string, targetUid: string, actorUid: string, reason: 'removed' | 'left') {
  const famRef = db.collection('families').doc(fid);
  await db.runTransaction(async (tx) => {
    const m = await tx.get(famRef.collection('members').doc(targetUid));
    if (!m.exists || m.get('status') !== 'active') throw new HttpsError('not-found', 'not_a_member');
    if (m.get('role') === 'owner') throw new HttpsError('failed-precondition', 'owner_cannot_leave');
    tx.update(m.ref, { status: reason, leftAt: FieldValue.serverTimestamp(), role: 'member' });
    tx.update(famRef, { memberCount: FieldValue.increment(-1), updatedAt: FieldValue.serverTimestamp() });
    tx.update(db.collection('users').doc(targetUid), { activeFamilyId: null });
  });
  await detachMemberData(fid, targetUid);
  await recomputeEntitlement(targetUid);
  await recomputeUsage(fid);
  await audit(reason === 'left' ? 'member_left' : 'member_removed', actorUid, { familyId: fid, targetUid });
}

export const removeMember = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const { familyId, memberUid } = (req.data ?? {}) as { familyId?: string; memberUid?: string };
  const fid = str(familyId, 128, 'familyId');
  const target = str(memberUid, 128, 'memberUid');
  const actor = await requireManager(fid, uid);
  const t = await memberDoc(fid, target);
  if (t.get('role') === 'admin' && actor.get('role') !== 'owner') throw new HttpsError('permission-denied', 'only_owner_removes_admin');
  await removeFromFamily(fid, target, uid, 'removed');
  return { ok: true };
});

export const leaveFamily = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const fid = str((req.data as any)?.familyId, 128, 'familyId');
  await removeFromFamily(fid, uid, uid, 'left');
  return { ok: true };
});

export const setMemberRole = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const { familyId, memberUid, role } = (req.data ?? {}) as { familyId?: string; memberUid?: string; role?: string };
  const fid = str(familyId, 128, 'familyId');
  const target = str(memberUid, 128, 'memberUid');
  if (role !== 'admin' && role !== 'member') throw new HttpsError('invalid-argument', 'invalid_role');
  const actor = await memberDoc(fid, uid);
  if (actor.get('role') !== 'owner' || actor.get('status') !== 'active') throw new HttpsError('permission-denied', 'only_owner');
  const t = await memberDoc(fid, target);
  if (!t.exists || t.get('status') !== 'active' || t.get('role') === 'owner') throw new HttpsError('failed-precondition', 'invalid_target');
  await t.ref.update({ role, permissions: { manageMembers: role === 'admin', manageProfiles: role === 'admin' } });
  await audit('member_role_changed', uid, { familyId: fid, targetUid: target, role });
  return { ok: true };
});

/** Owner dissolves the family. Only allowed when no other active members remain. */
export const dissolveFamily = onCall(callableOpts, async (req) => {
  const uid = requireAuth(req);
  const fid = str((req.data as any)?.familyId, 128, 'familyId');
  const fam = await db.collection('families').doc(fid).get();
  if (!fam.exists || fam.get('ownerUid') !== uid) throw new HttpsError('permission-denied', 'only_owner');
  await dissolve(fid, uid);
  return { ok: true };
});

export async function dissolve(fid: string, ownerUid: string) {
  const famRef = db.collection('families').doc(fid);
  const others = await famRef.collection('members').where('status', '==', 'active').get();
  if (others.docs.some((d) => d.id !== ownerUid)) throw new HttpsError('failed-precondition', 'family_has_members');
  await detachMemberData(fid, ownerUid);
  await famRef.collection('members').doc(ownerUid).update({ status: 'left', leftAt: FieldValue.serverTimestamp() });
  await famRef.update({ status: 'dissolved', memberCount: 0, updatedAt: FieldValue.serverTimestamp() });
  await db.collection('users').doc(ownerUid).update({ activeFamilyId: null });
  const pending = await db.collection('familyInvitations').where('familyId', '==', fid).where('status', '==', 'pending').get();
  await Promise.all(pending.docs.map((d) => d.ref.update({ status: 'revoked' })));
  await recomputeEntitlement(ownerUid);
  await audit('family_dissolved', ownerUid, { familyId: fid });
}
