/// Shared building blocks for all records. Pure Dart — the data layer converts
/// Firestore Timestamps to DateTime before these constructors see the data.
library;

enum PrivacyLevel { private, shared, family }

PrivacyLevel privacyFrom(Object? v) =>
    PrivacyLevel.values.firstWhere((e) => e.name == v, orElse: () => PrivacyLevel.private);

/// Privacy of one record. A family role never grants access by itself; each
/// record states who may see it, and the server re-checks it.
class Privacy {
  const Privacy({this.level = PrivacyLevel.private, this.familyId, this.sharedWith = const []});

  final PrivacyLevel level;
  final String? familyId;
  final List<String> sharedWith;

  static const private = Privacy();

  factory Privacy.fromMap(Map<String, dynamic> m) => Privacy(
        level: privacyFrom(m['privacyLevel']),
        familyId: m['familyId'] as String?,
        sharedWith: stringList(m['sharedWith']),
      );

  Map<String, dynamic> toMap() => {
        'privacyLevel': level.name,
        'familyId': familyId,
        'sharedWith': level == PrivacyLevel.shared ? sharedWith : const <String>[],
      };

  /// Validation mirrored from firestore.rules (`validPrivacy`).
  String? validate() {
    if (level != PrivacyLevel.private && (familyId == null || familyId!.isEmpty)) return 'privacy_needs_family';
    if (level == PrivacyLevel.shared && sharedWith.isEmpty) return 'privacy_needs_people';
    if (sharedWith.length > 25) return 'privacy_too_many_people';
    return null;
  }

  Privacy copyWith({PrivacyLevel? level, String? familyId, List<String>? sharedWith}) => Privacy(
        level: level ?? this.level,
        familyId: familyId ?? this.familyId,
        sharedWith: sharedWith ?? this.sharedWith,
      );
}

List<String> stringList(Object? v) => v is List ? v.whereType<String>().toList() : const <String>[];
DateTime? date(Object? v) => v is DateTime ? v : null;
double? number(Object? v) => v is num ? v.toDouble() : null;
int? integer(Object? v) => v is num ? v.toInt() : null;
String? text(Object? v) => v is String && v.isNotEmpty ? v : null;

/// Common contract for everything that lives in a privacy-aware collection.
abstract class OwnedRecord {
  String get id;
  String get ownerUid;
  Privacy get privacy;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  DateTime? get deletedAt => null;

  /// Fields written by the client (no createdAt — the repository adds it on create).
  Map<String, dynamic> toMap();
}

/// Money amount with explicit currency (never inferred from locale).
class Money {
  const Money(this.amount, this.currency);
  final double amount;
  final String currency;
}
