import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/states.dart';
import '../../domain/categories.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/document.dart';

/// Shows AI suggestions next to current values. Nothing is applied until the
/// user confirms; every field can be corrected. Warranty dates are always
/// presented as unconfirmed suggestions.
class ExtractionReviewScreen extends ConsumerStatefulWidget {
  const ExtractionReviewScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ExtractionReviewScreen> createState() => _ExtractionReviewScreenState();
}

class _ExtractionReviewScreenState extends ConsumerState<ExtractionReviewScreen> {
  bool _initialized = false;
  final _title = TextEditingController();
  final _vendor = TextEditingController();
  final _amount = TextEditingController();
  String? _currency;
  String? _category;
  DateTime? _date;
  DateTime? _purchase;
  DateTime? _warranty;
  DateTime? _expiry;
  List<String> _tags = [];
  final Set<String> _accepted = {};
  bool _busy = false;

  void _init(DocumentRecord d, Extraction x) {
    _initialized = true;
    _title.text = x.str('title') ?? d.title;
    _vendor.text = x.str('vendor') ?? d.vendor ?? '';
    _amount.text = (x.num('amount') ?? d.amount)?.toString() ?? '';
    _currency = x.str('currency') ?? d.currency;
    _category = Categories.find(Categories.documents, x.str('suggestedCategory')) != null ? x.str('suggestedCategory') : d.categoryId;
    _date = x.isoDate('documentDate') ?? d.documentDate;
    _purchase = x.isoDate('purchaseDate') ?? d.purchaseDate;
    // Warranty is only pre-filled when explicitly printed; still needs confirmation.
    _warranty = d.warrantyExpiryDate;
    _expiry = x.isoDate('expiryDate') ?? d.expiryDate;
    _tags = {...d.tags, ...((x.fields['suggestedTags'] as List?)?.whereType<String>() ?? const <String>[])}.toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = ref.watch(documentByIdProvider(widget.id));
    final xAsync = ref.watch(extractionProvider(widget.id));
    if (d == null) return Scaffold(appBar: AppBar(), body: const LoadingState());
    return Scaffold(
      appBar: AppBar(title: Text(l.reviewSuggestions)),
      body: asyncView<Extraction?>(xAsync, (x) {
        if (x == null) return EmptyState(icon: Icons.auto_awesome, title: l.noSuggestions, message: l.noSuggestionsBody);
        if (!_initialized) _init(d, x);
        final locale = Localizations.localeOf(context);
        final suggestedWarranty = x.isoDate('warrantyExpiryDate');
        final months = (x.fields['warrantyDurationMonths'] as num?)?.toInt();
        Widget flag(String field) => x.needsReview(field)
            ? Padding(padding: const EdgeInsets.only(bottom: Space.xs), child: Row(children: [const Icon(Icons.info_outline, size: 16, color: AppColors.warning), const SizedBox(width: 4), Text(l.checkThisField, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.warning))]))
            : const SizedBox.shrink();
        return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
          AppCard(
            child: Row(children: [
              const Icon(Icons.auto_awesome, color: AppColors.secondary),
              const SizedBox(width: Space.md),
              Expanded(child: Text(l.reviewIntro((x.confidence * 100).round()))),
            ]),
          ),
          if (x.injectionSuspected) ...[
            const SizedBox(height: Space.md),
            AppCard(child: Text(l.injectionWarning, style: const TextStyle(color: AppColors.warning))),
          ],
          if (x.str('summary') != null) ...[
            SectionHeader(title: l.summary),
            Text(x.str('summary')!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          SectionHeader(title: l.details),
          flag('title'),
          AppTextField(label: l.title, controller: _title, maxLength: 200),
          fieldGap,
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.category),
            items: [for (final c in Categories.documents) DropdownMenuItem(value: c.id, child: Text(c.label.of(locale)))],
            onChanged: (v) => setState(() => _category = v),
          ),
          fieldGap,
          flag('vendor'),
          AppTextField(label: l.vendor, controller: _vendor, maxLength: 200),
          fieldGap,
          flag('amount'),
          MoneyField(label: l.amount, amountController: _amount, currency: _currency, onCurrency: (c) => setState(() => _currency = c)),
          fieldGap,
          flag('documentDate'),
          DateField(label: l.documentDate, value: _date, onChanged: (v) => setState(() => _date = v)),
          fieldGap,
          flag('purchaseDate'),
          DateField(label: l.purchaseDate, value: _purchase, onChanged: (v) => setState(() => _purchase = v)),
          if (x.dateCandidates.length > 1) ...[
            const SizedBox(height: Space.sm),
            Text(l.dateOptions, style: Theme.of(context).textTheme.labelMedium),
            Wrap(spacing: Space.sm, children: [
              for (final c in x.dateCandidates)
                ActionChip(label: Text('${c.label}: ${Fmt.dateShort(context, c.date)}'), onPressed: () => setState(() => _purchase = c.date)),
            ]),
          ],
          fieldGap,
          SectionHeader(title: l.warranty),
          if (suggestedWarranty == null && months == null)
            Text(l.noWarrantyFound, style: Theme.of(context).textTheme.bodySmall)
          else
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.warrantySuggestion, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: Space.xs),
                if (suggestedWarranty != null) Text(l.warrantyPrintedUntil(Fmt.date(context, suggestedWarranty))),
                if (months != null) Text(l.warrantyPrintedMonths(months)),
                const SizedBox(height: Space.sm),
                Text(l.warrantyConfirmHelp, style: Theme.of(context).textTheme.bodySmall),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _accepted.contains('warranty'),
                  title: Text(l.warrantyConfirm),
                  onChanged: (v) => setState(() {
                    if (v == true) {
                      _accepted.add('warranty');
                      _warranty = suggestedWarranty ??
                          (months != null && _purchase != null ? DateTime(_purchase!.year, _purchase!.month + months, _purchase!.day) : null);
                    } else {
                      _accepted.remove('warranty');
                      _warranty = d.warrantyExpiryDate;
                    }
                  }),
                ),
              ]),
            ),
          fieldGap,
          DateField(label: l.warrantyUntil, value: _warranty, onChanged: (v) => setState(() => _warranty = v)),
          fieldGap,
          flag('expiryDate'),
          DateField(label: l.expiryDate, value: _expiry, onChanged: (v) => setState(() => _expiry = v)),
          fieldGap,
          TagsField(tags: _tags, onChanged: (t) => setState(() => _tags = t)),
          const SizedBox(height: Space.xl),
          PrimaryButton(label: l.confirmAndSave, loading: _busy, onPressed: () => _save(d)),
          const SizedBox(height: Space.sm),
          TextButton(
            onPressed: () async {
              await ref.read(documentRepoProvider).patch(d.id, {'processingStatus': 'ready'});
              if (context.mounted) context.pop();
            },
            child: Text(l.ignoreSuggestions),
          ),
        ]);
      }),
    );
  }

  Future<void> _save(DocumentRecord d) async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      await ref.read(documentRepoProvider).patch(d.id, {
        'title': _title.text.trim().isEmpty ? d.title : _title.text.trim(),
        'categoryId': _category,
        'vendor': _vendor.text.trim().isEmpty ? null : _vendor.text.trim(),
        'amount': parseAmount(_amount.text),
        'currency': _currency,
        'documentDate': _date,
        'purchaseDate': _purchase,
        'warrantyExpiryDate': _warranty,
        'expiryDate': _expiry,
        'tags': _tags,
        'processingStatus': 'ready',
      });
      if (!mounted) return;
      showSuccess(context, l.saved);
      // Offer a reminder only for a date the user just confirmed.
      final due = _warranty ?? _expiry;
      if (due != null && due.isAfter(DateTime.now())) {
        final go = await confirmDialog(context, title: l.createReminder, message: l.offerReminderBody(Fmt.date(context, due)), confirmLabel: l.createReminder);
        if (go && mounted) {
          context.pushReplacement(Uri(path: '/reminders/new', queryParameters: {
            'doc': d.id,
            'title': _warranty != null ? l.warrantyExpiresTitle(_title.text) : l.documentExpiresTitle(_title.text),
            'due': due.toIso8601String(),
            'kind': _warranty != null ? 'warranty' : 'document',
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
