import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/account.dart';
import '../../domain/models/common.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';
import '../documents/document_screens.dart';
import '../scanner/scan_screens.dart';

String roleLabel(BuildContext context, FamilyRole r) => switch (r) {
      FamilyRole.owner => context.l10n.roleOwner,
      FamilyRole.admin => context.l10n.roleAdmin,
      FamilyRole.member => context.l10n.roleMember,
    };

class FamilyDashboard extends ConsumerStatefulWidget {
  const FamilyDashboard({super.key});
  @override
  ConsumerState<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends ConsumerState<FamilyDashboard> {
  final _name = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(const AddContext(area: 'family')));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final fid = ref.watch(familyIdProvider);
    final family = ref.watch(familyProvider).value;

    if (fid == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.areaFamily)),
        body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          Text(l.familyIntro, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Space.xl),
          if (ent.canCreateFamily) ...[
            Text(l.createFamily, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: Space.md),
            AppTextField(label: l.familyName, controller: _name, maxLength: 60, textCapitalization: TextCapitalization.words),
            const SizedBox(height: Space.lg),
            PrimaryButton(
              label: l.createFamily,
              loading: _busy,
              onPressed: () async {
                if (_name.text.trim().isEmpty) return;
                setState(() => _busy = true);
                try {
                  await ref.read(familyRepoProvider).createFamily(_name.text.trim());
                } catch (e) {
                  if (context.mounted) showError(context, e);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
            ),
          ] else
            const UpgradePrompt(reason: UpgradeReason.family),
          const SizedBox(height: Space.xl),
          AppCard(
            child: Row(children: [
              const Icon(Icons.mail_outline, color: AppColors.secondary),
              const SizedBox(width: Space.md),
              Expanded(child: Text(l.haveInvitationHint)),
            ]),
          ),
        ]),
      );
    }

    final members = ref.watch(familyMembersProvider).value ?? const <FamilyMember>[];
    final profiles = ref.watch(familyProfilesProvider).value ?? const <FamilyProfile>[];
    final me = ref.watch(myMembershipProvider);
    final uid = ref.watch(uidProvider);
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.privacy.familyId == fid && r.privacy.level != PrivacyLevel.private && r.isActive).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final shared = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.privacy.familyId == fid && d.privacy.level != PrivacyLevel.private && !d.inTrash).toList();

    return Scaffold(
      appBar: AppBar(title: Text(family?.name ?? l.areaFamily), actions: [
        IconButton(tooltip: l.familySettings, onPressed: () => context.push('/family/settings'), icon: const Icon(Icons.settings_outlined)),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.xxl), children: [
        if (!ent.isFamilyPlan)
          Padding(padding: const EdgeInsets.only(bottom: Space.md), child: AppCard(child: Text(l.familyPlanLapsed, style: const TextStyle(color: AppColors.warning)))),
        SectionHeader(title: l.members, actionLabel: me?.canManage == true ? l.invite : null, onAction: () => context.push('/family/invite')),
        for (final m in members)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: FamilyMemberCard(
              name: m.uid == uid ? '${m.displayName ?? ''} (${l.you})' : (m.displayName ?? l.member),
              subtitle: l.joinedOn(Fmt.date(context, m.joinedAt)),
              role: roleLabel(context, m.role),
              onTap: () => context.push('/family/member/${m.uid}'),
            ),
          ),
        SectionHeader(title: l.familyProfiles, actionLabel: me?.canManage == true ? l.add : null, onAction: () => context.push('/family/profile/new')),
        Text(l.familyProfilesHelp, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.sm),
        for (final p in profiles)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: FamilyMemberCard(name: p.name, subtitle: [p.relationship, if (p.isMinor) l.minor].whereType<String>().join(' · '), photoPath: p.photoStoragePath, onTap: () => context.push('/family/profile/${p.id}')),
          ),
        SectionHeader(title: l.familyDeadlines),
        if (reminders.isEmpty) Text(l.noFamilyDeadlines, style: Theme.of(context).textTheme.bodySmall),
        for (final r in reminders.take(5)) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ReminderCard(reminder: r, onTap: () => context.push('/reminders/${r.id}'))),
        SectionHeader(title: l.sharedDocuments, actionLabel: l.seeAll, onAction: () => context.push('/family/shared')),
        if (shared.isEmpty) Text(l.noSharedDocs, style: Theme.of(context).textTheme.bodySmall),
        for (final d in shared.take(5)) DocumentListItem(document: d, categoryLabel: categoryName(context, ref, d.categoryId), onTap: () => context.push('/documents/${d.id}')),
        if (me?.canManage == true) ...[
          const SizedBox(height: Space.lg),
          SecondaryButton(label: l.familyPermissions, icon: Icons.admin_panel_settings_outlined, onPressed: () => context.push('/family/permissions')),
        ],
      ]),
    );
  }
}

class FamilyMembersScreen extends ConsumerWidget {
  const FamilyMembersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final members = ref.watch(familyMembersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.members)),
      body: asyncView<List<FamilyMember>>(members, (list) => ListView(padding: const EdgeInsets.all(Space.gutter), children: [
            for (final m in list)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: FamilyMemberCard(name: m.displayName ?? l.member, subtitle: roleLabel(context, m.role), onTap: () => context.push('/family/member/${m.uid}')),
              ),
          ])),
    );
  }
}

/// Profile of a member with an account: what *I* may see of theirs.
class MemberProfileScreen extends ConsumerWidget {
  const MemberProfileScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = (ref.watch(familyMembersProvider).value ?? const <FamilyMember>[]).where((x) => x.uid == uid).firstOrNull;
    if (m == null) return Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.person_off_outlined, title: l.notAvailable));
    final me = ref.watch(myMembershipProvider);
    final isMe = uid == ref.watch(uidProvider);
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.ownerUid == uid && !d.inTrash).toList();
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.ownerUid == uid).toList();
    final assets = (ref.watch(assetsProvider).value ?? const <Asset>[]).where((a) => a.ownerUid == uid).toList();
    return Scaffold(
      appBar: AppBar(title: Text(m.displayName ?? l.member)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Center(child: CircleAvatar(radius: 40, child: Text((m.displayName ?? '?').characters.first, style: Theme.of(context).textTheme.headlineSmall))),
        const SizedBox(height: Space.md),
        Center(child: Chip(label: Text(roleLabel(context, m.role)))),
        if (!isMe) Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.memberVisibleNote, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)),
        SectionHeader(title: l.documentsCount(docs.length)),
        for (final d in docs) DocumentListItem(document: d, onTap: () => context.push('/documents/${d.id}')),
        SectionHeader(title: l.remindersCount(reminders.length)),
        for (final r in reminders) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ReminderCard(reminder: r, onTap: () => context.push('/reminders/${r.id}'))),
        SectionHeader(title: l.itemsCount(assets.length)),
        for (final a in assets) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.chair_outlined), title: Text(a.name), onTap: () => context.push('/assets/${a.id}')),
        if (!isMe && me?.canManage == true && m.role != FamilyRole.owner) ...[
          const SizedBox(height: Space.xl),
          SecondaryButton(label: l.removeMember, destructive: true, onPressed: () => context.push('/family/remove/${m.uid}')),
        ],
      ]),
    );
  }
}

/// Family profile (person without own account, e.g. a child).
class FamilyProfileScreen extends ConsumerStatefulWidget {
  const FamilyProfileScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<FamilyProfileScreen> createState() => _FamilyProfileScreenState();
}

class _FamilyProfileScreenState extends ConsumerState<FamilyProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(AddContext(area: 'family', profileId: widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = (ref.watch(familyProfilesProvider).value ?? const <FamilyProfile>[]).where((x) => x.id == widget.id).firstOrNull;
    if (p == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    final canManage = ref.watch(myMembershipProvider)?.canManage == true;
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.linkedEntityIds.contains(p.id) && !d.inTrash).toList();
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.linkedEntityId == p.id).toList();
    final assets = (ref.watch(assetsProvider).value ?? const <Asset>[]).where((a) => a.assignedProfileIds.contains(p.id)).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scan?mode=scan&area=family&profile=${p.id}'),
        icon: const Icon(Icons.add),
        label: Text(l.addDocumentFor(p.name)),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          actions: [if (canManage) IconButton(tooltip: l.edit, onPressed: () => context.push('/family/profile/${p.id}/edit'), icon: const Icon(Icons.edit_outlined))],
          flexibleSpace: FlexibleSpaceBar(title: Text(p.name), background: StorageImage(path: p.photoStoragePath, placeholderIcon: Icons.person_outline)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 96),
          sliver: SliverList.list(children: [
            if (p.relationship != null || p.isMinor) Text([p.relationship, if (p.isMinor) l.minor].whereType<String>().join(' · ')),
            SectionHeader(title: l.documents),
            if (docs.isEmpty) Text(l.noLinkedDocs, style: Theme.of(context).textTheme.bodySmall),
            for (final d in docs) DocumentListItem(document: d, categoryLabel: categoryName(context, ref, d.categoryId), onTap: () => context.push('/documents/${d.id}')),
            SectionHeader(title: l.reminders, actionLabel: l.add, onAction: () => context.push('/reminders/new?link=${p.id}&linkType=profile')),
            for (final r in reminders) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ReminderCard(reminder: r, onTap: () => context.push('/reminders/${r.id}'))),
            SectionHeader(title: l.assignedItems),
            if (assets.isEmpty) Text(l.noAssignedItems, style: Theme.of(context).textTheme.bodySmall),
            for (final a in assets) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.chair_outlined), title: Text(a.name), onTap: () => context.push('/assets/${a.id}')),
          ]),
        ),
      ]),
    );
  }
}

class EditFamilyProfileScreen extends ConsumerStatefulWidget {
  const EditFamilyProfileScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<EditFamilyProfileScreen> createState() => _EditFamilyProfileScreenState();
}

class _EditFamilyProfileScreenState extends ConsumerState<EditFamilyProfileScreen> {
  final _name = TextEditingController();
  final _rel = TextEditingController();
  bool _minor = false;
  String? _photo;
  Uint8List? _newPhoto;
  bool _loaded = false;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fid = ref.watch(familyIdProvider);
    if (!_loaded && widget.id != null) {
      final p = (ref.read(familyProfilesProvider).value ?? const <FamilyProfile>[]).where((x) => x.id == widget.id).firstOrNull;
      if (p != null) {
        _name.text = p.name;
        _rel.text = p.relationship ?? '';
        _minor = p.isMinor;
        _photo = p.photoStoragePath;
      }
    }
    _loaded = true;
    if (fid == null || ref.watch(myMembershipProvider)?.canManage != true) {
      return Scaffold(appBar: AppBar(), body: const Padding(padding: EdgeInsets.all(Space.gutter), child: UpgradePrompt(reason: UpgradeReason.family)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? l.addFamilyMember : l.editProfile)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        Text(l.addMemberHelp, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.lg),
        Center(
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () async {
              final b = await pickPhotoSheet(context, ref);
              if (b != null) setState(() => _newPhoto = b);
            },
            child: ClipOval(child: SizedBox(width: 110, height: 110, child: _newPhoto != null ? Image.memory(_newPhoto!, fit: BoxFit.cover) : StorageImage(path: _photo, placeholderIcon: Icons.add_a_photo_outlined))),
          ),
        ),
        const SizedBox(height: Space.lg),
        AppTextField(label: l.name, controller: _name, maxLength: 80, textCapitalization: TextCapitalization.words),
        fieldGap,
        AppTextField(label: l.relationshipOptional, controller: _rel, maxLength: 40),
        SwitchListTile(contentPadding: EdgeInsets.zero, value: _minor, onChanged: (v) => setState(() => _minor = v), title: Text(l.minor), subtitle: Text(l.minorHelp)),
        const SizedBox(height: Space.xl),
        PrimaryButton(
          label: l.save,
          loading: _busy,
          onPressed: () async {
            if (_name.text.trim().isEmpty) return;
            setState(() => _busy = true);
            final repo = ref.read(familyRepoProvider);
            final id = widget.id ?? repo.newProfileId(fid);
            try {
              var photo = _photo;
              if (_newPhoto != null) photo = await repo.uploadProfilePhoto(fid, id, _newPhoto!);
              await repo.saveProfile(fid, ref.read(uidProvider)!,
                  FamilyProfile(id: id, name: _name.text.trim(), relationship: _rel.text.trim().isEmpty ? null : _rel.text.trim(), isMinor: _minor, photoStoragePath: photo),
                  isNew: widget.id == null);
              if (context.mounted) context.pop();
            } catch (e) {
              if (context.mounted) showError(context, e);
            } finally {
              if (mounted) setState(() => _busy = false);
            }
          },
        ),
        if (widget.id != null) ...[
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.deleteProfile,
            destructive: true,
            onPressed: () async {
              if (!await confirmDialog(context, title: l.deleteProfile, message: l.deleteProfileBody, confirmLabel: l.delete, destructive: true)) return;
              await ref.read(familyRepoProvider).deleteProfile(fid, widget.id!);
              if (context.mounted) context.go('/family');
            },
          ),
        ],
      ]),
    );
  }
}

class InviteMemberScreen extends ConsumerStatefulWidget {
  const InviteMemberScreen({super.key});
  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _email = TextEditingController();
  String? _link;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fid = ref.watch(familyIdProvider);
    final ent = ref.watch(entitlementValueProvider);
    final invites = fid == null ? null : ref.watch(_invitesProvider(fid)).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.inviteMember)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        if (!ent.canInviteMembers) const UpgradePrompt(reason: UpgradeReason.family) else ...[
          Text(l.inviteHelp, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Space.lg),
          AppTextField(label: l.emailOptional, controller: _email, keyboardType: TextInputType.emailAddress, textCapitalization: TextCapitalization.none, helper: l.inviteEmailHelp),
          const SizedBox(height: Space.lg),
          PrimaryButton(
            label: l.createInviteLink,
            loading: _busy,
            onPressed: () async {
              if (_email.text.isNotEmpty && !isValidEmail(_email.text)) return showError(context, Exception());
              setState(() => _busy = true);
              try {
                final r = await ref.read(familyRepoProvider).invite(fid!, email: _email.text.trim());
                setState(() => _link = r.link);
              } catch (e) {
                if (context.mounted) showError(context, e);
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
          ),
          if (_link != null) ...[
            const SizedBox(height: Space.lg),
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.inviteReady, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: Space.xs),
                Text(l.inviteExpiresNote, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: Space.md),
                Row(children: [
                  Expanded(child: SecondaryButton(label: l.copy, icon: Icons.copy, onPressed: () {
                    Clipboard.setData(ClipboardData(text: _link!));
                    showSuccess(context, l.copied);
                  })),
                  const SizedBox(width: Space.sm),
                  Expanded(child: PrimaryButton(label: l.share, icon: Icons.ios_share, onPressed: () => SharePlus.instance.share(ShareParams(text: l.inviteShareText(_link!))))),
                ]),
              ]),
            ),
          ],
          if (invites != null && invites.isNotEmpty) ...[
            SectionHeader(title: l.pendingInvites),
            for (final i in invites.where((i) => i.isPending))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule_send_outlined),
                title: Text(i.targetEmail ?? l.inviteLink),
                subtitle: Text(l.expiresOn(Fmt.date(context, i.expiresAt))),
                trailing: TextButton(onPressed: () => ref.read(familyRepoProvider).revokeInvitation(i.id), child: Text(l.revoke)),
              ),
          ],
        ],
      ]),
    );
  }
}

final _invitesProvider = StreamProvider.family<List<FamilyInvitation>, String>((ref, fid) => ref.watch(familyRepoProvider).watchInvitations(fid));

/// Opened from the invitation link (myworld-b0330.web.app/invite?i=…&t=…).
class InvitationAcceptanceScreen extends ConsumerStatefulWidget {
  const InvitationAcceptanceScreen({super.key, required this.invitationId, required this.token});
  final String invitationId;
  final String token;
  @override
  ConsumerState<InvitationAcceptanceScreen> createState() => _InvitationAcceptanceScreenState();
}

class _InvitationAcceptanceScreenState extends ConsumerState<InvitationAcceptanceScreen> {
  late final Future<({String familyName, String? inviterName})> _preview =
      ref.read(familyRepoProvider).previewInvitation(widget.invitationId, widget.token);
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.familyInvitation)),
      body: FutureBuilder(
        future: _preview,
        builder: (context, snap) {
          if (snap.hasError) return ErrorState(error: snap.error!);
          if (!snap.hasData) return const LoadingState();
          final p = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(children: [
              Expanded(child: EmptyState(icon: Icons.family_restroom, title: l.invitedTo(p.familyName), message: l.invitationBody(p.inviterName ?? l.member))),
              PrimaryButton(label: l.accept, loading: _busy, onPressed: () => _respond(true)),
              const SizedBox(height: Space.md),
              SecondaryButton(label: l.decline, onPressed: _busy ? null : () => _respond(false)),
            ]),
          );
        },
      ),
    );
  }

  Future<void> _respond(bool accept) async {
    setState(() => _busy = true);
    try {
      await ref.read(familyRepoProvider).respond(widget.invitationId, widget.token, accept);
      if (!mounted) return;
      showSuccess(context, accept ? context.l10n.joinedFamily : context.l10n.invitationDeclined);
      context.go(accept ? '/family' : '/home');
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class FamilyPermissionsScreen extends ConsumerWidget {
  const FamilyPermissionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final fid = ref.watch(familyIdProvider);
    final me = ref.watch(myMembershipProvider);
    final members = ref.watch(familyMembersProvider).value ?? const <FamilyMember>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.familyPermissions)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        AppCard(child: Text(l.permissionsExplainer, style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(height: Space.lg),
        for (final m in members)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(m.displayName ?? l.member),
            subtitle: Text(roleLabel(context, m.role)),
            trailing: me?.role == FamilyRole.owner && m.role != FamilyRole.owner
                ? DropdownButton<FamilyRole>(
                    value: m.role,
                    items: [
                      DropdownMenuItem(value: FamilyRole.admin, child: Text(l.roleAdmin)),
                      DropdownMenuItem(value: FamilyRole.member, child: Text(l.roleMember)),
                    ],
                    onChanged: (r) async {
                      try {
                        await ref.read(familyRepoProvider).setRole(fid!, m.uid, r!);
                      } catch (e) {
                        if (context.mounted) showError(context, e);
                      }
                    },
                  )
                : null,
          ),
      ]),
    );
  }
}

class SharedDocumentsScreen extends ConsumerWidget {
  const SharedDocumentsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final fid = ref.watch(familyIdProvider);
    final uid = ref.watch(uidProvider);
    final docs = (ref.watch(documentsProvider).value ?? const <DocumentRecord>[]).where((d) => d.privacy.familyId == fid && d.privacy.level != PrivacyLevel.private && !d.inTrash).toList();
    final mine = docs.where((d) => d.ownerUid == uid).toList();
    final theirs = docs.where((d) => d.ownerUid != uid).toList();
    final names = ref.watch(memberNamesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.sharedDocuments)),
      body: docs.isEmpty
          ? EmptyState(icon: Icons.folder_shared_outlined, title: l.noSharedDocs, message: l.noSharedDocsHint)
          : ListView(padding: const EdgeInsets.all(Space.gutter), children: [
              if (theirs.isNotEmpty) SectionHeader(title: l.sharedWithMe),
              for (final d in theirs) DocumentListItem(document: d, categoryLabel: l.sharedBy(names[d.ownerUid] ?? l.member), onTap: () => context.push('/documents/${d.id}')),
              if (mine.isNotEmpty) SectionHeader(title: l.sharedByMe),
              for (final d in mine) DocumentListItem(document: d, categoryLabel: privacyLabel(context, d.privacy.level), onTap: () => context.push('/documents/${d.id}')),
            ]),
    );
  }
}

class FamilySettingsScreen extends ConsumerWidget {
  const FamilySettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final family = ref.watch(familyProvider).value;
    final me = ref.watch(myMembershipProvider);
    final members = ref.watch(familyMembersProvider).value ?? const <FamilyMember>[];
    if (family == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    final isOwner = me?.role == FamilyRole.owner;
    return Scaffold(
      appBar: AppBar(title: Text(l.familySettings)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        InfoRow(label: l.familyName, value: family.name, icon: Icons.family_restroom),
        InfoRow(label: l.members, value: '${members.length}', icon: Icons.group_outlined),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.person_add_alt), title: Text(l.inviteMember), onTap: () => context.push('/family/invite')),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.admin_panel_settings_outlined), title: Text(l.familyPermissions), onTap: () => context.push('/family/permissions')),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.folder_shared_outlined), title: Text(l.sharedDocuments), onTap: () => context.push('/family/shared')),
        const SizedBox(height: Space.xl),
        if (!isOwner) SecondaryButton(label: l.leaveFamily, destructive: true, onPressed: () => context.push('/family/leave')),
        if (isOwner) ...[
          Text(members.length > 1 ? l.ownerCannotLeave : l.dissolveHelp, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.dissolveFamily,
            destructive: true,
            onPressed: members.length > 1
                ? null
                : () async {
                    if (!await confirmDialog(context, title: l.dissolveFamily, message: l.dissolveBody, confirmLabel: l.dissolveFamily, destructive: true)) return;
                    try {
                      await ref.read(familyRepoProvider).dissolve(family.id);
                      if (context.mounted) context.go('/home');
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

class LeaveFamilyScreen extends ConsumerStatefulWidget {
  const LeaveFamilyScreen({super.key});
  @override
  ConsumerState<LeaveFamilyScreen> createState() => _LeaveFamilyScreenState();
}

class _LeaveFamilyScreenState extends ConsumerState<LeaveFamilyScreen> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.leaveFamily)),
      body: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(children: [
          Expanded(child: EmptyState(icon: Icons.logout, title: l.leaveFamilyTitle, message: l.leaveFamilyBody)),
          PrimaryButton(
            label: l.leaveFamily,
            loading: _busy,
            onPressed: () async {
              setState(() => _busy = true);
              try {
                await ref.read(familyRepoProvider).leave(ref.read(familyIdProvider)!);
                if (context.mounted) context.go('/home');
              } catch (e) {
                if (context.mounted) showError(context, e);
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
          ),
          TextButton(onPressed: () => context.pop(), child: Text(l.cancel)),
        ]),
      ),
    );
  }
}

class RemoveMemberScreen extends ConsumerStatefulWidget {
  const RemoveMemberScreen({super.key, required this.uid});
  final String uid;
  @override
  ConsumerState<RemoveMemberScreen> createState() => _RemoveMemberScreenState();
}

class _RemoveMemberScreenState extends ConsumerState<RemoveMemberScreen> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = (ref.watch(familyMembersProvider).value ?? const <FamilyMember>[]).where((x) => x.uid == widget.uid).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(l.removeMember)),
      body: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(children: [
          Expanded(child: EmptyState(icon: Icons.person_remove_outlined, title: l.removeMemberTitle(m?.displayName ?? l.member), message: l.removeMemberBody)),
          PrimaryButton(
            label: l.removeMember,
            loading: _busy,
            onPressed: () async {
              setState(() => _busy = true);
              try {
                await ref.read(familyRepoProvider).removeMember(ref.read(familyIdProvider)!, widget.uid);
                if (context.mounted) context.go('/family');
              } catch (e) {
                if (context.mounted) showError(context, e);
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
          ),
          TextButton(onPressed: () => context.pop(), child: Text(l.cancel)),
        ]),
      ),
    );
  }
}
