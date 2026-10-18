import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_error.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';
import 'buttons.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.message, this.actionLabel, this.onAction, this.secondary});

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, shape: BoxShape.circle),
            child: Icon(icon, size: 38, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: Space.lg),
          Text(title, style: t.titleLarge, textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: Space.sm),
            Text(message!, style: t.bodySmall, textAlign: TextAlign.center),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: Space.xl),
            PrimaryButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
          if (secondary != null) ...[const SizedBox(height: Space.md), secondary!],
        ]),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: message ?? context.l10n.loading,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircularProgressIndicator(),
            if (message != null) ...[const SizedBox(height: Space.md), Text(message!, style: Theme.of(context).textTheme.bodySmall)],
          ]),
        ),
      );
}

/// Shimmer-free skeleton rows for lists (fast and accessible).
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key, this.rows = 5});
  final int rows;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      label: context.l10n.loading,
      child: Column(children: [
        for (var i = 0; i < rows; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.sm),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(Radii.sm))),
              const SizedBox(width: Space.md),
              Expanded(child: Container(height: 14, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(6)))),
            ]),
          ),
      ]),
    );
  }
}

String errorMessage(BuildContext context, Object error) {
  final l = context.l10n;
  final e = AppError.from(error);
  return switch (e.code) {
    AppErrorCode.network => l.errNetwork,
    AppErrorCode.unavailable => l.errUnavailable,
    AppErrorCode.permissionDenied => l.errPermission,
    AppErrorCode.sessionExpired => l.errSession,
    AppErrorCode.notFound => l.errNotFound,
    AppErrorCode.wrongPassword => l.errWrongPassword,
    AppErrorCode.userNotFound => l.errUserNotFound,
    AppErrorCode.emailInUse => l.errEmailInUse,
    AppErrorCode.weakPassword => l.errWeakPassword,
    AppErrorCode.invalidEmail => l.errInvalidEmail,
    AppErrorCode.tooManyRequests => l.errTooMany,
    AppErrorCode.emailNotVerified => l.errEmailNotVerified,
    AppErrorCode.recentLoginRequired => l.errRecentLogin,
    AppErrorCode.aiNotInPlan => l.errAiNotInPlan,
    AppErrorCode.aiLimit => l.errAiLimit,
    AppErrorCode.aiFailed => l.errAiFailed,
    AppErrorCode.familyPlanRequired => l.errFamilyPlan,
    AppErrorCode.familyFull => l.errFamilyFull,
    AppErrorCode.familyHasMembers => l.errFamilyHasMembers,
    AppErrorCode.alreadyInFamily => l.errAlreadyInFamily,
    AppErrorCode.invitationInvalid => l.errInvitationInvalid,
    AppErrorCode.invitationExpired => l.errInvitationExpired,
    AppErrorCode.invitationEmailMismatch => l.errInvitationEmail,
    AppErrorCode.storageLimit => l.errStorageLimit,
    AppErrorCode.documentLimit => l.errDocumentLimit,
    AppErrorCode.unsupportedFile => l.errUnsupportedFile,
    AppErrorCode.fileTooLarge => l.errFileTooLarge,
    AppErrorCode.cancelled => l.errCancelled,
    AppErrorCode.unknown => l.errGeneric,
  };
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, this.onRetry});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final code = AppError.from(error).code;
    final icon = switch (code) {
      AppErrorCode.network => Icons.wifi_off_rounded,
      AppErrorCode.permissionDenied => Icons.lock_outline,
      AppErrorCode.sessionExpired => Icons.timer_off_outlined,
      _ => Icons.error_outline,
    };
    return EmptyState(
      icon: icon,
      title: code == AppErrorCode.permissionDenied ? context.l10n.permissionDeniedTitle : context.l10n.errTitle,
      message: errorMessage(context, error),
      actionLabel: onRetry == null ? null : context.l10n.retry,
      onAction: onRetry,
    );
  }
}

void showError(BuildContext context, Object error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(errorMessage(context, error)), backgroundColor: AppColors.error));
}

void showSuccess(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: Space.sm), Expanded(child: Text(message))]),
      backgroundColor: AppColors.success,
    ));
}

/// Consistent loading / error / data rendering for Riverpod AsyncValues.
Widget asyncView<T>(AsyncValue<T> value, Widget Function(T data) data, {VoidCallback? onRetry, Widget? loading}) {
  if (value.hasValue) return data(value.value as T);
  if (value.hasError) return ErrorState(error: value.error!, onRetry: onRetry);
  return loading ?? const LoadingState();
}
