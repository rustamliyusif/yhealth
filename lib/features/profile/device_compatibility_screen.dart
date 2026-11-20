import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/step_counter_provider.dart';
import '../../core/services/activity_recognition_service.dart';
import '../../core/services/native_step_service.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Diagnostic & Hardware Compatibility Screen.
/// Displays hardware sensor presence, activity recognition, background service status,
/// battery optimization states, and manufacturer-specific instructions for Samsung,
/// Xiaomi, Redmi, POCO, Pixel, OnePlus, OPPO, Realme, Vivo, Huawei, and others.
class DeviceCompatibilityScreen extends StatefulWidget {
  const DeviceCompatibilityScreen({super.key});

  @override
  State<DeviceCompatibilityScreen> createState() => _DeviceCompatibilityScreenState();
}

class _DeviceCompatibilityScreenState extends State<DeviceCompatibilityScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    final provider = context.read<StepCounterProvider>();
    await provider.refreshDeviceCompatibility();
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  String _getActivityName(HumanActivityType type, AppLocalizations l10n) {
    switch (type) {
      case HumanActivityType.still:
        return l10n.activityStill;
      case HumanActivityType.walking:
        return l10n.activityWalking;
      case HumanActivityType.running:
        return l10n.activityRunning;
      case HumanActivityType.onBicycle:
        return l10n.activityBicycle;
      case HumanActivityType.inVehicle:
        return l10n.activityVehicle;
    }
  }

  IconData _getActivityIcon(HumanActivityType type) {
    switch (type) {
      case HumanActivityType.still:
        return Icons.accessibility_new_rounded;
      case HumanActivityType.walking:
        return Icons.directions_walk_rounded;
      case HumanActivityType.running:
        return Icons.directions_run_rounded;
      case HumanActivityType.onBicycle:
        return Icons.directions_bike_rounded;
      case HumanActivityType.inVehicle:
        return Icons.directions_car_rounded;
    }
  }

  Color _getActivityColor(HumanActivityType type) {
    switch (type) {
      case HumanActivityType.still:
        return const Color(0xFF6B7280);
      case HumanActivityType.walking:
        return const Color(0xFF10B981);
      case HumanActivityType.running:
        return const Color(0xFF059669);
      case HumanActivityType.onBicycle:
        return const Color(0xFF3B82F6);
      case HumanActivityType.inVehicle:
        return const Color(0xFFF59E0B);
    }
  }

  String _getManufacturerGuidance(String manufacturer, AppLocalizations l10n) {
    final m = manufacturer.toLowerCase();
    if (m.contains('xiaomi') || m.contains('redmi') || m.contains('poco')) {
      return l10n.guidanceXiaomi;
    } else if (m.contains('samsung')) {
      return l10n.guidanceSamsung;
    } else if (m.contains('huawei') || m.contains('honor')) {
      return l10n.guidanceHuawei;
    } else if (m.contains('oneplus') || m.contains('oppo') || m.contains('realme')) {
      return l10n.guidanceOnePlus;
    } else if (m.contains('vivo') || m.contains('iqoo')) {
      return l10n.guidanceVivo;
    } else if (m.contains('google')) {
      return l10n.guidancePixel;
    }
    return l10n.guidanceGeneral;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stepProvider = context.watch<StepCounterProvider>();
    final info = stepProvider.deviceCompatibility ?? DeviceCompatibilityModel.fallback();
    final currentActivity = stepProvider.currentActivity;

    final isOptimizedExempt = info.isIgnoringBatteryOptimizations;
    final hasHardware = info.hasHardwarePedometer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.deviceCompatibilityTitle,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            tooltip: l10n.retry,
            onPressed: _isRefreshing ? null : _refresh,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Overall Compatibility Banner
          _buildOverallCard(context, info, hasHardware, isOptimizedExempt, l10n),
          const SizedBox(height: 16),

          // Device Information Card
          _buildDeviceInfoCard(context, info, l10n),
          const SizedBox(height: 16),

          // Hardware Sensors Card
          _buildHardwareSensorsCard(context, info, l10n),
          const SizedBox(height: 16),

          // Activity Recognition Card
          _buildActivityRecognitionCard(context, currentActivity, stepProvider, l10n),
          const SizedBox(height: 16),

          // Background Operation & Service
          _buildBackgroundOperationCard(context, info, stepProvider, l10n),
          const SizedBox(height: 16),

          // Battery Optimization & Guidance
          _buildBatteryOptimizationCard(context, info, stepProvider, l10n),
          const SizedBox(height: 16),

          // GPS & Location Note
          _buildGpsStatusCard(context, info, l10n),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOverallCard(
    BuildContext context,
    DeviceCompatibilityModel info,
    bool hasHardware,
    bool isOptimizedExempt,
    AppLocalizations l10n,
  ) {
    final bool isFullyCompatible = hasHardware && isOptimizedExempt;
    final Color badgeColor = isFullyCompatible
        ? const Color(0xFF10B981)
        : (hasHardware ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));

    final String statusText = isFullyCompatible
        ? l10n.fullyCompatible
        : (hasHardware ? l10n.attentionNeeded : l10n.partiallyCompatible);

    final String subtitleText = isFullyCompatible
        ? l10n.supportedMethodsDesc
        : (hasHardware
            ? '${l10n.batteryRestricted} — ${l10n.batteryOptimizeButton}'
            : l10n.sensorNone);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFullyCompatible
                  ? Icons.verified_rounded
                  : (hasHardware ? Icons.warning_amber_rounded : Icons.info_outline_rounded),
              color: badgeColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitleText,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryOf(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoCard(
    BuildContext context,
    DeviceCompatibilityModel info,
    AppLocalizations l10n,
  ) {
    return _buildSectionCard(
      context: context,
      title: l10n.deviceInfo,
      icon: Icons.smartphone_rounded,
      children: [
        _buildInfoRow(context, l10n.deviceManufacturer, info.manufacturer),
        _buildInfoRow(context, l10n.deviceModel, '${info.brand} ${info.model}'),
        _buildInfoRow(context, l10n.androidVersion, '${info.androidVersion} (API ${info.sdkInt})'),
      ],
    );
  }

  Widget _buildHardwareSensorsCard(
    BuildContext context,
    DeviceCompatibilityModel info,
    AppLocalizations l10n,
  ) {
    String activeModeText;
    if (info.activeSensorType == 'counter') {
      activeModeText = l10n.sensorCounterPrimary;
    } else if (info.activeSensorType == 'detector') {
      activeModeText = l10n.sensorDetectorAlternative;
    } else {
      activeModeText = l10n.sensorNone;
    }

    return _buildSectionCard(
      context: context,
      title: l10n.sensorDiagnostics,
      icon: Icons.sensors_rounded,
      children: [
        _buildCheckRow(
          context,
          l10n.stepCounterSensor,
          info.hasStepCounter,
          subtitle: info.stepCounterName,
        ),
        _buildCheckRow(
          context,
          l10n.stepDetectorSensor,
          info.hasStepDetector,
          subtitle: info.stepDetectorName,
        ),
        _buildCheckRow(
          context,
          l10n.accelerometerSensor,
          info.hasAccelerometer,
          subtitle: info.accelerometerName,
        ),
        const Divider(height: 20),
        _buildInfoRow(
          context,
          l10n.activeTrackingMode,
          activeModeText,
          highlightValue: true,
        ),
      ],
    );
  }

  Widget _buildActivityRecognitionCard(
    BuildContext context,
    HumanActivityType currentActivity,
    StepCounterProvider stepProvider,
    AppLocalizations l10n,
  ) {
    final activityName = _getActivityName(currentActivity, l10n);
    final activityColor = _getActivityColor(currentActivity);
    final activityIcon = _getActivityIcon(currentActivity);

    return _buildSectionCard(
      context: context,
      title: l10n.activityRecognitionTitle,
      icon: Icons.directions_walk_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.activityRecognitionDesc,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: activityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: activityColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(activityIcon, color: activityColor, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          activityName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: activityColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backgroundOf(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.security_update_good_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.vehicleFilteringActive,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundOperationCard(
    BuildContext context,
    DeviceCompatibilityModel info,
    StepCounterProvider stepProvider,
    AppLocalizations l10n,
  ) {
    return _buildSectionCard(
      context: context,
      title: l10n.backgroundOperationTitle,
      icon: Icons.published_with_changes_rounded,
      children: [
        _buildCheckRow(
          context,
          l10n.foregroundServiceStatus,
          info.isStepServiceRunning,
          customSuccessText: l10n.serviceRunning,
          customFailText: l10n.serviceStopped,
        ),
        _buildCheckRow(
          context,
          l10n.notificationPermission,
          info.hasNotificationPermission,
        ),
        _buildCheckRow(
          context,
          l10n.bootRecovery,
          true,
          subtitle: 'RECEIVE_BOOT_COMPLETED configured',
        ),
      ],
    );
  }

  Widget _buildBatteryOptimizationCard(
    BuildContext context,
    DeviceCompatibilityModel info,
    StepCounterProvider stepProvider,
    AppLocalizations l10n,
  ) {
    final bool isUnrestricted = info.isIgnoringBatteryOptimizations;
    final String guidance = _getManufacturerGuidance(info.manufacturer, l10n);

    return _buildSectionCard(
      context: context,
      title: l10n.batteryOptimizationTitle,
      icon: Icons.battery_charging_full_rounded,
      children: [
        Row(
          children: [
            Icon(
              isUnrestricted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: isUnrestricted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isUnrestricted ? l10n.batteryUnrestricted : l10n.batteryRestricted,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isUnrestricted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Action buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.bolt_rounded, size: 18),
              label: Text(l10n.batteryOptimizeButton),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await stepProvider.requestIgnoreBatteryOptimization();
                await _refresh();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings_suggest_rounded, size: 18),
              label: Text(l10n.openOemSettingsButton),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await stepProvider.openOemBatterySettings();
                await _refresh();
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Manufacturer specific instruction
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundOf(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderOf(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  Text(
                    l10n.manufacturerGuidance,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                guidance,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGpsStatusCard(
    BuildContext context,
    DeviceCompatibilityModel info,
    AppLocalizations l10n,
  ) {
    return _buildSectionCard(
      context: context,
      title: l10n.gpsTrackingStatus,
      icon: Icons.location_on_rounded,
      children: [
        _buildCheckRow(
          context,
          l10n.gpsPermissionRequired,
          info.hasLocationPermission,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gpsOptionalNote,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryOf(context)),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool highlightValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: highlightValue ? FontWeight.w700 : FontWeight.w600,
                color: highlightValue ? AppColors.primaryOf(context) : AppColors.textPrimaryOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(
    BuildContext context,
    String title,
    bool isAvailable, {
    String? subtitle,
    String? customSuccessText,
    String? customFailText,
  }) {
    final statusColor = isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final statusIcon = isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final statusLabel = isAvailable
        ? (customSuccessText ?? 'Available')
        : (customFailText ?? 'Unavailable');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(statusIcon, color: statusColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
