import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/health_sync_provider.dart';
import '../../core/services/health_connect_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../l10n/app_localizations.dart';

class HealthConnectScreen extends StatelessWidget {
  const HealthConnectScreen({super.key});

  static String formatLastSync(AppLocalizations l10n, DateTime? t) {
    if (t == null) return l10n.hcNever;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.day)}.${two(t.month)} ${two(t.hour)}:${two(t.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hc = context.watch<HealthSyncProvider>();
    const teal = Color(0xFF14B8A6);

    final String statusText;
    if (hc.status == HealthConnectStatus.notInstalled) {
      statusText = l10n.hcNotInstalled;
    } else if (hc.status == HealthConnectStatus.unsupported) {
      statusText = l10n.hcUnsupported;
    } else if (hc.connected) {
      statusText = l10n.hcConnected(formatLastSync(l10n, hc.lastSync));
    } else {
      statusText = l10n.hcNotConnected;
    }

    Widget row(IconData icon, Color color, String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: AppColors.textPrimaryOf(context)),
                ),
              ),
              Icon(
                hc.connected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: hc.connected ? teal : AppColors.textMutedOf(context),
                size: 18,
              ),
            ],
          ),
        );

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Health Connect'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: hc.connected ? teal.withValues(alpha: 0.5) : AppColors.borderOf(context)),
                boxShadow: AppDecorations.cardShadow(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.health_and_safety_rounded, color: teal, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  row(Icons.bedtime_rounded, AppColors.accentSleep, l10n.hcReadSleep),
                  row(Icons.scale_rounded, AppColors.accentSteps, l10n.hcReadWeight),
                  row(Icons.directions_walk_rounded, AppColors.accentSteps, l10n.hcWriteSteps),
                  row(Icons.water_drop_rounded, const Color(0xFF0EA5E9), l10n.hcWriteWater),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (hc.status == HealthConnectStatus.notInstalled)
              FilledButton.icon(
                onPressed: hc.openSettings,
                icon: const Icon(Icons.download_rounded),
                label: Text(l10n.hcInstall),
              )
            else if (hc.status == HealthConnectStatus.available && !hc.connected)
              FilledButton.icon(
                onPressed: () async {
                  final ok = await hc.connect();
                  if (!context.mounted || ok) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.hcPermissionDenied)));
                },
                icon: const Icon(Icons.link_rounded),
                label: Text(l10n.hcConnect),
              )
            else if (hc.connected)
              FilledButton.icon(
                onPressed: hc.syncing
                    ? null
                    : () async {
                        final r = await hc.syncNow();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.hcSyncResult(r.sleep, r.weight))),
                        );
                      },
                icon: hc.syncing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.sync_rounded),
                label: Text(l10n.hcSyncNow),
              ),
            if (hc.status == HealthConnectStatus.available) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: hc.openSettings,
                icon: const Icon(Icons.settings_outlined),
                label: Text(l10n.hcOpenSettings),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              l10n.hcSamsungHint,
              style: TextStyle(fontFamily: 'Roboto', fontSize: 12.5, height: 1.4, color: AppColors.textSecondaryOf(context)),
            ),
          ],
        ),
      ),
    );
  }
}
