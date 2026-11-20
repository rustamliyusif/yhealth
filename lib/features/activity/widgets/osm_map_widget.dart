import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';

class OsmMapWidget extends StatefulWidget {
  final LatLng center;
  final double initialZoom;
  final List<LatLng> polylinePoints;
  final LatLng? userPosition;
  final bool showStartEndMarkers;
  final MapController? mapController;

  const OsmMapWidget({
    super.key,
    required this.center,
    this.initialZoom = 16.0,
    this.polylinePoints = const [],
    this.userPosition,
    this.showStartEndMarkers = false,
    this.mapController,
  });

  @override
  State<OsmMapWidget> createState() => _OsmMapWidgetState();
}

class _OsmMapWidgetState extends State<OsmMapWidget> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.mapController ?? MapController();
  }

  @override
  void didUpdateWidget(covariant OsmMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userPosition != null &&
        (oldWidget.userPosition == null ||
            oldWidget.userPosition!.latitude != widget.userPosition!.latitude ||
            oldWidget.userPosition!.longitude != widget.userPosition!.longitude)) {
      _controller.move(widget.userPosition!, _controller.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];

    // Current position marker
    if (widget.userPosition != null) {
      markers.add(
        Marker(
          point: widget.userPosition!,
          width: 32,
          height: 32,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.navigation_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      );
    }

    // Start & End markers for saved routes
    if (widget.showStartEndMarkers && widget.polylinePoints.isNotEmpty) {
      // Start Marker
      markers.add(
        Marker(
          point: widget.polylinePoints.first,
          width: 28,
          height: 28,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
          ),
        ),
      );

      // End Marker
      if (widget.polylinePoints.length > 1) {
        markers.add(
          Marker(
            point: widget.polylinePoints.last,
            width: 28,
            height: 28,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCalories,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.flag_rounded, color: Colors.white, size: 16),
            ),
          ),
        );
      }
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: widget.initialZoom,
            minZoom: 4,
            maxZoom: 19,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.rustamliyusif.yhealth',
              maxZoom: 19,
            ),
            if (widget.polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.polylinePoints,
                    strokeWidth: 5.0,
                    color: AppColors.primary,
                    borderColor: Colors.white.withValues(alpha: 0.8),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
            MarkerLayer(markers: markers),
          ],
        ),
        // OpenStreetMap Mandatory Attribution Bar
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context).withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderOf(context), width: 0.8),
            ),
            child: Text(
              '© OpenStreetMap contributors',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
