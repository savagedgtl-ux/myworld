import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../domain/categories.dart';
import '../../domain/logic/search.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';

String categoryName(BuildContext context, WidgetRef ref, String? id) {
  final builtIn = Categories.find(Categories.documents, id) ?? Categories.find(Categories.vault, id);
  if (builtIn != null) return builtIn.label.of(Localizations.localeOf(context));
  for (final c in ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[]) {
    if (c.id == id) return c.name;
  }
  return id ?? '';
}

/// My Documents: central archive with categories and quick links.
class MyDocumentsScreen extends ConsumerWidget {
  const MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => !d.inTrash && !d.isVault).toList();
    final custom = (ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[]).where((c) => c.area == 'documents').toList();
    final locale = Localizations.localeOf(context);
    int count(String id) => docs.where((d) => d.categoryId == id).length;

    return Scaffold(
      appBar: AppBar(title: Text(l.areaDocuments), actions: [
        IconButton(tooltip: l.search, onPressed: () => context.push('/search'), icon: const Icon(Icons.search)),
        IconButton(tooltip: l.addCategory, onPressed: () => addCategoryDialog(context, ref, 'documents'), icon: const Icon(Icons.create_new_folder_outlined)),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(addContextProvider.notifier).set(const AddContext(area: 'documents'));
          showAddSheet(context, ref);
        },
        icon: const Icon(Icons.add),
        label: Text(l.addDocument),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
        Row(children: [
          Expanded(child: _QuickLink(icon: Icons.star_outline_rounded, label: l.favorites, onTap: () => context.push('/documents/list?favorites=1'))),
          const SizedBox(width: Space.md),
          Expanded(child: _QuickLink(icon: Icons.schedule_rounded, label: l.recentlyAdded, onTap: () => context.push('/documents/recent'))),
          const SizedBox(width: Space.md),
          Expanded(child: _QuickLink(icon: Icons.delete_outline, label: l.trash, onTap: () => context.push('/documents/list?trash=1'))),
        ]),
        SectionHeader(title: l.categories),
        for (final c in Categories.documents)
          ListTile(
            leading: Icon(c.icon, color: AppColors.secondary),
            title: Text(c.label.of(locale)),
            trailing: Text('${count(c.id)}', style: Theme.of(context).textTheme.bodySmall),
            onTap: () => context.push('/documents/list?category=${c.id}'),
          ),
        for (final c in custom)
          ListTile(
            leading: const Icon(Icons.folder_special_outlined, color: AppColors.accent),
            title: Text(c.name),
            trailing: Text('${count(c.id)}', style: Theme.of(context).textTheme.bodySmall),
            onTap: () => context.push('/documents/list?category=${c.id}'),
            onLongPress: () async {
              if (await confirmDialog(context, title: l.deleteCategory, message: l.deleteCategoryBody, confirmLabel: l.delete, destructive: true)) {
                await ref.read(categoryRepoProvider).remove(c.id);
              }
            },
          ),
      ]),
    );
  }
}

Future<void> addCategoryDialog(BuildContext context, WidgetRef ref, String area) async {
  final c = TextEditingController();
  final l = context.l10n;
  final name = await showDialog<String>(
    context: context,
    builder: (d) => AlertDialog(
      title: Text(l.addCategory),
      content: TextField(controller: c, autofocus: true, maxLength: 60, decoration: InputDecoration(labelText: l.name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: Text(l.cancel)),
        TextButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: Text(l.save)),
      ],
    ),
  );
  if (name == null || name.isEmpty) return;
  try {
    await ref.read(categoryRepoProvider).add(ref.read(uidProvider)!, name, area);
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        semanticLabel: label,
        padding: const EdgeInsets.symmetric(vertical: Space.lg, horizontal: Space.sm),
        child: Column(children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(height: Space.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center, maxLines: 2),
        ]),
      );
}

/// Document list with filters, sorting and grouping by month.
class DocumentListScreen extends ConsumerStatefulWidget {
  const DocumentListScreen({super.key, this.categoryId, this.favorites = false, this.trash = false, this.recent = false, this.linkedEntityId, this.title});
  final String? categoryId;
  final bool favorites;
  final bool trash;
  final bool recent;
  final String? linkedEntityId;
  final String? title;

  @override
  ConsumerState<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends ConsumerState<DocumentListScreen> {
  late DocumentFilter _filter = DocumentFilter(
    categoryIds: {?widget.categoryId},
    favoritesOnly: widget.favorites,
    linkedEntityId: widget.linkedEntityId,
    sort: DocSort.newest,
    includeVault: false,
  );
  bool _grid = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final all = ref.watch(documentsProvider);
    final title = widget.title ??
        (widget.trash
            ? l.trash
            : widget.favorites
                ? l.favorites
                : widget.recent
                    ? l.recentlyAdded
                    : widget.categoryId != null
                        ? categoryName(context, ref, widget.categoryId)
                        : l.allDocuments);
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        if (!widget.trash)
          IconButton(tooltip: _grid ? l.listView : l.gridView, onPressed: () => setState(() => _grid = !_grid), icon: Icon(_grid ? Icons.view_list_outlined : Icons.grid_view_outlined)),
        if (!widget.trash) IconButton(tooltip: l.filters, onPressed: _openFilters, icon: Badge(isLabelVisible: !_filter.isEmpty, child: const Icon(Icons.tune))),
      ]),
      body: asyncView<List<DocumentRecord>>(all, (docs) {
        List<DocumentRecord> list;
        if (widget.trash) {
          list = docs.where((d) => d.inTrash && d.ownerUid == ref.read(uidProvider)).toList()
            ..sort((a, b) => b.deletedAt!.compareTo(a.deletedAt!));
        } else if (widget.recent) {
          list = docs.where((d) => !d.inTrash && !d.isVault).toList()
            ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          list = list.take(50).toList();
        } else {
          list = applyDocumentFilter(docs, _filter);
        }
        if (list.isEmpty) {
          return EmptyState(
            icon: widget.trash ? Icons.delete_outline : Icons.folder_open_outlined,
            title: widget.trash ? l.trashEmpty : l.noDocuments,
            message: widget.trash ? l.trashRetention : (_filter.isEmpty ? l.noDocumentsHint : l.noResultsFiltered),
            actionLabel: widget.trash ? null : (_filter.isEmpty || widget.categoryId != null ? l.addDocument : l.clearFilters),
            onAction: widget.trash
                ? null
                : () {
                    if (_filter.isEmpty || widget.categoryId != null) {
                      ref.read(addContextProvider.notifier).set(const AddContext(area: 'documents'));
                      showAddSheet(context, ref);
                    } else {
                      setState(() => _filter = DocumentFilter(includeVault: false, categoryIds: {?widget.categoryId}));
                    }
                  },
          );
        }
        if (_grid) {
          return GridView.count(
            padding: const EdgeInsets.all(Space.gutter),
            crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
            mainAxisSpacing: Space.md,
            crossAxisSpacing: Space.md,
            childAspectRatio: 1.1,
            children: [for (final d in list) DocumentGridCard(document: d, onTap: () => context.push('/documents/${d.id}'))],
          );
        }
        // Group by month of the relevant date.
        final groups = <String, List<DocumentRecord>>{};
        for (final d in list) {
          final dt = d.documentDate ?? d.purchaseDate ?? d.createdAt ?? DateTime(0);
          groups.putIfAbsent(Fmt.monthYear(context, dt), () => []).add(d);
        }
        final sortedByDate = _filter.sort == DocSort.newest || _filter.sort == DocSort.oldest;
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.xxl), children: [
          if (widget.trash) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: Text(l.trashRetention, style: Theme.of(context).textTheme.bodySmall)),
          if (sortedByDate && !widget.trash)
            for (final g in groups.entries) ...[
              SectionHeader(title: g.key),
              for (final d in g.value) _item(d),
            ]
          else
            for (final d in list) _item(d),
        ]);
      }),
    );
  }

  Widget _item(DocumentRecord d) {
    final l = context.l10n;
    if (widget.trash) {
      return DocumentListItem(
        document: d,
        onTap: () {},
        trailing: PopupMenuButton<String>(
          tooltip: l.more,
          onSelected: (v) async {
            final repo = ref.read(documentRepoProvider);
            try {
              if (v == 'restore') {
                await repo.restore(d.id);
                if (mounted) showSuccess(context, l.restored);
              } else if (await confirmDialog(context, title: l.deleteForever, message: l.deleteForeverBody, confirmLabel: l.delete, destructive: true)) {
                await repo.purge(d.id);
              }
            } catch (e) {
              if (mounted) showError(context, e);
            }
          },
          itemBuilder: (_) => [PopupMenuItem(value: 'restore', child: Text(l.restore)), PopupMenuItem(value: 'purge', child: Text(l.deleteForever))],
        ),
      );
    }
    return DocumentListItem(document: d, categoryLabel: categoryName(context, ref, d.categoryId), onTap: () => context.push('/documents/${d.id}'));
  }

  Future<void> _openFilters() async {
    final ent = ref.read(entitlementValueProvider);
    final reminders = ref.read(remindersProvider).value ?? const <Reminder>[];
    final result = await showModalBottomSheet<DocumentFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterSheet(initial: _filter, advanced: ent.advancedFilters, reminderDocIds: {for (final r in reminders) ?r.linkedDocumentId}),
    );
    if (result != null) setState(() => _filter = result);
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.initial, required this.advanced, required this.reminderDocIds});
  final DocumentFilter initial;
  final bool advanced;
  final Set<String> reminderDocIds;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late DocumentFilter f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.gutter), children: [
          Text(l.filters, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Space.md),
          Text(l.sortBy, style: Theme.of(context).textTheme.labelMedium),
          Wrap(spacing: Space.sm, children: [
            for (final s in DocSort.values)
              ChoiceChip(label: Text(sortLabel(context, s)), selected: f.sort == s, onSelected: (_) => setState(() => f = f.copyWith(sort: s))),
          ]),
          const SizedBox(height: Space.md),
          Text(l.period, style: Theme.of(context).textTheme.labelMedium),
          Wrap(spacing: Space.sm, children: [
            for (final r in DateRange.values)
              ChoiceChip(
                label: Text(switch (r) { DateRange.any => l.anyTime, DateRange.last30 => l.last30Days, DateRange.thisYear => l.thisYear, DateRange.lastYear => l.lastYear }),
                selected: f.range == r,
                onSelected: (_) => setState(() => f = f.copyWith(range: r)),
              ),
          ]),
          const SizedBox(height: Space.md),
          Text(l.category, style: Theme.of(context).textTheme.labelMedium),
          Wrap(spacing: Space.sm, children: [
            for (final c in Categories.documents)
              FilterChip(
                label: Text(c.label.of(locale)),
                selected: f.categoryIds.contains(c.id),
                onSelected: (on) => setState(() => f = f.copyWith(categoryIds: on ? {...f.categoryIds, c.id} : ({...f.categoryIds}..remove(c.id)))),
              ),
          ]),
          const SizedBox(height: Space.md),
          Text(l.fileType, style: Theme.of(context).textTheme.labelMedium),
          Wrap(spacing: Space.sm, children: [
            ChoiceChip(label: Text(l.all), selected: f.fileType == null, onSelected: (_) => setState(() => f = f.copyWith(clearFileType: true))),
            ChoiceChip(label: const Text('PDF'), selected: f.fileType == 'pdf', onSelected: (_) => setState(() => f = f.copyWith(fileType: 'pdf'))),
            ChoiceChip(label: Text(l.image), selected: f.fileType == 'image', onSelected: (_) => setState(() => f = f.copyWith(fileType: 'image'))),
          ]),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.favoritesOnly), value: f.favoritesOnly, onChanged: (v) => setState(() => f = f.copyWith(favoritesOnly: v))),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.withWarranty), value: f.withWarrantyOnly, onChanged: (v) => setState(() => f = f.copyWith(withWarrantyOnly: v))),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.withReminder),
            value: f.withReminderIds != null,
            onChanged: (v) => setState(() => f = v ? f.copyWith(withReminderIds: widget.reminderDocIds) : f.copyWith(clearReminder: true)),
          ),
          if (widget.advanced) ...[
            Text(l.processingStatus, style: Theme.of(context).textTheme.labelMedium),
            Wrap(spacing: Space.sm, children: [
              ChoiceChip(label: Text(l.all), selected: f.status == null, onSelected: (_) => setState(() => f = f.copyWith(clearStatus: true))),
              ChoiceChip(label: Text(l.statusNeedsReview), selected: f.status == ProcessingStatus.needsReview, onSelected: (_) => setState(() => f = f.copyWith(status: ProcessingStatus.needsReview))),
              ChoiceChip(label: Text(l.statusFailed), selected: f.status == ProcessingStatus.failed, onSelected: (_) => setState(() => f = f.copyWith(status: ProcessingStatus.failed))),
            ]),
          ] else
            const UpgradePrompt(reason: UpgradeReason.filters, compact: true),
          const SizedBox(height: Space.lg),
          Row(children: [
            Expanded(child: SecondaryButton(label: l.clearFilters, onPressed: () => Navigator.pop(context, DocumentFilter(includeVault: widget.initial.includeVault)))),
            const SizedBox(width: Space.md),
            Expanded(child: PrimaryButton(label: l.apply, onPressed: () => Navigator.pop(context, f))),
          ]),
        ]),
      ),
    );
  }
}

String sortLabel(BuildContext context, DocSort s) {
  final l = context.l10n;
  return switch (s) {
    DocSort.newest => l.sortNewest,
    DocSort.oldest => l.sortOldest,
    DocSort.nameAsc => l.sortNameAsc,
    DocSort.nameDesc => l.sortNameDesc,
    DocSort.amountDesc => l.sortAmountDesc,
    DocSort.amountAsc => l.sortAmountAsc,
    DocSort.expiry => l.sortExpiry,
  };
}

/// Document detail: preview, metadata, links, actions.
class DocumentDetailScreen extends ConsumerWidget {
  const DocumentDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final docsAsync = ref.watch(documentsProvider);
    final d = ref.watch(documentByIdProvider(id));
    if (d == null) {
      return Scaffold(appBar: AppBar(), body: docsAsync.isLoading ? const LoadingState() : EmptyState(icon: Icons.lock_outline, title: l.permissionDeniedTitle, message: l.docNotAvailable));
    }
    final uid = ref.watch(uidProvider);
    final isOwner = d.ownerUid == uid;
    final ent = ref.watch(entitlementValueProvider);
    final names = ref.watch(memberNamesProvider);
    final assets = ref.watch(assetsProvider).value ?? const <Asset>[];
    final vehicles = ref.watch(vehiclesProvider).value ?? const <Vehicle>[];
    final profiles = ref.watch(familyProfilesProvider).value ?? const [];
    String linkName(String id) =>
        assets.where((a) => a.id == id).map((a) => a.name).firstOrNull ??
        vehicles.where((v) => v.id == id).map((v) => v.displayName).firstOrNull ??
        profiles.where((p) => p.id == id).map((p) => p.name).firstOrNull ??
        l.linkedItem;
    String? linkRoute(String id) => assets.any((a) => a.id == id)
        ? '/assets/$id'
        : vehicles.any((v) => v.id == id)
            ? '/vehicles/$id'
            : profiles.any((p) => p.id == id)
                ? '/family/profile/$id'
                : null;

    return Scaffold(
      appBar: AppBar(title: Text(d.title, maxLines: 1, overflow: TextOverflow.ellipsis), actions: [
        if (isOwner)
          IconButton(
            tooltip: d.isFavorite ? l.removeFavorite : l.addFavorite,
            onPressed: () => ref.read(documentRepoProvider).setFavorite(d.id, !d.isFavorite),
            icon: Icon(d.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded, color: d.isFavorite ? AppColors.warning : null),
          ),
        if (isOwner) IconButton(tooltip: l.edit, onPressed: () => context.push('/documents/${d.id}/edit'), icon: const Icon(Icons.edit_outlined)),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.xxl), children: [
        Hero(
          tag: 'doc-${d.id}',
          child: AppCard(
            onTap: () => context.push('/documents/${d.id}/preview'),
            semanticLabel: l.openPreview,
            padding: EdgeInsets.zero,
            child: SizedBox(height: 220, child: DocumentThumbnail(document: d)),
          ),
        ),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          StatusChip(status: d.processingStatus),
          Chip(avatar: Icon(d.privacy.level == PrivacyLevel.private ? Icons.lock_outline : Icons.people_alt_outlined, size: 16), label: Text(privacyLabel(context, d.privacy.level))),
          if (d.isVault) Chip(avatar: const Icon(Icons.shield_outlined, size: 16), label: Text(l.navVault)),
          if (!isOwner) Chip(label: Text(l.sharedBy(names[d.ownerUid] ?? l.member))),
        ]),
        if (d.processingStatus == ProcessingStatus.needsReview && isOwner)
          Padding(
            padding: const EdgeInsets.only(top: Space.md),
            child: AppCard(
              onTap: () => context.push('/documents/${d.id}/review'),
              child: Row(children: [
                const Icon(Icons.fact_check_outlined, color: AppColors.warning),
                const SizedBox(width: Space.md),
                Expanded(child: Text(l.reviewSuggestions)),
                const Icon(Icons.chevron_right),
              ]),
            ),
          ),
        if (d.processingStatus == ProcessingStatus.processing)
          Padding(padding: const EdgeInsets.only(top: Space.md), child: Row(children: [const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)), const SizedBox(width: Space.sm), Text(l.aiProcessing)])),
        if (d.processingStatus == ProcessingStatus.failed && isOwner)
          Padding(padding: const EdgeInsets.only(top: Space.md), child: Text(l.uploadFailedHint, style: const TextStyle(color: AppColors.error))),
        const SizedBox(height: Space.md),
        InfoRow(label: l.category, value: categoryName(context, ref, d.categoryId), icon: Icons.folder_outlined),
        InfoRow(label: l.documentDate, value: d.documentDate == null ? null : Fmt.date(context, d.documentDate), icon: Icons.event_outlined),
        InfoRow(label: l.purchaseDate, value: d.purchaseDate == null ? null : Fmt.date(context, d.purchaseDate), icon: Icons.shopping_bag_outlined),
        InfoRow(label: l.vendor, value: d.vendor, icon: Icons.storefront_outlined),
        InfoRow(label: l.amount, value: d.amount == null ? null : Fmt.money(context, d.amount, d.currency), icon: Icons.payments_outlined),
        InfoRow(label: l.warrantyUntil, value: d.warrantyExpiryDate == null ? null : Fmt.date(context, d.warrantyExpiryDate), icon: Icons.verified_outlined),
        InfoRow(label: l.expiryDate, value: d.expiryDate == null ? null : Fmt.date(context, d.expiryDate), icon: Icons.hourglass_bottom_outlined),
        InfoRow(label: l.description, value: d.description, icon: Icons.notes_outlined),
        InfoRow(label: l.notes, value: d.notes, icon: Icons.sticky_note_2_outlined),
        if (d.tags.isNotEmpty) Wrap(spacing: Space.sm, children: [for (final t in d.tags) Chip(label: Text('#$t'))]),
        InfoRow(label: l.fileInfo, value: '${d.isPdf ? 'PDF' : l.image} · ${l.pagesCount(d.pageCount)} · ${Fmt.bytes(context, d.fileSizeBytes)}', icon: Icons.insert_drive_file_outlined),
        SectionHeader(title: l.links, actionLabel: isOwner ? l.manage : null, onAction: () => context.push('/documents/${d.id}/links')),
        if (d.linkedEntityIds.isEmpty)
          Text(l.noLinks, style: Theme.of(context).textTheme.bodySmall)
        else
          for (final e in d.linkedEntityIds)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: Text(linkName(e)),
              onTap: linkRoute(e) == null ? null : () => context.push(linkRoute(e)!),
            ),
        const SizedBox(height: Space.xl),
        if (isOwner) ...[
          if (d.warrantyExpiryDate != null || d.expiryDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.md),
              child: SecondaryButton(
                label: l.createReminder,
                icon: Icons.add_alarm_outlined,
                onPressed: () => context.push(Uri(path: '/reminders/new', queryParameters: {
                  'doc': d.id,
                  'title': d.warrantyExpiryDate != null ? l.warrantyExpiresTitle(d.title) : l.documentExpiresTitle(d.title),
                  'due': (d.warrantyExpiryDate ?? d.expiryDate)!.toIso8601String(),
                  'kind': d.warrantyExpiryDate != null ? 'warranty' : 'document',
                }).toString()),
              ),
            ),
          SecondaryButton(label: l.sharing, icon: Icons.group_outlined, onPressed: () => context.push('/documents/${d.id}/sharing')),
          const SizedBox(height: Space.md),
          if (ent.aiEnabled)
            SecondaryButton(
              label: l.aiAnalyzeAgain,
              icon: Icons.auto_awesome,
              // Not while the file is uploading or the automatic run is pending
              // (double charge), nor when the upload failed (nothing to read).
              onPressed: const {ProcessingStatus.uploading, ProcessingStatus.uploaded, ProcessingStatus.processing, ProcessingStatus.failed}
                      .contains(d.processingStatus)
                  ? null
                  : () async {
                      try {
                        await ref.read(documentRepoProvider).runAi(d.id);
                      } catch (e) {
                        if (context.mounted) showError(context, e);
                      }
                    },
            )
          else
            const UpgradePrompt(reason: UpgradeReason.ai, compact: true),
          const SizedBox(height: Space.md),
          SecondaryButton(label: l.shareFile, icon: Icons.ios_share, onPressed: () => shareDocumentFile(context, ref, d)),
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.moveToTrash,
            icon: Icons.delete_outline,
            destructive: true,
            onPressed: () async {
              if (!await confirmDialog(context, title: l.moveToTrash, message: l.moveToTrashBody, confirmLabel: l.moveToTrash, destructive: true)) return;
              await ref.read(documentRepoProvider).moveToTrash(d.id);
              if (context.mounted) {
                context.pop();
                showSuccess(context, l.movedToTrash);
              }
            },
          ),
        ],
      ]),
    );
  }
}

String privacyLabel(BuildContext context, PrivacyLevel p) => switch (p) {
      PrivacyLevel.private => context.l10n.privacyPrivate,
      PrivacyLevel.shared => context.l10n.privacyShared,
      PrivacyLevel.family => context.l10n.privacyFamily,
    };

/// Explicit export of a single file: written to the app's private temp dir
/// only for the duration of the system share sheet, then deleted.
Future<void> shareDocumentFile(BuildContext context, WidgetRef ref, DocumentRecord d) async {
  try {
    final bytes = await ref.read(documentRepoProvider).fileBytes(d);
    final dir = await getTemporaryDirectory();
    final safe = d.title.replaceAll(RegExp(r'[^\w\- ]'), '_');
    final f = File('${dir.path}/$safe.${d.isPdf ? 'pdf' : 'jpg'}');
    await f.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(f.path, mimeType: d.mimeType)]));
    await f.delete();
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

class DocumentThumbnail extends ConsumerWidget {
  const DocumentThumbnail({super.key, required this.document});
  final DocumentRecord document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (document.processingStatus == ProcessingStatus.uploading || document.processingStatus == ProcessingStatus.failed) {
      return PhotoPlaceholder(icon: fileIcon(document));
    }
    return FutureBuilder<Uint8List>(
      future: ref.read(documentRepoProvider).fileBytes(document),
      builder: (context, snap) {
        if (!snap.hasData) return snap.hasError ? PhotoPlaceholder(icon: fileIcon(document)) : const LoadingState();
        if (document.isImage) return Image.memory(snap.data!, fit: BoxFit.cover, excludeFromSemantics: true);
        return IgnorePointer(child: PdfViewer.data(snap.data!, sourceName: document.id));
      },
    );
  }
}

/// Full-screen preview (PDF pages / zoomable image).
class DocumentPreviewScreen extends ConsumerWidget {
  const DocumentPreviewScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(documentByIdProvider(id));
    if (d == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    return Scaffold(
      appBar: AppBar(title: Text(d.title)),
      body: FutureBuilder<Uint8List>(
        future: ref.read(documentRepoProvider).fileBytes(d),
        builder: (context, snap) {
          if (snap.hasError) return ErrorState(error: snap.error!);
          if (!snap.hasData) return const LoadingState();
          if (d.isImage) {
            return InteractiveViewer(maxScale: 6, child: Center(child: Image.memory(snap.data!, semanticLabel: d.title)));
          }
          return PdfViewer.data(snap.data!, sourceName: d.id);
        },
      ),
    );
  }
}

/// Edit document metadata (all AI-extracted fields are editable here).
class EditDocumentScreen extends ConsumerStatefulWidget {
  const EditDocumentScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<EditDocumentScreen> createState() => _EditDocumentScreenState();
}

class _EditDocumentScreenState extends ConsumerState<EditDocumentScreen> {
  final _form = GlobalKey<FormState>();
  DocumentRecord? _d;
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _vendor = TextEditingController();
  final _amount = TextEditingController();
  final _notes = TextEditingController();
  bool _busy = false;

  void _init(DocumentRecord d) {
    _d = d;
    _title.text = d.title;
    _desc.text = d.description ?? '';
    _vendor.text = d.vendor ?? '';
    _amount.text = d.amount?.toString() ?? '';
    _notes.text = d.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final src = ref.watch(documentByIdProvider(widget.id));
    if (src == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    if (_d == null) _init(src);
    final d = _d!;
    final locale = Localizations.localeOf(context);
    final custom = ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[];
    final cats = d.isVault ? Categories.vault : Categories.documents;
    return Scaffold(
      appBar: AppBar(title: Text(l.editDocument)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          AppTextField(label: l.title, controller: _title, maxLength: 200, validator: (v) => validateTitle(v) == null ? null : l.required),
          fieldGap,
          DropdownButtonFormField<String>(
            initialValue: cats.any((c) => c.id == d.categoryId) || custom.any((c) => c.id == d.categoryId) ? d.categoryId : null,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.category),
            items: [
              for (final c in cats) DropdownMenuItem(value: c.id, child: Text(c.label.of(locale))),
              for (final c in custom.where((c) => c.area == (d.isVault ? 'vault' : 'documents'))) DropdownMenuItem(value: c.id, child: Text(c.name)),
            ],
            onChanged: (v) => setState(() => _d = d.copyWith(categoryId: v)),
          ),
          fieldGap,
          AppTextField(label: l.description, controller: _desc, maxLines: 3, maxLength: 2000),
          FormSection(title: l.purchaseDetails, children: [
            DateField(label: l.documentDate, value: d.documentDate, onChanged: (v) => setState(() => _d = DocumentRecord.fromMap(d.id, {...d.toMap(), 'documentDate': v, 'createdAt': d.createdAt}))),
            DateField(label: l.purchaseDate, value: d.purchaseDate, onChanged: (v) => setState(() => _d = DocumentRecord.fromMap(d.id, {...d.toMap(), 'purchaseDate': v, 'createdAt': d.createdAt}))),
            AppTextField(label: l.vendor, controller: _vendor, maxLength: 200),
            MoneyField(label: l.amount, amountController: _amount, currency: d.currency, onCurrency: (c) => setState(() => _d = d.copyWith(currency: c))),
            DateField(label: l.warrantyUntil, value: d.warrantyExpiryDate, onChanged: (v) => setState(() => _d = v == null ? d.copyWith(clearWarranty: true) : d.copyWith(warrantyExpiryDate: v))),
            DateField(label: l.expiryDate, value: d.expiryDate, onChanged: (v) => setState(() => _d = DocumentRecord.fromMap(d.id, {...d.toMap(), 'expiryDate': v, 'createdAt': d.createdAt}))),
          ]),
          TagsField(tags: d.tags, onChanged: (t) => setState(() => _d = d.copyWith(tags: t))),
          fieldGap,
          AppTextField(label: l.notes, controller: _notes, maxLines: 4, maxLength: 4000),
          fieldGap,
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.saveToVault), value: d.isVault, onChanged: (v) => setState(() => _d = d.copyWith(isVault: v))),
          const SizedBox(height: Space.xl),
          PrimaryButton(
            label: l.save,
            loading: _busy,
            onPressed: () async {
              if (!_form.currentState!.validate()) return;
              setState(() => _busy = true);
              final amount = parseAmount(_amount.text);
              final updated = DocumentRecord.fromMap(d.id, {
                ...d.toMap(),
                'title': _title.text.trim(),
                'description': _desc.text.trim(),
                'vendor': _vendor.text.trim(),
                'amount': amount,
                'notes': _notes.text.trim(),
                // A manual save confirms the data.
                'processingStatus': d.processingStatus == ProcessingStatus.needsReview ? 'ready' : processingToWire(d.processingStatus),
              });
              try {
                await ref.read(documentRepoProvider).save(updated);
                if (context.mounted) {
                  showSuccess(context, l.saved);
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) showError(context, e);
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

/// Document sharing: privacy level + selected members.
class DocumentSharingScreen extends ConsumerStatefulWidget {
  const DocumentSharingScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<DocumentSharingScreen> createState() => _DocumentSharingScreenState();
}

class _DocumentSharingScreenState extends ConsumerState<DocumentSharingScreen> {
  Privacy? _p;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = ref.watch(documentByIdProvider(widget.id));
    if (d == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    _p ??= d.privacy;
    final fid = ref.watch(familyIdProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.sharing)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Text(d.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Space.lg),
        if (fid == null) ...[
          Text(l.sharingNeedsFamily, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Space.lg),
          const UpgradePrompt(reason: UpgradeReason.family),
        ] else ...[
          PrivacySelector(value: _p!, onChanged: (p) => setState(() => _p = p)),
          const SizedBox(height: Space.lg),
          Text(l.sharingServerNote, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Space.xl),
          PrimaryButton(
            label: l.save,
            onPressed: () async {
              if (_p!.validate() != null) return showError(context, Exception());
              try {
                await ref.read(documentRepoProvider).patch(d.id, _p!.toMap());
                if (context.mounted) {
                  showSuccess(context, l.sharingUpdated);
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) showError(context, e);
              }
            },
          ),
        ],
      ]),
    );
  }
}

/// Link/unlink a document to items, vehicles and family profiles (no duplicates).
class DocumentLinksScreen extends ConsumerStatefulWidget {
  const DocumentLinksScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<DocumentLinksScreen> createState() => _DocumentLinksScreenState();
}

class _DocumentLinksScreenState extends ConsumerState<DocumentLinksScreen> {
  Set<String>? _links;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = ref.watch(documentByIdProvider(widget.id));
    if (d == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    _links ??= d.linkedEntityIds.toSet();
    final uid = ref.watch(uidProvider);
    final assets = (ref.watch(assetsProvider).value ?? const <Asset>[]).where((a) => a.ownerUid == uid);
    final vehicles = (ref.watch(vehiclesProvider).value ?? const <Vehicle>[]).where((v) => v.ownerUid == uid);
    final profiles = ref.watch(familyProfilesProvider).value ?? const [];
    Widget tile(String id, String title, IconData icon) => CheckboxListTile(
          value: _links!.contains(id),
          secondary: Icon(icon),
          title: Text(title),
          onChanged: (v) => setState(() => v == true ? _links!.add(id) : _links!.remove(id)),
        );
    return Scaffold(
      appBar: AppBar(title: Text(l.links), actions: [
        TextButton(
          onPressed: () async {
            await ref.read(documentRepoProvider).setLinks(d.id, _links!.toList());
            if (context.mounted) context.pop();
          },
          child: Text(l.save),
        ),
      ]),
      body: ListView(children: [
        Padding(padding: const EdgeInsets.all(Space.gutter), child: Text(l.linksHelp, style: Theme.of(context).textTheme.bodySmall)),
        if (assets.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: Space.gutter), child: SectionHeader(title: l.items)),
        for (final a in assets) tile(a.id, a.name, Icons.chair_outlined),
        if (vehicles.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: Space.gutter), child: SectionHeader(title: l.areaCar)),
        for (final v in vehicles) tile(v.id, v.displayName, Icons.directions_car_outlined),
        if (profiles.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: Space.gutter), child: SectionHeader(title: l.areaFamily)),
        for (final p in profiles) tile(p.id, p.name, Icons.person_outline),
        if (assets.isEmpty && vehicles.isEmpty && profiles.isEmpty) EmptyState(icon: Icons.link_off, title: l.noLinkTargets),
      ]),
    );
  }
}

/// Storage usage screen with explicit, non-destructive limit handling.
class StorageUsageScreen extends ConsumerWidget {
  const StorageUsageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final usage = ref.watch(usageProvider).value;
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.ownerUid == ref.watch(uidProvider)).toList()
      ..sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
    final over = usage != null && (usage.storageLimitReached(ent) || usage.documentLimitReached(ent));
    return Scaffold(
      appBar: AppBar(title: Text(l.storage)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        PlanBadge(plan: ent.planId),
        const SizedBox(height: Space.md),
        if (usage != null) StorageUsageCard(usage: usage, entitlement: ent, compact: false),
        if (over) ...[
          const SizedBox(height: Space.lg),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.limitReachedTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.error)),
              const SizedBox(height: Space.sm),
              Text(l.limitReachedBody),
            ]),
          ),
          const SizedBox(height: Space.md),
          const UpgradePrompt(reason: UpgradeReason.storage),
        ],
        SectionHeader(title: l.largestFiles),
        for (final d in docs.take(20))
          DocumentListItem(document: d, categoryLabel: Fmt.bytes(context, d.fileSizeBytes), onTap: () => context.push('/documents/${d.id}')),
        const SizedBox(height: Space.lg),
        SecondaryButton(label: l.exportData, icon: Icons.download_outlined, onPressed: () => context.push('/settings/export')),
      ]),
    );
  }
}
