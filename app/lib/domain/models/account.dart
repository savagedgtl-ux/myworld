import '../plans.dart';
import 'common.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.preferredLanguage = 'sr',
    this.region,
    this.activeFamilyId,
    this.onboardingCompleted = false,
    this.notificationPreview = 'generic',
    this.accountStatus = 'active',
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String preferredLanguage;
  final String? region;
  final String? activeFamilyId;
  final bool onboardingCompleted;

  /// 'generic' hides reminder titles on the lock screen (default), 'detailed' shows them.
  final String notificationPreview;
  final String accountStatus;

  factory UserProfile.fromMap(String uid, Map<String, dynamic> m) => UserProfile(
        uid: uid,
        displayName: text(m['displayName']),
        email: text(m['email']),
        photoUrl: text(m['photoUrl']),
        preferredLanguage: m['preferredLanguage'] as String? ?? 'sr',
        region: text(m['region']),
        activeFamilyId: text(m['activeFamilyId']),
        onboardingCompleted: m['onboardingCompleted'] == true,
        notificationPreview: m['notificationPreview'] as String? ?? 'generic',
        accountStatus: m['accountStatus'] as String? ?? 'active',
      );
}

/// Server-computed entitlement (entitlements/{uid}). Read-only for the client.
class Entitlement {
  const Entitlement({
    required this.planId,
    required this.status,
    required this.aiEnabled,
    required this.adsEnabled,
    required this.storageLimitBytes,
    required this.maxDocuments,
    required this.maxFamilyMembers,
    required this.maxVehicles,
    required this.usageKey,
    this.source = 'none',
    this.ownPlanId = PlanId.individualBase,
    this.currentPeriodEnd,
    this.cancelAtPeriodEnd = false,
    this.advancedExport = false,
    this.advancedFilters = false,
    this.aiMonthlyRequests = 0,
    this.canCreateFamily = false,
    this.canInviteMembers = false,
    this.familyId,
  });

  final PlanId planId;
  final PlanId ownPlanId;
  final String status;
  final String source;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final bool aiEnabled;
  final bool adsEnabled;
  final int storageLimitBytes;
  final int maxDocuments;
  final int maxFamilyMembers;
  final int maxVehicles;
  final bool advancedExport;
  final bool advancedFilters;
  final int aiMonthlyRequests;
  final bool canCreateFamily;
  final bool canInviteMembers;
  final String? familyId;
  final String usageKey;

  bool get isPaid => planId != PlanId.individualBase;
  bool get isFamilyPlan => planId == PlanId.familyBase || planId == PlanId.familyPro;

  /// Used before the server document arrives. Most restrictive: no AI, ads on.
  static Entitlement fallback(String uid) {
    final p = Plans.of(PlanId.individualBase);
    return Entitlement(
      planId: PlanId.individualBase, status: 'none', aiEnabled: false, adsEnabled: true,
      storageLimitBytes: p.storageLimitBytes, maxDocuments: p.maxDocuments, maxFamilyMembers: 1,
      maxVehicles: p.maxVehicles, usageKey: uid,
    );
  }

  factory Entitlement.fromMap(String uid, Map<String, dynamic> m) {
    final ms = m['currentPeriodEnd'];
    return Entitlement(
      planId: planIdFromWire(m['planId']),
      ownPlanId: planIdFromWire(m['ownPlanId']),
      status: m['status'] as String? ?? 'none',
      source: m['source'] as String? ?? 'none',
      currentPeriodEnd: ms is num ? DateTime.fromMillisecondsSinceEpoch(ms.toInt()) : date(ms),
      cancelAtPeriodEnd: m['cancelAtPeriodEnd'] == true,
      aiEnabled: m['aiEnabled'] == true,
      adsEnabled: m['adsEnabled'] != false,
      storageLimitBytes: integer(m['storageLimitBytes']) ?? 0,
      maxDocuments: integer(m['maxDocuments']) ?? 0,
      maxFamilyMembers: integer(m['maxFamilyMembers']) ?? 1,
      maxVehicles: integer(m['maxVehicles']) ?? 1,
      advancedExport: m['advancedExport'] == true,
      advancedFilters: m['advancedFilters'] == true,
      aiMonthlyRequests: integer(m['aiMonthlyRequests']) ?? 0,
      canCreateFamily: m['canCreateFamily'] == true,
      canInviteMembers: m['canInviteMembers'] == true,
      familyId: text(m['familyId']),
      usageKey: m['usageKey'] as String? ?? uid,
    );
  }
}

class Usage {
  const Usage({this.activeDocumentCount = 0, this.storageUsedBytes = 0});
  final int activeDocumentCount;
  final int storageUsedBytes;

  factory Usage.fromMap(Map<String, dynamic> m) => Usage(
        activeDocumentCount: integer(m['activeDocumentCount']) ?? 0,
        storageUsedBytes: integer(m['storageUsedBytes']) ?? 0,
      );

  double storageRatio(Entitlement e) =>
      e.storageLimitBytes <= 0 ? 0 : (storageUsedBytes / e.storageLimitBytes).clamp(0, 1).toDouble();
  bool documentLimitReached(Entitlement e) => activeDocumentCount >= e.maxDocuments;
  bool storageLimitReached(Entitlement e) => storageUsedBytes >= e.storageLimitBytes;
}

enum FamilyRole { owner, admin, member }

class Family {
  const Family({required this.id, required this.name, required this.ownerUid, this.memberCount = 1, this.status = 'active'});
  final String id;
  final String name;
  final String ownerUid;
  final int memberCount;
  final String status;

  factory Family.fromMap(String id, Map<String, dynamic> m) => Family(
        id: id,
        name: m['name'] as String? ?? '',
        ownerUid: m['ownerUid'] as String? ?? '',
        memberCount: integer(m['memberCount']) ?? 1,
        status: m['status'] as String? ?? 'active',
      );
}

class FamilyMember {
  const FamilyMember({required this.uid, required this.role, required this.status, this.displayName, this.joinedAt});
  final String uid;
  final FamilyRole role;
  final String status;
  final String? displayName;
  final DateTime? joinedAt;

  bool get isActive => status == 'active';
  bool get canManage => role == FamilyRole.owner || role == FamilyRole.admin;

  factory FamilyMember.fromMap(String uid, Map<String, dynamic> m) => FamilyMember(
        uid: uid,
        role: FamilyRole.values.firstWhere((e) => e.name == m['role'], orElse: () => FamilyRole.member),
        status: m['status'] as String? ?? 'active',
        displayName: text(m['displayName']),
        joinedAt: date(m['joinedAt']),
      );
}

/// A person tracked in the family record who may not have an account (e.g. a child).
class FamilyProfile {
  const FamilyProfile({
    required this.id,
    required this.name,
    this.relationship,
    this.photoStoragePath,
    this.isMinor = false,
    this.linkedUid,
  });

  final String id;
  final String name;
  final String? relationship;
  final String? photoStoragePath;
  final bool isMinor;
  final String? linkedUid;

  factory FamilyProfile.fromMap(String id, Map<String, dynamic> m) => FamilyProfile(
        id: id,
        name: m['name'] as String? ?? '',
        relationship: text(m['relationship']),
        photoStoragePath: text(m['photoStoragePath']),
        isMinor: m['isMinor'] == true,
        linkedUid: text(m['linkedUid']),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'relationship': relationship,
        'photoStoragePath': photoStoragePath,
        'isMinor': isMinor,
      };
}

class FamilyInvitation {
  const FamilyInvitation({required this.id, required this.status, required this.expiresAt, this.targetEmail});
  final String id;
  final String status;
  final DateTime expiresAt;
  final String? targetEmail;

  bool get isPending => status == 'pending' && expiresAt.isAfter(DateTime.now());

  factory FamilyInvitation.fromMap(String id, Map<String, dynamic> m) => FamilyInvitation(
        id: id,
        status: m['status'] as String? ?? 'pending',
        expiresAt: date(m['expiresAt']) ?? DateTime.now(),
        targetEmail: text(m['targetEmail']),
      );
}
