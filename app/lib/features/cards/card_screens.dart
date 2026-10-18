import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/states.dart';
import '../../domain/logic/search.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../../domain/models/entities.dart';
import '../add/add_sheet.dart';
import '../scanner/scan_screens.dart';

String walletKindLabel(BuildContext context, WalletCardKind k) {
  final l = context.l10n;
  return switch (k) {
    WalletCardKind.loyalty => l.cardLoyalty,
    WalletCardKind.discount => l.cardDiscount,
    WalletCardKind.coupon => l.cardCoupon,
    WalletCardKind.gift => l.cardGift,
    WalletCardKind.membership => l.cardMembership,
    WalletCardKind.other => l.cardOther,
  };
}

IconData walletKindIcon(WalletCardKind k) => switch (k) {
      WalletCardKind.loyalty => Icons.loyalty_outlined,
      WalletCardKind.discount => Icons.percent,
      WalletCardKind.coupon => Icons.confirmation_number_outlined,
      WalletCardKind.gift => Icons.card_giftcard,
      WalletCardKind.membership => Icons.card_membership,
      WalletCardKind.other => Icons.credit_card,
    };

const _cardColors = ['#173B57', '#4A90C6', '#56B8B0', '#31856A', '#E9A23B', '#C94D4D', '#6B5B95', '#2F3E46'];

Color cardColor(String? hex) {
  final h = (hex ?? '#173B57').replaceFirst('#', '');
  return Color(int.tryParse('FF$h', radix: 16) ?? 0xFF173B57);
}

Barcode? toBarcode(BarcodeKind k) => switch (k) {
      BarcodeKind.qr => Barcode.qrCode(),
      BarcodeKind.ean13 => Barcode.ean13(),
      BarcodeKind.ean8 => Barcode.ean8(),
      BarcodeKind.code128 => Barcode.code128(),
      BarcodeKind.code39 => Barcode.code39(),
      BarcodeKind.upca => Barcode.upcA(),
      BarcodeKind.pdf417 => Barcode.pdf417(),
      BarcodeKind.aztec => Barcode.aztec(),
      BarcodeKind.datamatrix => Barcode.dataMatrix(),
      BarcodeKind.none => null,
    };

BarcodeKind fromScanned(ms.BarcodeFormat f) => switch (f) {
      ms.BarcodeFormat.qrCode || ms.BarcodeFormat.microQrCode => BarcodeKind.qr,
      ms.BarcodeFormat.ean13 => BarcodeKind.ean13,
      ms.BarcodeFormat.ean8 => BarcodeKind.ean8,
      ms.BarcodeFormat.code39 => BarcodeKind.code39,
      ms.BarcodeFormat.upcA => BarcodeKind.upca,
      ms.BarcodeFormat.pdf417 => BarcodeKind.pdf417,
      ms.BarcodeFormat.aztec => BarcodeKind.aztec,
      ms.BarcodeFormat.dataMatrix => BarcodeKind.datamatrix,
      _ => BarcodeKind.code128,
    };

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});
  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  WalletCardKind? _kind;
  String _q = '';
  bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(addContextProvider.notifier).set(const AddContext(area: 'cards')));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(l.areaCards)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/cards/new'), icon: const Icon(Icons.add), label: Text(l.addWalletCard)),
      body: asyncView<List<WalletCard>>(ref.watch(walletCardsProvider), (all) {
        final list = all
            .where((c) => _kind == null || c.kind == _kind)
            .where((c) => _showArchived || (!c.isUsed && !c.isExpired(now)))
            .where((c) => matchesQuery(_q, [c.name, c.issuer, c.discountText, c.cardNumber, c.notes]))
            .toList()
          ..sort((a, b) {
            if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
            return normalizeText(a.name).compareTo(normalizeText(b.name));
          });
        final expiringSoon = all.where((c) => !c.isUsed && c.expiryDate != null && !c.isExpired(now) && c.expiryDate!.difference(now).inDays <= 14).toList();
        return ListView(padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, 96), children: [
          AppSearchBar(hint: l.searchCards, onChanged: (v) => setState(() => _q = v)),
          const SizedBox(height: Space.md),
          FilterChips<WalletCardKind>(options: WalletCardKind.values, selected: {?_kind}, labelOf: (k) => walletKindLabel(context, k), onToggle: (k) => setState(() => _kind = _kind == k ? null : k)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.showUsedExpired), value: _showArchived, onChanged: (v) => setState(() => _showArchived = v)),
          if (expiringSoon.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.md),
              child: AppCard(child: Row(children: [const Icon(Icons.timer_outlined, color: AppColors.warning), const SizedBox(width: Space.md), Expanded(child: Text(l.cardsExpiringSoon(expiringSoon.length)))])),
            ),
          if (list.isEmpty)
            EmptyState(icon: Icons.loyalty_outlined, title: l.noCards, message: l.noCardsHint, actionLabel: l.addWalletCard, onAction: () => context.push('/cards/new'))
          else
            for (final c in list) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: WalletCardTile(card: c, onTap: () => context.push('/cards/${c.id}'))),
        ]);
      }),
    );
  }
}

class WalletCardTile extends StatelessWidget {
  const WalletCardTile({super.key, required this.card, required this.onTap});
  final WalletCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = card;
    final l = context.l10n;
    final expired = c.isExpired(DateTime.now());
    final bg = cardColor(c.color);
    return Semantics(
      button: true,
      label: '${c.name}, ${walletKindLabel(context, c.kind)}',
      excludeSemantics: true,
      child: Opacity(
        opacity: expired || c.isUsed ? 0.55 : 1,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(Radii.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(Space.lg),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(walletKindIcon(c.kind), color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(walletKindLabel(context, c.kind), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      if (c.isFavorite) const Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.star_rounded, color: Colors.amber, size: 16)),
                    ]),
                    const Spacer(),
                    Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (c.discountText != null) Text(c.discountText!, style: const TextStyle(color: Colors.white, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (c.expiryDate != null)
                      Text(expired ? l.expired : l.validUntil(Fmt.date(context, c.expiryDate)), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ),
                if (c.barcodeValue != null) const Icon(Icons.qr_code_2, color: Colors.white, size: 36),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the code large on a white background for scanning at the checkout.
class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final all = ref.watch(walletCardsProvider);
    final c = (all.value ?? const <WalletCard>[]).where((x) => x.id == id).firstOrNull;
    if (c == null) return Scaffold(appBar: AppBar(), body: all.isLoading ? const LoadingState() : EmptyState(icon: Icons.lock_outline, title: l.notAvailable));
    final isOwner = c.ownerUid == ref.watch(uidProvider);
    final repo = ref.read(walletRepoProvider);
    final barcode = toBarcode(c.barcodeFormat);
    final twoD = const {BarcodeKind.qr, BarcodeKind.pdf417, BarcodeKind.aztec, BarcodeKind.datamatrix}.contains(c.barcodeFormat);
    return Scaffold(
      appBar: AppBar(title: Text(c.name), actions: [
        if (isOwner) IconButton(tooltip: c.isFavorite ? l.removeFavorite : l.addFavorite, onPressed: () => repo.patch(c.id, {'isFavorite': !c.isFavorite}), icon: Icon(c.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded)),
        if (isOwner) IconButton(tooltip: l.edit, onPressed: () => context.push('/cards/${c.id}/edit'), icon: const Icon(Icons.edit_outlined)),
      ]),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        if (c.barcodeValue != null && barcode != null)
          Container(
            padding: const EdgeInsets.all(Space.xl),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Radii.lg), boxShadow: Shadows.soft),
            child: Column(children: [
              BarcodeWidget(
                barcode: barcode,
                data: c.barcodeValue!,
                height: twoD ? 220 : 110,
                width: twoD ? 220 : double.infinity,
                color: Colors.black,
                drawText: !twoD,
                errorBuilder: (_, _) => Text(l.barcodeInvalid, style: const TextStyle(color: AppColors.error)),
              ),
              const SizedBox(height: Space.md),
              SelectableText(c.cardNumber ?? c.barcodeValue!, style: const TextStyle(color: Colors.black, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w600)),
            ]),
          )
        else if (c.cardNumber != null)
          AppCard(
            child: Row(children: [
              Expanded(child: SelectableText(c.cardNumber!, style: Theme.of(context).textTheme.headlineSmall)),
              IconButton(tooltip: l.copy, onPressed: () => Clipboard.setData(ClipboardData(text: c.cardNumber!)), icon: const Icon(Icons.copy)),
            ]),
          ),
        const SizedBox(height: Space.lg),
        WalletCardTile(card: c, onTap: () {}),
        const SizedBox(height: Space.md),
        InfoRow(label: l.issuer, value: c.issuer, icon: Icons.storefront_outlined),
        InfoRow(label: l.discount, value: c.discountText, icon: Icons.percent),
        InfoRow(label: l.balance, value: c.balance == null ? null : Fmt.money(context, c.balance, c.currency), icon: Icons.account_balance_wallet_outlined),
        InfoRow(label: l.validFrom, value: c.validFrom == null ? null : Fmt.date(context, c.validFrom), icon: Icons.event_available),
        InfoRow(label: l.expiryDate, value: c.expiryDate == null ? null : Fmt.date(context, c.expiryDate), icon: Icons.event_busy),
        InfoRow(label: l.notes, value: c.notes, icon: Icons.notes),
        if (c.frontPhotoPath != null || c.backPhotoPath != null) ...[
          SectionHeader(title: l.photos),
          Row(children: [
            if (c.frontPhotoPath != null) Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(Radii.sm), child: AspectRatio(aspectRatio: 1.6, child: StorageImage(path: c.frontPhotoPath, placeholderIcon: Icons.credit_card)))),
            if (c.frontPhotoPath != null && c.backPhotoPath != null) const SizedBox(width: Space.sm),
            if (c.backPhotoPath != null) Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(Radii.sm), child: AspectRatio(aspectRatio: 1.6, child: StorageImage(path: c.backPhotoPath, placeholderIcon: Icons.credit_card)))),
          ]),
        ],
        const SizedBox(height: Space.xl),
        if (isOwner && c.kind == WalletCardKind.coupon && !c.isUsed)
          PrimaryButton(label: l.markUsed, icon: Icons.check, onPressed: () => repo.patch(c.id, {'usedAt': DateTime.now()})),
        if (isOwner && c.expiryDate != null && c.expiryDate!.isAfter(DateTime.now())) ...[
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.remindBeforeExpiry,
            icon: Icons.add_alarm,
            onPressed: () => context.push(Uri(path: '/reminders/new', queryParameters: {
              'title': l.cardExpiresTitle(c.name),
              'due': c.expiryDate!.subtract(const Duration(days: 3)).toIso8601String(),
              'kind': 'document',
            }).toString()),
          ),
        ],
        if (isOwner) ...[
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.delete,
            destructive: true,
            onPressed: () async {
              if (!await confirmDialog(context, title: l.deleteCard, message: l.deleteCardBody, confirmLabel: l.delete, destructive: true)) return;
              await repo.delete(c.id);
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

class EditCardScreen extends ConsumerStatefulWidget {
  const EditCardScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends ConsumerState<EditCardScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _issuer = TextEditingController();
  final _number = TextEditingController();
  final _barcode = TextEditingController();
  final _discount = TextEditingController();
  final _balance = TextEditingController();
  final _notes = TextEditingController();
  WalletCardKind _kind = WalletCardKind.loyalty;
  BarcodeKind _format = BarcodeKind.none;
  String? _currency;
  DateTime? _validFrom;
  DateTime? _expiry;
  String _color = _cardColors.first;
  Privacy _privacy = Privacy.private;
  String? _front;
  String? _back;
  Uint8List? _newFront;
  Uint8List? _newBack;
  WalletCard? _existing;
  bool _loaded = false;
  bool _busy = false;

  void _load() {
    _loaded = true;
    if (widget.id == null) return;
    final c = (ref.read(walletCardsProvider).value ?? const <WalletCard>[]).where((x) => x.id == widget.id).firstOrNull;
    if (c == null) return;
    _existing = c;
    _name.text = c.name;
    _issuer.text = c.issuer ?? '';
    _number.text = c.cardNumber ?? '';
    _barcode.text = c.barcodeValue ?? '';
    _discount.text = c.discountText ?? '';
    _balance.text = c.balance?.toString() ?? '';
    _notes.text = c.notes ?? '';
    _kind = c.kind;
    _format = c.barcodeFormat;
    _currency = c.currency;
    _validFrom = c.validFrom;
    _expiry = c.expiryDate;
    _color = c.color ?? _color;
    _privacy = c.privacy;
    _front = c.frontPhotoPath;
    _back = c.backPhotoPath;
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.of(context).push<ms.Barcode>(MaterialPageRoute(builder: (_) => const BarcodeScanScreen()));
    if (result?.rawValue == null) return;
    setState(() {
      _barcode.text = result!.rawValue!;
      _format = fromScanned(result.format);
      if (_number.text.isEmpty) _number.text = result.displayValue ?? result.rawValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) _load();
    final l = context.l10n;
    Widget photo(String label, String? path, Uint8List? fresh, void Function(Uint8List) set) => Expanded(
          child: InkWell(
            onTap: () async {
              final b = await pickPhotoSheet(context, ref);
              if (b != null) setState(() => set(b));
            },
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.sm),
                child: AspectRatio(aspectRatio: 1.6, child: fresh != null ? Image.memory(fresh, fit: BoxFit.cover) : StorageImage(path: path, placeholderIcon: Icons.add_a_photo_outlined)),
              ),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ]),
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? l.addWalletCard : l.editCard)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          SegmentedButton<WalletCardKind>(
            segments: [for (final k in [WalletCardKind.loyalty, WalletCardKind.discount, WalletCardKind.coupon]) ButtonSegment(value: k, label: Text(walletKindLabel(context, k)), icon: Icon(walletKindIcon(k)))],
            selected: {if ([WalletCardKind.loyalty, WalletCardKind.discount, WalletCardKind.coupon].contains(_kind)) _kind},
            emptySelectionAllowed: true,
            onSelectionChanged: (s) => setState(() => _kind = s.isEmpty ? _kind : s.first),
          ),
          const SizedBox(height: Space.sm),
          Wrap(spacing: Space.sm, children: [
            for (final k in [WalletCardKind.gift, WalletCardKind.membership, WalletCardKind.other])
              ChoiceChip(label: Text(walletKindLabel(context, k)), selected: _kind == k, onSelected: (_) => setState(() => _kind = k)),
          ]),
          const SizedBox(height: Space.lg),
          AppTextField(label: l.cardName, controller: _name, maxLength: 80, validator: (v) => (v ?? '').trim().isEmpty ? l.required : null, helper: l.cardNameHelp),
          fieldGap,
          AppTextField(label: l.issuer, controller: _issuer, maxLength: 120),
          FormSection(title: l.code, children: [
            SecondaryButton(label: l.scanBarcode, icon: Icons.qr_code_scanner, onPressed: _scanBarcode),
            AppTextField(label: l.cardNumber, controller: _number, maxLength: 64, textCapitalization: TextCapitalization.characters),
            AppTextField(label: l.barcodeValue, controller: _barcode, maxLength: 512, textCapitalization: TextCapitalization.none),
            DropdownButtonFormField<BarcodeKind>(
              initialValue: _format,
              decoration: InputDecoration(labelText: l.barcodeFormat),
              items: [for (final f in BarcodeKind.values) DropdownMenuItem(value: f, child: Text(f == BarcodeKind.none ? l.none : f.name.toUpperCase()))],
              onChanged: (v) => setState(() => _format = v ?? BarcodeKind.none),
            ),
          ]),
          if (_kind == WalletCardKind.discount || _kind == WalletCardKind.coupon) ...[AppTextField(label: l.discountText, controller: _discount, maxLength: 200, helper: l.discountHelp), fieldGap],
          if (_kind == WalletCardKind.gift) ...[MoneyField(label: l.balance, amountController: _balance, currency: _currency, onCurrency: (c) => setState(() => _currency = c)), fieldGap],
          DateField(label: l.validFrom, value: _validFrom, onChanged: (v) => setState(() => _validFrom = v)),
          fieldGap,
          DateField(label: l.expiryDate, value: _expiry, onChanged: (v) => setState(() => _expiry = v)),
          fieldGap,
          Text(l.color, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: Space.sm),
          Wrap(spacing: Space.sm, children: [
            for (final c in _cardColors)
              Semantics(
                button: true,
                selected: _color == c,
                label: c,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: cardColor(c), shape: BoxShape.circle, border: Border.all(color: _color == c ? AppColors.accent : Colors.transparent, width: 3)),
                  ),
                ),
              ),
          ]),
          FormSection(title: l.photos, children: [
            Row(children: [
              photo(l.front, _front, _newFront, (b) => _newFront = b),
              const SizedBox(width: Space.md),
              photo(l.back, _back, _newBack, (b) => _newBack = b),
            ]),
          ]),
          AppTextField(label: l.notes, controller: _notes, maxLines: 3, maxLength: 2000),
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
    setState(() => _busy = true);
    final uid = ref.read(uidProvider)!;
    final repo = ref.read(walletRepoProvider);
    final id = widget.id ?? repo.newId();
    String? t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    try {
      final photos = ref.read(photoRepoProvider);
      final front = _newFront != null ? await photos.upload(uid, id, 'front', _newFront!) : _front;
      final back = _newBack != null ? await photos.upload(uid, id, 'back', _newBack!) : _back;
      await repo.save(
        WalletCard(
          id: id,
          ownerUid: uid,
          kind: _kind,
          name: _name.text.trim(),
          privacy: _privacy,
          issuer: t(_issuer),
          cardNumber: t(_number),
          barcodeValue: t(_barcode),
          barcodeFormat: t(_barcode) == null ? BarcodeKind.none : (_format == BarcodeKind.none ? BarcodeKind.code128 : _format),
          discountText: t(_discount),
          balance: parseAmount(_balance.text),
          currency: _currency,
          validFrom: _validFrom,
          expiryDate: _expiry,
          frontPhotoPath: front,
          backPhotoPath: back,
          color: _color,
          notes: t(_notes),
          isFavorite: _existing?.isFavorite ?? false,
          usedAt: _existing?.usedAt,
        ),
        isNew: widget.id == null,
      );
      if (!mounted) return;
      widget.id == null ? context.pushReplacement('/cards/$id') : context.pop();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});
  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  final _controller = ms.MobileScannerController(detectionSpeed: ms.DetectionSpeed.noDuplicates);
  bool _done = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.scanBarcode)),
        body: Stack(children: [
          ms.MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_done) return;
              final b = capture.barcodes.where((b) => b.rawValue != null).firstOrNull;
              if (b == null) return;
              _done = true;
              Navigator.of(context).pop(b);
            },
          ),
          Positioned(
            left: Space.xl,
            right: Space.xl,
            bottom: Space.xxl,
            child: Text(context.l10n.scanBarcodeHelp, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, shadows: [Shadow(blurRadius: 6)])),
          ),
        ]),
      );
}
