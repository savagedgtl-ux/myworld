import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Normalised error codes the UI can translate. Raw exception text is never
/// shown to the user or sent to logs with document content.
enum AppErrorCode {
  network,
  unavailable,
  permissionDenied,
  sessionExpired,
  notFound,
  wrongPassword,
  userNotFound,
  emailInUse,
  weakPassword,
  invalidEmail,
  tooManyRequests,
  emailNotVerified,
  recentLoginRequired,
  aiNotInPlan,
  aiLimit,
  aiFailed,
  familyPlanRequired,
  familyFull,
  familyHasMembers,
  alreadyInFamily,
  invitationInvalid,
  invitationExpired,
  invitationEmailMismatch,
  storageLimit,
  documentLimit,
  unsupportedFile,
  fileTooLarge,
  cancelled,
  unknown,
}

class AppError implements Exception {
  const AppError(this.code, [this.detail]);
  final AppErrorCode code;
  final String? detail;

  @override
  String toString() => 'AppError($code)';

  static AppError from(Object e) {
    if (e is AppError) return e;
    if (e is FirebaseFunctionsException) return _fromServer(e.code, e.message);
    if (e is FirebaseAuthException) {
      return AppError(switch (e.code) {
        'wrong-password' || 'invalid-credential' => AppErrorCode.wrongPassword,
        'user-not-found' => AppErrorCode.userNotFound,
        'email-already-in-use' => AppErrorCode.emailInUse,
        'weak-password' => AppErrorCode.weakPassword,
        'invalid-email' => AppErrorCode.invalidEmail,
        'too-many-requests' => AppErrorCode.tooManyRequests,
        'network-request-failed' => AppErrorCode.network,
        'requires-recent-login' => AppErrorCode.recentLoginRequired,
        'user-token-expired' || 'user-disabled' => AppErrorCode.sessionExpired,
        _ => AppErrorCode.unknown,
      });
    }
    if (e is FirebaseException) {
      return AppError(switch (e.code) {
        'permission-denied' || 'unauthorized' => AppErrorCode.permissionDenied,
        'unavailable' => AppErrorCode.unavailable,
        'not-found' || 'object-not-found' => AppErrorCode.notFound,
        'unauthenticated' => AppErrorCode.sessionExpired,
        'quota-exceeded' => AppErrorCode.storageLimit,
        'canceled' => AppErrorCode.cancelled,
        'retry-limit-exceeded' => AppErrorCode.network,
        _ => AppErrorCode.unknown,
      });
    }
    return const AppError(AppErrorCode.unknown);
  }

  static AppError _fromServer(String code, String? message) {
    final m = message ?? '';
    final mapped = switch (m) {
      'ai_not_in_plan' => AppErrorCode.aiNotInPlan,
      'ai_monthly_limit' || 'ai_rate_limited' || 'ai_family_limit' => AppErrorCode.aiLimit,
      'ai_failed' || 'ai_invalid_output' || 'ai_temporarily_unavailable' || 'ai_provider_busy' || 'ai_not_configured' =>
        AppErrorCode.aiFailed,
      'family_plan_required' => AppErrorCode.familyPlanRequired,
      'family_full' => AppErrorCode.familyFull,
      'family_has_members' => AppErrorCode.familyHasMembers,
      'already_in_family' => AppErrorCode.alreadyInFamily,
      'invitation_invalid' || 'invitation_used' => AppErrorCode.invitationInvalid,
      'invitation_expired' => AppErrorCode.invitationExpired,
      'invitation_email_mismatch' => AppErrorCode.invitationEmailMismatch,
      'recent_login_required' => AppErrorCode.recentLoginRequired,
      _ => null,
    };
    if (mapped != null) return AppError(mapped);
    return AppError(switch (code) {
      'unauthenticated' => AppErrorCode.sessionExpired,
      'permission-denied' => AppErrorCode.permissionDenied,
      'unavailable' || 'deadline-exceeded' => AppErrorCode.unavailable,
      'resource-exhausted' => AppErrorCode.aiLimit,
      'not-found' => AppErrorCode.notFound,
      _ => AppErrorCode.unknown,
    });
  }
}
