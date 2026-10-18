import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/costs.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';
import '../scanner/scan_screens.dart';

String recordTypeLabel(BuildContext context, VehicleRecordType t) {
  final l = context.l10n;
  return switch (t) {
    VehicleRecordType.registration => l.recRegistration,
    VehicleRecordType.insurance => l.recInsurance,
    VehicleRecordType.inspection => l.recInspection,
    VehicleRecordType.service => l.recService,
    VehicleRecordType.oil => l.recOil,
    VehicleRecordType.tires => l.recTires,
    VehicleRecordType.repair => l.recRepair,
    VehicleRecordType.parts => l.recParts,
    VehicleRecordType.fuel => l.recFuel,
    VehicleRecordType.tolls => l.recTolls,
    VehicleRecordType.parking => l.recParking,
    VehicleRecordType.other => l.recOther,
  };
}

IconData recordTypeIcon(VehicleRecordType t) => switch (t) {
      VehicleRecordType.registration => Icons.assignment_outlined,
      VehicleRecordType.insurance => Icons.shield_outlined,
      VehicleRecordType.inspection => Icons.fact_check_outlined,
      VehicleRecordType.service => Icons.build_outlined,
      VehicleRecordType.oil => Icons.oil_barrel_outlined,
      VehicleRecordType.tires => Icons.tire_repair_outlined,
      VehicleRecordType.repair => Icons.car_repair_outlined,
      VehicleRecordType.parts => Icons.settings_outlined,
      VehicleRecordType.fuel => Icons.local_gas_station_outlined,
      VehicleRecordType.tolls => Icons.toll_outlined,
      VehicleRecordType.parking => Icons.local_parking_outlined,
      VehicleRecordType.other => Icons.more_horiz,
    };

String moneyMap(BuildContext context, Map<String, double> m) =>
    m.isEmpty ? '—' : m.entries.map((e) => Fmt.money(context, e.value, e.key == '—' ? null : e.key)).join(' + ');

Vehicle? _vehicle(WidgetRef ref, String id) => (ref.watch(vehiclesProvider).value ?? const <Vehicle>[]).where((v) => v.id == id).firstOrNull;
List<VehicleRecord> _records(WidgetRef ref, String vehicleId) =>
    (ref.watch(vehicleRecordsProvider).value ?? const <VehicleRecord>[]).where((r) => r.vehicleId == vehicleId).toList()..sort((a, b) => b.date.compareTo(a.date));

class VehiclesDashboard extends ConsumerStatefulWidget {
  const VehiclesDashboard({super.key, this.pickForRecord = false});
  final bool pickForRecord;
  @override
  ConsumerState<VehiclesDashboard> createState() => _VehiclesDashboardState();
}

class _VehiclesDashboardState extends ConsumerState<VehiclesDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(const AddContext(area: 'car')));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.pickForRecord ? l.chooseVehicle : l.areaCar)),
      floatingActionButton: widget.pickForRecord
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                final own = (ref.read(vehiclesProvider).value ?? const <Vehicle>[]).where((v) => v.ownerUid == ref.read(uidProvider)).length;
                if (own >= ent.maxVehicles) {
                  showUpgradeSheet(context, UpgradeReason.vehicles);
                  return;
                }
                context.push('/vehicles/new');
              },
              icon: const Icon(Icons.add),
              label: Text(l.addVehicle),
            ),
      body: asyncView<List<Vehicle>>(ref.watch(vehiclesProvider), (vehicles) {
        if (vehicles.isEmpty) {
          return EmptyState(icon: Icons.directions_car_outlined, title: l.noVehicles, message: l.noVehiclesHint, actionLabel: l.addVehicle, onAction: () => context.push('/vehicles/new'));
        }
        final allRecords = ref.watch(vehicleRecordsProvider).value ?? const <VehicleRecord>[];
        final upcoming = upcomingDeadlines(allRecords).take(5).toList();
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
          for (final v in vehicles) ...[
            _VehicleHeroCard(
              vehicle: v,
              summary: summarizeCosts(allRecords.where((r) => r.vehicleId == v.id), vehicleMileage: v.currentMileage),
              onTap: () => widget.pickForRecord ? context.pushReplacement('/vehicles/${v.id}/records/new') : context.push('/vehicles/${v.id}'),
            ),
            const SizedBox(height: Space.md),
          ],
          if (upcoming.isNotEmpty && !widget.pickForRecord) ...[
            SectionHeader(title: l.upcomingDeadlines),
            for (final r in upcoming)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(recordTypeIcon(r.type), color: AppColors.warning),
                title: Text('${recordTypeLabel(context, r.type)} · ${vehicles.where((v) => v.id == r.vehicleId).firstOrNull?.displayName ?? ''}'),
                subtitle: Text(Fmt.date(context, r.nextDueDate)),
                trailing: Text(Fmt.relativeDays(context, r.nextDueDate!)),
                onTap: () => context.push('/vehicles/${r.vehicleId}/records'),
              ),
          ],
        ]);
      }),
    );
  }
}

class _VehicleHeroCard extends StatelessWidget {
  const _VehicleHeroCard({required this.vehicle, required this.summary, required this.onTap});
  final Vehicle vehicle;
  final CostSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = vehicle;
    return AppCard(
      onTap: onTap,
      semanticLabel: v.displayName,
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 150, child: StorageImage(path: v.photoStoragePath, placeholderIcon: Icons.directions_car_filled_outlined)),
        Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v.displayName, style: Theme.of(context).textTheme.titleLarge),
            Text([v.year?.toString(), v.registrationNumber].whereType<String>().join(' · '), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: Space.md),
            Row(children: [
              Expanded(child: _kv(context, l.thisYear, moneyMap(context, summary.thisYearByCurrency))),
              Expanded(child: _kv(context, l.mileage, summary.lastMileage == null ? '—' : '${Fmt.number(context, summary.lastMileage)} km')),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(k, style: Theme.of(context).textTheme.labelSmall),
        Text(v, style: Theme.of(context).textTheme.titleSmall),
      ]);
}

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(AddContext(area: 'car', entityId: widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = _vehicle(ref, widget.id);
    if (v == null) return Scaffold(appBar: AppBar(), body: ref.watch(vehiclesProvider).isLoading ? const LoadingState() : EmptyState(icon: Icons.lock_outline, title: l.notAvailable));
    final records = _records(ref, v.id);
    final s = summarizeCosts(records, vehicleMileage: v.currentMileage);
    final isOwner = v.ownerUid == ref.watch(uidProvider);
    final upcoming = upcomingDeadlines(records);
    return Scaffold(
      floatingActionButton: isOwner
          ? FloatingActionButton.extended(onPressed: () => context.push('/vehicles/${v.id}/records/new'), icon: const Icon(Icons.add), label: Text(l.addRecord))
          : null,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          actions: [if (isOwner) IconButton(tooltip: l.edit, onPressed: () => context.push('/vehicles/${v.id}/edit'), icon: const Icon(Icons.edit_outlined))],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(v.displayName, style: const TextStyle(shadows: [Shadow(blurRadius: 8, color: Colors.black45)])),
            background: StorageImage(path: v.photoStoragePath, placeholderIcon: Icons.directions_car_filled_outlined),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Space.gutter, Space.gutter, Space.gutter, 96),
          sliver: SliverList.list(children: [
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.totalInvested, style: Theme.of(context).textTheme.labelMedium),
                Text(moneyMap(context, s.totalByCurrency), style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: Space.sm),
                Text('${l.thisYear}: ${moneyMap(context, s.thisYearByCurrency)}', style: Theme.of(context).textTheme.bodySmall),
                Text('${l.lastMileage}: ${s.lastMileage == null ? '—' : '${Fmt.number(context, s.lastMileage)} km'}', style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(height: Space.md),
            Row(children: [
              Expanded(child: _Nav(icon: Icons.history, label: l.serviceHistory, onTap: () => context.push('/vehicles/${v.id}/records'))),
              const SizedBox(width: Space.sm),
              Expanded(child: _Nav(icon: Icons.pie_chart_outline, label: l.expenses, onTap: () => context.push('/vehicles/${v.id}/expenses'))),
            ]),
            const SizedBox(height: Space.sm),
            Row(children: [
              Expanded(child: _Nav(icon: Icons.assignment_outlined, label: l.registrationInsurance, onTap: () => context.push('/vehicles/${v.id}/registration'))),
              const SizedBox(width: Space.sm),
              Expanded(child: _Nav(icon: Icons.speed, label: l.mileageHistory, onTap: () => context.push('/vehicles/${v.id}/mileage'))),
            ]),
            if (upcoming.isNotEmpty) ...[
              SectionHeader(title: l.upcomingDeadlines),
              for (final r in upcoming.take(3))
                ListTile(contentPadding: EdgeInsets.zero, leading: Icon(recordTypeIcon(r.type)), title: Text(recordTypeLabel(context, r.type)), subtitle: Text(Fmt.date(context, r.nextDueDate)), trailing: Text(Fmt.relativeDays(context, r.nextDueDate!))),
            ],
            SectionHeader(title: l.details),
            InfoRow(label: l.year, value: v.year?.toString(), icon: Icons.calendar_month_outlined),
            InfoRow(label: l.registrationNumber, value: v.registrationNumber, icon: Icons.badge_outlined),
            InfoRow(label: 'VIN', value: v.vin, icon: Icons.qr_code),
            InfoRow(label: l.fuelType, value: v.fuelType, icon: Icons.local_gas_station_outlined),
            InfoRow(label: l.purchaseDate, value: v.purchaseDate == null ? null : Fmt.date(context, v.purchaseDate), icon: Icons.event),
            InfoRow(label: l.price, value: v.purchasePrice == null ? null : Fmt.money(context, v.purchasePrice, v.currency), icon: Icons.payments_outlined),
            InfoRow(label: l.notes, value: v.notes, icon: Icons.notes),
            SectionHeader(title: l.recentRecords),
            if (records.isEmpty) Text(l.noRecords, style: Theme.of(context).textTheme.bodySmall),
            for (final r in records.take(5)) _RecordTile(record: r),
            if (isOwner) ...[
              const SizedBox(height: Space.xl),
              SecondaryButton(
                label: l.deleteVehicle,
                destructive: true,
                onPressed: () async {
                  if (!await confirmDialog(context, title: l.deleteVehicle, message: l.deleteVehicleBody, confirmLabel: l.delete, destructive: true)) return;
                  for (final r in records.where((r) => r.ownerUid == v.ownerUid)) {
                    await ref.read(vehicleRecordRepoProvider).delete(r.id);
                  }
                  await ref.read(vehicleRepoProvider).delete(v.id);
                  if (context.mounted) context.pop();
                },
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}

class _Nav extends StatelessWidget {
  const _Nav({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        semanticLabel: label,
        padding: const EdgeInsets.all(Space.md),
        child: Row(children: [Icon(icon, color: AppColors.secondary), const SizedBox(width: Space.sm), Expanded(child: Text(label, style: Theme.of(context).textTheme.labelLarge))]),
      );
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});
  final VehicleRecord record;
  @override
  Widget build(BuildContext context) {
    final r = record;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(recordTypeIcon(r.type), color: AppColors.secondary)),
      title: Text(recordTypeLabel(context, r.type)),
      subtitle: Text([Fmt.date(context, r.date), if (r.mileage != null) '${Fmt.number(context, r.mileage)} km', ?r.vendor].join(' · ')),
      trailing: Text(Fmt.money(context, r.amount, r.currency), style: Theme.of(context).textTheme.titleSmall),
      onTap: () => context.push('/vehicle-records/${r.id}/edit'),
    );
  }
}

class VehicleRecordsScreen extends ConsumerStatefulWidget {
  const VehicleRecordsScreen({super.key, required this.id, this.types});
  final String id;
  final Set<VehicleRecordType>? types;
  @override
  ConsumerState<VehicleRecordsScreen> createState() => _VehicleRecordsScreenState();
}

class _VehicleRecordsScreenState extends ConsumerState<VehicleRecordsScreen> {
  final Set<VehicleRecordType> _types = {};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final records = _records(ref, widget.id).where((r) => _types.isEmpty || _types.contains(r.type)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.serviceHistory)),
      floatingActionButton: FloatingActionButton(tooltip: l.addRecord, onPressed: () => context.push('/vehicles/${widget.id}/records/new'), child: const Icon(Icons.add)),
      body: ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
        FilterChips<VehicleRecordType>(
          options: VehicleRecordType.values,
          selected: _types,
          labelOf: (t) => recordTypeLabel(context, t),
          onToggle: (t) => setState(() => _types.contains(t) ? _types.remove(t) : _types.add(t)),
        ),
        const SizedBox(height: Space.md),
        if (records.isEmpty) EmptyState(icon: Icons.history, title: l.noRecords, actionLabel: l.addRecord, onAction: () => context.push('/vehicles/${widget.id}/records/new')),
        for (final r in records) _RecordTile(record: r),
      ]),
    );
  }
}

class ExpenseOverviewScreen extends ConsumerWidget {
  const ExpenseOverviewScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final v = _vehicle(ref, id);
    final records = _records(ref, id);
    final s = summarizeCosts(records, vehicleMileage: v?.currentMileage);
    final currencies = s.totalByCurrency.keys.toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.expenses)),
      body: records.isEmpty
          ? EmptyState(icon: Icons.pie_chart_outline, title: l.noExpenses)
          : ListView(padding: const EdgeInsets.all(Space.gutter), children: [
              AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.totalInvested, style: Theme.of(context).textTheme.labelMedium),
                  Text(moneyMap(context, s.totalByCurrency), style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: Space.xs),
                  Text('${l.thisYear}: ${moneyMap(context, s.thisYearByCurrency)}'),
                ]),
              ),
              if (currencies.length > 1) Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.multiCurrencyNote, style: Theme.of(context).textTheme.bodySmall)),
              for (final cur in currencies) ...[
                SectionHeader(title: l.last12Months(cur == '—' ? '' : cur)),
                _MonthlyBars(data: monthlyTotals(records, cur), currency: cur == '—' ? null : cur),
              ],
              SectionHeader(title: l.byCategory),
              for (final e in s.byType.entries.toList()..sort((a, b) => b.value.values.fold<double>(0, (x, y) => x + y).compareTo(a.value.values.fold<double>(0, (x, y) => x + y))))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(recordTypeIcon(e.key), color: AppColors.secondary),
                  title: Text(recordTypeLabel(context, e.key)),
                  trailing: Text(moneyMap(context, e.value), style: Theme.of(context).textTheme.titleSmall),
                ),
            ]),
    );
  }
}

/// Simple accessible bar chart (no chart library needed).
class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.data, required this.currency});
  final List<({DateTime month, double amount})> data;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final maxV = data.fold<double>(0, (m, e) => e.amount > m ? e.amount : m);
    return Semantics(
      label: data.where((e) => e.amount > 0).map((e) => '${Fmt.monthYear(context, e.month)}: ${Fmt.money(context, e.amount, currency)}').join(', '),
      child: ExcludeSemantics(
        child: SizedBox(
          height: 140,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (final e in data)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: maxV == 0 ? 2 : 2 + 110 * (e.amount / maxV),
                      decoration: BoxDecoration(color: e.amount > 0 ? AppColors.secondary : AppColors.divider, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(height: 4),
                    Text('${e.month.month}', style: Theme.of(context).textTheme.labelSmall),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class RegistrationInsuranceScreen extends ConsumerWidget {
  const RegistrationInsuranceScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final records = _records(ref, id);
    Widget block(VehicleRecordType t) {
      final list = records.where((r) => r.type == t).toList();
      final last = list.firstOrNull;
      return AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(recordTypeIcon(t), color: AppColors.secondary), const SizedBox(width: Space.sm), Text(recordTypeLabel(context, t), style: Theme.of(context).textTheme.titleMedium)]),
          const SizedBox(height: Space.sm),
          if (last == null)
            Text(l.noRecordYet, style: Theme.of(context).textTheme.bodySmall)
          else ...[
            Text(l.lastOn(Fmt.date(context, last.date))),
            if (last.nextDueDate != null) Text(l.nextDue(Fmt.date(context, last.nextDueDate)), style: const TextStyle(fontWeight: FontWeight.w600)),
            if (last.vendor != null) Text(last.vendor!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: Space.sm),
          Row(children: [
            TextButton(onPressed: () => context.push('/vehicles/$id/records/new?type=${t.name}'), child: Text(l.addRecord)),
            if (last?.nextDueDate != null)
              TextButton(
                onPressed: () => context.push(Uri(path: '/reminders/new', queryParameters: {
                  'link': id,
                  'linkType': 'vehicle',
                  'title': recordTypeLabel(context, t),
                  'due': last!.nextDueDate!.toIso8601String(),
                  'kind': t == VehicleRecordType.insurance ? 'insurance' : 'registration',
                }).toString()),
                child: Text(l.createReminder),
              ),
          ]),
        ]),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.registrationInsurance)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        block(VehicleRecordType.registration),
        const SizedBox(height: Space.md),
        block(VehicleRecordType.insurance),
        const SizedBox(height: Space.md),
        block(VehicleRecordType.inspection),
        const SizedBox(height: Space.md),
        Text(l.noInventedIntervals, style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}

class MileageHistoryScreen extends ConsumerWidget {
  const MileageHistoryScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final v = _vehicle(ref, id);
    final points = _records(ref, id).where((r) => r.mileage != null).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.mileageHistory)),
      body: points.isEmpty && v?.currentMileage == null
          ? EmptyState(icon: Icons.speed, title: l.noMileage)
          : ListView(padding: const EdgeInsets.all(Space.gutter), children: [
              if (v?.currentMileage != null) AppCard(child: Text('${l.currentMileage}: ${Fmt.number(context, v!.currentMileage)} km', style: Theme.of(context).textTheme.titleMedium)),
              for (var i = 0; i < points.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(recordTypeIcon(points[i].type)),
                  title: Text('${Fmt.number(context, points[i].mileage)} km'),
                  subtitle: Text('${Fmt.date(context, points[i].date)} · ${recordTypeLabel(context, points[i].type)}'),
                  trailing: i + 1 < points.length ? Text('+${Fmt.number(context, points[i].mileage! - points[i + 1].mileage!)} km') : null,
                ),
            ]),
    );
  }
}

class EditVehicleScreen extends ConsumerStatefulWidget {
  const EditVehicleScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends ConsumerState<EditVehicleScreen> {
  final _form = GlobalKey<FormState>();
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _plate = TextEditingController();
  final _vin = TextEditingController();
  final _mileage = TextEditingController();
  final _fuel = TextEditingController();
  final _price = TextEditingController();
  final _notes = TextEditingController();
  String? _currency;
  DateTime? _purchase;
  Privacy _privacy = Privacy.private;
  String? _photo;
  Uint8List? _newPhoto;
  bool _loaded = false;
  bool _busy = false;
  Vehicle? _existing;

  void _load() {
    _loaded = true;
    if (widget.id == null) return;
    final v = (ref.read(vehiclesProvider).value ?? const <Vehicle>[]).where((x) => x.id == widget.id).firstOrNull;
    if (v == null) return;
    _existing = v;
    _make.text = v.make;
    _model.text = v.model;
    _year.text = v.year?.toString() ?? '';
    _plate.text = v.registrationNumber ?? '';
    _vin.text = v.vin ?? '';
    _mileage.text = v.currentMileage?.toStringAsFixed(0) ?? '';
    _fuel.text = v.fuelType ?? '';
    _price.text = v.purchasePrice?.toString() ?? '';
    _notes.text = v.notes ?? '';
    _currency = v.currency;
    _purchase = v.purchaseDate;
    _privacy = v.privacy;
    _photo = v.photoStoragePath;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) _load();
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? l.addVehicle : l.editVehicle)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          InkWell(
            onTap: () async {
              final b = await pickPhotoSheet(context, ref);
              if (b != null) setState(() => _newPhoto = b);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.md),
              child: SizedBox(height: 170, child: _newPhoto != null ? Image.memory(_newPhoto!, fit: BoxFit.cover) : StorageImage(path: _photo, placeholderIcon: Icons.add_a_photo_outlined)),
            ),
          ),
          const SizedBox(height: Space.lg),
          AppTextField(label: l.make, controller: _make, maxLength: 60, validator: (v) => (v ?? '').trim().isEmpty ? l.required : null),
          fieldGap,
          AppTextField(label: l.model, controller: _model, maxLength: 60),
          fieldGap,
          AppTextField(
            label: l.year,
            controller: _year,
            keyboardType: TextInputType.number,
            validator: (v) {
              if ((v ?? '').isEmpty) return null;
              final y = int.tryParse(v!);
              return y == null || y < 1900 || y > DateTime.now().year + 1 ? l.invalidValue : null;
            },
          ),
          FormSection(title: l.optionalDetails, children: [
            AppTextField(label: l.registrationNumber, controller: _plate, maxLength: 20, textCapitalization: TextCapitalization.characters),
            AppTextField(label: 'VIN', controller: _vin, maxLength: 17, textCapitalization: TextCapitalization.characters, validator: (v) => (v ?? '').isEmpty || isValidVin(v!) ? null : l.invalidVin),
            AppTextField(label: l.currentMileageKm, controller: _mileage, keyboardType: TextInputType.number),
            AppTextField(label: l.fuelType, controller: _fuel, maxLength: 40),
            DateField(label: l.purchaseDate, value: _purchase, lastDate: DateTime.now(), onChanged: (v) => setState(() => _purchase = v)),
            MoneyField(label: l.price, amountController: _price, currency: _currency, onCurrency: (c) => setState(() => _currency = c)),
            AppTextField(label: l.notes, controller: _notes, maxLines: 3, maxLength: 4000),
          ]),
          PrivacySelector(value: _privacy, onChanged: (p) => setState(() => _privacy = p)),
          const SizedBox(height: Space.xl),
          PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final uid = ref.read(uidProvider)!;
    final repo = ref.read(vehicleRepoProvider);
    final id = widget.id ?? repo.newId();
    try {
      var photo = _photo;
      if (_newPhoto != null) photo = await ref.read(photoRepoProvider).upload(uid, id, 'photo', _newPhoto!);
      String? t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
      await repo.save(
        Vehicle(
          id: id,
          ownerUid: _existing?.ownerUid ?? uid,
          make: _make.text.trim(),
          model: _model.text.trim(),
          privacy: _privacy,
          year: int.tryParse(_year.text),
          registrationNumber: t(_plate)?.toUpperCase(),
          vin: t(_vin)?.toUpperCase(),
          purchaseDate: _purchase,
          purchasePrice: parseAmount(_price.text),
          currency: _currency,
          currentMileage: parseAmount(_mileage.text),
          fuelType: t(_fuel),
          photoStoragePath: photo,
          notes: t(_notes),
        ),
        isNew: widget.id == null,
      );
      if (!mounted) return;
      widget.id == null ? context.pushReplacement('/vehicles/$id') : context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Add / edit a vehicle record (service, registration, fuel…). A receipt can
/// be scanned and is linked to both the record and the vehicle.
class EditVehicleRecordScreen extends ConsumerStatefulWidget {
  const EditVehicleRecordScreen({super.key, this.vehicleId, this.recordId, this.initialType});
  final String? vehicleId;
  final String? recordId;
  final VehicleRecordType? initialType;
  @override
  ConsumerState<EditVehicleRecordScreen> createState() => _EditVehicleRecordScreenState();
}

class _EditVehicleRecordScreenState extends ConsumerState<EditVehicleRecordScreen> {
  final _form = GlobalKey<FormState>();
  late VehicleRecordType _type = widget.initialType ?? VehicleRecordType.service;
  DateTime _date = DateTime.now();
  DateTime? _nextDue;
  final _mileage = TextEditingController();
  final _amount = TextEditingController();
  final _vendor = TextEditingController();
  final _desc = TextEditingController();
  final _nextMileage = TextEditingController();
  String? _currency;
  List<String> _docIds = [];
  bool _loaded = false;
  bool _busy = false;
  VehicleRecord? _existing;
  late String? _vehicleId = widget.vehicleId;

  void _load() {
    _loaded = true;
    if (widget.recordId == null) return;
    final r = (ref.read(vehicleRecordsProvider).value ?? const <VehicleRecord>[]).where((x) => x.id == widget.recordId).firstOrNull;
    if (r == null) return;
    _existing = r;
    _vehicleId = r.vehicleId;
    _type = r.type;
    _date = r.date;
    _nextDue = r.nextDueDate;
    _mileage.text = r.mileage?.toStringAsFixed(0) ?? '';
    _amount.text = r.amount?.toString() ?? '';
    _vendor.text = r.vendor ?? '';
    _desc.text = r.description ?? '';
    _nextMileage.text = r.nextDueMileage?.toStringAsFixed(0) ?? '';
    _currency = r.currency;
    _docIds = r.documentIds;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) _load();
    final l = context.l10n;
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => _docIds.contains(d.id)).toList();
    final isOwner = _existing == null || _existing!.ownerUid == ref.watch(uidProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.recordId == null ? l.addRecord : l.editRecord)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          DropdownButtonFormField<VehicleRecordType>(
            initialValue: _type,
            decoration: InputDecoration(labelText: l.recordType),
            items: [for (final t in VehicleRecordType.values) DropdownMenuItem(value: t, child: Row(children: [Icon(recordTypeIcon(t), size: 18), const SizedBox(width: 8), Text(recordTypeLabel(context, t))]))],
            onChanged: isOwner ? (v) => setState(() => _type = v!) : null,
          ),
          fieldGap,
          DateField(label: l.date, value: _date, lastDate: DateTime.now().add(const Duration(days: 1)), onChanged: (v) => setState(() => _date = v ?? DateTime.now())),
          fieldGap,
          AppTextField(label: l.mileageKm, controller: _mileage, keyboardType: TextInputType.number),
          fieldGap,
          MoneyField(label: l.amount, amountController: _amount, currency: _currency, onCurrency: (c) => setState(() => _currency = c)),
          fieldGap,
          AppTextField(label: l.serviceOrVendor, controller: _vendor, maxLength: 120),
          fieldGap,
          AppTextField(label: l.description, controller: _desc, maxLines: 3, maxLength: 1000),
          FormSection(title: l.nextDueSection, children: [
            Text(l.nextDueHelp, style: Theme.of(context).textTheme.bodySmall),
            DateField(label: l.nextDueDate, value: _nextDue, onChanged: (v) => setState(() => _nextDue = v)),
            AppTextField(label: l.nextDueMileage, controller: _nextMileage, keyboardType: TextInputType.number),
          ]),
          SectionHeader(title: l.receipts),
          for (final d in docs) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.receipt_long_outlined), title: Text(d.title), onTap: () => context.push('/documents/${d.id}')),
          if (isOwner && _vehicleId != null)
            SecondaryButton(
              label: l.attachReceipt,
              icon: Icons.document_scanner_outlined,
              onPressed: () async {
                final before = (ref.read(documentsProvider).value ?? const <DocumentRecord>[]).map((d) => d.id).toSet();
                await context.push('/scan?mode=scan&area=car&link=$_vehicleId');
                final after = ref.read(documentsProvider).value ?? const <DocumentRecord>[];
                final added = after.where((d) => !before.contains(d.id)).map((d) => d.id);
                setState(() => _docIds = {..._docIds, ...added}.toList());
              },
            ),
          const SizedBox(height: Space.xl),
          if (isOwner) PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
          if (isOwner && _existing != null) ...[
            const SizedBox(height: Space.md),
            SecondaryButton(
              label: l.delete,
              destructive: true,
              onPressed: () async {
                if (!await confirmDialog(context, title: l.deleteRecord, message: l.deleteRecordBody, confirmLabel: l.delete, destructive: true)) return;
                await ref.read(vehicleRecordRepoProvider).delete(_existing!.id);
                if (context.mounted) context.pop();
              },
            ),
          ],
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _vehicleId == null) return;
    setState(() => _busy = true);
    final uid = ref.read(uidProvider)!;
    final repo = ref.read(vehicleRecordRepoProvider);
    final v = (ref.read(vehiclesProvider).value ?? const <Vehicle>[]).where((x) => x.id == _vehicleId).firstOrNull;
    final id = _existing?.id ?? repo.newId();
    final mileage = parseAmount(_mileage.text);
    try {
      await repo.save(
        VehicleRecord(
          id: id,
          vehicleId: _vehicleId!,
          ownerUid: uid,
          type: _type,
          date: _date,
          // Records follow the vehicle's privacy.
          privacy: v?.privacy ?? Privacy.private,
          mileage: mileage,
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          amount: parseAmount(_amount.text),
          currency: _currency,
          vendor: _vendor.text.trim().isEmpty ? null : _vendor.text.trim(),
          documentIds: _docIds,
          nextDueDate: _nextDue,
          nextDueMileage: parseAmount(_nextMileage.text),
        ),
        isNew: _existing == null,
      );
      if (v != null && mileage != null && (v.currentMileage == null || mileage > v.currentMileage!)) {
        await ref.read(vehicleRepoProvider).patch(v.id, {'currentMileage': mileage});
      }
      if (!mounted) return;
      if (_nextDue != null && _existing == null) {
        final go = await confirmDialog(context, title: context.l10n.createReminder, message: context.l10n.offerReminderBody(Fmt.date(context, _nextDue)), confirmLabel: context.l10n.createReminder);
        if (go && mounted) {
          context.pushReplacement(Uri(path: '/reminders/new', queryParameters: {
            'link': _vehicleId!,
            'linkType': 'vehicle',
            'title': '${recordTypeLabel(context, _type)} · ${v?.displayName ?? ''}',
            'due': _nextDue!.toIso8601String(),
            'kind': _type == VehicleRecordType.insurance ? 'insurance' : _type == VehicleRecordType.registration ? 'registration' : 'service',
          }).toString());
          return;
        }
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
