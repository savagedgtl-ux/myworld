import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/states.dart';
import '../../domain/categories.dart';
import '../../domain/logic/search.dart';
import '../../domain/models/document.dart';
import '../add/add_sheet.dart';
import '../documents/document_screens.dart';

/// Vault: private, important documents. No ads are ever shown here.
class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});
  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> with WidgetsBindingObserver {
  bool? _lockEnabled;
  String _query = '';
  String? _category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(vaultLockProvider).isEnabled().then((v) => mounted ? setState(() => _lockEnabled = v) : null);
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(const AddContext(area: 'documents', vault: true)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-lock when the app goes to background.
    if (state == AppLifecycleState.paused) {
      ref.read(vaultLockProvider).lock();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lock = ref.read(vaultLockProvider);
    if (_lockEnabled == null) return const Scaffold(body: LoadingState());
    if (_lockEnabled! && !lock.isUnlocked) return VaultLockScreen(onUnlocked: () => setState(() {}));

    final docs = ref.watch(documentsProvider);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navVault), actions: [
        IconButton(tooltip: l.vaultSettings, onPressed: () => context.push('/settings/vault').then((_) => lock.isEnabled().then((v) => setState(() => _lockEnabled = v))), icon: const Icon(Icons.settings_outlined)),
        if (_lockEnabled!) IconButton(tooltip: l.lockNow, onPressed: () => setState(lock.lock), icon: const Icon(Icons.lock_outline)),
      ]),
      body: asyncView<List<DocumentRecord>>(docs, (all) {
        final vault = all.where((d) => d.isVault && !d.inTrash).toList();
        final list = applyDocumentFilter(vault, DocumentFilter(query: _query, categoryIds: {?_category}, vaultOnly: true));
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.xxl), children: [
          Text(l.vaultSubtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Space.md),
          AppSearchBar(hint: l.searchVault, onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: Space.md),
          FilterChips<String>(
            options: [for (final c in Categories.vault) c.id],
            selected: {?_category},
            labelOf: (id) => Categories.find(Categories.vault, id)!.label.of(locale),
            onToggle: (id) => setState(() => _category = _category == id ? null : id),
          ),
          const SizedBox(height: Space.md),
          if (vault.isEmpty)
            EmptyState(
              icon: Icons.shield_outlined,
              title: l.vaultEmpty,
              message: l.vaultEmptyBody,
              actionLabel: l.addDocument,
              onAction: () {
                ref.read(addContextProvider.notifier).set(const AddContext(area: 'documents', vault: true));
                showAddSheet(context, ref);
              },
            )
          else if (list.isEmpty)
            EmptyState(icon: Icons.search_off, title: l.noResults)
          else
            for (final d in list)
              DocumentListItem(
                document: d,
                categoryLabel: Categories.labelFor(context, d.categoryId, list: Categories.vault),
                onTap: () => context.push('/documents/${d.id}'),
              ),
        ]);
      }),
    );
  }
}

class VaultLockScreen extends ConsumerStatefulWidget {
  const VaultLockScreen({super.key, required this.onUnlocked});
  final VoidCallback onUnlocked;
  @override
  ConsumerState<VaultLockScreen> createState() => _VaultLockScreenState();
}

class _VaultLockScreenState extends ConsumerState<VaultLockScreen> {
  final _pin = TextEditingController();
  String? _error;
  bool _bio = false;

  @override
  void initState() {
    super.initState();
    final lock = ref.read(vaultLockProvider);
    lock.biometricEnabled().then((b) async {
      if (!mounted) return;
      setState(() => _bio = b);
      if (b) _tryBio();
    });
  }

  Future<void> _tryBio() async {
    if (await ref.read(vaultLockProvider).unlockWithBiometrics(context.l10n.unlockVaultReason)) widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.lock_outline, size: 56, color: AppColors.secondary),
            const SizedBox(height: Space.lg),
            Text(l.vaultLocked, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: Space.sm),
            Text(l.vaultLockedBody, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: Space.xl),
            TextField(
              controller: _pin,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 8,
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: l.pin, errorText: _error, counterText: ''),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: Space.lg),
            PrimaryButton(label: l.unlock, onPressed: _submit),
            if (_bio) TextButton.icon(onPressed: _tryBio, icon: const Icon(Icons.fingerprint), label: Text(l.useBiometrics)),
          ]),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final left = await ref.read(vaultLockProvider).unlockWithPin(_pin.text);
    _pin.clear();
    if (left == -1) return widget.onUnlocked();
    if (left == 0) {
      // Too many attempts: require a fresh sign-in, then the lock resets.
      await ref.read(vaultLockProvider).disable();
      await ref.read(authServiceProvider).signOut();
      return;
    }
    setState(() => _error = l.wrongPin(left));
  }
}

class VaultSettingsScreen extends ConsumerStatefulWidget {
  const VaultSettingsScreen({super.key});
  @override
  ConsumerState<VaultSettingsScreen> createState() => _VaultSettingsScreenState();
}

class _VaultSettingsScreenState extends ConsumerState<VaultSettingsScreen> {
  bool _enabled = false;
  bool _bio = false;
  bool _bioAvailable = false;
  final _pin = TextEditingController();
  final _pin2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    final lock = ref.read(vaultLockProvider);
    Future.wait([lock.isEnabled(), lock.biometricEnabled(), lock.biometricsAvailable()]).then((v) {
      if (!mounted) return;
      setState(() {
        _enabled = v[0];
        _bio = v[1];
        _bioAvailable = v[2];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lock = ref.read(vaultLockProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.vaultSettings)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        AppCard(child: Text(l.vaultLockDisclaimer, style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(height: Space.lg),
        if (!_enabled) ...[
          Text(l.setPin, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Space.md),
          TextField(controller: _pin, keyboardType: TextInputType.number, obscureText: true, maxLength: 8, decoration: InputDecoration(labelText: l.pinNew, helperText: l.pinHelp)),
          const SizedBox(height: Space.md),
          TextField(controller: _pin2, keyboardType: TextInputType.number, obscureText: true, maxLength: 8, decoration: InputDecoration(labelText: l.pinRepeat)),
          if (_bioAvailable) SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.useBiometrics), value: _bio, onChanged: (v) => setState(() => _bio = v)),
          const SizedBox(height: Space.lg),
          PrimaryButton(
            label: l.enableLock,
            onPressed: () async {
              if (!RegExp(r'^\d{4,8}$').hasMatch(_pin.text)) return setState(() {});
              if (_pin.text != _pin2.text) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.pinMismatch)));
                return;
              }
              await lock.enable(pin: _pin.text, biometric: _bio);
              if (mounted) setState(() => _enabled = true);
            },
          ),
        ] else ...[
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.lock, color: AppColors.success), title: Text(l.lockEnabled)),
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.disableLock,
            destructive: true,
            onPressed: () async {
              await lock.disable();
              if (mounted) setState(() => _enabled = false);
            },
          ),
        ],
      ]),
    );
  }
}

/// Re-export so the router can reference the document detail from Vault.
typedef VaultDocumentDetail = DocumentDetailScreen;
