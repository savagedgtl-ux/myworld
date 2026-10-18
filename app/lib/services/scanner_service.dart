import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/errors/app_error.dart';
import '../domain/logic/validation.dart';
import '../domain/plans.dart';

/// One scanned or picked page kept in memory until the user saves.
class ScanPage {
  ScanPage(this.bytes, {this.rotationQuarterTurns = 0});
  Uint8List bytes;
  int rotationQuarterTurns;
}

class PreparedFile {
  const PreparedFile({required this.bytes, required this.mime, required this.pageCount, required this.sha256});
  final Uint8List bytes;
  final String mime;
  final int pageCount;
  final String sha256;
  String get extension => switch (mime) {
        'application/pdf' => 'pdf',
        'image/png' => 'png',
        'image/heic' || 'image/heif' => 'heic',
        _ => 'jpg',
      };
}

/// Camera document scanning (edge detection, perspective correction, auto/manual
/// capture handled by VisionKit on iOS and ML Kit Document Scanner on Android),
/// page editing and PDF assembly.
class ScannerService {
  final _picker = ImagePicker();

  /// Opens the native scanner. Returns null if the user cancelled.
  Future<List<ScanPage>?> scan({int maxPages = UploadLimits.maxPages}) async {
    try {
      final paths = await CunningDocumentScanner.getPictures(noOfPages: maxPages, scannerSource: ScannerSource.cameraAndGallery);
      if (paths == null || paths.isEmpty) return null;
      final pages = <ScanPage>[];
      for (final p in paths) {
        final f = File(p);
        pages.add(ScanPage(await f.readAsBytes()));
        await _secureDelete(f);
      }
      return pages;
    } catch (e) {
      if (e is AppError) rethrow;
      throw const AppError(AppErrorCode.cancelled);
    }
  }

  /// Single photo (camera) — used for item photos, cards, business cards.
  Future<Uint8List?> takePhoto() => _pick(ImageSource.camera);
  Future<Uint8List?> pickImage() => _pick(ImageSource.gallery);

  Future<Uint8List?> _pick(ImageSource source) async {
    final x = await _picker.pickImage(source: source, maxWidth: 2400, maxHeight: 2400, imageQuality: 90, requestFullMetadata: false);
    if (x == null) return null;
    final bytes = await x.readAsBytes();
    await _secureDelete(File(x.path));
    return bytes;
  }

  Future<List<Uint8List>> pickImages() async {
    final xs = await _picker.pickMultiImage(maxWidth: 2400, maxHeight: 2400, imageQuality: 90, requestFullMetadata: false);
    final out = <Uint8List>[];
    for (final x in xs) {
      out.add(await x.readAsBytes());
      await _secureDelete(File(x.path));
    }
    return out;
  }

  /// Compresses an image page while keeping text readable on small screens.
  Future<Uint8List> compressPage(Uint8List bytes, {int rotate = 0}) async {
    final out = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1700,
      minHeight: 1700,
      quality: 82,
      rotate: rotate * 90,
      format: CompressFormat.jpeg,
      keepExif: false,
    );
    return out;
  }

  /// Combines pages into one PDF (A4, page fitted). Single-page scans are
  /// still stored as PDF for consistency.
  Future<PreparedFile> buildPdf(List<ScanPage> pages) async {
    if (pages.isEmpty) throw const AppError(AppErrorCode.unsupportedFile);
    if (pages.length > UploadLimits.maxPages) throw const AppError(AppErrorCode.fileTooLarge);
    final doc = pw.Document(compress: true, title: 'MyWorld+ scan');
    for (final p in pages) {
      final jpg = await compressPage(p.bytes, rotate: p.rotationQuarterTurns);
      final img = pw.MemoryImage(jpg);
      doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (_) => pw.Center(child: pw.Image(img, fit: pw.BoxFit.contain)),
      ));
    }
    final bytes = Uint8List.fromList(await doc.save());
    return _checked(bytes, pages.length);
  }

  /// Validates an existing file (PDF or image) picked by the user.
  Future<PreparedFile> prepareExisting(Uint8List bytes) async {
    final check = validateUpload(bytes);
    if (check is FileRejected) {
      throw AppError(check.reason == 'too_large' ? AppErrorCode.fileTooLarge : AppErrorCode.unsupportedFile);
    }
    final mime = (check as FileOk).mime;
    var data = bytes;
    if (mime == 'image/jpeg' || mime == 'image/png') {
      // Strip EXIF (location etc.) and reduce size.
      data = await compressPage(bytes);
      return _checked(data, 1);
    }
    return _checked(data, mime == 'application/pdf' ? _countPdfPages(bytes) : 1);
  }

  PreparedFile _checked(Uint8List bytes, int pages) {
    final check = validateUpload(bytes);
    if (check is FileRejected) {
      throw AppError(check.reason == 'too_large' ? AppErrorCode.fileTooLarge : AppErrorCode.unsupportedFile);
    }
    return PreparedFile(bytes: bytes, mime: (check as FileOk).mime, pageCount: pages, sha256: sha256.convert(bytes).toString());
  }

  /// Rough page count from the PDF structure (good enough for display/limits).
  int _countPdfPages(Uint8List bytes) {
    final s = String.fromCharCodes(bytes.length > 4 * 1024 * 1024 ? bytes.sublist(0, 4 * 1024 * 1024) : bytes);
    final n = RegExp(r'/Type\s*/Page[^s]').allMatches(s).length;
    return n == 0 ? 1 : n;
  }

  /// Temporary copies are removed as soon as they are in memory.
  Future<void> _secureDelete(File f) async {
    try {
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  Future<void> cleanup() async {
    try {
      await CunningDocumentScanner.cleanCache();
    } catch (_) {}
  }
}
