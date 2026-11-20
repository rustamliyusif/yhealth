import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typographic tokens for YHealth with tabular digits support.
class AppTypography {
  static const String fontFamily = 'Roboto';

  /// Huge numerical display (e.g., today's step count, big BMI value).
  /// Uses tabular figures to avoid layout jitter during live sensor updates.
  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 44,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
      color: color ?? AppColors.textPrimaryOf(context),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  /// Medium display number (e.g. card headers, key metric values).
  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      color: color ?? AppColors.textPrimaryOf(context),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  /// Screen headline (e.g., section titles, dialog headers).
  static TextStyle headlineMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: color ?? AppColors.textPrimaryOf(context),
    );
  }

  /// Title for card headers and important labels.
  static TextStyle titleMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: color ?? AppColors.textPrimaryOf(context),
    );
  }

  /// Body text for readable content.
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: color ?? AppColors.textSecondaryOf(context),
    );
  }

  /// Small label (e.g. units, timestamps, badges, chart labels).
  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: color ?? AppColors.textMutedOf(context),
    );
  }

  /// Metric unit label (e.g. "km", "kcal", "min").
  static TextStyle unitLabel(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textSecondaryOf(context),
    );
  }
}
