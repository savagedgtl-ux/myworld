import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { afterAll, beforeAll, beforeEach, describe, it } from 'vitest';
import { assertFails, assertSucceeds, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { doc, setDoc } from 'firebase/firestore';
import { ref, uploadBytes, getBytes } from 'firebase/storage';

let env;
const PDF = new Uint8Array([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x34]);

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-myworld',
    firestore: { rules: readFileSync(resolve(__dirname, '../firestore.rules'), 'utf8') },
    storage: { rules: readFileSync(resolve(__dirname, '../storage.rules'), 'utf8') },
  });
});
afterAll(async () => { await env.cleanup(); });

beforeEach(async () => {
  await env.clearFirestore();
  await env.clearStorage();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    for (const u of ['alice', 'bob']) {
      await setDoc(doc(db, 'entitlements', u), { maxDocuments: 100, storageLimitBytes: 1000, usageKey: u });
      await setDoc(doc(db, 'usage', u), { activeDocumentCount: 0, storageUsedBytes: 0 });
    }
    await setDoc(doc(db, 'documents', 'd1'), {
      documentId: 'd1', ownerUid: 'alice', privacyLevel: 'private', sharedWith: [],
      storagePath: 'users/alice/documents/d1/file.pdf', fileSizeBytes: PDF.length,
    });
    await uploadBytes(ref(ctx.storage(), 'users/alice/documents/d1/file.pdf'), PDF, { contentType: 'application/pdf' });
  });
});

const st = (u) => env.authenticatedContext(u).storage();

describe('storage', () => {
  it('owner can read own document file', async () => {
    await assertSucceeds(getBytes(ref(st('alice'), 'users/alice/documents/d1/file.pdf')));
  });

  it('8. another user cannot download by knowing the path/ID', async () => {
    await assertFails(getBytes(ref(st('bob'), 'users/alice/documents/d1/file.pdf')));
  });

  it('upload requires matching metadata record at exact path', async () => {
    await assertFails(uploadBytes(ref(st('alice'), 'users/alice/documents/d1/other.pdf'), PDF, { contentType: 'application/pdf' }));
    await assertFails(uploadBytes(ref(st('bob'), 'users/alice/documents/d1/file2.pdf'), PDF, { contentType: 'application/pdf' }));
  });

  it('7. disallowed file type is rejected', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'documents', 'd2'), {
        documentId: 'd2', ownerUid: 'alice', privacyLevel: 'private', sharedWith: [],
        storagePath: 'users/alice/documents/d2/evil.exe',
      });
      await setDoc(doc(ctx.firestore(), 'documents', 'd3'), {
        documentId: 'd3', ownerUid: 'alice', privacyLevel: 'private', sharedWith: [],
        storagePath: 'users/alice/documents/d3/ok.pdf', fileSizeBytes: PDF.length,
      });
    });
    await assertFails(uploadBytes(ref(st('alice'), 'users/alice/documents/d2/evil.exe'), PDF, { contentType: 'application/x-msdownload' }));
    await assertSucceeds(uploadBytes(ref(st('alice'), 'users/alice/documents/d3/ok.pdf'), PDF, { contentType: 'application/pdf' }));
  });

  it('file larger than its quota-checked record is rejected', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'documents', 'd4'), {
        documentId: 'd4', ownerUid: 'alice', privacyLevel: 'private', sharedWith: [],
        storagePath: 'users/alice/documents/d4/big.pdf', fileSizeBytes: PDF.length - 1,
      });
    });
    await assertFails(uploadBytes(ref(st('alice'), 'users/alice/documents/d4/big.pdf'), PDF, { contentType: 'application/pdf' }));
  });

  it('exports are owner read-only', async () => {
    await assertFails(uploadBytes(ref(st('alice'), 'exports/alice/x.zip'), PDF, { contentType: 'application/zip' }));
    await assertFails(getBytes(ref(st('bob'), 'exports/alice/x.zip')));
  });

  it('family member reads a shared vehicle photo; outsiders and private photos stay closed', async () => {
    const PNG = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, 'families', 'f1', 'members', 'alice'), { uid: 'alice', role: 'owner', status: 'active' });
      await setDoc(doc(db, 'families', 'f1', 'members', 'bob'), { uid: 'bob', role: 'member', status: 'active' });
      await setDoc(doc(db, 'vehicles', 'v1'), { vehicleId: 'v1', ownerUid: 'alice', familyId: 'f1', privacyLevel: 'family', sharedWith: [] });
      await setDoc(doc(db, 'vehicles', 'v2'), { vehicleId: 'v2', ownerUid: 'alice', familyId: 'f1', privacyLevel: 'private', sharedWith: [] });
      await uploadBytes(ref(ctx.storage(), 'users/alice/photos/v1/vehicles-photo.jpg'), PNG, { contentType: 'image/png' });
      await uploadBytes(ref(ctx.storage(), 'users/alice/photos/v2/vehicles-photo.jpg'), PNG, { contentType: 'image/png' });
    });
    await assertSucceeds(getBytes(ref(st('bob'), 'users/alice/photos/v1/vehicles-photo.jpg')));
    await assertFails(getBytes(ref(st('bob'), 'users/alice/photos/v2/vehicles-photo.jpg')));
    await assertFails(getBytes(ref(env.authenticatedContext('eve').storage(), 'users/alice/photos/v1/vehicles-photo.jpg')));
    await assertSucceeds(getBytes(ref(st('alice'), 'users/alice/photos/v2/vehicles-photo.jpg')));
  });

  it('client cannot overwrite or delete document files', async () => {
    await assertFails(uploadBytes(ref(st('alice'), 'users/alice/documents/d1/file.pdf'), PDF, { contentType: 'application/pdf' }));
  });
});
