import 'package:flutter/material.dart';

/// YHealth calming minimalist color palette with full Light and Dark mode specifications.
/// Modernized in Phase 6 with premium forest green and vibrant emerald identity tokens.
class AppColors {
  // --- LIGHT PALETTE ---
  // Primary Greens
  static const Color primary = Color(0xFF1E563E); // Deep Forest Pine
  static const Color primaryDark = Color(0xFF133B2A);
  static const Color primaryLight = Color(0xFFEAF5EE);
  static const Color primaryContainer = Color(0xFFD4EDE0);
  static const Color primaryAccent = Color(0xFF10B981); // Radiant Emerald

  // Backgrounds & Neutrals
  static const Color background = Color(0xFFF7FAF8); // Ultra-calm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F6F3);
  static const Color border = Color(0xFFE2EBE5);
  static const Color borderLight = Color(0xFFEDF3EF);
  static const Color divider = Color(0xFFE9EFEA);

  // Typography Neutrals
  static const Color textPrimary = Color(0xFF131D18); // Charcoal forest
  static const Color textSecondary = Color(0xFF56665E); // Cool sage gray
  static const Color textMuted = Color(0xFF8FA398);

  // --- DARK PALETTE ---
  static const Color darkBackground = Color(0xFF0D1410); // Deep obsidian forest
  static const Color darkSurface = Color(0xFF15201A); // Elevated charcoal-emerald surface
  static const Color darkSurfaceElevated = Color(0xFF1B2B22); // High-elevation card surface
  static const Color darkSurfaceMuted = Color(0xFF1A2620);
  static const Color darkBorder = Color(0xFF26382E);
  static const Color darkBorderLight = Color(0xFF1F2E25);
  static const Color darkDivider = Color(0xFF1F2E26);

  static const Color darkTextPrimary = Color(0xFFF5FAF7); // Crisp luminous white
  static const Color darkTextSecondary = Color(0xFF9EABA3); // Light sage gray
  static const Color darkTextMuted = Color(0xFF6B7B72);

  static const Color darkPrimary = Color(0xFF10B981); // Vibrant vital emerald
  static const Color darkPrimaryDark = Color(0xFF059669);
  static const Color darkPrimaryLight = Color(0xFF1E4233);
  static const Color darkPrimaryContainer = Color(0xFF132B20);
  static const Color darkPrimaryAccent = Color(0xFF34D399); // Neon mint

  // --- COMMON METRIC ACCENT TONES ---
  static const Color accentSteps = Color(0xFF10B981); // Vital green
  static const Color accentDistance = Color(0xFF2563EB); // Oceanic blue
  static const Color accentCalories = Color(0xFFF97316); // Warm coral fire
  static const Color accentTime = Color(0xFF8B5CF6); // Soft purple
  static const Color accentSleep = Color(0xFF6366F1); // Twilight Indigo
  static const Color accentCoach = Color(0xFF9333EA); // Royal Purple

  // BMI Status Colors
  static const Color bmiUnderweight = Color(0xFF38BDF8); // Light Blue
  static const Color bmiNormal = Color(0xFF10B981); // Emerald Vital
  static const Color bmiOverweight = Color(0xFFF59E0B); // Amber
  static const Color bmiObese = Color(0xFFEF4444); // Crimson

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // --- PREMIUM GRADIENTS ---
  /// Radiant emerald hero gradient (used in buttons, key progress rings)
  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );

  /// Deep forest to emerald gradient
  static const LinearGradient forestEmeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A4D36),
      Color(0xFF10B981),
    ],
  );

  /// Twilight sleep card gradient
  static const LinearGradient sleepGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B), // Midnight Indigo
      Color(0xFF0F172A), // Dark Slate
    ],
  );

  /// Coach Leo metabolic gradient
  static const LinearGradient coachGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF581C87), // Deep Violet
      Color(0xFF1E3A8A), // Midnight Blue
    ],
  );

  /// Calories flame gradient
  static const LinearGradient caloriesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF97316),
      Color(0xFFFB923C),
    ],
  );

  // --- DYNAMIC HELPERS ---
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundOf(BuildContext context) =>
      isDark(context) ? darkBackground : background;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? darkSurface : surface;

  static Color surfaceElevatedOf(BuildContext context) =>
      isDark(context) ? darkSurfaceElevated : surfaceElevated;

  static Color surfaceMutedOf(BuildContext context) =>
      isDark(context) ? darkSurfaceMuted : surfaceMuted;

  static Color borderOf(BuildContext context) =>
      isDark(context) ? darkBorder : border;

  static Color borderLightOf(BuildContext context) =>
      isDark(context) ? darkBorderLight : borderLight;

  static Color dividerOf(BuildContext context) =>
      isDark(context) ? darkDivider : divider;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? darkTextPrimary : textPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? darkTextSecondary : textSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? darkTextMuted : textMuted;

  static Color primaryOf(BuildContext context) =>
      isDark(context) ? darkPrimary : primary;

  static Color primaryContainerOf(BuildContext context) =>
      isDark(context) ? darkPrimaryContainer : primaryContainer;

  static Color primaryLightOf(BuildContext context) =>
      isDark(context) ? darkPrimaryLight : primaryLight;

  static Color primaryAccentOf(BuildContext context) =>
      isDark(context) ? darkPrimaryAccent : primaryAccent;

  /// Dynamic card gradient (subtle elevation shimmer)
  static LinearGradient cardGradientOf(BuildContext context) {
    if (isDark(context)) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF18241E),
          Color(0xFF131D18),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF9FBF9),
        ],
      );
    }
  }
}
