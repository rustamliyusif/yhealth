import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yhealth/core/theme/app_colors.dart';
import 'package:yhealth/core/theme/app_theme.dart';
import 'package:yhealth/core/widgets/yhealth_logo.dart';
import 'package:yhealth/core/widgets/vital_metric_tile.dart';
import 'package:yhealth/features/dashboard/widgets/circular_step_progress.dart';
import 'package:yhealth/features/dashboard/widgets/daily_goal_card.dart';
import 'package:yhealth/features/dashboard/widgets/weekly_step_bar_chart.dart';
import 'package:yhealth/features/health/widgets/bmi_gauge_widget.dart';

void main() {
  testWidgets('Generate high-resolution PNG snapshots of redesigned components', (tester) async {
    final screenshotDir = Directory('C:\\Users\\asus\\.gemini\\antigravity\\brain\\01acdeed-bbc7-44e7-acb6-9a4573ab5de6\\screenshots');
    if (!screenshotDir.existsSync()) {
      screenshotDir.createSync(recursive: true);
    }

    Future<void> captureWidget({
      required Widget widget,
      required String filename,
      required Size size,
      bool isDark = false,
    }) async {
      final boundaryKey = GlobalKey();

      tester.view.physicalSize = Size(size.width * 2, size.height * 2);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
            body: Center(
              child: RepaintBoundary(
                key: boundaryKey,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: widget,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final bytes = byteData!.buffer.asUint8List();
        final file = File('${screenshotDir.path}/$filename');
        await file.writeAsBytes(bytes);
      });
    }

    // 1. VITA-Y Monogram Logo Light & Dark
    await captureWidget(
      widget: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: YHealthLogo(size: 100, showContainer: true, showWordmark: true, showTagline: true, isDark: false),
        ),
      ),
      filename: '01_branding_vitay_logo_light.png',
      size: const Size(400, 260),
      isDark: false,
    );

    await captureWidget(
      widget: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: YHealthLogo(size: 100, showContainer: true, showWordmark: true, showTagline: true, isDark: true),
        ),
      ),
      filename: '01_branding_vitay_logo_dark.png',
      size: const Size(400, 260),
      isDark: true,
    );

    // 2. Dashboard Hero Circular Step Gauge
    await captureWidget(
      widget: Container(
        padding: const EdgeInsets.all(24),
        child: const CircularStepProgress(
          currentSteps: 8420,
          goalSteps: 10000,
          stepsLabel: 'Daily Steps',
          goalLabel: 'Goal: 10,000',
        ),
      ),
      filename: '02_dashboard_step_gauge_light.png',
      size: const Size(400, 320),
      isDark: false,
    );

    await captureWidget(
      widget: Container(
        padding: const EdgeInsets.all(24),
        child: const CircularStepProgress(
          currentSteps: 10540,
          goalSteps: 10000,
          stepsLabel: 'Daily Steps',
          goalLabel: 'Goal: 10,000',
        ),
      ),
      filename: '02_dashboard_step_gauge_dark.png',
      size: const Size(400, 320),
      isDark: true,
    );

    // 3. Vital Metrics Quad Cards
    await captureWidget(
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: const [
            Expanded(
              child: VitalMetricTile(
                title: 'Distance',
                value: '6.42',
                unit: 'km',
                icon: Icons.route_rounded,
                iconColor: AppColors.accentDistance,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: VitalMetricTile(
                title: 'Calories',
                value: '520',
                unit: 'kcal',
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.accentCalories,
              ),
            ),
          ],
        ),
      ),
      filename: '03_vital_metrics_tiles.png',
      size: const Size(400, 180),
      isDark: false,
    );

    // 4. Daily Goal Tracker
    await captureWidget(
      widget: const Padding(
        padding: EdgeInsets.all(16.0),
        child: DailyGoalCard(
          title: 'Daily Health Targets',
          currentSteps: 8420,
          goalSteps: 10000,
          currentCalories: 520,
          goalCalories: 600,
          currentDistanceKm: 6.42,
          goalDistanceKm: 8.0,
          currentActiveMinutes: 52,
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
      filename: '04_daily_goal_card.png',
      size: const Size(400, 340),
      isDark: false,
    );

    // 5. Weekly Activity Chart
    await captureWidget(
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WeeklyStepBarChart(
          history: const {
            '2026-11-02': 7500,
            '2026-11-03': 9200,
            '2026-11-04': 8100,
            '2026-11-05': 11400,
            '2026-11-06': 6900,
            '2026-11-07': 8800,
          },
          todaySteps: 10540,
          goalSteps: 10000,
          title: 'Weekly Step Overview',
        ),
      ),
      filename: '05_weekly_overview_chart.png',
      size: const Size(400, 280),
      isDark: false,
    );

    // 6. Clinical BMI Gauge
    await captureWidget(
      widget: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Clinical BMI Gauge', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            BmiGaugeWidget(bmi: 22.8, progress: 0.44),
          ],
        ),
      ),
      filename: '06_clinical_bmi_gauge.png',
      size: const Size(400, 180),
      isDark: false,
    );
  });
}
