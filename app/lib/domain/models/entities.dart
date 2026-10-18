import 'common.dart';
import 'common.dart' as c;

/// Area an item belongs to in My World.
enum ItemArea { home, hobby, life }

ItemArea areaFrom(Object? v) => ItemArea.values.firstWhere((e) => e.name == v, orElse: () => ItemArea.home);

enum AssetStatus { active, inRepair, sold, discarded }

AssetStatus assetStatusFrom(Object? v) =>
    AssetStatus.values.firstWhere((e) => e.name == v, orElse: () => AssetStatus.active);

/// Household item, hobby gear, collection piece or valuable.
class Asset implements OwnedRecord {
  const Asset({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.area,
    this.privacy = Privacy.private,
    this.category,
    this.description,
    this.photoStoragePath,
    this.brand,
    this.model,
    this.serialNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.currency,
    this.vendor,
    this.warrantyExpiryDate,
    this.location,
    this.status = AssetStatus.active,
    this.assignedProfileIds = const [],
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final String name;
  final ItemArea area;
  final String? category;
  final String? description;
  final String? photoStoragePath;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? currency;
  final String? vendor;
  final DateTime? warrantyExpiryDate;
  final String? location;
  final AssetStatus status;
  final List<String> assignedProfileIds;
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  DateTime? get deletedAt => null;

  factory Asset.fromMap(String id, Map<String, dynamic> m) => Asset(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        name: m['name'] as String? ?? '',
        area: areaFrom(m['area']),
        category: text(m['category']),
        description: text(m['description']),
        photoStoragePath: text(m['photoStoragePath']),
        brand: text(m['brand']),
        model: text(m['model']),
        serialNumber: text(m['serialNumber']),
        purchaseDate: date(m['purchaseDate']),
        purchasePrice: number(m['purchasePrice']),
        currency: text(m['currency']),
        vendor: text(m['vendor']),
        warrantyExpiryDate: date(m['warrantyExpiryDate']),
        location: text(m['location']),
        status: assetStatusFrom(m['status']),
        assignedProfileIds: stringList(m['assignedProfileIds']),
        notes: text(m['notes']),
        createdAt: date(m['createdAt']),
        updatedAt: date(m['updatedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'assetId': id,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'area': area.name,
        'name': name,
        'category': category,
        'description': description,
        'photoStoragePath': photoStoragePath,
        'brand': brand,
        'model': model,
        'serialNumber': serialNumber,
        'purchaseDate': purchaseDate,
        'purchasePrice': purchasePrice,
        'currency': currency,
        'vendor': vendor,
        'warrantyExpiryDate': warrantyExpiryDate,
        'location': location,
        'status': status.name,
        'assignedProfileIds': assignedProfileIds,
        'notes': notes,
      };
}

class Vehicle implements OwnedRecord {
  const Vehicle({
    required this.id,
    required this.ownerUid,
    required this.make,
    required this.model,
    this.privacy = Privacy.private,
    this.year,
    this.registrationNumber,
    this.vin,
    this.purchaseDate,
    this.purchasePrice,
    this.currency,
    this.currentMileage,
    this.fuelType,
    this.photoStoragePath,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final String make;
  final String model;
  final int? year;
  final String? registrationNumber;
  final String? vin;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? currency;
  final double? currentMileage;
  final String? fuelType;
  final String? photoStoragePath;
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  DateTime? get deletedAt => null;

  String get displayName => [make, model].where((s) => s.isNotEmpty).join(' ');

  factory Vehicle.fromMap(String id, Map<String, dynamic> m) => Vehicle(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        make: m['make'] as String? ?? '',
        model: m['model'] as String? ?? '',
        year: integer(m['year']),
        registrationNumber: text(m['registrationNumber']),
        vin: text(m['vin']),
        purchaseDate: date(m['purchaseDate']),
        purchasePrice: number(m['purchasePrice']),
        currency: text(m['currency']),
        currentMileage: number(m['currentMileage']),
        fuelType: text(m['fuelType']),
        photoStoragePath: text(m['photoStoragePath']),
        notes: text(m['notes']),
        createdAt: date(m['createdAt']),
        updatedAt: date(m['updatedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'vehicleId': id,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'make': make,
        'model': model,
        'year': year,
        'registrationNumber': registrationNumber,
        'vin': vin,
        'purchaseDate': purchaseDate,
        'purchasePrice': purchasePrice,
        'currency': currency,
        'currentMileage': currentMileage,
        'fuelType': fuelType,
        'photoStoragePath': photoStoragePath,
        'notes': notes,
      };

  Vehicle withMileage(double km) => Vehicle(
        id: id, ownerUid: ownerUid, make: make, model: model, privacy: privacy, year: year,
        registrationNumber: registrationNumber, vin: vin, purchaseDate: purchaseDate,
        purchasePrice: purchasePrice, currency: currency, currentMileage: km, fuelType: fuelType,
        photoStoragePath: photoStoragePath, notes: notes, createdAt: createdAt, updatedAt: updatedAt,
      );
}

enum VehicleRecordType { registration, insurance, inspection, service, oil, tires, repair, parts, fuel, tolls, parking, other }

VehicleRecordType recordTypeFrom(Object? v) =>
    VehicleRecordType.values.firstWhere((e) => e.name == v, orElse: () => VehicleRecordType.other);

class VehicleRecord implements OwnedRecord {
  const VehicleRecord({
    required this.id,
    required this.vehicleId,
    required this.ownerUid,
    required this.type,
    required this.date,
    this.privacy = Privacy.private,
    this.mileage,
    this.description,
    this.amount,
    this.currency,
    this.vendor,
    this.documentIds = const [],
    this.nextDueDate,
    this.nextDueMileage,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  final String vehicleId;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final VehicleRecordType type;
  final DateTime date;
  final double? mileage;
  final String? description;
  final double? amount;
  final String? currency;
  final String? vendor;
  final List<String> documentIds;
  final DateTime? nextDueDate;
  final double? nextDueMileage;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  DateTime? get deletedAt => null;

  factory VehicleRecord.fromMap(String id, Map<String, dynamic> m) => VehicleRecord(
        id: id,
        vehicleId: m['vehicleId'] as String? ?? '',
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        type: recordTypeFrom(m['recordType']),
        date: c.date(m['date']) ?? DateTime.fromMillisecondsSinceEpoch(0),
        mileage: number(m['mileage']),
        description: text(m['description']),
        amount: number(m['amount']),
        currency: text(m['currency']),
        vendor: text(m['vendor']),
        documentIds: stringList(m['documentIds']),
        nextDueDate: c.date(m['nextDueDate']),
        nextDueMileage: number(m['nextDueMileage']),
        createdAt: c.date(m['createdAt']),
        updatedAt: c.date(m['updatedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'recordId': id,
        'vehicleId': vehicleId,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'recordType': type.name,
        'date': date,
        'mileage': mileage,
        'description': description,
        'amount': amount,
        'currency': currency,
        'vendor': vendor,
        'documentIds': documentIds,
        'nextDueDate': nextDueDate,
        'nextDueMileage': nextDueMileage,
      };
}

enum RepeatRule { none, daily, weekly, monthly, yearly }

enum ReminderStatus { active, done, snoozed, cancelled }

enum ReminderKind { registration, insurance, service, warranty, contract, document, anniversary, subscription, custom }

class Reminder implements OwnedRecord {
  const Reminder({
    required this.id,
    required this.ownerUid,
    required this.title,
    required this.dueAt,
    required this.timezone,
    this.privacy = Privacy.private,
    this.description,
    this.repeatRule = RepeatRule.none,
    this.notificationChannels = const ['push', 'local'],
    this.linkedEntityId,
    this.linkedEntityType,
    this.linkedDocumentId,
    this.status = ReminderStatus.active,
    this.kind = ReminderKind.custom,
    this.leadTimeMinutes = 0,
    this.nextNotifyAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final String title;
  final String? description;
  final DateTime dueAt;
  final String timezone;
  final RepeatRule repeatRule;
  final List<String> notificationChannels;
  final String? linkedEntityId;
  final String? linkedEntityType;
  final String? linkedDocumentId;
  final ReminderStatus status;
  final ReminderKind kind;
  final int leadTimeMinutes;
  final DateTime? nextNotifyAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  DateTime? get deletedAt => null;

  bool get isActive => status == ReminderStatus.active;

  factory Reminder.fromMap(String id, Map<String, dynamic> m) => Reminder(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        title: m['title'] as String? ?? '',
        description: text(m['description']),
        dueAt: date(m['dueAt']) ?? DateTime.now(),
        timezone: m['timezone'] as String? ?? 'UTC',
        repeatRule: RepeatRule.values.firstWhere((e) => e.name == m['repeatRule'], orElse: () => RepeatRule.none),
        notificationChannels: stringList(m['notificationChannels']),
        linkedEntityId: text(m['linkedEntityId']),
        linkedEntityType: text(m['linkedEntityType']),
        linkedDocumentId: text(m['linkedDocumentId']),
        status: ReminderStatus.values.firstWhere((e) => e.name == m['status'], orElse: () => ReminderStatus.active),
        kind: ReminderKind.values.firstWhere((e) => e.name == m['kind'], orElse: () => ReminderKind.custom),
        leadTimeMinutes: integer(m['leadTimeMinutes']) ?? 0,
        nextNotifyAt: date(m['nextNotifyAt']),
        createdAt: date(m['createdAt']),
        updatedAt: date(m['updatedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'reminderId': id,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'title': title,
        'description': description,
        'dueAt': dueAt,
        'timezone': timezone,
        'repeatRule': repeatRule.name,
        'notificationChannels': notificationChannels,
        'linkedEntityId': linkedEntityId,
        'linkedEntityType': linkedEntityType,
        'linkedDocumentId': linkedDocumentId,
        'status': status.name,
        'kind': kind.name,
        'leadTimeMinutes': leadTimeMinutes,
        'nextNotifyAt': status == ReminderStatus.active ? dueAt.subtract(Duration(minutes: leadTimeMinutes)) : null,
      };

  Reminder copyWith({ReminderStatus? status, DateTime? dueAt}) => Reminder(
        id: id, ownerUid: ownerUid, title: title, dueAt: dueAt ?? this.dueAt, timezone: timezone,
        privacy: privacy, description: description, repeatRule: repeatRule,
        notificationChannels: notificationChannels, linkedEntityId: linkedEntityId,
        linkedEntityType: linkedEntityType, linkedDocumentId: linkedDocumentId,
        status: status ?? this.status, kind: kind, leadTimeMinutes: leadTimeMinutes,
        createdAt: createdAt, updatedAt: updatedAt,
      );
}

enum WalletCardKind { loyalty, discount, coupon, gift, membership, other }

enum BarcodeKind { qr, ean13, ean8, code128, code39, upca, pdf417, aztec, datamatrix, none }

/// Loyalty card, discount, coupon, gift card or membership card (My Cards).
class WalletCard implements OwnedRecord {
  const WalletCard({
    required this.id,
    required this.ownerUid,
    required this.kind,
    required this.name,
    this.privacy = Privacy.private,
    this.issuer,
    this.cardNumber,
    this.barcodeValue,
    this.barcodeFormat = BarcodeKind.none,
    this.discountText,
    this.balance,
    this.currency,
    this.validFrom,
    this.expiryDate,
    this.frontPhotoPath,
    this.backPhotoPath,
    this.color,
    this.notes,
    this.isFavorite = false,
    this.usedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final WalletCardKind kind;
  final String name;
  final String? issuer;
  final String? cardNumber;
  final String? barcodeValue;
  final BarcodeKind barcodeFormat;
  final String? discountText;
  final double? balance;
  final String? currency;
  final DateTime? validFrom;
  final DateTime? expiryDate;
  final String? frontPhotoPath;
  final String? backPhotoPath;
  final String? color;
  final String? notes;
  final bool isFavorite;
  final DateTime? usedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  DateTime? get deletedAt => null;

  bool isExpired(DateTime now) => expiryDate != null && expiryDate!.isBefore(DateTime(now.year, now.month, now.day));
  bool get isUsed => usedAt != null;

  factory WalletCard.fromMap(String id, Map<String, dynamic> m) => WalletCard(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        kind: WalletCardKind.values.firstWhere((e) => e.name == m['kind'], orElse: () => WalletCardKind.other),
        name: m['name'] as String? ?? '',
        issuer: text(m['issuer']),
        cardNumber: text(m['cardNumber']),
        barcodeValue: text(m['barcodeValue']),
        barcodeFormat: BarcodeKind.values.firstWhere((e) => e.name == m['barcodeFormat'], orElse: () => BarcodeKind.none),
        discountText: text(m['discountText']),
        balance: number(m['balance']),
        currency: text(m['currency']),
        validFrom: date(m['validFrom']),
        expiryDate: date(m['expiryDate']),
        frontPhotoPath: text(m['frontPhotoPath']),
        backPhotoPath: text(m['backPhotoPath']),
        color: text(m['color']),
        notes: text(m['notes']),
        isFavorite: m['isFavorite'] == true,
        usedAt: date(m['usedAt']),
        createdAt: date(m['createdAt']),
        updatedAt: date(m['updatedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'cardId': id,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'kind': kind.name,
        'name': name,
        'issuer': issuer,
        'cardNumber': cardNumber,
        'barcodeValue': barcodeValue,
        'barcodeFormat': barcodeFormat.name,
        'discountText': discountText,
        'balance': balance,
        'currency': currency,
        'validFrom': validFrom,
        'expiryDate': expiryDate,
        'frontPhotoPath': frontPhotoPath,
        'backPhotoPath': backPhotoPath,
        'color': color,
        'notes': notes,
        'isFavorite': isFavorite,
        'usedAt': usedAt,
      };
}

/// Someone else's business card (My Business Cards).
class BusinessCard implements OwnedRecord {
  const BusinessCard({
    required this.id,
    required this.ownerUid,
    this.privacy = Privacy.private,
    this.fullName,
    this.company,
    this.jobTitle,
    this.phones = const [],
    this.emails = const [],
    this.website,
    this.address,
    this.socialLinks = const [],
    this.frontPhotoPath,
    this.backPhotoPath,
    this.notes,
    this.tags = const [],
    this.metAt,
    this.metWhere,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final String? fullName;
  final String? company;
  final String? jobTitle;
  final List<String> phones;
  final List<String> emails;
  final String? website;
  final String? address;
  final List<String> socialLinks;
  final String? frontPhotoPath;
  final String? backPhotoPath;
  final String? notes;
  final List<String> tags;
  final DateTime? metAt;
  final String? metWhere;
  final bool isFavorite;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  DateTime? get deletedAt => null;

  String get displayName => fullName ?? company ?? '';

  factory BusinessCard.fromMap(String id, Map<String, dynamic> m) => BusinessCard(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        fullName: text(m['fullName']),
        company: text(m['company']),
        jobTitle: text(m['jobTitle']),
        phones: stringList(m['phones']),
        emails: stringList(m['emails']),
        website: text(m['website']),
        address: text(m['address']),
        socialLinks: stringList(m['socialLinks']),
        frontPhotoPath: text(m['frontPhotoPath']),
        backPhotoPath: text(m['backPhotoPath']),
        notes: text(m['notes']),
        tags: stringList(m['tags']),
        metAt: date(m['metAt']),
        metWhere: text(m['metWhere']),
        isFavorite: m['isFavorite'] == true,
        createdAt: date(m['createdAt']),
        updatedAt: date(m['updatedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'cardId': id,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'fullName': fullName,
        'company': company,
        'jobTitle': jobTitle,
        'phones': phones,
        'emails': emails,
        'website': website,
        'address': address,
        'socialLinks': socialLinks,
        'frontPhotoPath': frontPhotoPath,
        'backPhotoPath': backPhotoPath,
        'notes': notes,
        'tags': tags,
        'metAt': metAt,
        'metWhere': metWhere,
        'isFavorite': isFavorite,
      };
}

/// User-created category or subcategory.
class CustomCategory {
  const CustomCategory({required this.id, required this.ownerUid, required this.name, required this.area, this.parentId});

  final String id;
  final String ownerUid;
  final String name;
  final String area;
  final String? parentId;

  factory CustomCategory.fromMap(String id, Map<String, dynamic> m) => CustomCategory(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        name: m['name'] as String? ?? '',
        area: m['area'] as String? ?? 'documents',
        parentId: text(m['parentId']),
      );

  Map<String, dynamic> toMap() => {'ownerUid': ownerUid, 'name': name, 'area': area, 'parentId': parentId};
}
