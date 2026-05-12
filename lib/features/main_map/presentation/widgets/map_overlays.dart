import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/map_utilities_provider.dart';

/// أداة لرسم المسارات على الخريطة
class TrailPolyline {
  static Polyline buildTrailPolyline({
    required String deviceId,
    required List<TrailPoint> trailPoints,
    required Color color,
  }) {
    return Polyline(
      polylineId: PolylineId('trail_$deviceId'),
      points: trailPoints.map((p) => p.location).toList(),
      color: color,
      width: 3,
      geodesic: true,
    );
  }

  static Set<Polyline> buildAllTrailPolylines(
    Map<String, List<TrailPoint>> deviceTrails,
  ) {
    final polylines = <Polyline>{};
    int colorIndex = 0;
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];

    deviceTrails.forEach((deviceId, trailPoints) {
      if (trailPoints.isNotEmpty) {
        polylines.add(
          buildTrailPolyline(
            deviceId: deviceId,
            trailPoints: trailPoints,
            color: colors[colorIndex % colors.length],
          ),
        );
        colorIndex++;
      }
    });

    return polylines;
  }
}

/// أداة لرسم الأسوار الجغرافية على الخريطة
class GeofencePolygon {
  static Polygon buildGeofencePolygon(Geofence geofence) {
    return Polygon(
      polygonId: PolygonId('geofence_${geofence.id}'),
      points: geofence.points,
      fillColor: geofence.color,
      strokeColor: geofence.color.withOpacity(0.8),
      strokeWidth: 2,
      geodesic: true,
    );
  }

  static Set<Polygon> buildAllGeofencePolygons(List<Geofence> geofences) {
    return geofences.map((geofence) {
      return buildGeofencePolygon(geofence);
    }).toSet();
  }
}

/// أداة لرسم نقاط الاهتمام على الخريطة
class PoIMarker {
  static Marker buildPoIMarker(PointOfInterest poi) {
    return Marker(
      markerId: MarkerId('poi_${poi.id}'),
      position: poi.location,
      infoWindow: InfoWindow(
        title: poi.name,
        snippet: poi.description ?? poi.type,
      ),
      icon: _getPoIIcon(poi.type),
    );
  }

  static Set<Marker> buildAllPoIMarkers(List<PointOfInterest> pois) {
    return pois.map((poi) {
      return buildPoIMarker(poi);
    }).toSet();
  }

  static BitmapDescriptor _getPoIIcon(String type) {
    switch (type) {
      case 'gas_station':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
      case 'hospital':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        );
      case 'restaurant':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        );
      case 'hotel':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        );
      case 'parking':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        );
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }
}

/// عنصر واجهة لعرض معلومات المسار
class TrailInfoCard extends StatelessWidget {
  final String deviceId;
  final List<TrailPoint> trailPoints;

  const TrailInfoCard({
    Key? key,
    required this.deviceId,
    required this.trailPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trailPoints.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstPoint = trailPoints.first;
    final lastPoint = trailPoints.last;
    final distance = _calculateDistance(firstPoint.location, lastPoint.location);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات المسار',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Text('النقاط: ${trailPoints.length}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.straighten, size: 16),
                const SizedBox(width: 8),
                Text('المسافة: ${distance.toStringAsFixed(2)} كم'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 8),
                Text('المدة: ${_formatDuration(lastPoint.timestamp.difference(firstPoint.timestamp))}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// حساب المسافة بين نقطتين (تقريبي)
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadiusKm = 6371;
    final dLat = _toRadians(point2.latitude - point1.latitude);
    final dLng = _toRadians(point2.longitude - point1.longitude);
    final a = (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
        (Math.cos(_toRadians(point1.latitude)) *
            Math.cos(_toRadians(point2.latitude)) *
            Math.sin(dLng / 2) *
            Math.sin(dLng / 2));
    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }

  /// تنسيق المدة الزمنية
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours س $minutes د';
    } else if (minutes > 0) {
      return '$minutes د $seconds ث';
    } else {
      return '$seconds ث';
    }
  }
}

/// مكتبة رياضيات بسيطة
class Math {
  static double sin(double x) => _sin(x);
  static double cos(double x) => _cos(x);
  static double atan2(double y, double x) => _atan2(y, x);
  static double sqrt(double x) => _sqrt(x);

  static double _sin(double x) {
    // تقريب sin باستخدام سلسلة تايلور
    x = x % (2 * 3.141592653589793);
    double result = 0;
    double term = x;
    for (int i = 1; i < 20; i++) {
      result += term;
      term *= -x * x / ((2 * i) * (2 * i + 1));
    }
    return result;
  }

  static double _cos(double x) {
    // تقريب cos باستخدام سلسلة تايلور
    x = x % (2 * 3.141592653589793);
    double result = 1;
    double term = 1;
    for (int i = 1; i < 20; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _atan2(double y, double x) {
    // تقريب atan2
    if (x > 0) {
      return _atan(y / x);
    } else if (x < 0 && y >= 0) {
      return _atan(y / x) + 3.141592653589793;
    } else if (x < 0 && y < 0) {
      return _atan(y / x) - 3.141592653589793;
    } else if (x == 0 && y > 0) {
      return 3.141592653589793 / 2;
    } else if (x == 0 && y < 0) {
      return -3.141592653589793 / 2;
    }
    return 0;
  }

  static double _atan(double x) {
    // تقريب atan باستخدام سلسلة تايلور
    double result = 0;
    double term = x;
    for (int i = 1; i < 20; i++) {
      result += term;
      term *= -x * x * (2 * i - 1) / (2 * i + 1);
    }
    return result;
  }

  static double _sqrt(double x) {
    if (x < 0) return 0;
    if (x == 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}
