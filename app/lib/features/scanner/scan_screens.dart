import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../data/repositories/document_repository.dart';
import '../../domain/categories.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../../domain/plans.dart';
import '../../services/scanner_service.dart';

/// Entry point for adding a document: scan / photo / PDF / image.
/// Pages stay in memory; nothing is written to public storage.
class ScanFlowScreen extends ConsumerStatefulWidget {
  const ScanFlowScreen({super.key, required this.mode, this.area, this.link, this.profile, this.vault = false});
  final String mode; // scan | photo | pdf | image
  final String? area;
  final String? link;
  final String? profile;
  final bool vault;

  @override
  ConsumerState<ScanFlowScreen> createState() => _ScanFlowScreenState();
}

enum _Step { capture, review, details, uploading, done, error }

class _ScanFlowScreenState extends ConsumerState<ScanFlowScreen> {
  _Step _step = _Step.capture;
  final List<ScanPage> _pages = [];
  PreparedFile? _existing; // picked PDF (not re-rendered)
  double _progress = 0;
  Object? _error;
  String? _savedId;
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _vendor = TextEditingController();
  final _amount = TextEditingController();
  late NewDocumentInput _input;

  ScannerService get _scanner => ref.read(scannerServiceProvider);

  @override
  void initState() {
    super.initState();
    _input = NewDocumentInput(
      title: '',
      categoryId: _defaultCategory(),
      isVault: widget.vault,
      linkedEntityIds: [?widget.link, ?widget.profile],
      requestAi: ref.read(entitlementValueProvider).aiEnabled,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _capture());
  }

  String _defaultCategory() => switch (widget.area) {
        'car' => 'vehicle',
        'home' => 'receipts',
        'hobby' => 'receipts',
        'family' => 'family',
        'life' => 'contracts',
        _ => widget.vault ? 'personal' : 'other',
      };

  @override
  void dispose() {
    _title.dispose();
    _vendor.dispose();
    _amount.dispose();
    _pages.clear();
    _scanner.cleanup();
    super.dispose();
  }

  Future<void> _capture({bool append = false}) async {
    try {
      switch (widget.mode) {
        case 'pdf':
          final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['pdf']);
          if (file == null) return _cancel();
          if ((await file.length() ?? 0) > UploadLimits.maxBytes) throw const AppError(AppErrorCode.fileTooLarge);
          _existing = await _scanner.prepareExisting(await file.readAsBytes());
          _title.text = _stripExt(file.name);
          setState(() => _step = _Step.details);
          return;
        case 'image':
          final imgs = await _scanner.pickImages();
          if (imgs.isEmpty) return append ? null : _cancel();
          for (final b in imgs) {
            final check = validateUpload(b);
            if (check is FileRejected) throw AppError(check.reason == 'too_large' ? AppErrorCode.fileTooLarge : AppErrorCode.unsupportedFile);
            _pages.add(ScanPage(b));
          }
        case 'photo':
          final b = await _scanner.takePhoto();
          if (b == null) return append ? null : _cancel();
          _pages.add(ScanPage(b));
        default:
          final scanned = await _scanner.scan(maxPages: UploadLimits.maxPages - _pages.length);
          if (scanned == null) return append ? null : _cancel();
          _pages.addAll(scanned);
      }
      if (mounted) setState(() => _step = _Step.review);
    } on AppError catch (e) {
      if (e.code == AppErrorCode.cancelled) return append ? null : _cancel();
      if (mounted) {
        setState(() {
          _error = e;
          _step = _Step.error;
        });
      }
    }
  }

  void _cancel() {
    if (mounted && _pages.isEmpty && _existing == null) context.pop();
  }

  String _stripExt(String n) => n.contains('.') ? n.substring(0, n.lastIndexOf('.')) : n;

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final err = _input.privacy.validate();
    if (err != null) return showError(context, const AppError(AppErrorCode.permissionDenied));
    final usage = ref.read(usageProvider).value;
    final ent = ref.read(entitlementValueProvider);
    if (usage != null && usage.documentLimitReached(ent)) return showUpgradeSheet(context, UpgradeReason.documents);

    setState(() {
      _step = _Step.uploading;
      _progress = 0;
    });
    try {
      final file = _existing ?? await _scanner.buildPdf(_pages);
      if (usage != null && usage.storageUsedBytes + file.bytes.length > ent.storageLimitBytes) {
        throw const AppError(AppErrorCode.storageLimit);
      }
      _input
        ..title = _title.text.trim()
        ..vendor = _vendor.text.trim().isEmpty ? null : _vendor.text.trim()
        ..amount = parseAmount(_amount.text);
      final docs = ref.read(documentsProvider).value ?? const [];
      final dup = ref.read(documentRepoProvider).findDuplicate(docs, file.sha256);
      if (dup != null && mounted) {
        final go = await confirmDialog(context,
            title: context.l10n.duplicateTitle, message: context.l10n.duplicateBody(dup.title), confirmLabel: context.l10n.saveAnyway);
        if (!go) {
          setState(() => _step = _Step.details);
          return;
        }
      }
      final id = await ref.read(documentRepoProvider).create(
            uid: ref.read(uidProvider)!,
            file: file,
            input: _input,
            onProgress: (p) => mounted ? setState(() => _progress = p) : null,
          );
      _pages.clear();
      if (mounted) {
        setState(() {
          _savedId = id;
          _step = _Step.done;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _step = _Step.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: _step != _Step.uploading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(switch (_step) {
            _Step.review => l.scanReviewTitle(_pages.length),
            _Step.details => l.saveDocumentTitle,
            _Step.uploading => l.statusUploading,
            _Step.done => l.saved,
            _ => l.addTitle,
          }),
        ),
        body: switch (_step) {
          _Step.capture => LoadingState(message: l.openingCamera),
          _Step.review => _review(context),
          _Step.details => _details(context),
          _Step.uploading => _uploading(context),
          _Step.done => _done(context),
          _Step.error => _errorView(context),
        },
      ),
    );
  }

  Widget _review(BuildContext context) {
    final l = context.l10n;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.md),
        child: Text(l.scanReviewHelp, style: Theme.of(context).textTheme.bodySmall),
      ),
      Expanded(
        child: ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          itemCount: _pages.length,
          onReorderItem: (a, b) => setState(() => _pages.insert(b, _pages.removeAt(a))),
          itemBuilder: (_, i) {
            final p = _pages[i];
            return Padding(
              key: ObjectKey(p),
              padding: const EdgeInsets.only(bottom: Space.md),
              child: AppCard(
                padding: const EdgeInsets.all(Space.sm),
                child: Row(children: [
                  SizedBox(
                    width: 96,
                    height: 128,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Radii.sm),
                      child: RotatedBox(quarterTurns: p.rotationQuarterTurns, child: Image.memory(p.bytes, fit: BoxFit.cover, semanticLabel: l.pageN(i + 1))),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(child: Text(l.pageN(i + 1), style: Theme.of(context).textTheme.titleSmall)),
                  IconButton(tooltip: l.rotate, icon: const Icon(Icons.rotate_90_degrees_cw_outlined), onPressed: () => setState(() => p.rotationQuarterTurns = (p.rotationQuarterTurns + 1) % 4)),
                  IconButton(
                    tooltip: l.retake,
                    icon: const Icon(Icons.replay_outlined),
                    onPressed: () async {
                      final b = await _scanner.takePhoto();
                      if (b != null) setState(() => _pages[i] = ScanPage(b));
                    },
                  ),
                  IconButton(
                    tooltip: l.delete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() {
                      _pages.removeAt(i);
                      if (_pages.isEmpty) _step = _Step.capture;
                      if (_pages.isEmpty) _capture();
                    }),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.gutter),
          child: Row(children: [
            Expanded(child: SecondaryButton(label: l.addPage, icon: Icons.add, onPressed: _pages.length >= UploadLimits.maxPages ? null : () => _capture(append: true))),
            const SizedBox(width: Space.md),
            Expanded(child: PrimaryButton(label: l.done, onPressed: () => setState(() => _step = _Step.details))),
          ]),
        ),
      ),
    ]);
  }

  Widget _details(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final locale = Localizations.localeOf(context);
    final cats = widget.vault ? Categories.vault : Categories.documents;
    final custom = (ref.watch(customCategoriesProvider).value ?? const []).where((c) => c.area == (widget.vault ? 'vault' : 'documents'));
    final destination = [
      widget.vault ? l.navVault : l.areaDocuments,
      Categories.find(cats, _input.categoryId)?.label.of(locale) ?? custom.where((c) => c.id == _input.categoryId).map((c) => c.name).firstOrNull ?? '',
    ].where((s) => s.isNotEmpty).join(' › ');

    return Form(
      key: _form,
      child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        // Always show where it will be saved before saving.
        AppCard(
          child: Row(children: [
            const Icon(Icons.folder_outlined, color: AppColors.secondary),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.willBeSavedIn(destination), style: Theme.of(context).textTheme.bodyMedium)),
          ]),
        ),
        const SizedBox(height: Space.lg),
        AppTextField(label: l.title, controller: _title, maxLength: 200, validator: (v) => validateTitle(v) == null ? null : l.required),
        fieldGap,
        DropdownButtonFormField<String>(
          initialValue: _input.categoryId,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.category),
          items: [
            for (final c in cats) DropdownMenuItem(value: c.id, child: Text(c.label.of(locale))),
            for (final c in custom) DropdownMenuItem(value: c.id, child: Text(c.name)),
          ],
          onChanged: (v) => setState(() => _input.categoryId = v),
        ),
        fieldGap,
        DateField(label: l.documentDate, value: _input.documentDate, lastDate: DateTime.now().add(const Duration(days: 1)), onChanged: (d) => setState(() => _input.documentDate = d)),
        fieldGap,
        AppTextField(label: l.vendor, controller: _vendor, maxLength: 200),
        fieldGap,
        MoneyField(label: l.amount, amountController: _amount, currency: _input.currency, onCurrency: (c) => setState(() => _input.currency = c)),
        fieldGap,
        PrivacySelector(value: _input.privacy, onChanged: (p) => setState(() => _input.privacy = p)),
        fieldGap,
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _input.isVault,
          onChanged: (v) => setState(() => _input.isVault = v),
          title: Text(l.saveToVault),
          subtitle: Text(l.saveToVaultHelp),
        ),
        if (ent.aiEnabled)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _input.requestAi,
            onChanged: (v) => setState(() => _input.requestAi = v),
            title: Text(l.aiAnalyze),
            subtitle: Text(l.aiAnalyzeHelp),
          )
        else
          Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.aiNotInPlanHint, style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(height: Space.xl),
        PrimaryButton(label: l.save, icon: Icons.cloud_upload_outlined, onPressed: _save),
      ]),
    );
  }

  Widget _uploading(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Space.xxl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Semantics(
            label: context.l10n.uploadProgress((_progress * 100).round()),
            child: SizedBox(width: 96, height: 96, child: CircularProgressIndicator(value: _progress == 0 ? null : _progress, strokeWidth: 6)),
          ),
          const SizedBox(height: Space.xl),
          Text(context.l10n.uploadProgress((_progress * 100).round()), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Space.sm),
          Text(context.l10n.uploadKeepOpen, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
        ]),
      );

  /// No ads around the Vault: it promises an ad-free space.
  void _adBreak() {
    if (!widget.vault && !_input.isVault) showInterstitialAtBreak(ref);
  }

  Widget _done(BuildContext context) {
    final l = context.l10n;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: Motion.of(context, Motion.normal),
      builder: (_, s, child) => Transform.scale(scale: s, child: child),
      child: EmptyState(
        icon: Icons.check_circle_outline,
        title: l.documentSaved,
        message: _input.requestAi ? l.documentSavedAi : null,
        actionLabel: l.openDocument,
        onAction: () {
          _adBreak();
          context.pushReplacement('/documents/$_savedId');
        },
        secondary: TextButton(
          onPressed: () {
            _adBreak();
            context.pop();
          },
          child: Text(l.close),
        ),
      ),
    );
  }

  Widget _errorView(BuildContext context) {
    final l = context.l10n;
    final code = AppError.from(_error!).code;
    final canRetry = _pages.isNotEmpty || _existing != null;
    return Padding(
      padding: const EdgeInsets.all(Space.gutter),
      child: Column(children: [
        Expanded(
          child: EmptyState(
            icon: Icons.cloud_off_outlined,
            title: l.uploadErrorTitle,
            message: errorMessage(context, _error!),
            actionLabel: canRetry ? l.retry : l.close,
            onAction: canRetry ? _save : () => context.pop(),
          ),
        ),
        if (code == AppErrorCode.storageLimit || code == AppErrorCode.documentLimit)
          UpgradePrompt(reason: code == AppErrorCode.storageLimit ? UpgradeReason.storage : UpgradeReason.documents, compact: true),
        if (canRetry) TextButton(onPressed: () => setState(() => _step = _Step.details), child: Text(l.editDetails)),
      ]),
    );
  }
}

/// Convenience for other flows (cards, business cards, items) that need one photo.
Future<Uint8List?> pickPhotoSheet(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final scanner = ref.read(scannerServiceProvider);
  final src = await showModalBottomSheet<String>(
    context: context,
    builder: (c) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.photo_camera_outlined), title: Text(l.takePhoto), onTap: () => Navigator.pop(c, 'camera')),
        ListTile(leading: const Icon(Icons.photo_library_outlined), title: Text(l.chooseFromGallery), onTap: () => Navigator.pop(c, 'gallery')),
      ]),
    ),
  );
  if (src == null) return null;
  final raw = src == 'camera' ? await scanner.takePhoto() : await scanner.pickImage();
  if (raw == null) return null;
  return scanner.compressPage(raw);
}

/// Used when a document needs privacy details for an existing record.
Privacy defaultPrivacy() => Privacy.private;
