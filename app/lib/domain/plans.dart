/// Display-only mirror of functions/src/plans.ts. The server is authoritative:
/// these values are used for the pricing screen and copy, never for access.
enum PlanId { individualBase, individualPro, familyBase, familyPro }

PlanId planIdFromWire(Object? v) => switch (v) {
      'individual_pro' => PlanId.individualPro,
      'family_base' => PlanId.familyBase,
      'family_pro' => PlanId.familyPro,
      _ => PlanId.individualBase,
    };

String planIdToWire(PlanId p) => switch (p) {
      PlanId.individualBase => 'individual_base',
      PlanId.individualPro => 'individual_pro',
      PlanId.familyBase => 'family_base',
      PlanId.familyPro => 'family_pro',
    };

class PlanInfo {
  const PlanInfo({
    required this.id,
    required this.priceEur,
    required this.isFamily,
    required this.ai,
    required this.ads,
    required this.storageLimitBytes,
    required this.maxDocuments,
    required this.maxMembers,
    required this.maxVehicles,
    required this.storeEntitlementId,
  });

  final PlanId id;
  final double priceEur;
  final bool isFamily;
  final bool ai;
  final bool ads;
  final int storageLimitBytes;
  final int maxDocuments;
  final int maxMembers;
  final int maxVehicles;

  /// RevenueCat entitlement identifier (null for the free plan).
  final String? storeEntitlementId;
}

abstract final class Plans {
  static const _mb = 1024 * 1024;
  static const _gb = 1024 * _mb;

  static const all = <PlanInfo>[
    PlanInfo(id: PlanId.individualBase, priceEur: 0, isFamily: false, ai: false, ads: true,
        storageLimitBytes: 100 * _mb, maxDocuments: 100, maxMembers: 1, maxVehicles: 2, storeEntitlementId: null),
    PlanInfo(id: PlanId.individualPro, priceEur: 4.99, isFamily: false, ai: true, ads: false,
        storageLimitBytes: 10 * _gb, maxDocuments: 10000, maxMembers: 1, maxVehicles: 10, storeEntitlementId: 'individual_pro'),
    PlanInfo(id: PlanId.familyBase, priceEur: 4.99, isFamily: true, ai: false, ads: false,
        storageLimitBytes: 20 * _gb, maxDocuments: 20000, maxMembers: 5, maxVehicles: 10, storeEntitlementId: 'family_base'),
    PlanInfo(id: PlanId.familyPro, priceEur: 14.99, isFamily: true, ai: true, ads: false,
        storageLimitBytes: 100 * _gb, maxDocuments: 100000, maxMembers: 10, maxVehicles: 25, storeEntitlementId: 'family_pro'),
  ];

  static PlanInfo of(PlanId id) => all.firstWhere((p) => p.id == id);
}

/// Client-side upload limits (mirrors storage.rules; server re-validates).
abstract final class UploadLimits {
  static const maxBytes = 25 * 1024 * 1024;
  static const maxPages = 50;
  static const allowedMime = {'application/pdf', 'image/jpeg', 'image/png', 'image/heic', 'image/heif'};
}
