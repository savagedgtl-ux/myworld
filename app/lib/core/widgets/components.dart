import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/logic/reminders.dart';
import '../../domain/models/account.dart';
import '../../domain/models/document.dart';
import '../../domain/models/entities.dart';
import '../../domain/plans.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key, this.hint, this.onTap, this.controller, this.onChanged, this.autofocus = false, this.trailing});

  final String? hint;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final readOnly = onTap != null;
    return Semantics(
      textField: !readOnly,
      button: readOnly,
      label: hint ?? context.l10n.searchHint,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.lg),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 54),
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Radii.lg), boxShadow: Shadows.soft),
            child: Row(children: [
              Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: Space.md),
              Expanded(
                child: readOnly
                    ? Text(hint ?? context.l10n.searchHint, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))
                    : TextField(
                        controller: controller,
                        onChanged: onChanged,
                        autofocus: autofocus,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: hint ?? context.l10n.searchHint,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
              ),
              ?trailing,
            ]),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Space.xl, bottom: Space.md),
        child: Row(children: [
          Expanded(child: Semantics(header: true, child: Text(title, style: Theme.of(context).textTheme.titleLarge))),
          if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ]),
      );
}

/// White card with soft shadow.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(Space.lg), this.semanticLabel});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
        button: onTap != null,
        label: semanticLabel,
        child: Container(
          decoration: BoxDecoration(boxShadow: Shadows.soft, borderRadius: BorderRadius.circular(Radii.md)),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Radii.md),
            clipBehavior: Clip.antiAlias,
            child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
          ),
        ),
      );
}

/// Neutral placeholder used when a user hasn't added a photo. We never use
/// stock photos that could look like the user's real data.
class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({super.key, required this.icon, this.size});
  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.surfaceContainerHighest, cs.surfaceContainerHighest.withValues(alpha: 0.55)],
        ),
      ),
      child: Center(child: Icon(icon, size: size ?? 40, color: AppColors.secondary.withValues(alpha: 0.75))),
    );
  }
}

/// Loads a private image through the Storage SDK (rules-checked), in memory only.
class StorageImage extends ConsumerWidget {
  const StorageImage({super.key, required this.path, required this.placeholderIcon, this.fit = BoxFit.cover});
  final String? path;
  final IconData placeholderIcon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path == null) return PhotoPlaceholder(icon: placeholderIcon);
    return FutureBuilder<Uint8List>(
      future: ref.read(storageServiceProvider).download(path!),
      builder: (context, snap) {
        if (snap.hasData) return Image.memory(snap.data!, fit: fit, gaplessPlayback: true, excludeFromSemantics: true);
        return PhotoPlaceholder(icon: placeholderIcon);
      },
    );
  }
}

class WorldCategoryCard extends StatelessWidget {
  const WorldCategoryCard({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap, this.photoPath, this.locked = false, this.color});

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? photoPath;
  final bool locked;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '$title. $subtitle${locked ? '. ${context.l10n.lockedFeature}' : ''}',
      excludeSemantics: true,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Radii.lg), boxShadow: Shadows.soft),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                child: Stack(fit: StackFit.expand, children: [
                  photoPath != null ? StorageImage(path: photoPath, placeholderIcon: icon) : PhotoPlaceholder(icon: icon, size: 44),
                  if (locked)
                    Positioned(
                      top: Space.sm,
                      right: Space.sm,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
                        child: const Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.md, Space.md, Space.md, Space.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitle, style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

IconData fileIcon(DocumentRecord d) => d.isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined;

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final ProcessingStatus status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, color) = switch (status) {
      ProcessingStatus.draft => (l.statusDraft, AppColors.textSecondary),
      ProcessingStatus.uploading => (l.statusUploading, AppColors.secondary),
      ProcessingStatus.uploaded => (l.statusUploaded, AppColors.secondary),
      ProcessingStatus.processing => (l.statusProcessing, AppColors.secondary),
      ProcessingStatus.needsReview => (l.statusNeedsReview, AppColors.warning),
      ProcessingStatus.ready => (l.statusReady, AppColors.success),
      ProcessingStatus.failed => (l.statusFailed, AppColors.error),
    };
    if (status == ProcessingStatus.ready) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class DocumentListItem extends StatelessWidget {
  const DocumentListItem({super.key, required this.document, required this.onTap, this.categoryLabel, this.trailing});
  final DocumentRecord document;
  final VoidCallback onTap;
  final String? categoryLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final d = document;
    final t = Theme.of(context).textTheme;
    final date = d.documentDate ?? d.purchaseDate ?? d.createdAt;
    return Semantics(
      button: true,
      label: '${d.title}, ${categoryLabel ?? ''}, ${Fmt.date(context, date)}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.md, horizontal: Space.xs),
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(Radii.sm)),
              child: Icon(fileIcon(d), color: d.isPdf ? AppColors.error : AppColors.secondary),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: Text(d.title, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (d.isFavorite) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.star_rounded, size: 16, color: AppColors.warning)),
                  if (d.privacy.level.name != 'private')
                    Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.people_alt_outlined, size: 15, color: t.bodySmall?.color)),
                ]),
                const SizedBox(height: 2),
                Text([if (categoryLabel != null && categoryLabel!.isNotEmpty) categoryLabel, Fmt.date(context, date)].join(' · '),
                    style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            const SizedBox(width: Space.sm),
            StatusChip(status: d.processingStatus),
            ?trailing,
          ]),
        ),
      ),
    );
  }
}

class DocumentGridCard extends StatelessWidget {
  const DocumentGridCard({super.key, required this.document, required this.onTap});
  final DocumentRecord document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        semanticLabel: document.title,
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(fileIcon(document), size: 28, color: document.isPdf ? AppColors.error : AppColors.secondary),
          const Spacer(),
          Text(document.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(Fmt.date(context, document.createdAt), style: Theme.of(context).textTheme.bodySmall),
        ]),
      );
}

class AssetCard extends StatelessWidget {
  const AssetCard({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap, this.photoPath, this.badge});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? photoPath;
  final Widget? badge;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        semanticLabel: '$title. $subtitle',
        padding: EdgeInsets.zero,
        child: Row(children: [
          SizedBox(width: 84, height: 84, child: StorageImage(path: photoPath, placeholderIcon: icon)),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
          if (badge != null) Padding(padding: const EdgeInsets.only(right: Space.md), child: badge),
          const Padding(padding: EdgeInsets.only(right: Space.sm), child: Icon(Icons.chevron_right_rounded)),
        ]),
      );
}

class FamilyMemberCard extends StatelessWidget {
  const FamilyMemberCard({super.key, required this.name, required this.subtitle, required this.onTap, this.photoPath, this.role});
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  final String? photoPath;
  final String? role;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        semanticLabel: '$name, $subtitle',
        padding: const EdgeInsets.all(Space.md),
        child: Row(children: [
          ClipOval(child: SizedBox(width: 52, height: 52, child: StorageImage(path: photoPath, placeholderIcon: Icons.person_outline))),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name.isEmpty ? '—' : name, style: Theme.of(context).textTheme.titleSmall),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
          if (role != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(20)),
              child: Text(role!, style: Theme.of(context).textTheme.labelSmall),
            ),
        ]),
      );
}

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key, required this.reminder, required this.onTap, this.linkedLabel});
  final Reminder reminder;
  final VoidCallback onTap;
  final String? linkedLabel;

  @override
  Widget build(BuildContext context) {
    final state = dueState(reminder.dueAt);
    final color = switch (state) {
      DueState.overdue => AppColors.error,
      DueState.today || DueState.soon => AppColors.warning,
      DueState.later => AppColors.accent,
    };
    final l = context.l10n;
    final status = switch (state) {
      DueState.overdue => l.overdue,
      DueState.today => l.today,
      _ => Fmt.relativeDays(context, reminder.dueAt),
    };
    return AppCard(
      onTap: onTap,
      semanticLabel: '${reminder.title}, ${Fmt.date(context, reminder.dueAt)}, $status',
      padding: const EdgeInsets.all(Space.md),
      child: Row(children: [
        Container(width: 4, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(reminder.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text([Fmt.date(context, reminder.dueAt), ?linkedLabel].join(' · '), style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
        Text(status, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class StorageUsageCard extends StatelessWidget {
  const StorageUsageCard({super.key, required this.usage, required this.entitlement, this.onTap, this.compact = true});
  final Usage usage;
  final Entitlement entitlement;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ratio = usage.storageRatio(entitlement);
    final color = ratio > 0.9 ? AppColors.error : ratio > 0.75 ? AppColors.warning : AppColors.accent;
    final l = context.l10n;
    final text = l.storageUsed(Fmt.bytes(context, usage.storageUsedBytes), Fmt.bytes(context, entitlement.storageLimitBytes));
    return AppCard(
      onTap: onTap,
      semanticLabel: text,
      padding: EdgeInsets.all(compact ? Space.md : Space.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.cloud_outlined, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ]),
        const SizedBox(height: Space.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: ratio, minHeight: 6, color: color, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
        ),
        if (!compact) ...[
          const SizedBox(height: Space.sm),
          Text(l.documentsUsed(usage.activeDocumentCount, entitlement.maxDocuments), style: Theme.of(context).textTheme.bodySmall),
        ],
      ]),
    );
  }
}

String planName(BuildContext context, PlanId p) => switch (p) {
      PlanId.individualBase => context.l10n.planIndividualBase,
      PlanId.individualPro => context.l10n.planIndividualPro,
      PlanId.familyBase => context.l10n.planFamilyBase,
      PlanId.familyPro => context.l10n.planFamilyPro,
    };

class PlanBadge extends StatelessWidget {
  const PlanBadge({super.key, required this.plan});
  final PlanId plan;

  @override
  Widget build(BuildContext context) {
    final pro = plan == PlanId.individualPro || plan == PlanId.familyPro;
    final bg = pro ? AppColors.primary : Theme.of(context).colorScheme.surfaceContainerHighest;
    final fg = pro ? Colors.white : Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (pro) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.auto_awesome, size: 13, color: Colors.white)),
        Text(planName(context, plan), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class FilterChips<T> extends StatelessWidget {
  const FilterChips({super.key, required this.options, required this.selected, required this.labelOf, required this.onToggle});
  final List<T> options;
  final Set<T> selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (final o in options)
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: FilterChip(label: Text(labelOf(o)), selected: selected.contains(o), onSelected: (_) => onToggle(o)),
            ),
        ]),
      );
}

Future<bool> confirmDialog(BuildContext context, {required String title, required String message, required String confirmLabel, bool destructive = false}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.cancel)),
        TextButton(
          onPressed: () => Navigator.pop(c, true),
          style: destructive ? TextButton.styleFrom(foregroundColor: AppColors.error) : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return r == true;
}

/// Read-only labelled value row used on detail screens.
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value, this.icon, this.onTap});
  final String label;
  final String? value;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return MergeSemantics(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: icon == null ? null : Icon(icon),
        title: Text(label, style: Theme.of(context).textTheme.labelMedium),
        subtitle: Text(value!, style: Theme.of(context).textTheme.bodyLarge),
        onTap: onTap,
      ),
    );
  }
}
