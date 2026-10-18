import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/repositories/account_repositories.dart';
import '../data/repositories/document_repository.dart';
import '../data/repositories/record_repository.dart';
import '../domain/models/account.dart';
import '../domain/models/document.dart';
import '../domain/models/entities.dart';
import '../services/ads_service.dart';
import '../services/auth_service.dart';
import '../services/billing_service.dart';
import '../services/functions_service.dart';
import '../services/notification_service.dart';
import '../services/scanner_service.dart';
import '../services/storage_service.dart';
import '../services/vault_lock_service.dart';

// ---------- Firebase singletons ----------
final firestoreProvider = Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider<FirebaseStorage>((_) => FirebaseStorage.instance);
final functionsProvider = Provider<FunctionsService>(
    (_) => FunctionsService(FirebaseFunctions.instanceFor(region: AppConfig.functionsRegion)));

// ---------- services ----------
final authServiceProvider = Provider<AuthService>((ref) => AuthService(FirebaseAuth.instance, ref.watch(functionsProvider)));
final storageServiceProvider = Provider<StorageService>((ref) => StorageService(ref.watch(firebaseStorageProvider)));
final scannerServiceProvider = Provider<ScannerService>((_) => ScannerService());
final billingServiceProvider = Provider<BillingService>((ref) => BillingService(ref.watch(functionsProvider)));
final adsServiceProvider = Provider<AdsService>((_) => AdsService());
final notificationServiceProvider = Provider<NotificationService>((_) => NotificationService());
final vaultLockProvider = Provider<VaultLockService>((_) => VaultLockService());

// ---------- repositories ----------
final userRepoProvider = Provider((ref) => UserRepository(ref.watch(firestoreProvider)));
final entitlementRepoProvider = Provider((ref) => EntitlementRepository(ref.watch(firestoreProvider)));
final familyRepoProvider = Provider((ref) =>
    FamilyRepository(ref.watch(firestoreProvider), ref.watch(functionsProvider), ref.watch(firebaseStorageProvider)));
final categoryRepoProvider = Provider((ref) => CategoryRepository(ref.watch(firestoreProvider)));
final aiRepoProvider = Provider((ref) => AiRepository(ref.watch(functionsProvider)));
final accountRepoProvider = Provider((ref) => AccountRepository(ref.watch(functionsProvider), ref.watch(firebaseStorageProvider)));
final photoRepoProvider = Provider((ref) => PhotoRepository(ref.watch(firebaseStorageProvider)));
final documentRepoProvider = Provider((ref) =>
    DocumentRepository(ref.watch(firestoreProvider), ref.watch(storageServiceProvider), ref.watch(functionsProvider)));
final assetRepoProvider = Provider((ref) => RecordRepository<Asset>(ref.watch(firestoreProvider), 'assets', Asset.fromMap));
final vehicleRepoProvider = Provider((ref) => RecordRepository<Vehicle>(ref.watch(firestoreProvider), 'vehicles', Vehicle.fromMap));
final vehicleRecordRepoProvider =
    Provider((ref) => RecordRepository<VehicleRecord>(ref.watch(firestoreProvider), 'vehicleRecords', VehicleRecord.fromMap));
final reminderRepoProvider = Provider((ref) => RecordRepository<Reminder>(ref.watch(firestoreProvider), 'reminders', Reminder.fromMap));
final walletRepoProvider = Provider((ref) => RecordRepository<WalletCard>(ref.watch(firestoreProvider), 'walletCards', WalletCard.fromMap));
final businessCardRepoProvider =
    Provider((ref) => RecordRepository<BusinessCard>(ref.watch(firestoreProvider), 'businessCards', BusinessCard.fromMap));

// ---------- session ----------
final authUserProvider = StreamProvider<User?>((ref) => ref.watch(authServiceProvider).authChanges());

final uidProvider = Provider<String?>((ref) => ref.watch(authUserProvider).value?.uid);

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(userRepoProvider).watch(uid);
});

/// Active family id comes from the server-managed user field.
final familyIdProvider = Provider<String?>((ref) => ref.watch(userProfileProvider).value?.activeFamilyId);

/// Server-computed entitlement — the ONLY source for plan-gated UI.
final entitlementProvider = StreamProvider<Entitlement>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(Entitlement.fallback(''));
  return ref.watch(entitlementRepoProvider).watch(uid);
});

final entitlementValueProvider =
    Provider<Entitlement>((ref) => ref.watch(entitlementProvider).value ?? Entitlement.fallback(ref.watch(uidProvider) ?? ''));

final usageProvider = StreamProvider<Usage>((ref) {
  final key = ref.watch(entitlementValueProvider).usageKey;
  if (key.isEmpty) return Stream.value(const Usage());
  return ref.watch(entitlementRepoProvider).watchUsage(key);
});

// ---------- data streams (authorised records only) ----------
StreamProvider<List<T>> _accessible<T extends Object>(Provider<RecordRepository> repo) => StreamProvider<List<T>>((ref) {
      final uid = ref.watch(uidProvider);
      if (uid == null) return Stream.value(<T>[]);
      return ref.watch(repo).watchAccessible(uid, ref.watch(familyIdProvider)).map((l) => l.cast<T>());
    });

final documentsProvider = _accessible<DocumentRecord>(documentRepoProvider);
final assetsProvider = _accessible<Asset>(assetRepoProvider);
final vehiclesProvider = _accessible<Vehicle>(vehicleRepoProvider);
final vehicleRecordsProvider = _accessible<VehicleRecord>(vehicleRecordRepoProvider);
final remindersProvider = _accessible<Reminder>(reminderRepoProvider);
final walletCardsProvider = _accessible<WalletCard>(walletRepoProvider);
final businessCardsProvider = _accessible<BusinessCard>(businessCardRepoProvider);

final customCategoriesProvider = StreamProvider<List<CustomCategory>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(categoryRepoProvider).watch(uid);
});

final documentByIdProvider = Provider.family<DocumentRecord?, String>((ref, id) {
  final list = ref.watch(documentsProvider).value ?? const [];
  for (final d in list) {
    if (d.id == id) return d;
  }
  return null;
});

final extractionProvider = StreamProvider.family<Extraction?, String>((ref, id) => ref.watch(documentRepoProvider).watchExtraction(id));

// ---------- family ----------
final familyProvider = StreamProvider<Family?>((ref) {
  final fid = ref.watch(familyIdProvider);
  if (fid == null) return Stream.value(null);
  return ref.watch(familyRepoProvider).watchFamily(fid);
});

final familyMembersProvider = StreamProvider<List<FamilyMember>>((ref) {
  final fid = ref.watch(familyIdProvider);
  if (fid == null) return Stream.value(const []);
  return ref.watch(familyRepoProvider).watchMembers(fid);
});

final familyProfilesProvider = StreamProvider<List<FamilyProfile>>((ref) {
  final fid = ref.watch(familyIdProvider);
  if (fid == null) return Stream.value(const []);
  return ref.watch(familyRepoProvider).watchProfiles(fid);
});

final myMembershipProvider = Provider<FamilyMember?>((ref) {
  final uid = ref.watch(uidProvider);
  for (final m in ref.watch(familyMembersProvider).value ?? const <FamilyMember>[]) {
    if (m.uid == uid) return m;
  }
  return null;
});

/// Display name lookup for family members (for "shared by" labels).
final memberNamesProvider = Provider<Map<String, String>>((ref) => {
      for (final m in ref.watch(familyMembersProvider).value ?? const <FamilyMember>[]) m.uid: m.displayName ?? '',
    });
