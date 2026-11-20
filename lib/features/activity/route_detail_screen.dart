import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../core/providers/activity_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/osm_map_widget.dart';

class RouteDetailScreen extends StatelessWidget {
  final SavedRouteModel route;

  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final initialCenter = route.coordinates.isNotEmpty
        ? route.coordinates.first
        : const LatLng(40.4093, 49.8671);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          route.title,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // OpenStreetMap map
          Expanded(
            flex: 6,
            child: OsmMapWidget(
              center: initialCenter,
              initialZoom: 15.5,
              polylinePoints: route.coordinates,
              showStartEndMarkers: true,
            ),
          ),

          // Detail Card
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: AppDecorations.cardShadow(context),
                border: Border(
                  top: BorderSide(color: AppColors.borderOf(context), width: 1),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sessionRecorded,
                      style: AppTypography.titleMedium(context).copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(route.dateTime),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.5,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            label: l10n.distanceLabel,
                            value: '${route.distanceKm.toStringAsFixed(2)} ${l10n.kmUnit}',
                            icon: Icons.straighten_rounded,
                            color: AppColors.accentDistance,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            label: l10n.duration,
                            value: _formatDuration(route.durationSeconds),
                            icon: Icons.timer_outlined,
                            color: AppColors.accentTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            label: l10n.avgSpeed,
                            value: '${route.avgSpeedKmH.toStringAsFixed(1)} ${l10n.speedUnitKmH}',
                            icon: Icons.speed_rounded,
                            color: AppColors.primaryAccentOf(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            label: l10n.caloriesLabel,
                            value: '${route.calories} ${l10n.kcalUnit}',
                            icon: Icons.local_fire_department_rounded,
                            color: AppColors.accentCalories,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMutedOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} • ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }
}
