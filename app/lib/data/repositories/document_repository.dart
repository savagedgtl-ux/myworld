import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/app_error.dart';
import '../../domain/models/common.dart';
import '../../domain/models/document.dart';
import '../../services/functions_service.dart';
import '../../services/scanner_service.dart';
import '../../services/storage_service.dart';
import '../firestore_codec.dart';
import 'record_repository.dart';

/// Metadata the user confirms before saving (name, category, privacy…).
class NewDocumentInput {
  NewDocumentInput({
    required this.title,
    this.categoryId,
    this.privacy = Privacy.private,
    this.isVault = false,
    this.tags = const [],
    this.linkedEntityIds = const [],
    this.documentDate,
    this.vendor,
    this.amount,
    this.currency,
    this.notes,
    this.requestAi = false,
  });

  String title;
  String? categoryId;
  Privacy privacy;
  bool isVault;
  List<String> tags;
  List<String> linkedEntityIds;
  DateTime? documentDate;
  String? vendor;
  double? amount;
  String? currency;
  String? notes;

  /// Only honoured server-side when the plan includes AI.
  bool requestAi;
}

class DocumentRepository extends RecordRepository<DocumentRecord> {
  DocumentRepository(this._db, this._storage, this._functions) : super(_db, 'documents', DocumentRecord.fromMap);

  final FirebaseFirestore _db;
  final StorageService _storage;
  final FunctionsService _functions;

  /// Upload flow:
  ///  1. metadata record created with status `uploading` (rules check quota),
  ///  2. file uploaded to the exact declared private path (rules check owner/type/size/quota),
  ///  3. status moved to `uploaded` — server validates content and may run AI.
  /// Success is reported only after both the file and metadata are confirmed.
  Future<String> create({
    required String uid,
    required PreparedFile file,
    required NewDocumentInput input,
    void Function(double progress)? onProgress,
  }) async {
    final id = newId();
    final path = 'users/$uid/documents/$id/document.${file.extension}';
    final record = DocumentRecord(
      id: id,
      ownerUid: uid,
      title: input.title.trim(),
      storagePath: path,
      mimeType: file.mime,
      privacy: input.privacy,
      categoryId: input.categoryId,
      tags: input.tags,
      fileSizeBytes: file.bytes.length,
      pageCount: file.pageCount,
      documentDate: input.documentDate,
      vendor: input.vendor,
      amount: input.amount,
      currency: input.currency,
      linkedEntityIds: input.linkedEntityIds,
      processingStatus: ProcessingStatus.uploading,
      isVault: input.isVault,
      notes: input.notes,
      contentHash: file.sha256,
    );
    try {
      await save(record, isNew: true);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw const AppError(AppErrorCode.documentLimit);
      throw AppError.from(e);
    }
    try {
      await _storage.upload(path, file.bytes, file.mime, onProgress: onProgress);
    } on AppError catch (e) {
      // The screen's retry creates a fresh record, so park this one in the
      // trash: it holds no file and must not count toward the document limit.
      await patch(id, {'processingStatus': 'failed', 'deletedAt': DateTime.now()}).catchError((_) {});
      if (e.code == AppErrorCode.permissionDenied) throw const AppError(AppErrorCode.storageLimit);
      rethrow;
    }
    await patch(id, {'processingStatus': input.requestAi ? 'uploaded' : 'ready'});
    return id;
  }

  /// Retry a failed upload for an existing record (same path).
  Future<void> retryUpload(DocumentRecord d, PreparedFile file, {void Function(double)? onProgress}) async {
    await patch(d.id, {'processingStatus': 'uploading'});
    await _storage.upload(d.storagePath, file.bytes, file.mime, onProgress: onProgress);
    await patch(d.id, {'processingStatus': 'ready'});
  }

  Future<Uint8List> fileBytes(DocumentRecord d) => _storage.download(d.storagePath);

  Future<void> setFavorite(String id, bool v) => patch(id, {'isFavorite': v});
  Future<void> moveToTrash(String id) => patch(id, {'deletedAt': DateTime.now()});
  Future<void> restore(String id) => patch(id, {'deletedAt': null});

  /// Permanent deletion (server removes the file, extraction and record).
  Future<void> purge(String id) => _functions.call('purgeDocument', {'documentId': id});

  Future<void> runAi(String id) => _functions.call('extractDocument', {'documentId': id}, const Duration(seconds: 130));

  Stream<Extraction?> watchExtraction(String id) => _db
      .collection('documentExtractions')
      .doc(id)
      .snapshots()
      .map((s) => s.exists ? Extraction.fromMap(s.id, decode(s.data()!)) : null);

  /// Possible duplicate (same content hash) — shown as a suggestion only.
  DocumentRecord? findDuplicate(List<DocumentRecord> docs, String sha) {
    for (final d in docs) {
      if (d.contentHash == sha && !d.inTrash) return d;
    }
    return null;
  }

  /// Adds/removes a link to another entity (no file duplication).
  Future<void> setLinks(String id, List<String> links) => patch(id, {'linkedEntityIds': links});
}
