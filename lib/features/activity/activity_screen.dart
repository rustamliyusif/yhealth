import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/providers/activity_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/premium_button.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/osm_map_widget.dart';
import 'widgets/permission_info_dialog.dart';
import 'route_history_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final MapController _mapController = MapController();

  Future<void> _handleStartTracking() async {
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    final success = await activityProvider.startTracking();
    if (!mounted) return;

    if (!success) {
      final error = activityProvider.statusError;
      if (error == 'permanently_denied' || error == 'permission_denied') {
        _showPermissionDialog();
      } else if (error == 'service_disabled') {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permissionDenied),
            action: SnackBarAction(
              label: l10n.openSettings,
              onPressed: () => LocationService.openLocationSettings(),
            ),
          ),
        );
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => PermissionInfoDialog(
        onOpenSettings: () => LocationService.openAppSettings(),
      ),
    );
  }

  Future<void> _confirmStopRoute() async {
    final l10n = AppLocalizations.of(context)!;
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final titleController = TextEditingController(
      text: '${l10n.activityTitle} • ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.finishRouteTitle,
          style: AppTypography.headlineMedium(ctx).copyWith(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.finishRouteConfirmation,
              style: AppTypography.bodyMedium(ctx),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: l10n.activityTitle,
                labelText: l10n.saveRoute,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
              activityProvider.discardTracking();
            },
            child: Text(l10n.discard, style: const TextStyle(color: AppColors.error)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccentOf(ctx),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final saved = await activityProvider.stopAndSaveRoute(
        titleController.text,
        userId: authProvider.userId,
      );
      if (saved != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.routeSavedSuccess),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activity = context.watch<ActivityProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.activityTitle,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderOf(context), width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.history_rounded, color: AppColors.primaryAccentOf(context), size: 22),
              tooltip: l10n.routeHistoryTitle,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RouteHistoryScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // OpenStreetMap Full View
          Positioned.fill(
            child: OsmMapWidget(
              center: activity.currentPosition ?? const LatLng(40.4093, 49.8671),
              initialZoom: 16.5,
              polylinePoints: activity.currentRoutePoints,
              userPosition: activity.currentPosition,
              mapController: _mapController,
            ),
          ),

          // Floating Top Metrics Bar (when tracking or paused)
          if (!activity.isIdle)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildTrackingHUD(context, l10n, activity),
            ),

          // Vehicle transit warning banner
          if (activity.isVehicleDetected)
            Positioned(
              top: activity.isIdle ? 16 : 95,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.vehicleDetectedWarning,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Center on location button
          Positioned(
            right: 16,
            bottom: activity.isIdle ? 104 : 160,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderOf(context), width: 1),
                boxShadow: AppDecorations.cardShadow(context),
              ),
              child: IconButton(
                icon: Icon(Icons.my_location_rounded, color: AppColors.primaryAccentOf(context)),
                onPressed: () {
                  if (activity.currentPosition != null) {
                    _mapController.move(activity.currentPosition!, 17.0);
                  }
                },
              ),
            ),
          ),

          // Bottom Control Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _buildBottomControls(context, l10n, activity),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingHUD(BuildContext context, AppLocalizations l10n, ActivityProvider activity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.borderOf(context), width: 1),
            boxShadow: AppDecorations.cardShadow(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHUDMetric(
                context: context,
                label: l10n.duration,
                value: _formatDuration(activity.durationSeconds),
              ),
              Container(width: 1, height: 32, color: AppColors.dividerOf(context)),
              _buildHUDMetric(
                context: context,
                label: l10n.distanceLabel,
                value: '${activity.distanceKm.toStringAsFixed(2)} ${l10n.kmUnit}',
              ),
              Container(width: 1, height: 32, color: AppColors.dividerOf(context)),
              _buildHUDMetric(
                context: context,
                label: l10n.avgSpeed,
                value: '${activity.avgSpeedKmH.toStringAsFixed(1)} ${l10n.speedUnitKmH}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUDMetric({required BuildContext context, required String label, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.displayMedium(context).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            fontSize: 11,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(BuildContext context, AppLocalizations l10n, ActivityProvider activity) {
    final isDark = AppColors.isDark(context);

    if (activity.isIdle) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderOf(context)),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: PremiumButton(
          onPressed: _handleStartTracking,
          icon: Icons.play_arrow_rounded,
          label: l10n.startWalk,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: AppDecorations.cardShadow(context),
      ),
      child: Row(
        children: [
          // Pause / Resume Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: activity.isTracking ? activity.pauseTracking : activity.resumeTracking,
              icon: Icon(
                activity.isTracking ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 22,
              ),
              label: Text(activity.isTracking ? l10n.pauseWalk : l10n.resumeWalk),
              style: ElevatedButton.styleFrom(
                backgroundColor: activity.isTracking
                    ? (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMutedOf(context))
                    : AppColors.primaryAccentOf(context),
                foregroundColor: activity.isTracking ? AppColors.textPrimaryOf(context) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Finish & Save Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _confirmStopRoute,
              icon: const Icon(Icons.stop_rounded, size: 22),
              label: Text(l10n.stopWalk),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCalories,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
