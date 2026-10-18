import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/logic/validation.dart';
import '../../domain/models/common.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';

const fieldGap = SizedBox(height: Space.md);

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.helper,
    this.obscure = false,
    this.autofill,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLength,
    this.onChanged,
    this.suffix,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? helper;
  final bool obscure;
  final Iterable<String>? autofill;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final bool enabled;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: obscure ? 1 : maxLines,
        obscureText: obscure,
        autofillHints: autofill,
        textCapitalization: textCapitalization,
        maxLength: maxLength,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(labelText: label, helperText: helper, suffixIcon: suffix, counterText: ''),
      );
}

/// Date picker field; clearable.
class DateField extends StatelessWidget {
  const DateField({super.key, required this.label, required this.value, required this.onChanged, this.firstDate, this.lastDate, this.withTime = false, this.helper});
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool withTime;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final text = value == null ? '' : (withTime ? Fmt.dateTime(context, value) : Fmt.date(context, value));
    return Semantics(
      button: true,
      label: '$label ${text.isEmpty ? context.l10n.notSet : text}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.sm),
        onTap: () async {
          final now = DateTime.now();
          final d = await showDatePicker(
            context: context,
            initialDate: value ?? now,
            firstDate: firstDate ?? DateTime(1950),
            lastDate: lastDate ?? DateTime(now.year + 40),
          );
          if (d == null || !context.mounted) return;
          if (!withTime) return onChanged(d);
          final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(value ?? DateTime(now.year, now.month, now.day, 9)));
          onChanged(DateTime(d.year, d.month, d.day, t?.hour ?? 9, t?.minute ?? 0));
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            helperText: helper,
            suffixIcon: value == null
                ? const Icon(Icons.calendar_today_outlined, size: 20)
                : IconButton(tooltip: context.l10n.clear, icon: const Icon(Icons.close, size: 20), onPressed: () => onChanged(null)),
          ),
          isEmpty: value == null,
          child: Text(text),
        ),
      ),
    );
  }
}

/// Amount + explicit currency (currency is never assumed from the language).
class MoneyField extends StatelessWidget {
  const MoneyField({super.key, required this.label, required this.amountController, required this.currency, required this.onCurrency});
  final String label;
  final TextEditingController amountController;
  final String? currency;
  final ValueChanged<String?> onCurrency;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: label),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              if (parseAmount(v) == null) return context.l10n.invalidAmount;
              if (currency == null) return context.l10n.chooseCurrency;
              return null;
            },
          ),
        ),
        const SizedBox(width: Space.sm),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            initialValue: currency,
            isExpanded: true,
            decoration: InputDecoration(labelText: context.l10n.currency),
            items: [for (final c in {...commonCurrencies, ?currency}) DropdownMenuItem(value: c, child: Text(c))],
            onChanged: onCurrency,
          ),
        ),
      ]);
}

/// Privacy selector: private / shared with selected members / family.
class PrivacySelector extends ConsumerWidget {
  const PrivacySelector({super.key, required this.value, required this.onChanged});
  final Privacy value;
  final ValueChanged<Privacy> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final fid = ref.watch(familyIdProvider);
    final uid = ref.watch(uidProvider);
    final members = (ref.watch(familyMembersProvider).value ?? const []).where((m) => m.uid != uid).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l.privacy, style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: Space.sm),
      SegmentedButton<PrivacyLevel>(
        segments: [
          ButtonSegment(value: PrivacyLevel.private, icon: const Icon(Icons.lock_outline), label: Text(l.privacyPrivate)),
          ButtonSegment(value: PrivacyLevel.shared, icon: const Icon(Icons.group_outlined), label: Text(l.privacyShared), enabled: fid != null),
          ButtonSegment(value: PrivacyLevel.family, icon: const Icon(Icons.family_restroom), label: Text(l.privacyFamily), enabled: fid != null),
        ],
        selected: {value.level},
        onSelectionChanged: (s) => onChanged(Privacy(level: s.first, familyId: s.first == PrivacyLevel.private ? null : fid, sharedWith: s.first == PrivacyLevel.shared ? value.sharedWith : const [])),
        showSelectedIcon: false,
      ),
      const SizedBox(height: Space.xs),
      Text(
        switch (value.level) {
          PrivacyLevel.private => l.privacyPrivateHelp,
          PrivacyLevel.shared => l.privacySharedHelp,
          PrivacyLevel.family => l.privacyFamilyHelp,
        },
        style: Theme.of(context).textTheme.bodySmall,
      ),
      if (fid == null) Text(l.privacyNoFamilyHelp, style: Theme.of(context).textTheme.bodySmall),
      if (value.level == PrivacyLevel.shared)
        Wrap(spacing: Space.sm, children: [
          for (final m in members)
            FilterChip(
              label: Text(m.displayName ?? l.member),
              selected: value.sharedWith.contains(m.uid),
              onSelected: (on) => onChanged(value.copyWith(
                  sharedWith: on ? [...value.sharedWith, m.uid] : value.sharedWith.where((x) => x != m.uid).toList())),
            ),
        ]),
    ]);
  }
}

/// Tag input as chips.
class TagsField extends StatefulWidget {
  const TagsField({super.key, required this.tags, required this.onChanged});
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _add() {
    final t = _c.text.trim().toLowerCase();
    if (t.isEmpty || widget.tags.contains(t) || widget.tags.length >= 30) return;
    widget.onChanged([...widget.tags, t]);
    _c.clear();
  }

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: _c,
          decoration: InputDecoration(labelText: context.l10n.tags, suffixIcon: IconButton(tooltip: context.l10n.add, onPressed: _add, icon: const Icon(Icons.add))),
          onSubmitted: (_) => _add(),
        ),
        if (widget.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: Space.sm),
            child: Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
              for (final t in widget.tags) InputChip(label: Text(t), onDeleted: () => widget.onChanged(widget.tags.where((x) => x != t).toList())),
            ]),
          ),
      ]);
}

class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Space.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Semantics(header: true, child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
          const SizedBox(height: Space.md),
          for (final c in children) ...[c, fieldGap],
        ]),
      );
}
