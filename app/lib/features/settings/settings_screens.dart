import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/reminders.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';

const _secure = FlutterSecureStorage();

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = ref.watch(userProfileProvider).value;
    final ent = ref.watch(entitlementValueProvider);
    final user = ref.watch(authUserProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.profile)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Center(child: CircleAvatar(radius: 40, child: Text((p?.displayName ?? '?').characters.first.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall))),
        const SizedBox(height: Space.md),
        Center(child: Text(p?.displayName ?? '', style: Theme.of(context).textTheme.headlineSmall)),
        Center(child: Text(user?.email ?? '', style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(height: Space.sm),
        Center(child: PlanBadge(plan: ent.planId)),
        const SizedBox(height: Space.xl),
        ListTile(leading: const Icon(Icons.edit_outlined), title: Text(l.editProfile), onTap: () => _editName(context, ref, p?.displayName ?? '')),
        ListTile(leading: const Icon(Icons.workspace_premium_outlined), title: Text(l.manageSubscription), onTap: () => context.push('/subscription')),
        ListTile(leading: const Icon(Icons.cloud_outlined), title: Text(l.storage), onTap: () => context.push('/storage')),
        ListTile(leading: const Icon(Icons.settings_outlined), title: Text(l.settings), onTap: () => context.push('/settings')),
        const SizedBox(height: Space.lg),
        SecondaryButton(
          label: l.signOut,
          icon: Icons.logout,
          onPressed: () async {
            final uid = ref.read(uidProvider);
            if (uid != null) {
              try {
                await ref.read(notificationServiceProvider).unregisterDevice(ref.read(firestoreProvider), uid);
              } catch (_) {}
            }
            await ref.read(notificationServiceProvider).cancelAll();
            ref.read(storageServiceProvider).clearMemoryCache();
            ref.read(vaultLockProvider).lock();
            await ref.read(billingServiceProvider).logOut();
            await ref.read(authServiceProvider).signOut();
          },
        ),
      ]),
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref, String current) async {
    final c = TextEditingController(text: current);
    final l = context.l10n;
    final v = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.displayName),
        content: TextField(controller: c, maxLength: 80, autofocus: true),
        actions: [TextButton(onPressed: () => Navigator.pop(d), child: Text(l.cancel)), TextButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: Text(l.save))],
      ),
    );
    if (v != null && v.isNotEmpty) await ref.read(userRepoProvider).updateProfile(ref.read(uidProvider)!, displayName: v);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = ref.watch(userProfileProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l.language),
          trailing: DropdownButton<String>(
            value: p?.preferredLanguage ?? 'sr',
            underline: const SizedBox.shrink(),
            items: [DropdownMenuItem(value: 'sr', child: Text(l.langSerbian)), DropdownMenuItem(value: 'en', child: Text(l.langEnglish))],
            onChanged: (v) => ref.read(userRepoProvider).updateProfile(ref.read(uidProvider)!, language: v),
          ),
        ),
        ListTile(leading: const Icon(Icons.notifications_outlined), title: Text(l.reminderSettings), onTap: () => context.push('/settings/reminders')),
        ListTile(leading: const Icon(Icons.lock_outline), title: Text(l.vaultSettings), onTap: () => context.push('/settings/vault')),
        ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: Text(l.privacySettings), onTap: () => context.push('/settings/privacy')),
        ListTile(leading: const Icon(Icons.workspace_premium_outlined), title: Text(l.manageSubscription), onTap: () => context.push('/subscription')),
        ListTile(leading: const Icon(Icons.download_outlined), title: Text(l.exportData), onTap: () => context.push('/settings/export')),
        ListTile(leading: const Icon(Icons.gavel_outlined), title: Text(l.legal), onTap: () => context.push('/settings/legal')),
        ListTile(leading: const Icon(Icons.help_outline), title: Text(l.help), onTap: () => context.push('/settings/help')),
        const Divider(),
        ListTile(leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error), title: Text(l.deleteAccount, style: const TextStyle(color: AppColors.error)), onTap: () => context.push('/settings/delete-account')),
      ]),
    );
  }
}

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});
  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _analytics = false;
  bool _adOptions = false;

  @override
  void initState() {
    super.initState();
    _secure.read(key: 'analytics_consent').then((v) => mounted ? setState(() => _analytics = v == 'true') : null);
    final ent = ref.read(entitlementValueProvider);
    if (ent.adsEnabled) {
      ref.read(adsServiceProvider).ensureReady().then((_) => ref.read(adsServiceProvider).privacyOptionsRequired()).then((r) => mounted ? setState(() => _adOptions = r) : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.privacySettings)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.analyticsConsent),
          subtitle: Text(l.analyticsConsentHelp),
          value: _analytics,
          onChanged: (v) async {
            await _secure.write(key: 'analytics_consent', value: '$v');
            await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(v);
            setState(() => _analytics = v);
          },
        ),
        const Divider(),
        // Ad consent (screen 77): Google UMP form, only relevant on the free plan.
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.campaign_outlined),
          title: Text(l.adConsent),
          subtitle: Text(ent.adsEnabled ? l.adConsentHelp : l.adsOffForPlan),
          trailing: ent.adsEnabled && _adOptions ? TextButton(onPressed: () => ref.read(adsServiceProvider).showPrivacyOptions(), child: Text(l.manage)) : null,
        ),
        const Divider(),
        SectionHeader(title: l.howWeProtect),
        Text(l.privacyBullets, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.lg),
        SectionHeader(title: l.aiAndYourData),
        Text(l.aiDataNote, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.lg),
        SecondaryButton(label: l.privacyPolicy, icon: Icons.open_in_new, onPressed: () => launchUrl(Uri.parse(AppConfig.privacyPolicyUrl), mode: LaunchMode.externalApplication)),
      ]),
    );
  }
}

class ExportDataScreen extends ConsumerStatefulWidget {
  const ExportDataScreen({super.key});
  @override
  ConsumerState<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends ConsumerState<ExportDataScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.exportData)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Text(l.exportBody, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.md),
        Text(ent.advancedExport ? l.exportAdvancedIncluded : l.exportBasicOnly, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.md),
        Text(l.exportFamilyNote, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.xl),
        PrimaryButton(
          label: l.startExport,
          loading: _busy,
          icon: Icons.download,
          onPressed: () async {
            setState(() => _busy = true);
            try {
              final bytes = await ref.read(accountRepoProvider).exportData();
              final dir = await getTemporaryDirectory();
              final f = File('${dir.path}/myworldplus-export-${DateTime.now().millisecondsSinceEpoch}.zip');
              await f.writeAsBytes(bytes, flush: true);
              await SharePlus.instance.share(ShareParams(files: [XFile(f.path, mimeType: 'application/zip')], subject: 'MyWorld+ export'));
              await f.delete();
            } catch (e) {
              if (context.mounted) showError(context, e);
            } finally {
              if (mounted) setState(() => _busy = false);
            }
          },
        ),
        if (_busy) Padding(padding: const EdgeInsets.only(top: Space.md), child: Text(l.exportWait, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)),
      ]),
    );
  }
}

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});
  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = ref.read(authServiceProvider);
    final needsPassword = auth.providerIds.contains('password');
    final ent = ref.watch(entitlementValueProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.deleteAccount)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.deleteConsequencesTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.error)),
            const SizedBox(height: Space.sm),
            Text(l.deleteConsequences),
          ]),
        ),
        const SizedBox(height: Space.md),
        if (ent.source == 'own' && ent.isPaid) AppCard(child: Text(l.deleteCancelStoreFirst, style: const TextStyle(color: AppColors.warning))),
        const SizedBox(height: Space.md),
        SecondaryButton(label: l.exportFirst, icon: Icons.download_outlined, onPressed: () => context.push('/settings/export')),
        const SizedBox(height: Space.xl),
        if (needsPassword) ...[AppTextField(label: l.password, controller: _password, obscure: true, textCapitalization: TextCapitalization.none), fieldGap],
        AppTextField(label: l.typeDeleteToConfirm, controller: _confirm, textCapitalization: TextCapitalization.characters, onChanged: (_) => setState(() {})),
        const SizedBox(height: Space.xl),
        PrimaryButton(
          label: l.deleteAccountForever,
          loading: _busy,
          onPressed: _confirm.text.trim().toUpperCase() != l.deleteWord ? null : _delete,
        ),
      ]),
    );
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    try {
      final auth = ref.read(authServiceProvider);
      await auth.reauthenticate(password: _password.text);
      await ref.read(accountRepoProvider).deleteAccount();
      await ref.read(vaultLockProvider).disable();
      await ref.read(notificationServiceProvider).cancelAll();
      await ref.read(billingServiceProvider).logOut();
      await auth.signOut();
    } on AppError catch (e) {
      if (mounted) showError(context, e);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.legal)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.privacy_tip_outlined), title: Text(l.privacyPolicy), trailing: const Icon(Icons.open_in_new), onTap: () => launchUrl(Uri.parse(AppConfig.privacyPolicyUrl), mode: LaunchMode.externalApplication)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.description_outlined), title: Text(l.termsOfUse), trailing: const Icon(Icons.open_in_new), onTap: () => launchUrl(Uri.parse(AppConfig.termsUrl), mode: LaunchMode.externalApplication)),
        const SizedBox(height: Space.lg),
        Text(l.legalSummary, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.lg),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.article_outlined), title: Text(l.openSourceLicenses), onTap: () => showLicensePage(context: context, applicationName: 'MyWorld+')),
      ]),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final faq = [(l.faq1q, l.faq1a), (l.faq2q, l.faq2a), (l.faq3q, l.faq3a), (l.faq4q, l.faq4a), (l.faq5q, l.faq5a)];
    return Scaffold(
      appBar: AppBar(title: Text(l.help)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        for (final f in faq) ExpansionTile(tilePadding: EdgeInsets.zero, title: Text(f.$1), children: [Padding(padding: const EdgeInsets.only(bottom: Space.md), child: Text(f.$2))]),
        const SizedBox(height: Space.xl),
        PrimaryButton(
          label: l.contactSupport,
          icon: Icons.email_outlined,
          onPressed: () => launchUrl(Uri(scheme: 'mailto', path: AppConfig.supportEmail, queryParameters: {'subject': 'MyWorld+'})),
        ),
        const SizedBox(height: Space.sm),
        Text(l.supportPrivacyNote, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ]),
    );
  }
}

/// In-app notifications: overdue/upcoming reminders and account notices.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.isActive && dueState(r.dueAt) != DueState.later).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final review = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.processingStatus == ProcessingStatus.needsReview && d.ownerUid == ref.watch(uidProvider)).toList();
    final ent = ref.watch(entitlementValueProvider);
    final usage = ref.watch(usageProvider).value;
    final notices = <Widget>[
      if (ent.status == 'in_grace_period' || ent.status == 'billing_issue')
        ListTile(leading: const Icon(Icons.credit_card_off, color: AppColors.warning), title: Text(l.subBillingIssue), onTap: () => context.push('/subscription')),
      if (usage != null && usage.storageRatio(ent) > 0.9)
        ListTile(leading: const Icon(Icons.cloud_off, color: AppColors.warning), title: Text(l.storageAlmostFull), onTap: () => context.push('/storage')),
      for (final d in review) ListTile(leading: const Icon(Icons.fact_check_outlined, color: AppColors.secondary), title: Text(l.reviewNeededFor(d.title)), onTap: () => context.push('/documents/${d.id}/review')),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.notifications)),
      body: reminders.isEmpty && notices.isEmpty
          ? EmptyState(icon: Icons.notifications_none, title: l.noNotifications)
          : ListView(padding: const EdgeInsets.all(Space.gutter), children: [
              ...notices,
              if (reminders.isNotEmpty) SectionHeader(title: l.reminders),
              for (final r in reminders) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ReminderCard(reminder: r, onTap: () => context.push('/reminders/${r.id}'))),
            ]),
    );
  }
}

class SessionExpiredScreen extends ConsumerWidget {
  const SessionExpiredScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: EmptyState(
          icon: Icons.timer_off_outlined,
          title: context.l10n.sessionExpiredTitle,
          message: context.l10n.sessionExpiredBody,
          actionLabel: context.l10n.signIn,
          onAction: () async {
            await ref.read(authServiceProvider).signOut();
            if (context.mounted) context.go('/auth/sign-in');
          },
        ),
      );
}

class GenericErrorScreen extends StatelessWidget {
  const GenericErrorScreen({super.key, this.error});
  final Object? error;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.explore_off_outlined,
          title: context.l10n.errTitle,
          message: context.l10n.pageNotFound,
          actionLabel: context.l10n.goHome,
          onAction: () => context.go('/home'),
        ),
      );
}
