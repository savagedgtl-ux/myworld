import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { afterAll, beforeAll, beforeEach, describe, it } from 'vitest';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  doc, getDoc, setDoc, updateDoc, deleteDoc, collection, query, where, getDocs,
  Timestamp, serverTimestamp,
} from 'firebase/firestore';

let env;
const ALICE = 'alice';
const BOB = 'bob';
const CAROL = 'carol'; // family member of Alice
const DAVE = 'dave';   // removed family member
const FAMILY = 'fam1';

function docData(id, owner, extra = {}) {
  return {
    documentId: id,
    ownerUid: owner,
    familyId: null,
    title: 'Račun za veš mašinu',
    fileType: 'pdf',
    mimeType: 'application/pdf',
    storagePath: `users/${owner}/documents/${id}/file.pdf`,
    fileSizeBytes: 1234,
    pageCount: 1,
    privacyLevel: 'private',
    sharedWith: [],
    linkedEntityIds: [],
    tags: [],
    processingStatus: 'uploading',
    isFavorite: false,
    deletedAt: null,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
    ...extra,
  };
}

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-myworld',
    firestore: { rules: readFileSync(resolve(__dirname, '../firestore.rules'), 'utf8') },
  });
});

afterAll(async () => { await env.cleanup(); });

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    for (const u of [ALICE, BOB, CAROL, DAVE]) {
      await setDoc(doc(db, 'entitlements', u), {
        planId: 'individual_base', aiEnabled: false, adsEnabled: true,
        maxDocuments: 100, storageLimitBytes: 100 * 1024 * 1024, usageKey: u,
      });
      await setDoc(doc(db, 'usage', u), { activeDocumentCount: 0, storageUsedBytes: 0 });
    }
    await setDoc(doc(db, 'families', FAMILY), { ownerUid: ALICE, name: 'Petrović', status: 'active' });
    await setDoc(doc(db, 'families', FAMILY, 'members', ALICE), { uid: ALICE, role: 'owner', status: 'active' });
    await setDoc(doc(db, 'families', FAMILY, 'members', CAROL), { uid: CAROL, role: 'member', status: 'active' });
    await setDoc(doc(db, 'families', FAMILY, 'members', DAVE), { uid: DAVE, role: 'member', status: 'removed' });

    await setDoc(doc(db, 'documents', 'alicePrivate'), docData('alicePrivate', ALICE, { familyId: FAMILY }));
    await setDoc(doc(db, 'documents', 'aliceFamily'), docData('aliceFamily', ALICE, { familyId: FAMILY, privacyLevel: 'family' }));
    await setDoc(doc(db, 'documents', 'aliceSharedCarol'), docData('aliceSharedCarol', ALICE, {
      familyId: FAMILY, privacyLevel: 'shared', sharedWith: [CAROL],
    }));
    await setDoc(doc(db, 'documents', 'bobDoc'), docData('bobDoc', BOB));
    await setDoc(doc(db, 'familyInvitations', 'inv1'), {
      familyId: FAMILY, invitedBy: ALICE, tokenHash: 'x', status: 'expired',
      expiresAt: Timestamp.fromMillis(Date.now() - 1000),
    });
  });
});

const as = (u) => env.authenticatedContext(u).firestore();

describe('documents isolation', () => {
  it('1. user A cannot read user B document', async () => {
    await assertFails(getDoc(doc(as(ALICE), 'documents', 'bobDoc')));
    await assertSucceeds(getDoc(doc(as(BOB), 'documents', 'bobDoc')));
  });

  it('unauthenticated users read nothing', async () => {
    await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), 'documents', 'bobDoc')));
  });

  it('2. family member cannot read another member private document', async () => {
    await assertFails(getDoc(doc(as(CAROL), 'documents', 'alicePrivate')));
  });

  it('family member reads family-level and explicitly shared documents', async () => {
    await assertSucceeds(getDoc(doc(as(CAROL), 'documents', 'aliceFamily')));
    await assertSucceeds(getDoc(doc(as(CAROL), 'documents', 'aliceSharedCarol')));
  });

  it('5. removed member loses access', async () => {
    await assertFails(getDoc(doc(as(DAVE), 'documents', 'aliceFamily')));
  });

  it('non-member cannot read family documents', async () => {
    await assertFails(getDoc(doc(as(BOB), 'documents', 'aliceFamily')));
  });

  it('family queries are allowed only in the authorised shape', async () => {
    const db = as(CAROL);
    await assertSucceeds(getDocs(query(collection(db, 'documents'),
      where('familyId', '==', FAMILY), where('privacyLevel', '==', 'family'))));
    await assertSucceeds(getDocs(query(collection(db, 'documents'),
      where('familyId', '==', FAMILY), where('privacyLevel', '==', 'shared'),
      where('sharedWith', 'array-contains', CAROL))));
    // A broad family query would include private docs -> denied.
    await assertFails(getDocs(query(collection(db, 'documents'), where('familyId', '==', FAMILY))));
    await assertSucceeds(getDocs(query(collection(db, 'documents'), where('ownerUid', '==', CAROL))));
    await assertFails(getDocs(query(collection(db, 'documents'), where('ownerUid', '==', ALICE))));
  });

  it('owner creates a valid document', async () => {
    await assertSucceeds(setDoc(doc(as(ALICE), 'documents', 'new1'), docData('new1', ALICE)));
  });

  it('cannot create a document for someone else', async () => {
    await assertFails(setDoc(doc(as(ALICE), 'documents', 'new2'), docData('new2', BOB)));
  });

  it('cannot point storagePath at another user folder', async () => {
    await assertFails(setDoc(doc(as(ALICE), 'documents', 'new3'), docData('new3', ALICE, {
      storagePath: `users/${BOB}/documents/new3/file.pdf`,
    })));
  });

  it('cannot share with family the user is not an active member of', async () => {
    await assertFails(setDoc(doc(as(BOB), 'documents', 'new4'), docData('new4', BOB, {
      familyId: FAMILY, privacyLevel: 'family',
    })));
    await assertFails(setDoc(doc(as(DAVE), 'documents', 'new5'), docData('new5', DAVE, {
      familyId: FAMILY, privacyLevel: 'family',
    })));
  });

  it('client cannot set server-managed AI statuses', async () => {
    await assertFails(setDoc(doc(as(ALICE), 'documents', 'new6'), docData('new6', ALICE, {
      processingStatus: 'needs_review',
    })));
  });

  it('9. cannot change document owner', async () => {
    await assertFails(updateDoc(doc(as(ALICE), 'documents', 'alicePrivate'), { ownerUid: BOB }));
    await assertSucceeds(updateDoc(doc(as(ALICE), 'documents', 'alicePrivate'), { title: 'Novi naziv' }));
  });

  it('family member cannot edit or delete another member document', async () => {
    await assertFails(updateDoc(doc(as(CAROL), 'documents', 'aliceFamily'), { title: 'x' }));
    await assertFails(deleteDoc(doc(as(CAROL), 'documents', 'aliceFamily')));
  });

  it('hard delete is server-only, soft delete allowed for owner', async () => {
    await assertFails(deleteDoc(doc(as(ALICE), 'documents', 'alicePrivate')));
    await assertSucceeds(updateDoc(doc(as(ALICE), 'documents', 'alicePrivate'), { deletedAt: Timestamp.now() }));
  });

  it('document quota is enforced from server-side usage', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'usage', ALICE), { activeDocumentCount: 100, storageUsedBytes: 0 });
    });
    await assertFails(setDoc(doc(as(ALICE), 'documents', 'over'), docData('over', ALICE)));
  });

  it('storage quota is enforced on the declared file size', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'usage', ALICE), { activeDocumentCount: 1, storageUsedBytes: 100 * 1024 * 1024 - 1000 });
    });
    await assertFails(setDoc(doc(as(ALICE), 'documents', 'big'), docData('big', ALICE, { fileSizeBytes: 1001 })));
    await assertSucceeds(setDoc(doc(as(ALICE), 'documents', 'fits'), docData('fits', ALICE, { fileSizeBytes: 1000 })));
  });

  it('declared file size cannot change after create', async () => {
    await assertFails(updateDoc(doc(as(ALICE), 'documents', 'alicePrivate'), { fileSizeBytes: 25 * 1024 * 1024 }));
  });

  it('cannot inject unknown fields', async () => {
    await assertFails(setDoc(doc(as(ALICE), 'documents', 'new7'), docData('new7', ALICE, { aiApproved: true })));
  });
});

describe('entitlements & billing', () => {
  it('3/12. user cannot change own plan or entitlement', async () => {
    await assertSucceeds(getDoc(doc(as(ALICE), 'entitlements', ALICE)));
    await assertFails(updateDoc(doc(as(ALICE), 'entitlements', ALICE), { planId: 'family_pro', aiEnabled: true }));
    await assertFails(setDoc(doc(as(BOB), 'entitlements', BOB), { planId: 'family_pro', aiEnabled: true }));
  });

  it('user cannot read others entitlements', async () => {
    await assertFails(getDoc(doc(as(ALICE), 'entitlements', BOB)));
  });

  it('subscriptions and usage are read-only for clients', async () => {
    await assertFails(setDoc(doc(as(ALICE), 'subscriptions', 's1'), { ownerUid: ALICE, planId: 'family_pro', status: 'active' }));
    await assertFails(updateDoc(doc(as(ALICE), 'usage', ALICE), { activeDocumentCount: 0 }));
  });

  it('user profile cannot set server-managed fields', async () => {
    const db = as(ALICE);
    await assertSucceeds(setDoc(doc(db, 'users', ALICE), {
      uid: ALICE, displayName: 'Alisa', preferredLanguage: 'sr', createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(), onboardingCompleted: true,
    }));
    await assertFails(updateDoc(doc(db, 'users', ALICE), { activeFamilyId: 'otherFamily' }));
    await assertFails(updateDoc(doc(db, 'users', ALICE), { accountStatus: 'admin' }));
  });
});

describe('families', () => {
  it('client cannot grant itself a family role', async () => {
    await assertFails(setDoc(doc(as(BOB), 'families', FAMILY, 'members', BOB), { uid: BOB, role: 'owner', status: 'active' }));
    await assertFails(updateDoc(doc(as(CAROL), 'families', FAMILY, 'members', CAROL), { role: 'admin' }));
  });

  it('6. expired invitation is not usable from the client', async () => {
    await assertFails(updateDoc(doc(as(BOB), 'familyInvitations', 'inv1'), { status: 'accepted' }));
    await assertFails(getDoc(doc(as(BOB), 'familyInvitations', 'inv1')));
  });

  it('only managers create family profiles', async () => {
    const data = { name: 'Mila', relationship: 'ćerka', isMinor: true, createdBy: ALICE, createdAt: serverTimestamp() };
    await assertSucceeds(setDoc(doc(as(ALICE), 'families', FAMILY, 'profiles', 'p1'), data));
    await assertFails(setDoc(doc(as(CAROL), 'families', FAMILY, 'profiles', 'p2'), { ...data, createdBy: CAROL }));
  });
});

describe('other private collections', () => {
  it('reminder server fields cannot be forged', async () => {
    const r = {
      reminderId: 'r1', ownerUid: ALICE, familyId: null, title: 'Registracija',
      dueAt: Timestamp.now(), timezone: 'Europe/Belgrade', repeatRule: 'yearly',
      status: 'active', privacyLevel: 'private', sharedWith: [], createdAt: Timestamp.now(),
    };
    await assertFails(setDoc(doc(as(ALICE), 'reminders', 'r1'), { ...r, lastSentKey: 'x' }));
    await assertSucceeds(setDoc(doc(as(ALICE), 'reminders', 'r1'), r));
    await assertFails(updateDoc(doc(as(ALICE), 'reminders', 'r1'), { lastSentKey: 'x' }));
  });

  it('wallet cards are private by default', async () => {
    const c = {
      cardId: 'c1', ownerUid: ALICE, familyId: null, kind: 'loyalty', name: 'Maxi',
      barcodeValue: '1234567890128', barcodeFormat: 'ean13', privacyLevel: 'private', sharedWith: [],
      createdAt: Timestamp.now(),
    };
    await assertSucceeds(setDoc(doc(as(ALICE), 'walletCards', 'c1'), c));
    await assertFails(getDoc(doc(as(BOB), 'walletCards', 'c1')));
    await assertFails(getDoc(doc(as(CAROL), 'walletCards', 'c1')));
  });

  it('business cards require a name or company', async () => {
    const base = { cardId: 'b1', ownerUid: ALICE, familyId: null, privacyLevel: 'private', sharedWith: [], createdAt: Timestamp.now() };
    await assertFails(setDoc(doc(as(ALICE), 'businessCards', 'b1'), base));
    await assertSucceeds(setDoc(doc(as(ALICE), 'businessCards', 'b1'), { ...base, fullName: 'Marko Marković', company: 'ACME' }));
  });

  it('vehicle record must belong to own vehicle', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'vehicles', 'bobCar'), { vehicleId: 'bobCar', ownerUid: BOB, make: 'VW', model: 'Golf', privacyLevel: 'private' });
    });
    await assertFails(setDoc(doc(as(ALICE), 'vehicleRecords', 'vr1'), {
      recordId: 'vr1', vehicleId: 'bobCar', ownerUid: ALICE, familyId: null, recordType: 'service',
      date: Timestamp.now(), privacyLevel: 'private', sharedWith: [],
    }));
  });

  it('audit logs and AI usage are not client writable', async () => {
    await assertFails(setDoc(doc(as(ALICE), 'auditLogs', 'a1'), { x: 1 }));
    await assertFails(setDoc(doc(as(ALICE), 'aiUsage', 'a1'), { uid: ALICE }));
    await assertFails(getDoc(doc(as(ALICE), 'auditLogs', 'a1')));
  });

  it('extraction readable only through document access', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'documentExtractions', 'alicePrivate'), { documentId: 'alicePrivate', extractedFields: {} });
    });
    await assertSucceeds(getDoc(doc(as(ALICE), 'documentExtractions', 'alicePrivate')));
    await assertFails(getDoc(doc(as(CAROL), 'documentExtractions', 'alicePrivate')));
    await assertFails(setDoc(doc(as(ALICE), 'documentExtractions', 'alicePrivate'), { extractedFields: { amount: 1 } }));
  });
});
