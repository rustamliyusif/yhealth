import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class FirebaseStatusSheet extends StatelessWidget {
  final bool isConnected;

  const FirebaseStatusSheet({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isConnected ? AppColors.primaryLightOf(context) : AppColors.surfaceMutedOf(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isConnected ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                  color: isConnected ? AppColors.primaryOf(context) : AppColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.firebaseStatusTitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    Text(
                      isConnected ? l10n.firebaseConnected : l10n.firebaseOfflineMode,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isConnected ? AppColors.primaryOf(context) : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.firebaseGuideDesc,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryOf(context),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceMutedOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderOf(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Android Package Name:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondaryOf(context)),
                ),
                const SizedBox(height: 4),
                Text(
                  'com.example.yhealth',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryOf(context)),
                ),
                const SizedBox(height: 10),
                Text(
                  'Target Path:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondaryOf(context)),
                ),
                const SizedBox(height: 4),
                Text(
                  'android/app/google-services.json',
                  style: TextStyle(fontSize: 13, fontFamily: 'monospace', color: AppColors.textPrimaryOf(context)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ),
        ],
      ),
    );
  }
}
