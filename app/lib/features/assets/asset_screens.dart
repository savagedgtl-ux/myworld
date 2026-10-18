import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/states.dart';
import '../../domain/categories.dart';
import '../../domain/logic/search.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';
import '../documents/document_screens.dart';
import '../scanner/scan_screens.dart';

List<CategoryDef> categoriesFor(ItemArea area) => area == ItemArea.hobby ? Categories.hobby : Categories.home;

/// My Home / My Hobby dashboard.
class AssetAreaDashboard extends ConsumerStatefulWidget {
  const AssetAreaDashboard({super.key, required this.area});
  final ItemArea area;
  @override
  ConsumerState<AssetAreaDashboard> createState() => _AssetAreaDashboardState();
}

class _AssetAreaDashboardState extends ConsumerState<AssetAreaDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(AddContext(area: widget.area.name)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final area = widget.area;
    final locale = Localizations.localeOf(context);
    final assetsAsync = ref.watch(assetsProvider);
    final custom = (ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[]).where((c) => c.area == area.name);
    return Scaffold(
      appBar: AppBar(title: Text(area == ItemArea.hobby ? l.areaHobby : l.areaHome), actions: [
        IconButton(tooltip: l.addCategory, onPressed: () => addCategoryDialog(context, ref, area.name), icon: const Icon(Icons.create_new_folder_outlined)),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/assets/new?area=${area.name}'), icon: const Icon(Icons.add), label: Text(l.addItem)),
      body: asyncView<List<Asset>>(assetsAsync, (all) {
        final items = all.where((a) => a.area == area).toList();
        final now = DateTime.now();
        final expiring = items.where((a) => a.warrantyExpiryDate != null && a.warrantyExpiryDate!.isAfter(now) && a.warrantyExpiryDate!.difference(now).inDays <= 90).toList()
          ..sort((a, b) => a.warrantyExpiryDate!.compareTo(b.warrantyExpiryDate!));
        final value = <String, double>{};
        for (final a in items) {
          if (a.purchasePrice != null && a.currency != null) value[a.currency!] = (value[a.currency!] ?? 0) + a.purchasePrice!;
        }
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
          if (items.isNotEmpty)
            AppCard(
              child: Row(children: [
                Expanded(child: _Stat(label: l.items, value: '${items.length}')),
                Expanded(child: _Stat(label: l.totalValue, value: value.isEmpty ? '—' : value.entries.map((e) => Fmt.money(context, e.value, e.key)).join('\n'))),
                Expanded(child: _Stat(label: l.warrantiesExpiring, value: '${expiring.length}')),
              ]),
            ),
          SectionHeader(title: l.categories),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: Space.md,
            crossAxisSpacing: Space.md,
            children: [
              for (final c in categoriesFor(area))
                _CategoryTile(icon: c.icon, label: c.label.of(locale), count: items.where((a) => a.category == c.id).length, onTap: () => context.push('/assets/list?area=${area.name}&category=${c.id}')),
              for (final c in custom)
                _CategoryTile(icon: Icons.folder_special_outlined, label: c.name, count: items.where((a) => a.category == c.id).length, onTap: () => context.push('/assets/list?area=${area.name}&category=${c.id}')),
            ],
          ),
          if (expiring.isNotEmpty) ...[
            SectionHeader(title: l.warrantiesExpiring),
            for (final a in expiring) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: _assetCard(context, a)),
          ],
          SectionHeader(title: l.allItems, actionLabel: items.isEmpty ? null : l.seeAll, onAction: () => context.push('/assets/list?area=${area.name}')),
          if (items.isEmpty)
            EmptyState(icon: area == ItemArea.hobby ? Icons.interests_outlined : Icons.chair_outlined, title: l.noItems, message: l.noItemsHint, actionLabel: l.addItem, onAction: () => context.push('/assets/new?area=${area.name}'))
          else
            for (final a in (items..sort((a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)))).take(6))
              Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: _assetCard(context, a)),
        ]);
      }),
    );
  }
}

Widget _assetCard(BuildContext context, Asset a) {
  final l = context.l10n;
  final sub = [
    if (a.brand != null || a.model != null) [a.brand, a.model].whereType<String>().join(' '),
    if (a.warrantyExpiryDate != null) l.warrantyUntilShort(Fmt.date(context, a.warrantyExpiryDate)),
    if (a.location != null) a.location!,
  ].join(' · ');
  final cat = Categories.find(categoriesFor(a.area), a.category);
  return AssetCard(
    title: a.name,
    subtitle: sub.isEmpty ? (cat?.label.of(Localizations.localeOf(context)) ?? '') : sub,
    icon: cat?.icon ?? Icons.category_outlined,
    photoPath: a.photoStoragePath,
    onTap: () => context.push('/assets/${a.id}'),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => MergeSemantics(
        child: Column(children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
        ]),
      );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.icon, required this.label, required this.count, required this.onTap});
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        semanticLabel: '$label, $count',
        padding: const EdgeInsets.all(Space.sm),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: AppColors.secondary, size: 28),
          const SizedBox(height: Space.xs),
          Text(label, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          Text('$count', style: Theme.of(context).textTheme.labelSmall),
        ]),
      );
}

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key, required this.area, this.category});
  final ItemArea area;
  final String? category;
  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context);
    final title = widget.category == null ? l.allItems : (Categories.find(categoriesFor(widget.area), widget.category)?.label.of(locale) ?? l.items);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.addItem,
        onPressed: () => context.push(Uri(path: '/assets/new', queryParameters: {'area': widget.area.name, 'category': ?widget.category}).toString()),
        child: const Icon(Icons.add),
      ),
      body: asyncView<List<Asset>>(ref.watch(assetsProvider), (all) {
        final list = all
            .where((a) => a.area == widget.area && (widget.category == null || a.category == widget.category))
            .where((a) => matchesQuery(_q, [a.name, a.brand, a.model, a.serialNumber, a.vendor, a.location, a.notes]))
            .toList()
          ..sort((a, b) => normalizeText(a.name).compareTo(normalizeText(b.name)));
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
          AppSearchBar(hint: l.searchItems, onChanged: (v) => setState(() => _q = v)),
          const SizedBox(height: Space.lg),
          if (list.isEmpty)
            EmptyState(icon: Icons.inventory_2_outlined, title: _q.isEmpty ? l.noItems : l.noResults, actionLabel: l.addItem, onAction: () => context.push('/assets/new?area=${widget.area.name}'))
          else
            for (final a in list) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: _assetCard(context, a)),
        ]);
      }),
    );
  }
}

class AssetDetailScreen extends ConsumerStatefulWidget {
  const AssetDetailScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final a = (ref.read(assetsProvider).value ?? const <Asset>[]).where((x) => x.id == widget.id).firstOrNull;
      ref.read(addContextProvider.notifier).set(AddContext(area: a?.area.name ?? 'home', entityId: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final all = ref.watch(assetsProvider);
    final a = (all.value ?? const <Asset>[]).where((x) => x.id == widget.id).firstOrNull;
    if (a == null) return Scaffold(appBar: AppBar(), body: all.isLoading ? const LoadingState() : EmptyState(icon: Icons.lock_outline, title: l.notAvailable));
    final isOwner = a.ownerUid == ref.watch(uidProvider);
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.linkedEntityIds.contains(a.id) && !d.inTrash).toList();
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.linkedEntityId == a.id).toList();
    final cat = Categories.find(categoriesFor(a.area), a.category);
    final locale = Localizations.localeOf(context);
    final warrantyActive = a.warrantyExpiryDate != null && a.warrantyExpiryDate!.isAfter(DateTime.now());

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          actions: [if (isOwner) IconButton(tooltip: l.edit, onPressed: () => context.push('/assets/${a.id}/edit'), icon: const Icon(Icons.edit_outlined))],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(a.name, style: const TextStyle(shadows: [Shadow(blurRadius: 8, color: Colors.black45)])),
            background: StorageImage(path: a.photoStoragePath, placeholderIcon: cat?.icon ?? Icons.category_outlined),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Space.gutter),
          sliver: SliverList.list(children: [
            if (a.warrantyExpiryDate != null)
              AppCard(
                onTap: () => context.push('/assets/${a.id}/warranty'),
                child: Row(children: [
                  Icon(Icons.verified_outlined, color: warrantyActive ? AppColors.success : AppColors.textSecondary),
                  const SizedBox(width: Space.md),
                  Expanded(child: Text(warrantyActive ? l.warrantyActiveUntil(Fmt.date(context, a.warrantyExpiryDate)) : l.warrantyExpiredOn(Fmt.date(context, a.warrantyExpiryDate)))),
                  const Icon(Icons.chevron_right),
                ]),
              ),
            InfoRow(label: l.category, value: cat?.label.of(locale) ?? a.category, icon: Icons.folder_outlined),
            InfoRow(label: l.brandModel, value: [a.brand, a.model].whereType<String>().join(' '), icon: Icons.sell_outlined),
            InfoRow(label: l.serialNumber, value: a.serialNumber, icon: Icons.qr_code_2),
            InfoRow(label: l.purchaseDate, value: a.purchaseDate == null ? null : Fmt.date(context, a.purchaseDate), icon: Icons.event_outlined),
            InfoRow(label: l.vendor, value: a.vendor, icon: Icons.storefront_outlined),
            InfoRow(label: l.price, value: a.purchasePrice == null ? null : Fmt.money(context, a.purchasePrice, a.currency), icon: Icons.payments_outlined),
            InfoRow(label: l.location, value: a.location, icon: Icons.place_outlined),
            InfoRow(label: l.status, value: assetStatusLabel(context, a.status), icon: Icons.info_outline),
            InfoRow(label: l.notes, value: a.notes, icon: Icons.notes_outlined),
            SectionHeader(title: l.documents, actionLabel: isOwner ? l.add : null, onAction: () => context.push('/scan?mode=scan&area=${a.area.name}&link=${a.id}')),
            if (docs.isEmpty)
              Text(l.noLinkedDocs, style: Theme.of(context).textTheme.bodySmall)
            else
              for (final d in docs) DocumentListItem(document: d, categoryLabel: categoryName(context, ref, d.categoryId), onTap: () => context.push('/documents/${d.id}')),
            SectionHeader(title: l.maintenanceHistory, actionLabel: l.open, onAction: () => context.push('/assets/${a.id}/maintenance')),
            SectionHeader(title: l.reminders, actionLabel: isOwner ? l.add : null, onAction: () => context.push('/reminders/new?link=${a.id}&linkType=asset')),
            if (reminders.isEmpty)
              Text(l.noReminders, style: Theme.of(context).textTheme.bodySmall)
            else
              for (final r in reminders) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ReminderCard(reminder: r, onTap: () => context.push('/reminders/${r.id}'))),
            const SizedBox(height: Space.xl),
            if (isOwner)
              SecondaryButton(
                label: l.deleteItem,
                destructive: true,
                icon: Icons.delete_outline,
                onPressed: () async {
                  if (!await confirmDialog(context, title: l.deleteItem, message: l.deleteItemBody, confirmLabel: l.delete, destructive: true)) return;
                  await ref.read(assetRepoProvider).delete(a.id);
                  if (a.photoStoragePath != null) await ref.read(storageServiceProvider).deletePhoto(a.photoStoragePath!);
                  if (context.mounted) context.pop();
                },
              ),
          ]),
        ),
      ]),
    );
  }
}

String assetStatusLabel(BuildContext context, AssetStatus s) => switch (s) {
      AssetStatus.active => context.l10n.statusActive,
      AssetStatus.inRepair => context.l10n.statusInRepair,
      AssetStatus.sold => context.l10n.statusSold,
      AssetStatus.discarded => context.l10n.statusDiscarded,
    };

class WarrantyDetailScreen extends ConsumerWidget {
  const WarrantyDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final a = (ref.watch(assetsProvider).value ?? const <Asset>[]).where((x) => x.id == id).firstOrNull;
    if (a == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[])
        .where((d) => d.linkedEntityIds.contains(id) && (d.categoryId == 'warranties' || d.hasWarranty || d.categoryId == 'receipts'))
        .toList();
    final exp = a.warrantyExpiryDate;
    final now = DateTime.now();
    final daysLeft = exp?.difference(DateTime(now.year, now.month, now.day)).inDays;
    return Scaffold(
      appBar: AppBar(title: Text(l.warranty)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Text(a.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: Space.lg),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(exp == null ? l.noWarrantyDate : (daysLeft! >= 0 ? l.warrantyDaysLeft(daysLeft) : l.warrantyExpiredOn(Fmt.date(context, exp))),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: daysLeft != null && daysLeft < 0 ? AppColors.error : AppColors.success)),
            const SizedBox(height: Space.sm),
            if (a.purchaseDate != null) Text(l.purchasedOn(Fmt.date(context, a.purchaseDate))),
            if (exp != null) Text(l.warrantyUntilShort(Fmt.date(context, exp))),
            const SizedBox(height: Space.sm),
            Text(l.warrantyUserEnteredNote, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
        SectionHeader(title: l.receiptsAndWarranties),
        if (docs.isEmpty) Text(l.noLinkedDocs, style: Theme.of(context).textTheme.bodySmall),
        for (final d in docs) DocumentListItem(document: d, onTap: () => context.push('/documents/${d.id}')),
        const SizedBox(height: Space.lg),
        if (exp != null && exp.isAfter(now))
          PrimaryButton(
            label: l.remindBeforeExpiry,
            icon: Icons.add_alarm,
            onPressed: () => context.push(Uri(path: '/reminders/new', queryParameters: {
              'link': a.id,
              'linkType': 'asset',
              'title': l.warrantyExpiresTitle(a.name),
              'due': exp.subtract(const Duration(days: 14)).toIso8601String(),
              'kind': 'warranty',
            }).toString()),
          ),
      ]),
    );
  }
}

/// Maintenance / repair history: linked documents and reminders on a timeline.
class MaintenanceHistoryScreen extends ConsumerWidget {
  const MaintenanceHistoryScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final a = (ref.watch(assetsProvider).value ?? const <Asset>[]).where((x) => x.id == id).firstOrNull;
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.linkedEntityIds.contains(id) && !d.inTrash);
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.linkedEntityId == id);
    final events = <({DateTime date, String title, String sub, VoidCallback onTap, IconData icon})>[
      for (final d in docs)
        (date: d.documentDate ?? d.createdAt ?? DateTime(0), title: d.title, sub: [d.vendor, d.amount == null ? null : Fmt.money(context, d.amount, d.currency)].whereType<String>().join(' · '), onTap: () => context.push('/documents/${d.id}'), icon: Icons.receipt_long_outlined),
      for (final r in reminders) (date: r.dueAt, title: r.title, sub: l.reminder, onTap: () => context.push('/reminders/${r.id}'), icon: Icons.alarm),
    ]..sort((x, y) => y.date.compareTo(x.date));
    return Scaffold(
      appBar: AppBar(title: Text(l.maintenanceHistory)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scan?mode=scan&area=${a?.area.name ?? 'home'}&link=$id'),
        icon: const Icon(Icons.add),
        label: Text(l.addRepairReceipt),
      ),
      body: events.isEmpty
          ? EmptyState(icon: Icons.build_outlined, title: l.noMaintenance, message: l.noMaintenanceHint)
          : ListView(padding: const EdgeInsets.all(Space.gutter), children: [
              for (final e in events)
                ListTile(
                  leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(e.icon, color: AppColors.secondary)),
                  title: Text(e.title),
                  subtitle: Text([Fmt.date(context, e.date), e.sub].where((s) => s.isNotEmpty).join(' · ')),
                  onTap: e.onTap,
                ),
            ]),
    );
  }
}

class EditAssetScreen extends ConsumerStatefulWidget {
  const EditAssetScreen({super.key, this.id, this.area = ItemArea.home, this.category});
  final String? id;
  final ItemArea area;
  final String? category;
  @override
  ConsumerState<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends ConsumerState<EditAssetScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _serial = TextEditingController();
  final _vendor = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController();
  final _notes = TextEditingController();
  String? _category;
  String? _currency;
  DateTime? _purchase;
  DateTime? _warranty;
  AssetStatus _status = AssetStatus.active;
  Privacy _privacy = Privacy.private;
  String? _photoPath;
  Uint8List? _newPhoto;
  bool _busy = false;
  bool _loaded = false;
  late ItemArea _area = widget.area;
  Asset? _existing;

  void _load() {
    _loaded = true;
    _category = widget.category;
    if (widget.id == null) return;
    final a = (ref.read(assetsProvider).value ?? const <Asset>[]).where((x) => x.id == widget.id).firstOrNull;
    if (a == null) return;
    _existing = a;
    _area = a.area;
    _name.text = a.name;
    _brand.text = a.brand ?? '';
    _model.text = a.model ?? '';
    _serial.text = a.serialNumber ?? '';
    _vendor.text = a.vendor ?? '';
    _price.text = a.purchasePrice?.toString() ?? '';
    _location.text = a.location ?? '';
    _notes.text = a.notes ?? '';
    _category = a.category;
    _currency = a.currency;
    _purchase = a.purchaseDate;
    _warranty = a.warrantyExpiryDate;
    _status = a.status;
    _privacy = a.privacy;
    _photoPath = a.photoStoragePath;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) _load();
    final l = context.l10n;
    final locale = Localizations.localeOf(context);
    final custom = (ref.watch(customCategoriesProvider).value ?? const <CustomCategory>[]).where((c) => c.area == _area.name);
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? l.addItem : l.editItem)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          Semantics(
            button: true,
            label: l.changePhoto,
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.md),
              onTap: () async {
                final b = await pickPhotoSheet(context, ref);
                if (b != null) setState(() => _newPhoto = b);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.md),
                child: SizedBox(
                  height: 180,
                  child: _newPhoto != null
                      ? Image.memory(_newPhoto!, fit: BoxFit.cover)
                      : Stack(fit: StackFit.expand, children: [
                          StorageImage(path: _photoPath, placeholderIcon: Icons.add_a_photo_outlined),
                          Positioned(right: Space.sm, bottom: Space.sm, child: Chip(avatar: const Icon(Icons.photo_camera_outlined, size: 16), label: Text(l.changePhoto))),
                        ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
          AppTextField(label: l.name, controller: _name, maxLength: 120, validator: (v) => (v ?? '').trim().isEmpty ? l.required : null),
          fieldGap,
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.category),
            items: [
              for (final c in categoriesFor(_area)) DropdownMenuItem(value: c.id, child: Text(c.label.of(locale))),
              for (final c in custom) DropdownMenuItem(value: c.id, child: Text(c.name)),
            ],
            onChanged: (v) => setState(() => _category = v),
          ),
          FormSection(title: l.details, children: [
            AppTextField(label: l.brand, controller: _brand, maxLength: 80),
            AppTextField(label: l.model, controller: _model, maxLength: 80),
            AppTextField(label: l.serialNumber, controller: _serial, maxLength: 80, textCapitalization: TextCapitalization.characters),
            AppTextField(label: l.location, controller: _location, maxLength: 120, helper: l.locationHelp),
            DropdownButtonFormField<AssetStatus>(
              initialValue: _status,
              decoration: InputDecoration(labelText: l.status),
              items: [for (final s in AssetStatus.values) DropdownMenuItem(value: s, child: Text(assetStatusLabel(context, s)))],
              onChanged: (v) => setState(() => _status = v ?? AssetStatus.active),
            ),
          ]),
          FormSection(title: l.purchaseDetails, children: [
            DateField(label: l.purchaseDate, value: _purchase, lastDate: DateTime.now(), onChanged: (v) => setState(() => _purchase = v)),
            AppTextField(label: l.vendor, controller: _vendor, maxLength: 120),
            MoneyField(label: l.price, amountController: _price, currency: _currency, onCurrency: (c) => setState(() => _currency = c)),
            DateField(label: l.warrantyUntil, value: _warranty, helper: l.warrantyFieldHelp, onChanged: (v) => setState(() => _warranty = v)),
          ]),
          AppTextField(label: l.notes, controller: _notes, maxLines: 4, maxLength: 4000),
          fieldGap,
          PrivacySelector(value: _privacy, onChanged: (p) => setState(() => _privacy = p)),
          const SizedBox(height: Space.xl),
          PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_privacy.validate() != null) return showError(context, Exception());
    setState(() => _busy = true);
    final uid = ref.read(uidProvider)!;
    final repo = ref.read(assetRepoProvider);
    final id = widget.id ?? repo.newId();
    try {
      var photo = _photoPath;
      if (_newPhoto != null) photo = await ref.read(photoRepoProvider).upload(uid, id, 'photo', _newPhoto!);
      String? t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
      final a = Asset(
        id: id,
        ownerUid: _existing?.ownerUid ?? uid,
        name: _name.text.trim(),
        area: _area,
        privacy: _privacy,
        category: _category,
        photoStoragePath: photo,
        brand: t(_brand),
        model: t(_model),
        serialNumber: t(_serial),
        purchaseDate: _purchase,
        purchasePrice: parseAmount(_price.text),
        currency: _currency,
        vendor: t(_vendor),
        warrantyExpiryDate: _warranty,
        location: t(_location),
        status: _status,
        notes: t(_notes),
        assignedProfileIds: _existing?.assignedProfileIds ?? const [],
      );
      await repo.save(a, isNew: widget.id == null);
      if (!mounted) return;
      showSuccess(context, context.l10n.saved);
      if (widget.id == null) {
        showInterstitialAtBreak(ref);
        context.pushReplacement('/assets/$id');
      } else {
        context.pop();
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
