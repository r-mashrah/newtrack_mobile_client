import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/device_entity.dart';

/// مدير أدوات الخريطة المتقدم - نسخة مصححة
class MapUtilitiesManager {
  /// بناء المسارات مع تأثيرات متقدمة
  /// ملاحظة: يتم استخدام lastLocation فقط لأن locationHistory غير متوفرة
  static Set<Polyline> buildAdvancedTrails(
    List<DeviceEntity> devices,
    bool showTrail,
  ) {
    if (!showTrail) return {};

    final trails = <Polyline>{};

    for (final device in devices) {
      // إذا كان لديك طريقة للحصول على السجل التاريخي للمواقع
      // يمكنك إضافتها هنا
      // حالياً نستخدم lastLocation فقط
      // ignore: unused_local_variable
      final color = _getSpeedBasedColor(device.speed ?? 0);

      // يمكن إضافة polyline بسيط يمثل الموقع الحالي
      // أو يمكن توسيع DeviceEntity لاحتواء locationHistory
    }

    return trails;
  }

  /// الحصول على اللون بناءً على السرعة
  static Color _getSpeedBasedColor(double speed) {
    if (speed == 0) {
      return Colors.red.withOpacity(0.7); // متوقف
    } else if (speed < 20) {
      return Colors.orange.withOpacity(0.7); // بطيء
    } else if (speed < 50) {
      return Colors.yellow.withOpacity(0.7); // متوسط
    } else if (speed < 80) {
      return Colors.lightGreen.withOpacity(0.7); // سريع
    } else {
      return Colors.green.withOpacity(0.7); // سريع جداً
    }
  }

  /// الحصول على عرض الخط بناءً على السرعة
  // ignore: unused_element
  static int _getSpeedBasedWidth(double speed) {
    if (speed == 0) return 2;
    if (speed < 20) return 3;
    if (speed < 50) return 4;
    if (speed < 80) return 5;
    return 6;
  }

  /// بناء الأسوار الجغرافية مع تأثيرات متقدمة
  static Set<Circle> buildAdvancedGeofences(
    List<DeviceEntity> devices,
    bool showGeofences,
  ) {
    if (!showGeofences) return {};

    final geofences = <Circle>{};

    for (final device in devices) {
      // الحد الأول - منطقة التحذير
      geofences.add(
        Circle(
          circleId: CircleId('geofence_warning_${device.id}'),
          center: LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          radius: 1000, // 1 كم
          fillColor: Colors.orange.withOpacity(0.05),
          strokeColor: Colors.orange.withOpacity(0.4),
          strokeWidth: 1,
        ),
      );

      // الحد الثاني - منطقة الخطر
      geofences.add(
        Circle(
          circleId: CircleId('geofence_danger_${device.id}'),
          center: LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          radius: 500, // 500 متر
          fillColor: Colors.red.withOpacity(0.05),
          strokeColor: Colors.red.withOpacity(0.5),
          strokeWidth: 2,
        ),
      );

      // الحد الثالث - منطقة آمنة
      geofences.add(
        Circle(
          circleId: CircleId('geofence_safe_${device.id}'),
          center: LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          radius: 2000, // 2 كم
          fillColor: Colors.green.withOpacity(0.02),
          strokeColor: Colors.green.withOpacity(0.3),
          strokeWidth: 1,
        ),
      );
    }

    return geofences;
  }

  /// بناء نقاط الاهتمام (POI)
  static Set<Marker> buildPointsOfInterest(
    List<DeviceEntity> devices,
    bool showPoI,
  ) {
    if (!showPoI) return {};

    final poiMarkers = <Marker>{};

    // يمكن إضافة نقاط اهتمام محددة مسبقاً
    // مثل المحطات والمستودعات والمكاتب

    return poiMarkers;
  }

  /// حساب إحصائيات المسار
  /// ملاحظة: تم تبسيطها لتعمل مع البيانات المتاحة الحالية
  static TrailStatistics calculateTrailStatistics(DeviceEntity device) {
    return TrailStatistics(
      totalDistance: 0.0,
      averageSpeed: device.speed ?? 0.0,
      maxSpeed: device.speed ?? 0.0,
      minSpeed: device.speed ?? 0.0,
      pointCount: 1,
    );
  }

  /// حساب المسافة بين نقطتين (Haversine Formula)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // كم

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = earthRadius * c;

    return distance;
  }

  /// تحويل الدرجات إلى راديان
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

/// فئة لتخزين إحصائيات المسار
class TrailStatistics {
  final double totalDistance; // بالكيلومتر
  final double averageSpeed; // كم/س
  final double maxSpeed; // كم/س
  final double minSpeed; // كم/س
  final int pointCount; // عدد النقاط

  TrailStatistics({
    required this.totalDistance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.minSpeed,
    required this.pointCount,
  });

  /// تنسيق الإحصائيات للعرض
  String formatStatistics() {
    return '''
المسافة الكلية: ${totalDistance.toStringAsFixed(2)} كم
متوسط السرعة: ${averageSpeed.toStringAsFixed(2)} كم/س
أقصى سرعة: ${maxSpeed.toStringAsFixed(2)} كم/س
أدنى سرعة: ${minSpeed.toStringAsFixed(2)} كم/س
عدد النقاط: $pointCount
    ''';
  }
}
