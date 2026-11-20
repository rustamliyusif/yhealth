import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/activity_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'route_detail_screen.dart';

class RouteHistoryScreen extends StatelessWidget {
  const RouteHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activity = context.watch<ActivityProvider>();
    final routes = activity.savedRoutes;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Text(
          l10n.routeHistoryTitle,
          style: AppTypography.headlineMedium(context).copyWith(fontSize: 19),
        ),
      ),
      body: routes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        size: 40,
                        color: AppColors.primaryAccentOf(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.noRoutesYet,
                      style: AppTypography.headlineMedium(context).copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noRoutesDesc,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(context),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: routes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (ctx, index) {
                final route = routes[index];
                return _buildRouteCard(context, l10n, route);
              },
            ),
    );
  }

  Widget _buildRouteCard(
    BuildContext context,
    AppLocalizations l10n,
    SavedRouteModel route,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RouteDetailScreen(route: route),
          ),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderOf(context)),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.directions_walk_rounded,
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
                        route.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(route.dateTime),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textMutedOf(context)),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: AppColors.dividerOf(context)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context: context,
                  label: l10n.distanceLabel,
                  value: '${route.distanceKm.toStringAsFixed(2)} ${l10n.kmUnit}',
                ),
                _buildStatItem(
                  context: context,
                  label: l10n.duration,
                  value: _formatDuration(route.durationSeconds),
                ),
                _buildStatItem(
                  context: context,
                  label: l10n.avgSpeed,
                  value: '${route.avgSpeedKmH.toStringAsFixed(1)} ${l10n.speedUnitKmH}',
                ),
                _buildStatItem(
                  context: context,
                  label: l10n.caloriesLabel,
                  value: '${route.calories} ${l10n.kcalUnit}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
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
