import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../app/providers.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';
import 'buttons.dart';
import 'components.dart';

enum UpgradeReason { ai, family, storage, documents, vehicles, export, filters }

/// Clear upgrade message for a locked feature — never pretends it is active.
class UpgradePrompt extends StatelessWidget {
  const UpgradePrompt({super.key, required this.reason, this.compact = false});
  final UpgradeReason reason;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (title, body, icon) = switch (reason) {
      UpgradeReason.ai => (l.upgradeAiTitle, l.upgradeAiBody, Icons.auto_awesome),
      UpgradeReason.family => (l.upgradeFamilyTitle, l.upgradeFamilyBody, Icons.family_restroom),
      UpgradeReason.storage => (l.upgradeStorageTitle, l.upgradeStorageBody, Icons.cloud_outlined),
      UpgradeReason.documents => (l.upgradeDocumentsTitle, l.upgradeDocumentsBody, Icons.description_outlined),
      UpgradeReason.vehicles => (l.upgradeVehiclesTitle, l.upgradeVehiclesBody, Icons.directions_car_outlined),
      UpgradeReason.export => (l.upgradeExportTitle, l.upgradeExportBody, Icons.ios_share),
      UpgradeReason.filters => (l.upgradeFiltersTitle, l.upgradeFiltersBody, Icons.tune),
    };
    return AppCard(
      padding: EdgeInsets.all(compact ? Space.md : Space.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(Space.sm),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(Radii.sm)),
            child: Icon(icon, color: AppColors.secondary),
          ),
          const SizedBox(width: Space.md),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        ]),
        const SizedBox(height: Space.sm),
        Text(body, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.seePlans, onPressed: () => context.push('/plans')),
      ]),
    );
  }
}

Future<void> showUpgradeSheet(BuildContext context, UpgradeReason reason) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.gutter), child: UpgradePrompt(reason: reason))),
    );

/// Full-screen ad at a natural break: right after the user saved something
/// new (document, item, vehicle, record, reminder, card, contact). Free plan
/// only, per the SERVER entitlement; consent and frequency limits live in
/// AdsService. Never call it on app open, in Vault, during capture/upload or
/// in front of alerts. Read before navigating away, while `ref` is still valid.
void showInterstitialAtBreak(WidgetRef ref) {
  final ent = ref.read(entitlementProvider);
  if (!(ent.hasValue && ent.value!.adsEnabled)) return;
  unawaited(ref.read(adsServiceProvider).maybeShowInterstitial());
}

/// The banner slot. Renders nothing unless the SERVER
/// entitlement says ads are enabled (Individual Base) and consent allows it.
/// Must never be placed in Vault, scanner, upload, document content or alerts.
class AdSlot extends ConsumerStatefulWidget {
  const AdSlot({super.key});

  @override
  ConsumerState<AdSlot> createState() => _AdSlotState();
}

class _AdSlotState extends ConsumerState<AdSlot> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _requested = false;

  Future<void> _load() async {
    _requested = true;
    final ads = ref.read(adsServiceProvider);
    await ads.ensureReady();
    if (!ads.canRequestAds || !mounted) return;
    // Have a full-screen ad ready for the next natural break.
    unawaited(ads.preloadInterstitial());
    final ad = BannerAd(
      adUnitId: ads.bannerUnitId,
      size: AdSize.mediumRectangle,
      // No keywords or content URLs: nothing about the user's data is sent.
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    await ad.load();
    _ad = ad;
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ent = ref.watch(entitlementProvider);
    // Wait for the server entitlement; never show ads based on a guess.
    final allowed = ent.hasValue && ent.value!.adsEnabled;
    if (!allowed) {
      if (_ad != null) {
        _ad!.dispose();
        _ad = null;
        _loaded = false;
      }
      return const SizedBox.shrink();
    }
    if (!_requested) _load();
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(context.l10n.adLabel, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: Space.xs),
        Center(child: SizedBox(width: _ad!.size.width.toDouble(), height: _ad!.size.height.toDouble(), child: AdWidget(ad: _ad!))),
        const SizedBox(height: Space.xs),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => context.push('/plans'), child: Text(context.l10n.removeAds)),
        ),
      ]),
    );
  }
}
