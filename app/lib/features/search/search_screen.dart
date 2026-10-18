import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/search.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';
import '../documents/document_screens.dart';

enum _Scope { all, documents, items, vehicles, cards, contacts, reminders }

/// Regular (non-AI) search over everything the user is authorised to see.
/// Runs locally over the permission-filtered data already on the device.
class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});
  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _c = TextEditingController();
  String _q = '';
  _Scope _scope = _Scope.all;
  DocSort _sort = DocSort.newest;
  DocumentFilter _filter = const DocumentFilter(includeVault: false);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final vaultUnlocked = ref.read(vaultLockProvider).isUnlocked;
    final docs = ref.watch(documentsProvider).value ?? const <DocumentRecord>[];
    final assets = ref.watch(assetsProvider).value ?? const <Asset>[];
    final vehicles = ref.watch(vehiclesProvider).value ?? const <Vehicle>[];
    final cards = ref.watch(walletCardsProvider).value ?? const <WalletCard>[];
    final contacts = ref.watch(businessCardsProvider).value ?? const <BusinessCard>[];
    final reminders = ref.watch(remindersProvider).value ?? const <Reminder>[];
    final profiles = ref.watch(familyProfilesProvider).value ?? const [];
    final names = ref.watch(memberNamesProvider);

    // Extra searchable text: linked person/item names, so "dokumenti mog deteta" works by name.
    final extra = <String, String>{
      for (final d in docs)
        d.id: [
          ...d.linkedEntityIds.map((id) => profiles.where((p) => p.id == id).map((p) => p.name).firstOrNull ?? assets.where((a) => a.id == id).map((a) => a.name).firstOrNull ?? vehicles.where((v) => v.id == id).map((v) => v.displayName).firstOrNull ?? ''),
          names[d.ownerUid] ?? '',
          categoryName(context, ref, d.categoryId),
        ].join(' '),
    };
    final searching = _q.trim().isNotEmpty || !_filter.isEmpty;
    final docResults = searching
        ? applyDocumentFilter(docs.where((d) => vaultUnlocked || !d.isVault).toList(), _filter.copyWith(query: _q, sort: _sort), extraText: extra)
        : <DocumentRecord>[];
    final assetResults = _q.isEmpty ? <Asset>[] : assets.where((a) => matchesQuery(_q, [a.name, a.brand, a.model, a.serialNumber, a.vendor, a.category, a.location, a.notes])).toList();
    final vehicleResults = _q.isEmpty ? <Vehicle>[] : vehicles.where((v) => matchesQuery(_q, [v.make, v.model, v.registrationNumber, v.vin, v.notes])).toList();
    final cardResults = _q.isEmpty ? <WalletCard>[] : cards.where((c) => matchesQuery(_q, [c.name, c.issuer, c.discountText, c.cardNumber])).toList();
    final contactResults = _q.isEmpty ? <BusinessCard>[] : contacts.where((c) => matchesQuery(_q, [c.fullName, c.company, c.jobTitle, c.metWhere, ...c.tags, ...c.emails])).toList();
    final reminderResults = _q.isEmpty ? <Reminder>[] : reminders.where((r) => matchesQuery(_q, [r.title, r.description])).toList();
    final total = docResults.length + assetResults.length + vehicleResults.length + cardResults.length + contactResults.length + reminderResults.length;
    bool show(_Scope s) => _scope == _Scope.all || _scope == s;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: Space.md),
          child: AppSearchBar(controller: _c, autofocus: true, onChanged: (v) => setState(() => _q = v), hint: l.searchHint),
        ),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.xxl), children: [
        // AI is a clearly separate action, never mixed into regular results.
        AppCard(
          onTap: () => ent.aiEnabled ? context.push(Uri(path: '/ai', queryParameters: {if (_q.isNotEmpty) 'q': _q}).toString()) : context.push('/ai/upgrade'),
          child: Row(children: [
            const Icon(Icons.auto_awesome, color: AppColors.secondary),
            const SizedBox(width: Space.md),
            Expanded(child: Text(ent.aiEnabled ? l.askAiInstead : l.aiSearchLocked)),
            Icon(ent.aiEnabled ? Icons.chevron_right : Icons.lock_outline),
          ]),
        ),
        const SizedBox(height: Space.md),
        FilterChips<_Scope>(
          options: _Scope.values,
          selected: {_scope},
          labelOf: (s) => switch (s) {
            _Scope.all => l.all,
            _Scope.documents => l.documents,
            _Scope.items => l.items,
            _Scope.vehicles => l.areaCar,
            _Scope.cards => l.areaCards,
            _Scope.contacts => l.areaBusinessCards,
            _Scope.reminders => l.reminders,
          },
          onToggle: (s) => setState(() => _scope = s),
        ),
        if (show(_Scope.documents))
          Row(children: [
            TextButton.icon(
              onPressed: () async {
                final reminderDocs = {for (final r in reminders) ?r.linkedDocumentId};
                final f = await showModalBottomSheet<DocumentFilter>(context: context, isScrollControlled: true, builder: (_) => FilterSheet(initial: _filter, advanced: ent.advancedFilters, reminderDocIds: reminderDocs));
                if (f != null) setState(() => _filter = f);
              },
              icon: Badge(isLabelVisible: !_filter.isEmpty, child: const Icon(Icons.tune, size: 18)),
              label: Text(l.filters),
            ),
            const Spacer(),
            DropdownButton<DocSort>(
              value: _sort,
              underline: const SizedBox.shrink(),
              items: [for (final s in DocSort.values) DropdownMenuItem(value: s, child: Text(sortLabel(context, s)))],
              onChanged: (s) => setState(() => _sort = s ?? DocSort.newest),
            ),
          ]),
        if (!searching)
          Padding(padding: const EdgeInsets.only(top: Space.xxl), child: EmptyState(icon: Icons.search, title: l.searchStartTitle, message: l.searchStartBody))
        else if (total == 0)
          Padding(
            padding: const EdgeInsets.only(top: Space.xl),
            child: EmptyState(
              icon: Icons.search_off,
              title: l.noResults,
              message: l.noResultsHint,
              actionLabel: l.addDocument,
              onAction: () {
                ref.read(addContextProvider.notifier).clear();
                showAddSheet(context, ref);
              },
              secondary: Wrap(alignment: WrapAlignment.center, spacing: Space.sm, children: [
                if (!_filter.isEmpty) TextButton(onPressed: () => setState(() => _filter = const DocumentFilter(includeVault: false)), child: Text(l.clearFilters)),
                if (ent.aiEnabled) TextButton(onPressed: () => context.push(Uri(path: '/ai', queryParameters: {'q': _q}).toString()), child: Text(l.tryAi)),
              ]),
            ),
          )
        else ...[
          if (show(_Scope.documents) && docResults.isNotEmpty) ...[
            SectionHeader(title: '${l.documents} (${docResults.length})'),
            for (final d in docResults.take(_scope == _Scope.all ? 8 : 200)) DocumentListItem(document: d, categoryLabel: categoryName(context, ref, d.categoryId), onTap: () => context.push('/documents/${d.id}')),
          ],
          if (show(_Scope.items) && assetResults.isNotEmpty) ...[
            SectionHeader(title: '${l.items} (${assetResults.length})'),
            for (final a in assetResults) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.chair_outlined), title: Text(a.name), subtitle: Text([a.brand, a.model].whereType<String>().join(' ')), onTap: () => context.push('/assets/${a.id}')),
          ],
          if (show(_Scope.vehicles) && vehicleResults.isNotEmpty) ...[
            SectionHeader(title: l.areaCar),
            for (final v in vehicleResults) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.directions_car_outlined), title: Text(v.displayName), subtitle: Text(v.registrationNumber ?? ''), onTap: () => context.push('/vehicles/${v.id}')),
          ],
          if (show(_Scope.cards) && cardResults.isNotEmpty) ...[
            SectionHeader(title: l.areaCards),
            for (final c in cardResults) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.loyalty_outlined), title: Text(c.name), subtitle: Text(c.discountText ?? c.issuer ?? ''), onTap: () => context.push('/cards/${c.id}')),
          ],
          if (show(_Scope.contacts) && contactResults.isNotEmpty) ...[
            SectionHeader(title: l.areaBusinessCards),
            for (final c in contactResults) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.badge_outlined), title: Text(c.displayName), subtitle: Text(c.company ?? ''), onTap: () => context.push('/business-cards/${c.id}')),
          ],
          if (show(_Scope.reminders) && reminderResults.isNotEmpty) ...[
            SectionHeader(title: l.reminders),
            for (final r in reminderResults) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.alarm), title: Text(r.title), subtitle: Text(Fmt.date(context, r.dueAt)), onTap: () => context.push('/reminders/${r.id}')),
          ],
        ],
      ]),
    );
  }
}
