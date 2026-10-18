import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/languages.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/validation.dart';

const _secure = FlutterSecureStorage();
const onboardingSeenKey = 'onboarding_seen';

class Logo extends StatelessWidget {
  const Logo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'MyWorld+',
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(size * 0.3),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Icon(Icons.public, color: Colors.white, size: size * 0.55),
              Positioned(right: size * 0.12, top: size * 0.1, child: Icon(Icons.add_rounded, color: AppColors.accent, size: size * 0.32)),
            ]),
          ),
          const SizedBox(height: Space.md),
          Text('MyWorld+', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        ]),
      );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Logo(size: 88)));
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  Future<void> _finish() async {
    await _secure.write(key: onboardingSeenKey, value: 'true');
    if (mounted) context.go('/auth/sign-up');
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pages = [
      (Icons.public, l.onboarding1Title, l.onboarding1Body),
      (Icons.document_scanner_outlined, l.onboarding2Title, l.onboarding2Body),
      (Icons.search_rounded, l.onboarding3Title, l.onboarding3Body),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _finish, child: Text(l.skip))),
          Expanded(
            child: PageView(
              controller: _page,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                for (final p in pages)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.xxl),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, shape: BoxShape.circle),
                        child: Icon(p.$1, size: 76, color: AppColors.secondary),
                      ),
                      const SizedBox(height: Space.xxl),
                      Text(p.$2, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                      const SizedBox(height: Space.md),
                      Text(p.$3, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                    ]),
                  ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < pages.length; i++)
              AnimatedContainer(
                duration: Motion.of(context, Motion.fast),
                margin: const EdgeInsets.all(4),
                width: i == _index ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(color: i == _index ? AppColors.primary : AppColors.divider, borderRadius: BorderRadius.circular(4)),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(children: [
              PrimaryButton(
                label: _index == pages.length - 1 ? l.getStarted : l.next,
                onPressed: () => _index == pages.length - 1
                    ? _finish()
                    : _page.nextPage(duration: Motion.of(context, Motion.normal), curve: Curves.easeOut),
              ),
              const SizedBox(height: Space.sm),
              TextButton(
                onPressed: () async {
                  await _secure.write(key: onboardingSeenKey, value: 'true');
                  if (context.mounted) context.go('/auth/sign-in');
                },
                child: Text(l.haveAccount),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _SocialButtons extends ConsumerWidget {
  const _SocialButtons({required this.onBusy});
  final ValueChanged<bool> onBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    Future<void> run(Future<void> Function() f) async {
      onBusy(true);
      try {
        await f();
      } on AppError catch (e) {
        if (e.code != AppErrorCode.cancelled && context.mounted) showError(context, e);
      } catch (e) {
        if (context.mounted) showError(context, e);
      } finally {
        onBusy(false);
      }
    }

    return Column(children: [
      Row(children: [
        const Expanded(child: Divider()),
        Padding(padding: const EdgeInsets.symmetric(horizontal: Space.md), child: Text(context.l10n.orContinueWith, style: Theme.of(context).textTheme.bodySmall)),
        const Expanded(child: Divider()),
      ]),
      const SizedBox(height: Space.lg),
      if (Platform.isIOS) ...[
        SecondaryButton(label: context.l10n.continueApple, icon: Icons.apple, onPressed: () => run(auth.signInWithApple)),
        const SizedBox(height: Space.md),
      ],
      SecondaryButton(label: context.l10n.continueGoogle, icon: Icons.g_mobiledata_rounded, onPressed: () => run(auth.signInWithGoogle)),
      if (Platform.isAndroid) ...[
        const SizedBox(height: Space.md),
        SecondaryButton(label: context.l10n.continueApple, icon: Icons.apple, onPressed: () => run(auth.signInWithApple)),
      ],
    ]);
  }
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.signUp = false});
  final bool signUp;
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _obscure = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (widget.signUp && !_acceptedTerms) {
      showError(context, const AppError(AppErrorCode.unknown));
      return;
    }
    setState(() => _busy = true);
    try {
      final auth = ref.read(authServiceProvider);
      if (widget.signUp) {
        await auth.signUpWithEmail(_email.text, _password.text);
      } else {
        await auth.signInWithEmail(_email.text, _password.text);
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _testSignIn() async {
    setState(() => _busy = true);
    try {
      await ref.read(authServiceProvider).signInWithEmail(AppConfig.testLoginEmail, AppConfig.testLoginPassword);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final up = widget.signUp;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.xl),
            child: AutofillGroup(
              child: Form(
                key: _form,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Logo(size: 60),
                  const SizedBox(height: Space.xl),
                  Text(up ? l.signUpTitle : l.signInTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: Space.sm),
                  Text(l.tagline, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: Space.xl),
                  AppTextField(
                    label: l.email,
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    autofill: const [AutofillHints.email],
                    validator: (v) => isValidEmail(v ?? '') ? null : l.errInvalidEmail,
                  ),
                  fieldGap,
                  AppTextField(
                    label: l.password,
                    controller: _password,
                    obscure: _obscure,
                    textCapitalization: TextCapitalization.none,
                    autofill: [up ? AutofillHints.newPassword : AutofillHints.password],
                    helper: up ? l.passwordHelp : null,
                    suffix: IconButton(
                      tooltip: _obscure ? l.showPassword : l.hidePassword,
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) {
                      if (!up) return (v ?? '').isEmpty ? l.required : null;
                      return switch (validatePassword(v ?? '')) {
                        'too_short' => l.passwordTooShort,
                        'weak' => l.passwordWeak,
                        _ => null,
                      };
                    },
                  ),
                  if (!up)
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => context.push('/auth/reset'), child: Text(l.forgotPassword))),
                  if (up)
                    CheckboxListTile(
                      value: _acceptedTerms,
                      onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l.acceptTerms, style: Theme.of(context).textTheme.bodySmall),
                      secondary: IconButton(tooltip: l.legal, icon: const Icon(Icons.open_in_new, size: 18), onPressed: () => context.push('/settings/legal')),
                    ),
                  const SizedBox(height: Space.md),
                  PrimaryButton(label: up ? l.createAccount : l.signIn, loading: _busy, onPressed: up && !_acceptedTerms ? null : _submit),
                  if (AppConfig.hasTestLogin && !up) ...[
                    const SizedBox(height: Space.md),
                    SecondaryButton(label: l.signInAsTester, icon: Icons.science_outlined, onPressed: _busy ? null : _testSignIn),
                  ],
                  const SizedBox(height: Space.xl),
                  _SocialButtons(onBusy: (b) => setState(() => _busy = b)),
                  const SizedBox(height: Space.lg),
                  TextButton(
                    onPressed: () => context.go(up ? '/auth/sign-in' : '/auth/sign-up'),
                    child: Text(up ? l.haveAccount : l.noAccount),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.resetPassword)),
      body: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: _sent
            ? EmptyState(icon: Icons.mark_email_read_outlined, title: l.resetSentTitle, message: l.resetSentBody, actionLabel: l.backToSignIn, onAction: () => context.go('/auth/sign-in'))
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(l.resetPasswordBody, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: Space.xl),
                AppTextField(label: l.email, controller: _email, keyboardType: TextInputType.emailAddress, textCapitalization: TextCapitalization.none),
                const SizedBox(height: Space.xl),
                PrimaryButton(
                  label: l.sendLink,
                  loading: _busy,
                  onPressed: () async {
                    if (!isValidEmail(_email.text)) return showError(context, const AppError(AppErrorCode.invalidEmail));
                    setState(() => _busy = true);
                    try {
                      await ref.read(authServiceProvider).sendPasswordReset(_email.text);
                      // Same message whether or not the account exists (no account enumeration).
                      setState(() => _sent = true);
                    } on AppError catch (e) {
                      if (e.code == AppErrorCode.userNotFound) {
                        setState(() => _sent = true);
                      } else if (context.mounted) {
                        showError(context, e);
                      }
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                ),
              ]),
      ),
    );
  }
}

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = ref.read(authServiceProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(children: [
            Expanded(
              child: EmptyState(
                icon: Icons.mark_email_unread_outlined,
                title: l.verifyEmailTitle,
                message: l.verifyEmailBody(auth.currentUser?.email ?? ''),
              ),
            ),
            PrimaryButton(
              label: l.iVerified,
              loading: _busy,
              onPressed: () async {
                setState(() => _busy = true);
                try {
                  final ok = await auth.reloadAndCheckVerified();
                  if (!ok && context.mounted) showError(context, const AppError(AppErrorCode.emailNotVerified));
                } catch (e) {
                  if (context.mounted) showError(context, e);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
            ),
            const SizedBox(height: Space.md),
            SecondaryButton(
              label: l.resendEmail,
              onPressed: () async {
                try {
                  await auth.resendVerification();
                  if (context.mounted) showSuccess(context, l.emailSent);
                } catch (e) {
                  if (context.mounted) showError(context, e);
                }
              },
            ),
            TextButton(onPressed: auth.signOut, child: Text(l.signOut)),
          ]),
        ),
      ),
    );
  }
}

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  String _lang = deviceLanguage();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name.text = ref.read(authServiceProvider).currentUser?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.profileSetupTitle), automaticallyImplyLeading: false),
      body: ListView(padding: const EdgeInsets.all(Space.xl), children: [
        Text(l.profileSetupBody, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.xl),
        AppTextField(label: l.displayName, controller: _name, maxLength: 80, textCapitalization: TextCapitalization.words),
        fieldGap,
        DropdownButtonFormField<String>(
          initialValue: _lang,
          decoration: InputDecoration(labelText: l.language),
          items: [for (final code in supportedLanguages) DropdownMenuItem(value: code, child: Text(languageName(l, code)))],
          onChanged: (v) => setState(() => _lang = v ?? 'sr'),
        ),
        const SizedBox(height: Space.xl),
        PrimaryButton(
          label: l.continueLabel,
          loading: _busy,
          onPressed: () async {
            final name = _name.text.trim();
            if (name.isEmpty) return showError(context, const AppError(AppErrorCode.unknown));
            setState(() => _busy = true);
            try {
              await ref.read(userRepoProvider).updateProfile(ref.read(uidProvider)!, displayName: name, language: _lang, onboardingCompleted: true);
            } catch (e) {
              if (context.mounted) showError(context, e);
            } finally {
              if (mounted) setState(() => _busy = false);
            }
          },
        ),
      ]),
    );
  }
}

Future<bool> onboardingSeen() async => await _secure.read(key: onboardingSeenKey) == 'true';
