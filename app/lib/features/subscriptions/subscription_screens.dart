import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/states.dart';
import '../../domain/plans.dart';
import '../../services/billing_service.dart';

final storeOffersProvider = FutureProvider<List<StoreOffer>>((ref) async {
  final uid = ref.watch(uidProvider);
  if (uid == null) return const [];
  final billing = ref.watch(billingServiceProvider);
  await billing.configure(uid);
  return billing.offers();
});

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});
  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  PlanId? _busy;
  bool _restoring = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final offers = ref.watch(storeOffersProvider);
    final billing = ref.read(billingServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.plansTitle)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Text(l.plansSubtitle, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.lg),
        for (final p in Plans.all) ...[
          _PlanCard(
            plan: p,
            current: ent.planId == p.id,
            priceString: offers.value?.where((o) => o.plan == p.id).firstOrNull?.priceString,
            loading: _busy == p.id,
            onSelect: p.id == PlanId.individualBase || ent.planId == p.id
                ? null
                : () async {
                    final offer = offers.value?.where((o) => o.plan == p.id).firstOrNull;
                    if (offer == null) {
                      showError(context, const AppError(AppErrorCode.unavailable));
                      return;
                    }
                    setState(() => _busy = p.id);
                    try {
                      await billing.purchase(offer);
                      if (context.mounted) showSuccess(context, l.purchaseProcessed);
                    } on AppError catch (e) {
                      if (e.code != AppErrorCode.cancelled && context.mounted) showError(context, e);
                    } finally {
                      if (mounted) setState(() => _busy = null);
                    }
                  },
          ),
          const SizedBox(height: Space.md),
        ],
        if (!billing.isAvailable) Text(l.billingNotConfigured, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.md),
        SecondaryButton(
          label: l.restorePurchases,
          icon: Icons.restore,
          onPressed: _restoring
              ? null
              : () async {
                  setState(() => _restoring = true);
                  try {
                    await billing.restore();
                    if (context.mounted) showSuccess(context, l.restoreDone);
                  } catch (e) {
                    if (context.mounted) showError(context, e);
                  } finally {
                    if (mounted) setState(() => _restoring = false);
                  }
                },
        ),
        const SizedBox(height: Space.md),
        Text(l.subscriptionTerms, style: Theme.of(context).textTheme.bodySmall),
        TextButton(onPressed: () => context.push('/settings/legal'), child: Text(l.legal)),
      ]),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.current, required this.priceString, required this.onSelect, required this.loading});
  final PlanInfo plan;
  final bool current;
  final String? priceString;
  final VoidCallback? onSelect;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final features = <String>[
      l.featureStorage(Fmt.bytes(context, plan.storageLimitBytes)),
      l.featureDocuments(Fmt.number(context, plan.maxDocuments)),
      if (plan.isFamily) l.featureMembers(plan.maxMembers),
      plan.ai ? l.featureAi : l.featureNoAi,
      plan.ads ? l.featureAds : l.featureNoAds,
      l.featureScan,
      l.featureReminders,
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: current ? AppColors.accent : Colors.transparent, width: 2),
      ),
      child: AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(planName(context, plan.id), style: Theme.of(context).textTheme.titleLarge)),
            if (current) Chip(label: Text(l.currentPlan)),
          ]),
          Text(
            plan.priceEur == 0 ? l.free : (priceString ?? l.pricePerMonth(plan.priceEur.toStringAsFixed(2).replaceAll('.', ','))),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: Space.md),
          for (final f in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check, size: 18, color: AppColors.success),
                const SizedBox(width: Space.sm),
                Expanded(child: Text(f)),
              ]),
            ),
          if (onSelect != null) ...[
            const SizedBox(height: Space.md),
            PrimaryButton(label: l.choosePlan, loading: loading, onPressed: onSelect),
          ],
        ]),
      ),
    );
  }
}

class ManageSubscriptionScreen extends ConsumerWidget {
  const ManageSubscriptionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final usage = ref.watch(usageProvider).value;
    final statusText = switch (ent.status) {
      'active' => l.subActive,
      'cancelled' => l.subCancelled,
      'in_grace_period' || 'billing_issue' => l.subBillingIssue,
      'expired' => l.subExpired,
      'refunded' => l.subRefunded,
      _ => l.subNone,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l.manageSubscription)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        PlanBadge(plan: ent.planId),
        const SizedBox(height: Space.lg),
        InfoRow(label: l.status, value: statusText, icon: Icons.info_outline),
        if (ent.source == 'family') InfoRow(label: l.source, value: l.planFromFamily, icon: Icons.family_restroom),
        if (ent.currentPeriodEnd != null)
          InfoRow(label: ent.cancelAtPeriodEnd ? l.accessUntil : l.renewsOn, value: Fmt.date(context, ent.currentPeriodEnd), icon: Icons.event),
        if (ent.status == 'in_grace_period' || ent.status == 'billing_issue')
          AppCard(child: Text(l.billingIssueBody, style: const TextStyle(color: AppColors.warning))),
        if (usage != null) ...[const SizedBox(height: Space.md), StorageUsageCard(usage: usage, entitlement: ent, compact: false)],
        const SizedBox(height: Space.lg),
        AppCard(child: Text(l.downgradePolicy, style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(height: Space.lg),
        PrimaryButton(label: l.changePlan, onPressed: () => context.push('/plans')),
        const SizedBox(height: Space.md),
        if (ent.source == 'own')
          SecondaryButton(
            label: l.manageInStore,
            icon: Icons.open_in_new,
            onPressed: () async {
              final url = await ref.read(billingServiceProvider).managementUrl();
              if (url != null) await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
          ),
        const SizedBox(height: Space.md),
        TextButton(
          onPressed: () async {
            try {
              await ref.read(billingServiceProvider).sync();
              if (context.mounted) showSuccess(context, l.statusRefreshed);
            } catch (e) {
              if (context.mounted) showError(context, e);
            }
          },
          child: Text(l.refreshStatus),
        ),
      ]),
    );
  }
}
