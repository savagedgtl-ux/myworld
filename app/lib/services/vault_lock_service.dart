import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Extra UI-level protection for the Vault (biometrics / PIN).
///
/// IMPORTANT: this is NOT encryption and does not replace server-side
/// authorization — Vault documents are protected by the same Firestore and
/// Storage rules as everything else. The lock only stops someone holding an
/// unlocked phone from casually opening the Vault.
class VaultLockService {
  VaultLockService({FlutterSecureStorage? storage, LocalAuthentication? auth})
      : _storage = storage ?? const FlutterSecureStorage(),
        _auth = auth ?? LocalAuthentication();

  final FlutterSecureStorage _storage;
  final LocalAuthentication _auth;
  static const _kEnabled = 'vault_lock_enabled';
  static const _kBiometric = 'vault_lock_biometric';
  static const _kPinHash = 'vault_pin_hash';
  static const _kPinSalt = 'vault_pin_salt';
  static const _kFailed = 'vault_pin_failed';

  DateTime? _unlockedAt;
  static const unlockWindow = Duration(minutes: 3);

  Future<bool> isEnabled() async => await _storage.read(key: _kEnabled) == 'true';
  Future<bool> biometricEnabled() async => await _storage.read(key: _kBiometric) == 'true';
  Future<bool> hasPin() async => await _storage.read(key: _kPinHash) != null;

  bool get isUnlocked => _unlockedAt != null && DateTime.now().difference(_unlockedAt!) < unlockWindow;
  void lock() => _unlockedAt = null;

  Future<bool> biometricsAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  static String hashPin(String pin, String salt) {
    // Iterated SHA-256 with a random per-device salt; never stored in plain text.
    List<int> digest = utf8.encode('$salt:$pin');
    for (var i = 0; i < 20000; i++) {
      digest = sha256.convert(digest).bytes;
    }
    return base64Encode(digest);
  }

  Future<void> enable({required String pin, required bool biometric}) async {
    if (!RegExp(r'^\d{4,8}$').hasMatch(pin)) throw ArgumentError('pin');
    final rnd = Random.secure();
    final salt = base64Encode(List<int>.generate(16, (_) => rnd.nextInt(256)));
    await _storage.write(key: _kPinSalt, value: salt);
    await _storage.write(key: _kPinHash, value: hashPin(pin, salt));
    await _storage.write(key: _kBiometric, value: '$biometric');
    await _storage.write(key: _kEnabled, value: 'true');
    await _storage.delete(key: _kFailed);
    _unlockedAt = DateTime.now();
  }

  Future<void> disable() async {
    for (final k in [_kEnabled, _kBiometric, _kPinHash, _kPinSalt, _kFailed]) {
      await _storage.delete(key: k);
    }
    _unlockedAt = null;
  }

  Future<bool> unlockWithBiometrics(String reason) async {
    try {
      final ok = await _auth.authenticate(localizedReason: reason, biometricOnly: false);
      if (ok) _unlockedAt = DateTime.now();
      return ok;
    } catch (_) {
      return false;
    }
  }

  /// Returns remaining attempts on failure, or -1 on success.
  Future<int> unlockWithPin(String pin) async {
    final salt = await _storage.read(key: _kPinSalt);
    final hash = await _storage.read(key: _kPinHash);
    if (salt == null || hash == null) return 0;
    if (hashPin(pin, salt) == hash) {
      await _storage.delete(key: _kFailed);
      _unlockedAt = DateTime.now();
      return -1;
    }
    final failed = int.tryParse(await _storage.read(key: _kFailed) ?? '0')! + 1;
    await _storage.write(key: _kFailed, value: '$failed');
    return max(0, 5 - failed);
  }
}
