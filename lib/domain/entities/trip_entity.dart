// trip_entity.dart - كيان الرحلة الكامل
import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// نقطة GPS واحدة على المسار
class GpsPoint {
  final double lat;
  final double lng;
  final double speed;
  final double altitude;
  final double course;
  final DateTime time;
  final Map<String, dynamic>? rawData;

  const GpsPoint({
    required this.lat,
    required this.lng,
    required this.speed,
    required this.altitude,
    required this.course,
    required this.time,
    this.rawData,
  });

  /// هل هذه النقطة تعتبر توقفاً (سرعة صفر تقريباً)
  bool get isStop => speed < 2.0;

  /// لون المسار حسب السرعة
  SpeedCategory get speedCategory {
    if (speed < 20) return SpeedCategory.low;
    if (speed < 80) return SpeedCategory.normal;
    return SpeedCategory.high;
  }
}

enum SpeedCategory { low, normal, high }

/// كيان توقف داخل الرحلة
class TripStop {
  final double lat;
  final double lng;
  final DateTime startTime;
  final DateTime endTime;
  final String? address;
  final StopReason reason;
  final int index; // ترتيب التوقف في الرحلة

  const TripStop({
    required this.lat,
    required this.lng,
    required this.startTime,
    required this.endTime,
    this.address,
    required this.reason,
    required this.index,
  });

  Duration get duration => endTime.difference(startTime);

  String get durationFormatted {
    final d = duration;
    if (d.inHours > 0) return '${d.inHours}س ${d.inMinutes.remainder(60)}د';
    return '${d.inMinutes}د ${d.inSeconds.remainder(60)}ث';
  }
}

enum StopReason { traffic, engineOff, parking, idle, unknown }

extension StopReasonExt on StopReason {
  String get arabicName {
    switch (this) {
      case StopReason.traffic:
        return 'ازدحام';
      case StopReason.engineOff:
        return 'محرك متوقف';
      case StopReason.parking:
        return 'انتظار';
      case StopReason.idle:
        return 'خمول';
      case StopReason.unknown:
        return 'غير محدد';
    }
  }

  String getName(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case StopReason.traffic:
        return isAr ? 'ازدحام' : 'Traffic Jam';
      case StopReason.engineOff:
        return isAr ? 'محرك متوقف' : 'Engine Off';
      case StopReason.parking:
        return isAr ? 'انتظار' : 'Parking';
      case StopReason.idle:
        return isAr ? 'خمول' : 'Idle';
      case StopReason.unknown:
        return isAr ? 'غير محدد' : 'Unknown';
    }
  }

  String get icon {
    switch (this) {
      case StopReason.traffic:
        return '🚦';
      case StopReason.engineOff:
        return '🔴';
      case StopReason.parking:
        return '🅿️';
      case StopReason.idle:
        return '⏸️';
      case StopReason.unknown:
        return '📍';
    }
  }
}

/// حدث في الخط الزمني
class TripEvent {
  final DateTime time;
  final TripEventType type;
  final double? lat;
  final double? lng;
  final String? description;
  final Map<String, dynamic>? data;

  const TripEvent({
    required this.time,
    required this.type,
    this.lat,
    this.lng,
    this.description,
    this.data,
  });
}

enum TripEventType {
  start,
  moving,
  stop,
  alert,
  overSpeed,
  engineOn,
  engineOff,
  geofenceEntry,
  geofenceExit,
  end,
}

extension TripEventTypeExt on TripEventType {
  String get arabicName {
    switch (this) {
      case TripEventType.start:
        return 'بداية الرحلة';
      case TripEventType.moving:
        return 'حركة';
      case TripEventType.stop:
        return 'توقف';
      case TripEventType.alert:
        return 'تنبيه';
      case TripEventType.overSpeed:
        return 'تجاوز سرعة';
      case TripEventType.engineOn:
        return 'تشغيل محرك';
      case TripEventType.engineOff:
        return 'إيقاف محرك';
      case TripEventType.geofenceEntry:
        return 'دخول منطقة';
      case TripEventType.geofenceExit:
        return 'خروج منطقة';
      case TripEventType.end:
        return 'نهاية الرحلة';
    }
  }

  String getName(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case TripEventType.start:
        return isAr ? 'بداية الرحلة' : 'Trip Started';
      case TripEventType.moving:
        return isAr ? 'حركة' : 'Moving';
      case TripEventType.stop:
        return isAr ? 'توقف' : 'Stopped';
      case TripEventType.alert:
        return isAr ? 'تنبيه' : 'Alert';
      case TripEventType.overSpeed:
        return isAr ? 'تجاوز سرعة' : 'Over Speed';
      case TripEventType.engineOn:
        return isAr ? 'تشغيل محرك' : 'Engine On';
      case TripEventType.engineOff:
        return isAr ? 'إيقاف محرك' : 'Engine Off';
      case TripEventType.geofenceEntry:
        return isAr ? 'دخول منطقة' : 'Enter Geofence';
      case TripEventType.geofenceExit:
        return isAr ? 'خروج منطقة' : 'Exit Geofence';
      case TripEventType.end:
        return isAr ? 'نهاية الرحلة' : 'Trip Finished';
    }
  }

  String get icon {
    switch (this) {
      case TripEventType.start:
        return '🟢';
      case TripEventType.moving:
        return '🚗';
      case TripEventType.stop:
        return '🔴';
      case TripEventType.alert:
        return '⚠️';
      case TripEventType.overSpeed:
        return '⚡';
      case TripEventType.engineOn:
        return '🔑';
      case TripEventType.engineOff:
        return '🔌';
      case TripEventType.geofenceEntry:
        return '📥';
      case TripEventType.geofenceExit:
        return '📤';
      case TripEventType.end:
        return '🏁';
    }
  }
}

/// كيان الرحلة الكامل - مجمّع من نقاط GPS
class TripEntity {
  final String id; // مولّد من deviceId + startTime
  final String deviceId;
  final String deviceName;
  final String? plateNumber;
  final DateTime startTime;
  final DateTime endTime;
  final List<GpsPoint> points;
  final List<TripStop> stops;
  final List<TripEvent> events;

  const TripEntity({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    this.plateNumber,
    required this.startTime,
    required this.endTime,
    required this.points,
    required this.stops,
    required this.events,
  });

  // ==================== الإحصائيات المحسوبة ====================

  Duration get duration => endTime.difference(startTime);

  String get durationFormatted {
    final d = duration;
    if (d.inHours > 0) return '${d.inHours}س ${d.inMinutes.remainder(60)}د';
    return '${d.inMinutes}د';
  }

  /// المسافة الكلية بالكيلومتر (محسوبة من النقاط)
  double get distanceKm {
    if (points.length < 2) return 0.0;
    double total = 0.0;
    for (int i = 1; i < points.length; i++) {
      total += _haversineDistance(
        points[i - 1].lat,
        points[i - 1].lng,
        points[i].lat,
        points[i].lng,
      );
    }
    return total;
  }

  double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double get maxSpeed => points.isEmpty
      ? 0
      : points.map((p) => p.speed).reduce((a, b) => a > b ? a : b);

  double get avgSpeed {
    if (points.isEmpty) return 0;
    final movingPoints = points.where((p) => !p.isStop).toList();
    if (movingPoints.isEmpty) return 0;
    return movingPoints.map((p) => p.speed).reduce((a, b) => a + b) /
        movingPoints.length;
  }

  /// وقت الحركة الصافي
  Duration get movingTime {
    final movingPoints = points.where((p) => !p.isStop).length;
    if (points.length < 2) return Duration.zero;
    final ratio = movingPoints / points.length;
    return Duration(seconds: (duration.inSeconds * ratio).round());
  }

  /// وقت التوقف الكلي
  Duration get stopTime =>
      stops.fold(Duration.zero, (acc, s) => acc + s.duration);

  /// نسبة الحركة (0-1)
  double get movingRatio {
    final total = duration.inSeconds;
    if (total == 0) return 0;
    return (total - stopTime.inSeconds) / total;
  }

  int get stopsCount => stops.length;

  GpsPoint? get startPoint => points.isNotEmpty ? points.first : null;
  GpsPoint? get endPoint => points.isNotEmpty ? points.last : null;

  /// تصنيف الرحلة
  TripCategory get category {
    if (distanceKm > 100) return TripCategory.longTrip;
    if (distanceKm < 10) return TripCategory.shortTrip;
    if (maxSpeed > 120) return TripCategory.fastTrip;
    if (stopsCount >= 3) return TripCategory.stops;
    if (startTime.hour >= 21 || startTime.hour < 6) return TripCategory.night;
    return TripCategory.normal;
  }

  bool get hasOverSpeed => maxSpeed > 120;
}

enum TripCategory { longTrip, shortTrip, fastTrip, stops, night, normal }

extension TripCategoryExt on TripCategory {
  String get arabicName {
    switch (this) {
      case TripCategory.longTrip:
        return 'رحلة طويلة';
      case TripCategory.shortTrip:
        return 'رحلة قصيرة';
      case TripCategory.fastTrip:
        return 'رحلة سريعة';
      case TripCategory.stops:
        return 'متعددة التوقفات';
      case TripCategory.night:
        return 'رحلة ليلية';
      case TripCategory.normal:
        return 'رحلة عادية';
    }
  }

  String getName(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case TripCategory.longTrip:
        return isAr ? 'رحلة طويلة' : 'Long Trip';
      case TripCategory.shortTrip:
        return isAr ? 'رحلة قصيرة' : 'Short Trip';
      case TripCategory.fastTrip:
        return isAr ? 'رحلة سريعة' : 'Fast Trip';
      case TripCategory.stops:
        return isAr ? 'متعددة التوقفات' : 'Multiple Stops';
      case TripCategory.night:
        return isAr ? 'رحلة ليلية' : 'Night Trip';
      case TripCategory.normal:
        return isAr ? 'رحلة عادية' : 'Normal Trip';
    }
  }
}
