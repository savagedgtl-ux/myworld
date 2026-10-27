import { setGlobalOptions } from 'firebase-functions/v2';
import { REGION } from './lib/admin';

setGlobalOptions({ region: REGION, maxInstances: 20 });

export { onAuthUserCreated, bootstrapAccount } from './account/bootstrap';
export { exportUserData, deleteAccount } from './account/account';
export { syncSubscription, revenueCatWebhook } from './billing/revenuecat';
export {
  createFamily, createInvitation, revokeInvitation, previewInvitation, respondToInvitation,
  removeMember, leaveFamily, setMemberRole, dissolveFamily,
} from './family/family';
export { onFileUploaded, onFileDeleted, onDocumentRecordWritten, purgeDocument, dailyHousekeeping } from './documents/documents';
export { dispatchReminders } from './reminders/dispatch';
export { extractDocument, autoExtractOnUpload, extractBusinessCard } from './ai/extract';
export { aiAsk } from './ai/ask';
export { prepareAiIndex, processAiIndexQueue } from './ai/indexer';
