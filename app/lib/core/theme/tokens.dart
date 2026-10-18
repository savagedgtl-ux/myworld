import 'package:flutter/material.dart';

/// Design tokens. All colors, spacing and radii live here — widgets never
/// hardcode raw values.
abstract final class AppColors {
  static const primary = Color(0xFF173B57);
  static const secondary = Color(0xFF4A90C6);
  static const surfaceTint = Color(0xFFEAF4FA);
  static const accent = Color(0xFF56B8B0);
  static const background = Color(0xFFF7F8FA);
  static const card = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF172B3A);
  static const textSecondary = Color(0xFF687784);
  static const divider = Color(0xFFE4EAF0);
  static const warning = Color(0xFFE9A23B);
  static const error = Color(0xFFC94D4D);
  static const success = Color(0xFF31856A);

  // Dark scheme counterparts (derived for contrast).
  static const darkBackground = Color(0xFF0F1A23);
  static const darkCard = Color(0xFF172632);
  static const darkTextPrimary = Color(0xFFE8EEF3);
  static const darkTextSecondary = Color(0xFFA3B1BD);
  static const darkDivider = Color(0xFF263845);
}

abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const gutter = 20.0;
}

abstract final class Radii {
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 22.0;
  static const xl = 28.0;
}

abstract final class Shadows {
  static const soft = [
    BoxShadow(color: Color(0x14173B57), blurRadius: 18, offset: Offset(0, 6)),
  ];
}

abstract final class Motion {
  static const fast = Duration(milliseconds: 160);
  static const normal = Duration(milliseconds: 240);

  /// Honors the OS "reduce motion" setting.
  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.maybeDisableAnimationsOf(context) == true ? Duration.zero : d;
}

/// Minimum touch target (Material + Apple HIG).
const double kMinTouch = 48;
