// Integration tests against the Functions + Auth + Firestore emulators.
// Run: npm run test:functions (from rules-tests/)
import { describe, it, expect, beforeAll } from 'vitest';
import { initializeApp } from 'firebase/app';
import { getAuth, connectAuthEmulator, createUserWithEmailAndPassword, signOut } from 'firebase/auth';
import { getFunctions, connectFunctionsEmulator, httpsCallable } from 'firebase/functions';
import { getFirestore, connectFirestoreEmulator, doc, getDoc, setDoc, updateDoc } from 'firebase/firestore';

const PROJECT = 'demo-myworld';
const REGION = 'europe-west1';
const ADMIN_TOKEN = 'owner'; // emulator accepts "Bearer owner" as admin

function makeApp(name) {
  const app = initializeApp({ projectId: PROJECT, apiKey: 'fake', authDomain: 'localhost' }, name);
  const auth = getAuth(app);
  connectAuthEmulator(auth, 'http://127.0.0.1:9099', { disableWarnings: true });
  const fns = getFunctions(app, REGION);
  connectFunctionsEmulator(fns, '127.0.0.1', 5001);
  const db = getFirestore(app);
  connectFirestoreEmulator(db, '127.0.0.1', 8080);
  return { app, auth, db, call: (n, d) => httpsCallable(fns, n)(d).then((r) => r.data) };
}

/** Writes a doc bypassing rules via the emulator REST API (simulates trusted server state). */
async function adminSet(path, fields) {
  const toValue = (v) => {
    if (v === null) return { nullValue: null };
    if (typeof v === 'string') return { stringValue: v };
    if (typeof v === 'boolean') return { booleanValue: v };
    if (typeof v === 'number') return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
    if (v instanceof Date) return { timestampValue: v.toISOString() };
    throw new Error('unsupported');
  };
  const body = { fields: Object.fromEntries(Object.entries(fields).map(([k, v]) => [k, toValue(v)])) };
  const res = await fetch(`http://127.0.0.1:8080/v1/projects/${PROJECT}/databases/(default)/documents/${path}`, {
    method: 'PATCH', headers: { Authorization: `Bearer ${ADMIN_TOKEN}`, 'Content-Type': 'application/json' }, body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error(await res.text());
}

async function signUp(ctx, email) {
  const cred = await createUserWithEmailAndPassword(ctx.auth, email, 'Test-password-123');
  await ctx.call('bootstrapAccount', {});
  return cred.user.uid;
}

const expectCode = async (p, code) => {
  try { await p; } catch (e) { expect(e.code).toBe(`functions/${code}`); return e; }
  throw new Error(`expected ${code}`);
};

describe('server-side enforcement', () => {
  const owner = makeApp('owner');
  const member = makeApp('member');
  const outsider = makeApp('outsider');
  let ownerUid, memberUid, familyId, invite;
  const stamp = Date.now();

  beforeAll(async () => {
    ownerUid = await signUp(owner, `owner${stamp}@test.dev`);
    memberUid = await signUp(member, `member${stamp}@test.dev`);
    await signUp(outsider, `out${stamp}@test.dev`);
  });

  it('bootstrap creates base entitlement', async () => {
    const e = await getDoc(doc(owner.db, 'entitlements', ownerUid));
    expect(e.get('planId')).toBe('individual_base');
    expect(e.get('aiEnabled')).toBe(false);
    expect(e.get('adsEnabled')).toBe(true);
  });

  it('4. AI endpoint without AI entitlement is rejected', async () => {
    await expectCode(owner.call('aiAsk', { question: 'Kada mi ističe garancija?' }), 'permission-denied');
    await expectCode(owner.call('extractDocument', { documentId: 'whatever' }), 'permission-denied');
  });

  it('3. changing local/client data cannot unlock a plan', async () => {
    await expect(setDoc(doc(owner.db, 'subscriptions', ownerUid), { ownerUid, planId: 'family_pro', status: 'active' })).rejects.toBeTruthy();
    await expect(updateDoc(doc(owner.db, 'entitlements', ownerUid), { aiEnabled: true })).rejects.toBeTruthy();
    await expectCode(owner.call('createFamily', { name: 'Hakeri' }), 'permission-denied');
  });

  it('family plan (server-verified) allows creating family and invitations', async () => {
    await adminSet(`subscriptions/${ownerUid}`, {
      ownerUid, planId: 'family_base', status: 'active', platform: 'ios', provider: 'revenuecat',
      currentPeriodEnd: new Date(Date.now() + 30 * 86400_000),
    });
    const res = await owner.call('createFamily', { name: 'Petrović' });
    familyId = res.familyId;
    const ent = await getDoc(doc(owner.db, 'entitlements', ownerUid));
    expect(ent.get('planId')).toBe('family_base');
    expect(ent.get('adsEnabled')).toBe(false);
    expect(ent.get('aiEnabled')).toBe(false);
    invite = await owner.call('createInvitation', { familyId });
    expect(invite.link).toContain('t=');
  });

  it('non-manager cannot create invitations', async () => {
    await expectCode(outsider.call('createInvitation', { familyId }), 'permission-denied');
  });

  it('wrong token is rejected', async () => {
    await expectCode(member.call('respondToInvitation', { invitationId: invite.invitationId, token: 'x'.repeat(43), accept: true }), 'not-found');
  });

  it('valid invitation joins; member gets family plan; reuse is rejected', async () => {
    const token = new URL(invite.link).searchParams.get('t');
    const r = await member.call('respondToInvitation', { invitationId: invite.invitationId, token, accept: true });
    expect(r.status).toBe('accepted');
    const ent = await getDoc(doc(member.db, 'entitlements', memberUid));
    expect(ent.get('planId')).toBe('family_base');
    expect(ent.get('usageKey')).toBe(familyId);
    // 6. second use of the same invitation
    await expectCode(outsider.call('respondToInvitation', { invitationId: invite.invitationId, token, accept: true }), 'failed-precondition');
  });

  it('expired invitation cannot be used', async () => {
    const inv2 = await owner.call('createInvitation', { familyId });
    await adminSet(`familyInvitations/${inv2.invitationId}?updateMask.fieldPaths=expiresAt`, { expiresAt: new Date(Date.now() - 1000) });
    const token = new URL(inv2.link).searchParams.get('t');
    await expectCode(outsider.call('respondToInvitation', { invitationId: inv2.invitationId, token, accept: true }), 'failed-precondition');
  });

  it('5. removed member loses access to family documents', async () => {
    const id = `famdoc${stamp}`;
    await setDoc(doc(owner.db, 'documents', id), {
      documentId: id, ownerUid, familyId, title: 'Zajednički ugovor', fileType: 'pdf', mimeType: 'application/pdf',
      storagePath: `users/${ownerUid}/documents/${id}/f.pdf`, fileSizeBytes: 10, pageCount: 1,
      privacyLevel: 'family', sharedWith: [], linkedEntityIds: [], tags: [], processingStatus: 'uploading',
      isFavorite: false, deletedAt: null,
    });
    expect((await getDoc(doc(member.db, 'documents', id))).exists()).toBe(true);
    await owner.call('removeMember', { familyId, memberUid });
    await expect(getDoc(doc(member.db, 'documents', id))).rejects.toBeTruthy();
    const ent = await getDoc(doc(member.db, 'entitlements', memberUid));
    expect(ent.get('planId')).toBe('individual_base');
  });

  it('account deletion requires a recent login and works', async () => {
    const r = await outsider.call('deleteAccount', {});
    expect(r.ok).toBe(true);
    await signOut(outsider.auth);
  });
});
