import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/search.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';
import '../scanner/scan_screens.dart';

class BusinessCardsScreen extends ConsumerStatefulWidget {
  const BusinessCardsScreen({super.key});
  @override
  ConsumerState<BusinessCardsScreen> createState() => _BusinessCardsScreenState();
}

class _BusinessCardsScreenState extends ConsumerState<BusinessCardsScreen> {
  String _q = '';
  String? _tag;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(const AddContext(area: 'business')));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.areaBusinessCards)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/business-cards/new'), icon: const Icon(Icons.add), label: Text(l.addBusinessCard)),
      body: asyncView<List<BusinessCard>>(ref.watch(businessCardsProvider), (all) {
        final tags = {for (final c in all) ...c.tags}.toList()..sort();
        final list = all
            .where((c) => _tag == null || c.tags.contains(_tag))
            .where((c) => matchesQuery(_q, [c.fullName, c.company, c.jobTitle, c.metWhere, c.notes, ...c.tags, ...c.emails, ...c.phones]))
            .toList()
          ..sort((a, b) => normalizeText(a.displayName).compareTo(normalizeText(b.displayName)));
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
          AppSearchBar(hint: l.searchContacts, onChanged: (v) => setState(() => _q = v)),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: Space.md),
            FilterChips<String>(options: tags, selected: {?_tag}, labelOf: (t) => '#$t', onToggle: (t) => setState(() => _tag = _tag == t ? null : t)),
          ],
          const SizedBox(height: Space.md),
          if (list.isEmpty)
            EmptyState(icon: Icons.contact_mail_outlined, title: _q.isEmpty ? l.noContacts : l.noResults, message: l.noContactsHint, actionLabel: l.addBusinessCard, onAction: () => context.push('/business-cards/new'))
          else
            for (final c in list)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: AssetCard(
                  title: c.displayName,
                  subtitle: [c.jobTitle, if (c.fullName != null) c.company].whereType<String>().join(' · '),
                  icon: Icons.badge_outlined,
                  photoPath: c.frontPhotoPath,
                  badge: c.isFavorite ? const Icon(Icons.star_rounded, color: AppColors.warning) : null,
                  onTap: () => context.push('/business-cards/${c.id}'),
                ),
              ),
        ]);
      }),
    );
  }
}

class BusinessCardDetailScreen extends ConsumerWidget {
  const BusinessCardDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final all = ref.watch(businessCardsProvider);
    final c = (all.value ?? const <BusinessCard>[]).where((x) => x.id == id).firstOrNull;
    if (c == null) return Scaffold(appBar: AppBar(), body: all.isLoading ? const LoadingState() : EmptyState(icon: Icons.lock_outline, title: l.notAvailable));
    final isOwner = c.ownerUid == ref.watch(uidProvider);
    Future<void> open(Uri u) async {
      if (!await launchUrl(u, mode: LaunchMode.externalApplication) && context.mounted) showError(context, Exception());
    }

    return Scaffold(
      appBar: AppBar(title: Text(c.displayName), actions: [
        if (isOwner) IconButton(tooltip: c.isFavorite ? l.removeFavorite : l.addFavorite, onPressed: () => ref.read(businessCardRepoProvider).patch(c.id, {'isFavorite': !c.isFavorite}), icon: Icon(c.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded)),
        if (isOwner) IconButton(tooltip: l.edit, onPressed: () => context.push('/business-cards/${c.id}/edit'), icon: const Icon(Icons.edit_outlined)),
      ]),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        if (c.frontPhotoPath != null)
          ClipRRect(borderRadius: BorderRadius.circular(Radii.md), child: AspectRatio(aspectRatio: 1.7, child: StorageImage(path: c.frontPhotoPath, placeholderIcon: Icons.badge_outlined, fit: BoxFit.contain))),
        const SizedBox(height: Space.lg),
        Text(c.displayName, style: Theme.of(context).textTheme.headlineSmall),
        if (c.jobTitle != null || (c.fullName != null && c.company != null))
          Text([c.jobTitle, if (c.fullName != null) c.company].whereType<String>().join(' · '), style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Space.lg),
        for (final p in c.phones) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.phone_outlined), title: Text(p), onTap: () => open(Uri(scheme: 'tel', path: p.replaceAll(' ', '')))),
        for (final e in c.emails) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.email_outlined), title: Text(e), onTap: () => open(Uri(scheme: 'mailto', path: e))),
        if (c.website != null)
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.language), title: Text(c.website!), onTap: () => open(Uri.parse(c.website!.startsWith('http') ? c.website! : 'https://${c.website}'))),
        if (c.address != null) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.place_outlined), title: Text(c.address!)),
        InfoRow(label: l.metWhere, value: [c.metWhere, if (c.metAt != null) Fmt.date(context, c.metAt)].whereType<String>().join(' · '), icon: Icons.handshake_outlined),
        InfoRow(label: l.notes, value: c.notes, icon: Icons.notes),
        if (c.tags.isNotEmpty) Wrap(spacing: Space.sm, children: [for (final t in c.tags) Chip(label: Text('#$t'))]),
        if (c.backPhotoPath != null) ...[
          SectionHeader(title: l.back),
          ClipRRect(borderRadius: BorderRadius.circular(Radii.md), child: AspectRatio(aspectRatio: 1.7, child: StorageImage(path: c.backPhotoPath, placeholderIcon: Icons.badge_outlined, fit: BoxFit.contain))),
        ],
        if (isOwner) ...[
          const SizedBox(height: Space.xl),
          SecondaryButton(
            label: l.delete,
            destructive: true,
            onPressed: () async {
              if (!await confirmDialog(context, title: l.deleteContact, message: l.deleteContactBody, confirmLabel: l.delete, destructive: true)) return;
              await ref.read(businessCardRepoProvider).delete(c.id);
              for (final p in [c.frontPhotoPath, c.backPhotoPath].whereType<String>()) {
                await ref.read(storageServiceProvider).deletePhoto(p);
              }
              if (context.mounted) context.pop();
            },
          ),
        ],
      ]),
    );
  }
}

class EditBusinessCardScreen extends ConsumerStatefulWidget {
  const EditBusinessCardScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<EditBusinessCardScreen> createState() => _EditBusinessCardScreenState();
}

class _EditBusinessCardScreenState extends ConsumerState<EditBusinessCardScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _company = TextEditingController();
  final _title = TextEditingController();
  final _phones = TextEditingController();
  final _emails = TextEditingController();
  final _web = TextEditingController();
  final _address = TextEditingController();
  final _metWhere = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _metAt;
  List<String> _tags = [];
  Privacy _privacy = Privacy.private;
  String? _front;
  String? _back;
  Uint8List? _newFront;
  Uint8List? _newBack;
  bool _loaded = false;
  bool _busy = false;
  bool _aiBusy = false;
  BusinessCard? _existing;
  late final String _id = widget.id ?? ref.read(businessCardRepoProvider).newId();

  void _load() {
    _loaded = true;
    if (widget.id == null) return;
    final c = (ref.read(businessCardsProvider).value ?? const <BusinessCard>[]).where((x) => x.id == widget.id).firstOrNull;
    if (c == null) return;
    _existing = c;
    _name.text = c.fullName ?? '';
    _company.text = c.company ?? '';
    _title.text = c.jobTitle ?? '';
    _phones.text = c.phones.join('\n');
    _emails.text = c.emails.join('\n');
    _web.text = c.website ?? '';
    _address.text = c.address ?? '';
    _metWhere.text = c.metWhere ?? '';
    _notes.text = c.notes ?? '';
    _metAt = c.metAt;
    _tags = c.tags;
    _privacy = c.privacy;
    _front = c.frontPhotoPath;
    _back = c.backPhotoPath;
  }

  /// AI reads the card (Pro plans). Photos are uploaded first to the user's
  /// private folder; the result only pre-fills the form for confirmation.
  Future<void> _readWithAi() async {
    if (_newFront == null && _front == null) return;
    setState(() => _aiBusy = true);
    try {
      final uid = ref.read(uidProvider)!;
      final photos = ref.read(photoRepoProvider);
      if (_newFront != null) {
        _front = await photos.upload(uid, _id, 'front', _newFront!);
        _newFront = null;
      }
      if (_newBack != null) {
        _back = await photos.upload(uid, _id, 'back', _newBack!);
        _newBack = null;
      }
      final r = await ref.read(aiRepoProvider).extractBusinessCard([?_front, ?_back]);
      void fill(TextEditingController c, Object? v) {
        if (v is String && v.isNotEmpty && c.text.isEmpty) c.text = v;
      }

      setState(() {
        fill(_name, r['fullName']);
        fill(_company, r['company']);
        fill(_title, r['jobTitle']);
        fill(_web, r['website']);
        fill(_address, r['address']);
        if (_phones.text.isEmpty) _phones.text = ((r['phones'] as List?) ?? const []).join('\n');
        if (_emails.text.isEmpty) _emails.text = ((r['emails'] as List?) ?? const []).join('\n');
      });
      if (mounted) showSuccess(context, context.l10n.aiFilledCheck);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _aiBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) _load();
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    Widget photo(String label, String? path, Uint8List? fresh, void Function(Uint8List) set) => Expanded(
          child: InkWell(
            onTap: () async {
              final b = await pickPhotoSheet(context, ref);
              if (b != null) setState(() => set(b));
            },
            child: Column(children: [
              ClipRRect(borderRadius: BorderRadius.circular(Radii.sm), child: AspectRatio(aspectRatio: 1.7, child: fresh != null ? Image.memory(fresh, fit: BoxFit.cover) : StorageImage(path: path, placeholderIcon: Icons.add_a_photo_outlined))),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ]),
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? l.addBusinessCard : l.editContact)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          Row(children: [
            photo(l.front, _front, _newFront, (b) => _newFront = b),
            const SizedBox(width: Space.md),
            photo(l.back, _back, _newBack, (b) => _newBack = b),
          ]),
          const SizedBox(height: Space.md),
          if (ent.aiEnabled)
            SecondaryButton(label: l.readCardWithAi, icon: Icons.auto_awesome, onPressed: _aiBusy || (_newFront == null && _front == null) ? null : _readWithAi)
          else
            const UpgradePrompt(reason: UpgradeReason.ai, compact: true),
          if (_aiBusy) const Padding(padding: EdgeInsets.only(top: Space.sm), child: LinearProgressIndicator()),
          const SizedBox(height: Space.lg),
          AppTextField(label: l.fullName, controller: _name, maxLength: 120, textCapitalization: TextCapitalization.words),
          fieldGap,
          AppTextField(
            label: l.company,
            controller: _company,
            maxLength: 120,
            validator: (_) => _name.text.trim().isEmpty && _company.text.trim().isEmpty ? l.nameOrCompanyRequired : null,
          ),
          fieldGap,
          AppTextField(label: l.jobTitle, controller: _title, maxLength: 120),
          fieldGap,
          AppTextField(label: l.phonesOnePerLine, controller: _phones, maxLines: 3, keyboardType: TextInputType.multiline),
          fieldGap,
          AppTextField(
            label: l.emailsOnePerLine,
            controller: _emails,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.none,
            validator: (v) => _lines(v ?? '').every(isValidEmail) ? null : l.errInvalidEmail,
          ),
          fieldGap,
          AppTextField(label: l.website, controller: _web, maxLength: 300, keyboardType: TextInputType.url, textCapitalization: TextCapitalization.none),
          fieldGap,
          AppTextField(label: l.address, controller: _address, maxLines: 2, maxLength: 400),
          FormSection(title: l.contextSection, children: [
            AppTextField(label: l.metWhere, controller: _metWhere, maxLength: 200),
            DateField(label: l.metAt, value: _metAt, lastDate: DateTime.now(), onChanged: (v) => setState(() => _metAt = v)),
            TagsField(tags: _tags, onChanged: (t) => setState(() => _tags = t)),
            AppTextField(label: l.notes, controller: _notes, maxLines: 4, maxLength: 4000),
          ]),
          PrivacySelector(value: _privacy, onChanged: (p) => setState(() => _privacy = p)),
          const SizedBox(height: Space.xl),
          PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
        ]),
      ),
    );
  }

  List<String> _lines(String s) => s.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final uid = ref.read(uidProvider)!;
    String? t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    try {
      final photos = ref.read(photoRepoProvider);
      if (_newFront != null) _front = await photos.upload(uid, _id, 'front', _newFront!);
      if (_newBack != null) _back = await photos.upload(uid, _id, 'back', _newBack!);
      await ref.read(businessCardRepoProvider).save(
            BusinessCard(
              id: _id,
              ownerUid: uid,
              privacy: _privacy,
              fullName: t(_name),
              company: t(_company),
              jobTitle: t(_title),
              phones: _lines(_phones.text).take(10).toList(),
              emails: _lines(_emails.text).map((e) => e.toLowerCase()).take(10).toList(),
              website: t(_web),
              address: t(_address),
              frontPhotoPath: _front,
              backPhotoPath: _back,
              notes: t(_notes),
              tags: _tags,
              metAt: _metAt,
              metWhere: t(_metWhere),
              isFavorite: _existing?.isFavorite ?? false,
            ),
            isNew: _existing == null,
          );
      if (!mounted) return;
      if (_existing == null) showInterstitialAtBreak(ref);
      _existing == null ? context.pushReplacement('/business-cards/$_id') : context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
