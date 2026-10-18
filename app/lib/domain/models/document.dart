import 'common.dart';

enum ProcessingStatus { draft, uploading, uploaded, processing, needsReview, ready, failed }

ProcessingStatus processingFrom(Object? v) => switch (v) {
      'draft' => ProcessingStatus.draft,
      'uploading' => ProcessingStatus.uploading,
      'uploaded' => ProcessingStatus.uploaded,
      'processing' => ProcessingStatus.processing,
      'needs_review' => ProcessingStatus.needsReview,
      'failed' => ProcessingStatus.failed,
      _ => ProcessingStatus.ready,
    };

String processingToWire(ProcessingStatus s) => switch (s) {
      ProcessingStatus.needsReview => 'needs_review',
      _ => s.name,
    };

class DocumentRecord implements OwnedRecord {
  const DocumentRecord({
    required this.id,
    required this.ownerUid,
    required this.title,
    required this.storagePath,
    required this.mimeType,
    this.privacy = Privacy.private,
    this.description,
    this.categoryId,
    this.subCategoryId,
    this.tags = const [],
    this.fileSizeBytes = 0,
    this.pageCount = 1,
    this.documentDate,
    this.purchaseDate,
    this.vendor,
    this.amount,
    this.currency,
    this.warrantyExpiryDate,
    this.expiryDate,
    this.linkedEntityIds = const [],
    this.processingStatus = ProcessingStatus.draft,
    this.isFavorite = false,
    this.isVault = false,
    this.notes,
    this.contentHash,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  final String id;
  @override
  final String ownerUid;
  @override
  final Privacy privacy;
  final String title;
  final String? description;
  final String? categoryId;
  final String? subCategoryId;
  final List<String> tags;
  final String storagePath;
  final String mimeType;
  final int fileSizeBytes;
  final int pageCount;
  final DateTime? documentDate;
  final DateTime? purchaseDate;
  final String? vendor;
  final double? amount;
  final String? currency;
  final DateTime? warrantyExpiryDate;
  final DateTime? expiryDate;
  final List<String> linkedEntityIds;
  final ProcessingStatus processingStatus;
  final bool isFavorite;
  final bool isVault;
  final String? notes;
  final String? contentHash;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;

  bool get isPdf => mimeType == 'application/pdf';
  bool get isImage => mimeType.startsWith('image/');
  bool get inTrash => deletedAt != null;
  bool get hasWarranty => warrantyExpiryDate != null;
  String get fileType => isPdf ? 'pdf' : 'image';

  factory DocumentRecord.fromMap(String id, Map<String, dynamic> m) => DocumentRecord(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        privacy: Privacy.fromMap(m),
        title: m['title'] as String? ?? '',
        description: text(m['description']),
        categoryId: text(m['categoryId']),
        subCategoryId: text(m['subCategoryId']),
        tags: stringList(m['tags']),
        storagePath: m['storagePath'] as String? ?? '',
        mimeType: m['mimeType'] as String? ?? 'application/pdf',
        fileSizeBytes: integer(m['fileSizeBytes']) ?? 0,
        pageCount: integer(m['pageCount']) ?? 1,
        documentDate: date(m['documentDate']),
        purchaseDate: date(m['purchaseDate']),
        vendor: text(m['vendor']),
        amount: number(m['amount']),
        currency: text(m['currency']),
        warrantyExpiryDate: date(m['warrantyExpiryDate']),
        expiryDate: date(m['expiryDate']),
        linkedEntityIds: stringList(m['linkedEntityIds']),
        processingStatus: processingFrom(m['processingStatus']),
        isFavorite: m['isFavorite'] == true,
        isVault: m['isVault'] == true,
        notes: text(m['notes']),
        contentHash: text(m['contentHash']),
        createdAt: date(m['createdAt']),
        updatedAt: date(m['updatedAt']),
        deletedAt: date(m['deletedAt']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'documentId': id,
        'ownerUid': ownerUid,
        ...privacy.toMap(),
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
        'tags': tags,
        'fileType': fileType,
        'mimeType': mimeType,
        'storagePath': storagePath,
        'fileSizeBytes': fileSizeBytes,
        'pageCount': pageCount,
        'documentDate': documentDate,
        'purchaseDate': purchaseDate,
        'vendor': vendor,
        'amount': amount,
        'currency': currency,
        'warrantyExpiryDate': warrantyExpiryDate,
        'expiryDate': expiryDate,
        'linkedEntityIds': linkedEntityIds,
        'processingStatus': processingToWire(processingStatus),
        'isFavorite': isFavorite,
        'isVault': isVault,
        'notes': notes,
        'contentHash': contentHash,
        'deletedAt': deletedAt,
        'searchText': searchText,
      };

  /// Lower-cased, diacritic-free text used for local search.
  String get searchText => [title, description, vendor, categoryId, ...tags, notes]
      .whereType<String>()
      .join(' ')
      .toLowerCase();

  DocumentRecord copyWith({
    String? title,
    Privacy? privacy,
    String? description,
    String? categoryId,
    String? subCategoryId,
    List<String>? tags,
    int? fileSizeBytes,
    int? pageCount,
    DateTime? documentDate,
    DateTime? purchaseDate,
    String? vendor,
    double? amount,
    String? currency,
    DateTime? warrantyExpiryDate,
    DateTime? expiryDate,
    List<String>? linkedEntityIds,
    ProcessingStatus? processingStatus,
    bool? isFavorite,
    bool? isVault,
    String? notes,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
    bool clearWarranty = false,
    bool clearAmount = false,
  }) =>
      DocumentRecord(
        id: id,
        ownerUid: ownerUid,
        storagePath: storagePath,
        mimeType: mimeType,
        createdAt: createdAt,
        updatedAt: updatedAt,
        contentHash: contentHash,
        title: title ?? this.title,
        privacy: privacy ?? this.privacy,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        subCategoryId: subCategoryId ?? this.subCategoryId,
        tags: tags ?? this.tags,
        fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
        pageCount: pageCount ?? this.pageCount,
        documentDate: documentDate ?? this.documentDate,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        vendor: vendor ?? this.vendor,
        amount: clearAmount ? null : (amount ?? this.amount),
        currency: currency ?? this.currency,
        warrantyExpiryDate: clearWarranty ? null : (warrantyExpiryDate ?? this.warrantyExpiryDate),
        expiryDate: expiryDate ?? this.expiryDate,
        linkedEntityIds: linkedEntityIds ?? this.linkedEntityIds,
        processingStatus: processingStatus ?? this.processingStatus,
        isFavorite: isFavorite ?? this.isFavorite,
        isVault: isVault ?? this.isVault,
        notes: notes ?? this.notes,
        deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
      );
}

/// AI extraction suggestions (server-written). Never applied without user confirmation.
class Extraction {
  const Extraction({
    required this.documentId,
    required this.fields,
    required this.confidence,
    required this.fieldsNeedingReview,
    required this.warnings,
  });

  final String documentId;
  final Map<String, dynamic> fields;
  final double confidence;
  final List<String> fieldsNeedingReview;
  final List<String> warnings;

  factory Extraction.fromMap(String id, Map<String, dynamic> m) => Extraction(
        documentId: id,
        fields: Map<String, dynamic>.from(m['extractedFields'] as Map? ?? const {}),
        confidence: number(m['confidence']) ?? 0,
        fieldsNeedingReview: stringList(m['fieldsNeedingReview']),
        warnings: stringList(m['warnings']),
      );

  String? str(String k) => text(fields[k]);
  double? num(String k) => number(fields[k]);

  /// Dates arrive as ISO strings (YYYY-MM-DD) from the server.
  DateTime? isoDate(String k) {
    final s = fields[k];
    if (s is! String) return null;
    return DateTime.tryParse(s);
  }

  bool needsReview(String field) => fieldsNeedingReview.contains(field);
  bool get injectionSuspected => warnings.contains('prompt_injection_suspected');
  List<({String label, DateTime date})> get dateCandidates => [
        for (final c in (fields['dateCandidates'] as List? ?? const []))
          if (c is Map && DateTime.tryParse('${c['date']}') != null)
            (label: '${c['label']}', date: DateTime.parse('${c['date']}')),
      ];
}
