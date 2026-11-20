import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yhealth/core/theme/app_colors.dart';
import 'package:yhealth/core/theme/app_decorations.dart';
import 'package:yhealth/core/theme/app_typography.dart';
import 'package:yhealth/core/theme/app_theme.dart';
import 'package:yhealth/core/widgets/yhealth_logo.dart';
import 'package:yhealth/core/widgets/premium_card.dart';
import 'package:yhealth/core/widgets/vital_metric_tile.dart';
import 'package:yhealth/core/widgets/premium_button.dart';
import 'package:yhealth/features/dashboard/widgets/circular_step_progress.dart';
import 'package:yhealth/features/dashboard/widgets/stat_card.dart';
import 'package:yhealth/features/dashboard/widgets/daily_goal_card.dart';
import 'package:yhealth/features/dashboard/widgets/weekly_step_bar_chart.dart';
import 'package:yhealth/features/health/widgets/bmi_gauge_widget.dart';

void main() {
  group('Phase 6 - Design Tokens & Visual Identity', () {
    test('AppColors verifies forest green and radiant emerald identity', () {
      expect(AppColors.primary, const Color(0xFF1E563E)); // Forest Pine
      expect(AppColors.primaryAccent, const Color(0xFF10B981)); // Radiant Emerald
      expect(AppColors.darkBackground, const Color(0xFF0D1410)); // Obsidian Forest
      expect(AppColors.darkSurface, const Color(0xFF15201A));
      expect(AppColors.darkPrimary, const Color(0xFF10B981));
      expect(AppColors.accentSteps, const Color(0xFF10B981));
      expect(AppColors.accentDistance, const Color(0xFF2563EB));
      expect(AppColors.accentCalories, const Color(0xFFF97316));
      expect(AppColors.accentSleep, const Color(0xFF6366F1));
      expect(AppColors.accentCoach, const Color(0xFF9333EA));
    });

    test('AppColors provides premium gradients', () {
      expect(AppColors.emeraldGradient.colors.length, 2);
      expect(AppColors.forestEmeraldGradient.colors.length, 2);
      expect(AppColors.sleepGradient.colors.length, 2);
      expect(AppColors.coachGradient.colors.length, 2);
      expect(AppColors.caloriesGradient.colors.length, 2);
    });

    test('AppDecorations defines standard border radii and shadows', () {
      expect(AppDecorations.radiusSm.topLeft.x, 8);
      expect(AppDecorations.radiusMd.topLeft.x, 14);
      expect(AppDecorations.radiusLg.topLeft.x, 20);
      expect(AppDecorations.radiusXl.topLeft.x, 24);
      expect(AppDecorations.radiusRound.topLeft.x, 999);

      final glow = AppDecorations.emeraldGlow(alpha: 0.3, blur: 16);
      expect(glow.isNotEmpty, isTrue);
      expect(glow.first.blurRadius, 16);
    });

    testWidgets('AppTypography configures tabular figures for live metrics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final styleLarge = AppTypography.displayLarge(context);
              final styleMedium = AppTypography.displayMedium(context);
              expect(styleLarge.fontFeatures?.contains(const FontFeature.tabularFigures()), isTrue);
              expect(styleMedium.fontFeatures?.contains(const FontFeature.tabularFigures()), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('AppTheme delivers coherent Light and Dark themes', () {
      final light = AppTheme.lightTheme;
      final dark = AppTheme.darkTheme;

      expect(light.brightness, Brightness.light);
      expect(light.primaryColor, AppColors.primary);
      expect(light.scaffoldBackgroundColor, AppColors.background);

      expect(dark.brightness, Brightness.dark);
      expect(dark.primaryColor, AppColors.darkPrimary);
      expect(dark.scaffoldBackgroundColor, AppColors.darkBackground);
    });
  });

  group('Phase 6 - Reusable UI Components & Branding', () {
    testWidgets('YHealthLogo renders VITA-Y Monogram correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: YHealthLogo(
                size: 80,
                showContainer: true,
                isDark: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(YHealthLogo), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('PremiumCard renders with content and responds to onTap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              onTap: () => tapped = true,
              child: const Text('Premium Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Premium Card Content'), findsOneWidget);
      await tester.tap(find.text('Premium Card Content'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('VitalMetricTile renders formatted metric and icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VitalMetricTile(
              title: 'Distance',
              value: '5.42',
              unit: 'km',
              icon: Icons.route_rounded,
              iconColor: AppColors.accentDistance,
            ),
          ),
        ),
      );

      expect(find.text('Distance'), findsOneWidget);
      expect(find.text('5.42'), findsOneWidget);
      expect(find.text('km'), findsOneWidget);
      expect(find.byIcon(Icons.route_rounded), findsOneWidget);
    });

    testWidgets('PremiumButton renders label, icon, and handles click', (tester) async {
      bool clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumButton(
              onPressed: () => clicked = true,
              label: 'Start Walk',
              icon: Icons.play_arrow_rounded,
            ),
          ),
        ),
      );

      expect(find.text('Start Walk'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      await tester.tap(find.text('Start Walk'));
      expect(clicked, isTrue);
    });
  });

  group('Phase 6 - Dashboard & Health Visualizations', () {
    testWidgets('CircularStepProgress renders daily steps and goal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularStepProgress(
              currentSteps: 7500,
              goalSteps: 10000,
              stepsLabel: 'Steps',
              goalLabel: 'Goal: 10,000',
            ),
          ),
        ),
      );

      expect(find.text('7,500'), findsOneWidget);
      expect(find.text('Steps'), findsOneWidget);
      expect(find.textContaining('75%'), findsOneWidget);
      expect(find.byIcon(Icons.directions_walk_rounded), findsOneWidget);
    });

    testWidgets('CircularStepProgress renders flame icon on goal achievement', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularStepProgress(
              currentSteps: 12000,
              goalSteps: 10000,
              stepsLabel: 'Steps',
              goalLabel: 'Goal: 10,000',
            ),
          ),
        ),
      );

      expect(find.text('12,000'), findsOneWidget);
      expect(find.textContaining('100%'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('StatCard renders distance, calories, or duration cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              title: 'Calories',
              value: '450',
              unit: 'kcal',
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.accentCalories,
              iconBgColor: Color(0x1AF97316),
            ),
          ),
        ),
      );

      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('450'), findsOneWidget);
      expect(find.text('kcal'), findsOneWidget);
    });

    testWidgets('DailyGoalCard renders 4 goals with progress bars', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyGoalCard(
              title: 'Daily Goals',
              currentSteps: 8000,
              goalSteps: 10000,
              currentCalories: 400,
              goalCalories: 500,
              currentDistanceKm: 6.0,
              goalDistanceKm: 8.0,
              currentActiveMinutes: 45,
              goalActiveMinutes: 60,
              stepsLabel: 'Steps',
              caloriesLabel: 'Calories',
              distanceLabel: 'Distance',
              activeTimeLabel: 'Active Time',
              kmUnit: 'km',
              kcalUnit: 'kcal',
              minUnit: 'min',
            ),
          ),
        ),
      );

      expect(find.text('Daily Goals'), findsOneWidget);
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('Distance'), findsOneWidget);
      expect(find.text('Active Time'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(4));
    });

    testWidgets('WeeklyStepBarChart renders 7 days of activity', (tester) async {
      final history = {
        '2026-11-02': 7000,
        '2026-11-03': 8500,
        '2026-11-04': 9200,
        '2026-11-05': 10500,
        '2026-11-06': 6500,
        '2026-11-07': 8000,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeeklyStepBarChart(
              history: history,
              todaySteps: 9500,
              goalSteps: 10000,
              title: 'Weekly Overview',
            ),
          ),
        ),
      );

      expect(find.text('Weekly Overview'), findsOneWidget);
      expect(find.byType(FractionallySizedBox), findsNWidgets(7));
    });

    testWidgets('BmiGaugeWidget renders spectrum bands and indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BmiGaugeWidget(
              bmi: 22.5,
              progress: 0.45,
            ),
          ),
        ),
      );

      expect(find.byType(BmiGaugeWidget), findsOneWidget);
      expect(find.text('18.5'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_up_rounded), findsOneWidget);
    });
  });
}
