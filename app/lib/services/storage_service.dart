import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../core/errors/app_error.dart';

/// Private file storage. No public download URLs are created or stored —
/// files are read through the SDK so every read passes storage.rules.
class StorageService {
  StorageService(this._storage);
  final FirebaseStorage _storage;

  /// Uploads bytes and reports progress (0..1). Throws [AppError] on failure.
  Future<void> upload(String path, Uint8List bytes, String contentType, {void Function(double)? onProgress}) async {
    final task = _storage.ref(path).putData(bytes, SettableMetadata(contentType: contentType, cacheControl: 'private, max-age=0'));
    final sub = task.snapshotEvents.listen((s) {
      if (s.totalBytes > 0) onProgress?.call(s.bytesTransferred / s.totalBytes);
    });
    try {
      await task;
    } catch (e) {
      throw AppError.from(e);
    } finally {
      await sub.cancel();
    }
  }

  final _cache = <String, Uint8List>{};

  /// Downloads a private file into memory (never into a shared/public cache).
  Future<Uint8List> download(String path, {int maxBytes = 30 * 1024 * 1024}) async {
    final cached = _cache[path];
    if (cached != null) return cached;
    try {
      final data = await _storage.ref(path).getData(maxBytes);
      if (data == null) throw const AppError(AppErrorCode.notFound);
      if (_cache.length > 40) _cache.remove(_cache.keys.first);
      _cache[path] = data;
      return data;
    } catch (e) {
      throw AppError.from(e);
    }
  }

  Future<void> deletePhoto(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (_) {
      // Missing photo is not an error for the user.
    }
  }

  void clearMemoryCache() => _cache.clear();
}
