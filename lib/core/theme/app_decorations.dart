import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable decoration tokens, borders, and shadows for YHealth Phase 6.
class AppDecorations {
  // Border Radii
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(14));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusRound = BorderRadius.all(Radius.circular(999));

  // Subtle Card Shadow
  static List<BoxShadow> cardShadow(BuildContext context) {
    final isDark = AppColors.isDark(context);
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
    }
  }

  // Emerald Glow Shadow (for hero buttons, active progress rings)
  static List<BoxShadow> emeraldGlow({double alpha = 0.25, double blur = 16}) {
    return [
      BoxShadow(
        color: AppColors.primaryAccent.withValues(alpha: alpha),
        blurRadius: blur,
        offset: const Offset(0, 4),
      ),
    ];
  }

  // Premium Card Box Decoration
  static BoxDecoration cardDecoration(
    BuildContext context, {
    Color? surfaceColor,
    BorderRadius? borderRadius,
    Border? border,
    bool showShadow = true,
  }) {
    return BoxDecoration(
      color: surfaceColor ?? AppColors.surfaceOf(context),
      borderRadius: borderRadius ?? radiusXl,
      border: border ??
          Border.all(
            color: AppColors.borderOf(context),
            width: 1.0,
          ),
      boxShadow: showShadow ? cardShadow(context) : null,
    );
  }

  // Pill Badge Decoration
  static BoxDecoration pillDecoration(
    BuildContext context, {
    required Color color,
    double bgAlpha = 0.12,
    double borderAlpha = 0.28,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: bgAlpha),
      borderRadius: radiusRound,
      border: Border.all(
        color: color.withValues(alpha: borderAlpha),
        width: 1.0,
      ),
    );
  }
}
