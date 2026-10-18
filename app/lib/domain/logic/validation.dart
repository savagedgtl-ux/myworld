import 'dart:typed_data';

import '../plans.dart';

/// Detects the real type of a file from its first bytes. The extension is never trusted.
String? sniffMime(Uint8List head) {
  bool at(int i, List<int> sig) {
    if (head.length < i + sig.length) return false;
    for (var k = 0; k < sig.length; k++) {
      if (head[i + k] != sig[k]) return false;
    }
    return true;
  }

  if (at(0, [0x25, 0x50, 0x44, 0x46, 0x2d])) return 'application/pdf';
  if (at(0, [0xff, 0xd8, 0xff])) return 'image/jpeg';
  if (at(0, [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])) return 'image/png';
  if (at(0, [0x52, 0x49, 0x46, 0x46]) && at(8, [0x57, 0x45, 0x42, 0x50])) return 'image/webp';
  if (at(4, [0x66, 0x74, 0x79, 0x70]) && head.length >= 12) {
    final brand = String.fromCharCodes(head.sublist(8, 12));
    if (const {'heic', 'heix', 'hevc', 'hevx', 'mif1', 'msf1', 'heim', 'heis'}.contains(brand)) return 'image/heic';
  }
  return null;
}

sealed class FileCheck {
  const FileCheck();
}

class FileOk extends FileCheck {
  const FileOk(this.mime);
  final String mime;
}

class FileRejected extends FileCheck {
  const FileRejected(this.reason);

  /// 'unsupported_type' | 'too_large' | 'empty'
  final String reason;
}

FileCheck validateUpload(Uint8List bytes) {
  if (bytes.isEmpty) return const FileRejected('empty');
  if (bytes.length > UploadLimits.maxBytes) return const FileRejected('too_large');
  final mime = sniffMime(bytes.sublist(0, bytes.length < 16 ? bytes.length : 16));
  if (mime == null || !UploadLimits.allowedMime.contains(mime)) return const FileRejected('unsupported_type');
  return FileOk(mime);
}

String? validateTitle(String? v) {
  final s = v?.trim() ?? '';
  if (s.isEmpty) return 'required';
  if (s.length > 200) return 'too_long';
  return null;
}

/// Parses a user-entered amount accepting both "1.234,56" and "1,234.56".
double? parseAmount(String input) {
  var s = input.trim().replaceAll(RegExp(r'[^\d,.\-]'), '');
  if (s.isEmpty) return null;
  final lastComma = s.lastIndexOf(',');
  final lastDot = s.lastIndexOf('.');
  if (lastComma > lastDot) {
    s = s.replaceAll('.', '').replaceAll(',', '.');
  } else {
    s = s.replaceAll(',', '');
  }
  final v = double.tryParse(s);
  if (v == null || v < 0 || v > 1e9) return null;
  return v;
}

bool isValidCurrency(String? c) => c != null && RegExp(r'^[A-Z]{3}$').hasMatch(c);

const commonCurrencies = ['EUR', 'RSD', 'USD', 'GBP', 'CHF', 'BAM', 'HRK', 'MKD', 'HUF', 'RON', 'BGN', 'CZK', 'PLN', 'SEK', 'NOK', 'DKK'];

bool isValidEmail(String s) => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s.trim());

/// Basic VIN check (17 chars, no I/O/Q).
bool isValidVin(String s) => RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(s.toUpperCase());

/// Password policy for e-mail sign-up.
String? validatePassword(String s) {
  if (s.length < 8) return 'too_short';
  if (!RegExp(r'[A-Za-z]').hasMatch(s) || !RegExp(r'\d').hasMatch(s)) return 'weak';
  return null;
}
