import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon, this.loading = false, this.expand = true});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: Space.sm)],
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          ]);
    final btn = FilledButton(onPressed: loading ? null : onPressed, child: child);
    return Semantics(button: true, enabled: onPressed != null && !loading, label: label, excludeSemantics: true,
        child: expand ? SizedBox(width: double.infinity, child: btn) : btn);
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, required this.onPressed, this.icon, this.expand = true, this.destructive = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : null;
    final btn = OutlinedButton(
      onPressed: onPressed,
      style: color == null ? null : OutlinedButton.styleFrom(foregroundColor: color, side: BorderSide(color: color.withValues(alpha: 0.5))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: Space.sm)],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ]),
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
