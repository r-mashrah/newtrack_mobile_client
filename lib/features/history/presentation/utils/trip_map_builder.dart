import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/trip_entity.dart';

/// Builds optimized map overlays for trip history playback.
class TripMapBuilder {
  TripMapBuilder._();

  static const int _maxDisplayPoints = 1200;

  /// Reduces point count for smooth map rendering on long trips.
  static List<GpsPoint> decimatePoints(List<GpsPoint> points) {
    if (points.length <= _maxDisplayPoints) return points;

    final step = points.length / _maxDisplayPoints;
    final result = <GpsPoint>[points.first];
    for (double i = step; i < points.length - 1; i += step) {
      result.add(points[i.round()]);
    }
    result.add(points.last);
    return result;
  }

  static Color speedColor(double speed) {
    if (speed < 20) return const Color(0xFF1565C0);
    if (speed < 80) return const Color(0xFF2E7D32);
    return const Color(0xFFC62828);
  }

  /// Full route in muted tone + optional traveled highlight.
  static Set<Polyline> buildRoutePolylines({
    required List<GpsPoint> points,
    int traveledUpToIndex = -1,
    String idPrefix = 'route',
  }) {
    if (points.length < 2) return {};

    final displayPoints = decimatePoints(points);
    final polylines = <Polyline>{};

    // Base outline for contrast on any map style
    polylines.add(Polyline(
      polylineId: PolylineId('${idPrefix}_outline'),
      points: displayPoints.map((p) => LatLng(p.lat, p.lng)).toList(),
      color: Colors.white.withValues(alpha: 0.85),
      width: 7,
      geodesic: true,
      zIndex: 1,
    ));

    // Muted full path
    polylines.add(Polyline(
      polylineId: PolylineId('${idPrefix}_base'),
      points: displayPoints.map((p) => LatLng(p.lat, p.lng)).toList(),
      color: Colors.grey.withValues(alpha: 0.45),
      width: 5,
      geodesic: true,
      zIndex: 2,
    ));

    // Speed-colored segments for full path or traveled portion
    final endIndex = traveledUpToIndex >= 0
        ? traveledUpToIndex.clamp(0, points.length - 1)
        : points.length - 1;

    if (endIndex > 0) {
      final traveledPoints = decimatePoints(points.sublist(0, endIndex + 1));
      polylines.addAll(_buildSpeedSegments(
        traveledPoints,
        idPrefix: '${idPrefix}_active',
        zIndex: 3,
      ));
    }

    return polylines;
  }

  static Set<Polyline> _buildSpeedSegments(
    List<GpsPoint> points, {
    required String idPrefix,
    required int zIndex,
  }) {
    if (points.length < 2) return {};

    final polylines = <Polyline>{};
    final segmentPoints = <LatLng>[];
    Color currentColor = speedColor(points.first.speed);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final color = speedColor(p.speed);
      segmentPoints.add(LatLng(p.lat, p.lng));

      if (color != currentColor || i == points.length - 1) {
        if (segmentPoints.length >= 2) {
          polylines.add(Polyline(
            polylineId: PolylineId('${idPrefix}_${polylines.length}'),
            points: List.from(segmentPoints),
            color: currentColor,
            width: 5,
            geodesic: true,
            zIndex: zIndex,
          ));
        }
        segmentPoints
          ..clear()
          ..add(LatLng(p.lat, p.lng));
        currentColor = color;
      }
    }

    return polylines;
  }

  static LatLngBounds boundsFromPoints(List<GpsPoint> points) {
    double minLat = points.first.lat;
    double maxLat = points.first.lat;
    double minLng = points.first.lng;
    double maxLng = points.first.lng;

    for (final p in points) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lng < minLng) minLng = p.lng;
      if (p.lng > maxLng) maxLng = p.lng;
    }

    // Expand tiny bounds (stationary device)
    if ((maxLat - minLat).abs() < 0.0005) {
      minLat -= 0.002;
      maxLat += 0.002;
    }
    if ((maxLng - minLng).abs() < 0.0005) {
      minLng -= 0.002;
      maxLng += 0.002;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
