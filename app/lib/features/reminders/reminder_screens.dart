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
import '../../domain/logic/reminders.dart';
import '../../domain/models/common.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';

String kindLabel(BuildContext context, ReminderKind k) {
  final l = context.l10n;
  return switch (k) {
    ReminderKind.registration => l.kindRegistration,
    ReminderKind.insurance => l.kindInsurance,
    ReminderKind.service => l.kindService,
    ReminderKind.warranty => l.kindWarranty,
    ReminderKind.contract => l.kindContract,
    ReminderKind.document => l.kindDocument,
    ReminderKind.anniversary => l.kindAnniversary,
    ReminderKind.subscription => l.kindSubscription,
    ReminderKind.custom => l.kindCustom,
  };
}

IconData kindIcon(ReminderKind k) => switch (k) {
      ReminderKind.registration => Icons.assignment_outlined,
      ReminderKind.insurance => Icons.shield_outlined,
      ReminderKind.service => Icons.build_outlined,
      ReminderKind.warranty => Icons.verified_outlined,
      ReminderKind.contract => Icons.handshake_outlined,
      ReminderKind.document => Icons.description_outlined,
      ReminderKind.anniversary => Icons.cake_outlined,
      ReminderKind.subscription => Icons.autorenew,
      ReminderKind.custom => Icons.notifications_none,
    };

String repeatLabel(BuildContext context, RepeatRule r) {
  final l = context.l10n;
  return switch (r) {
    RepeatRule.none => l.repeatNone,
    RepeatRule.daily => l.repeatDaily,
    RepeatRule.weekly => l.repeatWeekly,
    RepeatRule.monthly => l.repeatMonthly,
    RepeatRule.yearly => l.repeatYearly,
  };
}

/// My Life + Reminders dashboard.
class RemindersDashboard extends ConsumerStatefulWidget {
  const RemindersDashboard({super.key, this.lifeMode = false});
  final bool lifeMode;
  @override
  ConsumerState<RemindersDashboard> createState() => _RemindersDashboardState();
}

class _RemindersDashboardState extends ConsumerState<RemindersDashboard> {
  ReminderKind? _kind;
  bool _showDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(const AddContext(area: 'life')));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(widget.lifeMode ? l.areaLife : l.reminders), actions: [
        IconButton(tooltip: l.upcomingDeadlines, onPressed: () => context.push('/reminders/upcoming'), icon: const Icon(Icons.event_note_outlined)),
        IconButton(tooltip: l.reminderSettings, onPressed: () => context.push('/settings/reminders'), icon: const Icon(Icons.tune)),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/reminders/new'), icon: const Icon(Icons.add), label: Text(l.addReminder)),
      body: asyncView<List<Reminder>>(ref.watch(remindersProvider), (all) {
        final list = all.where((r) => (_showDone || r.isActive) && (_kind == null || r.kind == _kind)).toList()..sort((a, b) => a.dueAt.compareTo(b.dueAt));
        final overdue = list.where((r) => r.isActive && dueState(r.dueAt) == DueState.overdue).toList();
        final soon = list.where((r) => r.isActive && {DueState.today, DueState.soon}.contains(dueState(r.dueAt))).toList();
        final later = list.where((r) => !overdue.contains(r) && !soon.contains(r)).toList();
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
          if (widget.lifeMode) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: Text(l.lifeIntro, style: Theme.of(context).textTheme.bodySmall)),
          FilterChips<ReminderKind>(options: ReminderKind.values, selected: {?_kind}, labelOf: (k) => kindLabel(context, k), onToggle: (k) => setState(() => _kind = _kind == k ? null : k)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.showCompleted), value: _showDone, onChanged: (v) => setState(() => _showDone = v)),
          if (list.isEmpty) EmptyState(icon: Icons.notifications_none, title: l.noReminders, message: l.noRemindersHint, actionLabel: l.addReminder, onAction: () => context.push('/reminders/new')),
          if (overdue.isNotEmpty) ...[SectionHeader(title: l.overdue), for (final r in overdue) _tile(r)],
          if (soon.isNotEmpty) ...[SectionHeader(title: l.soon), for (final r in soon) _tile(r)],
          if (later.isNotEmpty) ...[SectionHeader(title: l.later), for (final r in later) _tile(r)],
        ]);
      }),
    );
  }

  Widget _tile(Reminder r) => Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ReminderCard(reminder: r, linkedLabel: kindLabel(context, r.kind), onTap: () => context.push('/reminders/${r.id}')));
}

class ReminderDetailScreen extends ConsumerWidget {
  const ReminderDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final all = ref.watch(remindersProvider);
    final r = (all.value ?? const <Reminder>[]).where((x) => x.id == id).firstOrNull;
    if (r == null) return Scaffold(appBar: AppBar(), body: all.isLoading ? const LoadingState() : EmptyState(icon: Icons.lock_outline, title: l.notAvailable));
    final isOwner = r.ownerUid == ref.watch(uidProvider);
    final doc = r.linkedDocumentId == null ? null : ref.watch(documentByIdProvider(r.linkedDocumentId!));
    final repo = ref.read(reminderRepoProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.reminder), actions: [
        if (isOwner) IconButton(tooltip: l.edit, onPressed: () => context.push('/reminders/$id/edit'), icon: const Icon(Icons.edit_outlined)),
      ]),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Row(children: [
          Icon(kindIcon(r.kind), color: AppColors.secondary, size: 32),
          const SizedBox(width: Space.md),
          Expanded(child: Text(r.title, style: Theme.of(context).textTheme.headlineSmall)),
        ]),
        const SizedBox(height: Space.lg),
        InfoRow(label: l.dueDate, value: '${Fmt.dateTime(context, r.dueAt)} (${Fmt.relativeDays(context, r.dueAt)})', icon: Icons.event),
        InfoRow(label: l.repeat, value: repeatLabel(context, r.repeatRule), icon: Icons.repeat),
        InfoRow(label: l.timezone, value: r.timezone, icon: Icons.public),
        InfoRow(label: l.notifyBefore, value: r.leadTimeMinutes == 0 ? l.atTime : l.minutesBefore(r.leadTimeMinutes), icon: Icons.alarm),
        InfoRow(label: l.description, value: r.description, icon: Icons.notes),
        InfoRow(label: l.status, value: switch (r.status) { ReminderStatus.active => l.statusActive, ReminderStatus.done => l.statusDone, ReminderStatus.snoozed => l.statusSnoozed, ReminderStatus.cancelled => l.statusCancelled }, icon: Icons.info_outline),
        if (doc != null) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.description_outlined), title: Text(doc.title), subtitle: Text(l.linkedDocument), onTap: () => context.push('/documents/${doc.id}')),
        if (r.linkedEntityId != null && r.linkedEntityType != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.link),
            title: Text(l.linkedItem),
            onTap: () => context.push(switch (r.linkedEntityType) { 'vehicle' => '/vehicles/${r.linkedEntityId}', 'profile' => '/family/profile/${r.linkedEntityId}', _ => '/assets/${r.linkedEntityId}' }),
          ),
        const SizedBox(height: Space.xl),
        if (isOwner && r.isActive) ...[
          PrimaryButton(
            label: r.repeatRule == RepeatRule.none ? l.markDone : l.markDoneNext,
            icon: Icons.check,
            onPressed: () async {
              final next = r.repeatRule == RepeatRule.none ? null : nextLocalOccurrence(r.dueAt, r.repeatRule, DateTime.now().isAfter(r.dueAt) ? DateTime.now() : r.dueAt);
              await repo.save(next == null ? r.copyWith(status: ReminderStatus.done) : r.copyWith(dueAt: next));
              if (context.mounted) showSuccess(context, l.saved);
            },
          ),
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.snoozeWeek,
            icon: Icons.snooze,
            onPressed: () => repo.save(r.copyWith(dueAt: DateTime.now().add(const Duration(days: 7)))),
          ),
        ],
        if (isOwner && !r.isActive)
          SecondaryButton(label: l.reactivate, onPressed: () => repo.save(r.copyWith(status: ReminderStatus.active))),
        if (isOwner) ...[
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.delete,
            destructive: true,
            onPressed: () async {
              if (!await confirmDialog(context, title: l.deleteReminder, message: l.deleteReminderBody, confirmLabel: l.delete, destructive: true)) return;
              await repo.delete(r.id);
              if (context.mounted) context.pop();
            },
          ),
        ],
      ]),
    );
  }
}

class EditReminderScreen extends ConsumerStatefulWidget {
  const EditReminderScreen({super.key, this.id, this.prefill = const {}});
  final String? id;
  final Map<String, String> prefill;
  @override
  ConsumerState<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends ConsumerState<EditReminderScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime _due = DateTime.now().add(const Duration(days: 1)).copyWith(hour: 9, minute: 0);
  RepeatRule _repeat = RepeatRule.none;
  ReminderKind _kind = ReminderKind.custom;
  int _lead = 0;
  bool _push = true;
  bool _local = true;
  Privacy _privacy = Privacy.private;
  String? _linkedDoc;
  String? _linkedEntity;
  String? _linkedType;
  Reminder? _existing;
  bool _loaded = false;
  bool _busy = false;

  void _load() {
    _loaded = true;
    final p = widget.prefill;
    if (widget.id != null) {
      final r = (ref.read(remindersProvider).value ?? const <Reminder>[]).where((x) => x.id == widget.id).firstOrNull;
      if (r != null) {
        _existing = r;
        _title.text = r.title;
        _desc.text = r.description ?? '';
        _due = r.dueAt;
        _repeat = r.repeatRule;
        _kind = r.kind;
        _lead = r.leadTimeMinutes;
        _push = r.notificationChannels.contains('push');
        _local = r.notificationChannels.contains('local');
        _privacy = r.privacy;
        _linkedDoc = r.linkedDocumentId;
        _linkedEntity = r.linkedEntityId;
        _linkedType = r.linkedEntityType;
      }
      return;
    }
    _title.text = p['title'] ?? '';
    final due = DateTime.tryParse(p['due'] ?? '');
    if (due != null) _due = due.copyWith(hour: 9, minute: 0);
    _kind = ReminderKind.values.firstWhere((k) => k.name == p['kind'], orElse: () => ReminderKind.custom);
    if (_kind == ReminderKind.registration || _kind == ReminderKind.insurance) _repeat = RepeatRule.yearly;
    _linkedDoc = p['doc'];
    _linkedEntity = p['link'];
    _linkedType = p['linkType'];
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) _load();
    final l = context.l10n;
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => !d.inTrash).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? l.addReminder : l.editReminder)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          AppTextField(label: l.title, controller: _title, maxLength: 120, validator: (v) => (v ?? '').trim().isEmpty ? l.required : null),
          fieldGap,
          DropdownButtonFormField<ReminderKind>(
            initialValue: _kind,
            decoration: InputDecoration(labelText: l.reminderType),
            items: [for (final k in ReminderKind.values) DropdownMenuItem(value: k, child: Text(kindLabel(context, k)))],
            onChanged: (v) => setState(() => _kind = v!),
          ),
          fieldGap,
          DateField(label: l.dueDate, value: _due, withTime: true, firstDate: DateTime(2000), onChanged: (v) => setState(() => _due = v ?? _due)),
          if (widget.prefill['due'] != null) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(l.confirmDateHint, style: Theme.of(context).textTheme.bodySmall)),
          fieldGap,
          DropdownButtonFormField<RepeatRule>(
            initialValue: _repeat,
            decoration: InputDecoration(labelText: l.repeat),
            items: [for (final r in RepeatRule.values) DropdownMenuItem(value: r, child: Text(repeatLabel(context, r)))],
            onChanged: (v) => setState(() => _repeat = v!),
          ),
          fieldGap,
          DropdownButtonFormField<int>(
            initialValue: _lead,
            decoration: InputDecoration(labelText: l.notifyBefore),
            items: [
              DropdownMenuItem(value: 0, child: Text(l.atTime)),
              DropdownMenuItem(value: 60, child: Text(l.hoursBefore(1))),
              DropdownMenuItem(value: 1440, child: Text(l.daysBefore(1))),
              DropdownMenuItem(value: 10080, child: Text(l.daysBefore(7))),
              DropdownMenuItem(value: 43200, child: Text(l.daysBefore(30))),
            ],
            onChanged: (v) => setState(() => _lead = v ?? 0),
          ),
          fieldGap,
          AppTextField(label: l.description, controller: _desc, maxLines: 3, maxLength: 1000),
          fieldGap,
          DropdownButtonFormField<String?>(
            initialValue: docs.any((d) => d.id == _linkedDoc) ? _linkedDoc : null,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.linkedDocumentOptional),
            items: [DropdownMenuItem<String?>(value: null, child: Text(l.none)), for (final d in docs) DropdownMenuItem(value: d.id, child: Text(d.title, overflow: TextOverflow.ellipsis))],
            onChanged: (v) => setState(() => _linkedDoc = v),
          ),
          FormSection(title: l.notificationChannels, children: [
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.channelPush), subtitle: Text(l.channelPushHelp), value: _push, onChanged: (v) => setState(() => _push = v)),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.channelLocal), subtitle: Text(l.channelLocalHelp), value: _local, onChanged: (v) => setState(() => _local = v)),
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
    if (_privacy.validate() != null) return showError(context, Exception());
    setState(() => _busy = true);
    final uid = ref.read(uidProvider)!;
    final repo = ref.read(reminderRepoProvider);
    final notifications = ref.read(notificationServiceProvider);
    if (_push || _local) await notifications.requestPermission();
    try {
      await repo.save(
        Reminder(
          id: _existing?.id ?? repo.newId(),
          ownerUid: uid,
          title: _title.text.trim(),
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          dueAt: _due,
          timezone: notifications.deviceTimezone,
          privacy: _privacy,
          repeatRule: _repeat,
          notificationChannels: [if (_push) 'push', if (_local) 'local'],
          linkedDocumentId: _linkedDoc,
          linkedEntityId: _linkedEntity,
          linkedEntityType: _linkedType,
          status: _existing?.status ?? ReminderStatus.active,
          kind: _kind,
          leadTimeMinutes: _lead,
        ),
        isNew: _existing == null,
      );
      if (!mounted) return;
      showSuccess(context, context.l10n.reminderSaved);
      if (_existing == null) showInterstitialAtBreak(ref);
      context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Aggregated deadlines: reminders + vehicle due dates + document/warranty
/// expiry + card expiry. Only dates the user entered or confirmed.
class UpcomingDeadlinesScreen extends ConsumerWidget {
  const UpcomingDeadlinesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final now = DateTime.now();
    final horizon = now.add(const Duration(days: 180));
    bool inRange(DateTime? d) => d != null && d.isAfter(now.subtract(const Duration(days: 1))) && d.isBefore(horizon);
    final items = <({DateTime date, String title, String sub, String route, IconData icon})>[
      for (final r in ref.watch(remindersProvider).value ?? const <Reminder>[])
        if (r.isActive && inRange(r.dueAt)) (date: r.dueAt, title: r.title, sub: kindLabel(context, r.kind), route: '/reminders/${r.id}', icon: kindIcon(r.kind)),
      for (final d in ref.watch(documentsProvider).value ?? const <DocumentRecord>[])
        if (!d.inTrash && inRange(d.warrantyExpiryDate)) (date: d.warrantyExpiryDate!, title: d.title, sub: l.warranty, route: '/documents/${d.id}', icon: Icons.verified_outlined)
        else if (!d.inTrash && inRange(d.expiryDate)) (date: d.expiryDate!, title: d.title, sub: l.expiryDate, route: '/documents/${d.id}', icon: Icons.hourglass_bottom),
      for (final a in ref.watch(assetsProvider).value ?? const <Asset>[])
        if (inRange(a.warrantyExpiryDate)) (date: a.warrantyExpiryDate!, title: a.name, sub: l.warranty, route: '/assets/${a.id}', icon: Icons.verified_outlined),
      for (final r in ref.watch(vehicleRecordsProvider).value ?? const <VehicleRecord>[])
        if (inRange(r.nextDueDate)) (date: r.nextDueDate!, title: r.description ?? r.type.name, sub: l.areaCar, route: '/vehicles/${r.vehicleId}', icon: Icons.directions_car_outlined),
      for (final c in ref.watch(walletCardsProvider).value ?? const <WalletCard>[])
        if (inRange(c.expiryDate)) (date: c.expiryDate!, title: c.name, sub: l.areaCards, route: '/cards/${c.id}', icon: Icons.loyalty_outlined),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return Scaffold(
      appBar: AppBar(title: Text(l.upcomingDeadlines)),
      body: items.isEmpty
          ? EmptyState(icon: Icons.event_available, title: l.noDeadlines)
          : ListView(padding: const EdgeInsets.all(Space.gutter), children: [
              Text(l.next6Months, style: Theme.of(context).textTheme.bodySmall),
              for (final i in items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(i.icon, color: AppColors.secondary)),
                  title: Text(i.title),
                  subtitle: Text('${i.sub} · ${Fmt.date(context, i.date)}'),
                  trailing: Text(Fmt.relativeDays(context, i.date), style: Theme.of(context).textTheme.labelMedium),
                  onTap: () => context.push(i.route),
                ),
            ]),
    );
  }
}

class ReminderSettingsScreen extends ConsumerStatefulWidget {
  const ReminderSettingsScreen({super.key});
  @override
  ConsumerState<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends ConsumerState<ReminderSettingsScreen> {
  bool? _granted;

  @override
  void initState() {
    super.initState();
    ref.read(notificationServiceProvider).permissionGranted().then((g) => mounted ? setState(() => _granted = g) : null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = ref.watch(userProfileProvider).value;
    final detailed = profile?.notificationPreview == 'detailed';
    return Scaffold(
      appBar: AppBar(title: Text(l.reminderSettings)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(_granted == true ? Icons.notifications_active : Icons.notifications_off_outlined),
          title: Text(_granted == true ? l.notificationsAllowed : l.notificationsBlocked),
          trailing: _granted == true
              ? null
              : TextButton(
                  onPressed: () async {
                    final g = await ref.read(notificationServiceProvider).requestPermission();
                    setState(() => _granted = g);
                  },
                  child: Text(l.allow),
                ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.showDetailsInNotifications),
          subtitle: Text(l.showDetailsHelp),
          value: detailed,
          onChanged: (v) => ref.read(userRepoProvider).updateProfile(ref.read(uidProvider)!, notificationPreview: v ? 'detailed' : 'generic'),
        ),
        const SizedBox(height: Space.md),
        Text(l.emailChannelNote, style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}
