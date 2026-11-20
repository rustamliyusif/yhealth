import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/health_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/bmi_gauge_widget.dart';

class BmiScreen extends StatelessWidget {
  const BmiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final health = context.watch<HealthProvider>();
    final auth = context.watch<AuthProvider>();

    final bmiValue = health.bmi;
    final category = health.category;
    final categoryDetails = _getCategoryDetails(l10n, category);

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.bmiTitle,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Result Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.yourBmiIs,
                      style: AppTypography.labelSmall(context).copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bmiValue.toStringAsFixed(1),
                      style: AppTypography.displayLarge(context).copyWith(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: categoryDetails.color,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: categoryDetails.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: categoryDetails.color.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        categoryDetails.title,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: categoryDetails.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Visual Gauge
                    BmiGaugeWidget(
                      bmi: bmiValue,
                      progress: health.gaugeProgress,
                    ),
                    const SizedBox(height: 20),
                    // Healthy Weight Range
                    Text(
                      l10n.healthyWeightRange(
                        health.minHealthyWeight.toStringAsFixed(1),
                        health.maxHealthyWeight.toStringAsFixed(1),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Height and Weight Sliders
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Column(
                  children: [
                    // Height Controller
                    _buildSliderRow(
                      context: context,
                      label: l10n.heightLabel,
                      value: '${health.height.round()} ${l10n.heightUnitCm}',
                      sliderValue: health.height,
                      min: 100.0,
                      max: 220.0,
                      onChanged: (val) {
                        health.updateValues(val, health.weight);
                        auth.updateProfile(height: val);
                      },
                    ),
                    Divider(height: 28, color: AppColors.dividerOf(context)),
                    // Weight Controller
                    _buildSliderRow(
                      context: context,
                      label: l10n.weightLabel,
                      value: '${health.weight.toStringAsFixed(1)} ${l10n.weightUnitKg}',
                      sliderValue: health.weight,
                      min: 30.0,
                      max: 180.0,
                      onChanged: (val) {
                        health.updateValues(health.height, val);
                        auth.updateProfile(weight: val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Health Explanation Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderOf(context)),
                  boxShadow: AppDecorations.cardShadow(context),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppColors.primaryAccentOf(context),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryDetails.title,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            categoryDetails.explanation,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: AppColors.textSecondaryOf(context),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Important Medical Disclaimer Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surfaceMutedOf(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.health_and_safety_outlined,
                          size: 20,
                          color: AppColors.primaryAccentOf(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.bmiDisclaimerTitle,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.bmiDisclaimerText,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11.5,
                        color: AppColors.textSecondaryOf(context),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required BuildContext context,
    required String label,
    required String value,
    required double sliderValue,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final isDark = AppColors.isDark(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primaryAccentOf(context),
            inactiveTrackColor: isDark ? AppColors.darkBorder : AppColors.primaryLight,
            thumbColor: AppColors.primaryAccentOf(context),
            overlayColor: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
            trackHeight: 6,
          ),
          child: Slider(
            value: sliderValue.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  _CategoryInfo _getCategoryDetails(AppLocalizations l10n, BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return _CategoryInfo(
          title: l10n.categoryUnderweight,
          color: AppColors.bmiUnderweight,
          explanation: l10n.bmiExplanationUnderweight,
        );
      case BmiCategory.normal:
        return _CategoryInfo(
          title: l10n.categoryNormal,
          color: AppColors.bmiNormal,
          explanation: l10n.bmiExplanationNormal,
        );
      case BmiCategory.overweight:
        return _CategoryInfo(
          title: l10n.categoryOverweight,
          color: AppColors.bmiOverweight,
          explanation: l10n.bmiExplanationOverweight,
        );
      case BmiCategory.obese:
        return _CategoryInfo(
          title: l10n.categoryObese,
          color: AppColors.bmiObese,
          explanation: l10n.bmiExplanationObese,
        );
    }
  }
}

class _CategoryInfo {
  final String title;
  final Color color;
  final String explanation;

  _CategoryInfo({
    required this.title,
    required this.color,
    required this.explanation,
  });
}
