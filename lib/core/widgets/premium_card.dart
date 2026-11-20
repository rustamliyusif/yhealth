import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

/// An elegant, reusable premium card with micro-borders, subtle shadows,
/// and smooth ink response.
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final Color? color;
  final Border? border;
  final bool showShadow;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.borderRadius,
    this.gradient,
    this.color,
    this.border,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppDecorations.radiusXl;
    final effectiveBorder = border ??
        Border.all(
          color: AppColors.borderOf(context),
          width: 1.0,
        );

    final decoration = BoxDecoration(
      color: gradient == null ? (color ?? AppColors.surfaceOf(context)) : null,
      gradient: gradient,
      borderRadius: effectiveRadius,
      border: effectiveBorder,
      boxShadow: showShadow ? AppDecorations.cardShadow(context) : null,
    );

    if (onTap != null) {
      return Container(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveRadius,
            splashColor: AppColors.primaryAccentOf(context).withValues(alpha: 0.1),
            highlightColor: AppColors.primaryAccentOf(context).withValues(alpha: 0.05),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}
