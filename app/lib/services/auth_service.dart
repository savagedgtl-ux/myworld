import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/config/app_config.dart';
import '../core/errors/app_error.dart';
import 'functions_service.dart';

class AuthService {
  AuthService(this._auth, this._functions);

  final FirebaseAuth _auth;
  final FunctionsService _functions;
  bool _googleReady = false;

  Stream<User?> authChanges() => _auth.userChanges();
  User? get currentUser => _auth.currentUser;

  Future<T> _guard<T>(Future<T> Function() f) async {
    try {
      return await f();
    } catch (e) {
      throw AppError.from(e);
    }
  }

  /// Ensures server-side docs (entitlement, usage) exist. Safe to call often.
  /// Best effort: the user is already signed in at this point, and the app
  /// falls back to the base entitlement until the docs appear, so a missing or
  /// unreachable function must not turn a successful sign-in into an error.
  Future<void> _afterSignIn() async {
    try {
      await _functions.call('bootstrapAccount', const {}, const Duration(seconds: 15));
    } catch (e) {
      debugPrint('bootstrapAccount failed: $e');
    }
  }

  Future<void> signInWithEmail(String email, String password) => _guard(() async {
        await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
        await _afterSignIn();
      });

  Future<void> signUpWithEmail(String email, String password) => _guard(() async {
        final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
        await cred.user?.sendEmailVerification();
        await _afterSignIn();
      });

  Future<void> sendPasswordReset(String email) => _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> resendVerification() => _guard(() async => _auth.currentUser?.sendEmailVerification());

  Future<bool> reloadAndCheckVerified() => _guard(() async {
        await _auth.currentUser?.reload();
        return _auth.currentUser?.emailVerified ?? false;
      });

  Future<void> signInWithGoogle() => _guard(() async {
        final g = GoogleSignIn.instance;
        if (!_googleReady) {
          await g.initialize(serverClientId: AppConfig.googleServerClientId.isEmpty ? null : AppConfig.googleServerClientId);
          _googleReady = true;
        }
        final account = await g.authenticate();
        final idToken = account.authentication.idToken;
        if (idToken == null) throw const AppError(AppErrorCode.cancelled);
        await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
        await _afterSignIn();
      });

  /// Sign in with Apple (required on iOS when other social logins are offered).
  Future<void> signInWithApple() => _guard(() async {
        final provider = AppleAuthProvider()..addScope('email')..addScope('name');
        await _auth.signInWithProvider(provider);
        await _afterSignIn();
      });

  bool get appleAvailable => Platform.isIOS || Platform.isMacOS || Platform.isAndroid;

  /// Re-authentication required before account deletion.
  Future<void> reauthenticate({String? password}) => _guard(() async {
        final user = _auth.currentUser!;
        final providers = user.providerData.map((p) => p.providerId).toSet();
        if (providers.contains('password') && password != null) {
          await user.reauthenticateWithCredential(EmailAuthProvider.credential(email: user.email!, password: password));
        } else if (providers.contains('google.com')) {
          final account = await GoogleSignIn.instance.authenticate();
          await user.reauthenticateWithCredential(GoogleAuthProvider.credential(idToken: account.authentication.idToken));
        } else if (providers.contains('apple.com')) {
          await user.reauthenticateWithProvider(AppleAuthProvider());
        } else {
          throw const AppError(AppErrorCode.recentLoginRequired);
        }
        await user.getIdToken(true);
      });

  Set<String> get providerIds => {...?_auth.currentUser?.providerData.map((p) => p.providerId)};

  Future<void> signOut() async {
    if (_googleReady) await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
