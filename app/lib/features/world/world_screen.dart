import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/monetization.dart';
import '../../domain/models/account.dart';

class WorldArea {
  const WorldArea({required this.title, required this.subtitle, required this.icon, required this.route, this.locked = false, this.lockReason});
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool locked;
  final UpgradeReason? lockReason;

  void open(BuildContext context) {
    // Locked areas show what they are, but still open (with an upgrade message
    // inside) — never pretend a locked feature is active.
    context.push(route);
  }
}

List<WorldArea> worldAreas(BuildContext context, Entitlement ent) {
  final l = context.l10n;
  return [
    WorldArea(title: l.areaHome, subtitle: l.areaHomeSub, icon: Icons.house_outlined, route: '/home-area'),
    WorldArea(title: l.areaFamily, subtitle: l.areaFamilySub, icon: Icons.family_restroom, route: '/family', locked: !ent.isFamilyPlan && ent.familyId == null, lockReason: UpgradeReason.family),
    WorldArea(title: l.areaHobby, subtitle: l.areaHobbySub, icon: Icons.interests_outlined, route: '/hobby'),
    WorldArea(title: l.areaDocuments, subtitle: l.areaDocumentsSub, icon: Icons.folder_open_outlined, route: '/documents'),
    WorldArea(title: l.areaCar, subtitle: l.areaCarSub, icon: Icons.directions_car_outlined, route: '/car'),
    WorldArea(title: l.areaLife, subtitle: l.areaLifeSub, icon: Icons.event_note_outlined, route: '/life'),
    WorldArea(title: l.areaCards, subtitle: l.areaCardsSub, icon: Icons.loyalty_outlined, route: '/cards'),
    WorldArea(title: l.areaBusinessCards, subtitle: l.areaBusinessCardsSub, icon: Icons.contact_mail_outlined, route: '/business-cards'),
  ];
}

class WorldScreen extends ConsumerWidget {
  const WorldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final areas = worldAreas(context, ent);
    final docs = ref.watch(documentsProvider).value ?? const [];
    final assets = ref.watch(assetsProvider).value ?? const [];
    final vehicles = ref.watch(vehiclesProvider).value ?? const [];
    final cards = ref.watch(walletCardsProvider).value ?? const [];
    final biz = ref.watch(businessCardsProvider).value ?? const [];
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final members = ref.watch(familyMembersProvider).value ?? const [];

    String count(String route) => switch (route) {
          '/home-area' => l.itemsCount(assets.where((a) => a.area.name == 'home').length),
          '/hobby' => l.itemsCount(assets.where((a) => a.area.name == 'hobby').length),
          '/documents' => l.documentsCount(docs.where((d) => !d.inTrash && !d.isVault).length),
          '/car' => l.vehiclesCount(vehicles.length),
          '/life' => l.remindersCount(reminders.where((r) => r.isActive).length),
          '/cards' => l.cardsCount(cards.length),
          '/business-cards' => l.contactsCount(biz.length),
          '/family' => ent.familyId == null ? l.familyPlanOnly : l.membersCount(members.length),
          _ => '',
        };

    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 700 ? 3 : 2;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, 0),
            sliver: SliverList.list(children: [
              Text(l.navWorld, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: Space.xs),
              Text(l.worldSubtitle, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: Space.lg),
              AppSearchBar(onTap: () => context.push('/search')),
              const SizedBox(height: Space.xl),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.xxl),
            sliver: SliverGrid.count(
              crossAxisCount: columns,
              mainAxisSpacing: Space.md,
              crossAxisSpacing: Space.md,
              childAspectRatio: 0.92,
              children: [
                for (final a in areas)
                  WorldCategoryCard(title: a.title, subtitle: count(a.route), icon: a.icon, locked: a.locked, onTap: () => a.open(context)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
