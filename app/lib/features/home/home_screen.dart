import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../domain/categories.dart';
import '../../domain/logic/reminders.dart';
import '../../domain/models/document.dart';
import '../add/add_sheet.dart';
import '../world/world_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profile = ref.watch(userProfileProvider).value;
    final ent = ref.watch(entitlementValueProvider);
    final usage = ref.watch(usageProvider).value;
    final docsAsync = ref.watch(documentsProvider);
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final top = topUpcoming(reminders);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(documentsProvider),
          child: ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, Space.xxl), children: [
            // Header
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('MyWorld+', style: Theme.of(context).textTheme.labelMedium),
                  Text(
                    profile?.displayName == null ? l.welcome : l.helloName(profile!.displayName!.split(' ').first),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ]),
              ),
              IconButton(
                tooltip: l.notifications,
                onPressed: () => context.push('/notifications'),
                icon: Badge(isLabelVisible: top.any((r) => dueState(r.dueAt) == DueState.overdue), child: const Icon(Icons.notifications_none_rounded)),
              ),
              const SizedBox(width: Space.xs),
              Semantics(
                button: true,
                label: l.profile,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.push('/profile'),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Text((profile?.displayName ?? '?').characters.first.toUpperCase(), style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: Space.xl),
            AppSearchBar(
              hint: l.searchHint,
              onTap: () => context.push('/search'),
              trailing: ent.aiEnabled
                  ? IconButton(tooltip: l.askAi, onPressed: () => context.push('/ai'), icon: const Icon(Icons.auto_awesome, color: AppColors.secondary))
                  : null,
            ),

            // Reminders
            SectionHeader(title: l.importantReminders, actionLabel: l.seeAll, onAction: () => context.push('/reminders')),
            if (top.isEmpty)
              AppCard(
                onTap: () => context.push('/reminders/new'),
                child: Row(children: [
                  const Icon(Icons.add_alarm_outlined, color: AppColors.secondary),
                  const SizedBox(width: Space.md),
                  Expanded(child: Text(l.noRemindersCta, style: Theme.of(context).textTheme.bodyMedium)),
                ]),
              )
            else
              for (final r in top)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: ReminderCard(reminder: r, onTap: () => context.push('/reminders/${r.id}')),
                ),

            // Areas
            SectionHeader(title: l.myAreas, actionLabel: l.seeAll, onAction: () => context.go('/world')),
            SizedBox(
              height: 168,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final a in worldAreas(context, ent))
                  Padding(
                    padding: const EdgeInsets.only(right: Space.md),
                    child: SizedBox(width: 148, child: WorldCategoryCard(title: a.title, subtitle: a.subtitle, icon: a.icon, locked: a.locked, onTap: () => a.open(context))),
                  ),
              ]),
            ),

            // Single, clearly-labelled ad slot between non-sensitive sections (Individual Base only).
            const AdSlot(),

            // Recently added
            SectionHeader(title: l.recentlyAdded, actionLabel: l.seeAll, onAction: () => context.push('/documents/recent')),
            asyncView<List<DocumentRecord>>(docsAsync, (docs) {
              final recent = docs.where((d) => !d.inTrash && !d.isVault).toList()
                ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
              if (recent.isEmpty) {
                return AppCard(
                  onTap: () {
                    ref.read(addContextProvider.notifier).clear();
                    showAddSheet(context, ref);
                  },
                  child: Row(children: [
                    const Icon(Icons.document_scanner_outlined, color: AppColors.secondary),
                    const SizedBox(width: Space.md),
                    Expanded(child: Text(l.noDocumentsCta)),
                  ]),
                );
              }
              return AppCard(
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
                child: Column(children: [
                  for (final d in recent.take(4))
                    DocumentListItem(
                      document: d,
                      categoryLabel: Categories.labelFor(context, d.categoryId),
                      onTap: () => context.push('/documents/${d.id}'),
                    ),
                ]),
              );
            }, loading: const ListSkeleton(rows: 3)),

            const SizedBox(height: Space.xl),
            if (usage != null) StorageUsageCard(usage: usage, entitlement: ent, onTap: () => context.push('/storage')),
          ]),
        ),
      ),
    );
  }
}
