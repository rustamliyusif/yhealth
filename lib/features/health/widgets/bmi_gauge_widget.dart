import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BmiGaugeWidget extends StatelessWidget {
  final double bmi;
  final double progress; // 0.0 to 1.0

  const BmiGaugeWidget({
    super.key,
    required this.bmi,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Semicircular / Segmented Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [
                // Underweight: < 18.5
                Expanded(
                  flex: 18,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.bmiUnderweight,
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 2.5),
                // Normal: 18.5 - 24.9
                Expanded(
                  flex: 32,
                  child: Container(color: AppColors.bmiNormal),
                ),
                const SizedBox(width: 2.5),
                // Overweight: 25.0 - 29.9
                Expanded(
                  flex: 25,
                  child: Container(color: AppColors.bmiOverweight),
                ),
                const SizedBox(width: 2.5),
                // Obese: >= 30.0
                Expanded(
                  flex: 25,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.bmiObese,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Pointer Indicator
        LayoutBuilder(
          builder: (context, constraints) {
            final pointerPosition = (constraints.maxWidth * progress).clamp(10.0, constraints.maxWidth - 10.0);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(height: 20, width: constraints.maxWidth),
                Positioned(
                  left: pointerPosition - 8,
                  top: 0,
                  child: Column(
                    children: [
                      Icon(Icons.arrow_drop_up_rounded, size: 24, color: AppColors.textPrimaryOf(context)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        // Scale labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15', style: TextStyle(fontFamily: 'Roboto', fontSize: 11, color: AppColors.textMutedOf(context))),
              Text('18.5', style: TextStyle(fontFamily: 'Roboto', fontSize: 11, color: AppColors.textMutedOf(context))),
              Text('25', style: TextStyle(fontFamily: 'Roboto', fontSize: 11, color: AppColors.textMutedOf(context))),
              Text('30', style: TextStyle(fontFamily: 'Roboto', fontSize: 11, color: AppColors.textMutedOf(context))),
              Text('35+', style: TextStyle(fontFamily: 'Roboto', fontSize: 11, color: AppColors.textMutedOf(context))),
            ],
          ),
        ),
      ],
    );
  }
}
