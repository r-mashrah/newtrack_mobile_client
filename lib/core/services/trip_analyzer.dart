import '../../domain/entities/history_entity.dart';
import '../../domain/entities/trip_entity.dart';

/// خدمة تحليل الرحلات: تحوّل نقاط GPS الخام إلى رحلات منظّمة مع إحصائيات
class TripAnalyzer {
  static const double _stopSpeedThreshold = 2.0; // كم/ساعة
  static const int _minStopDurationSeconds =
      60; // دقيقة واحدة على الأقل لاعتبارها توقفاً

  /// تحليل قائمة نقاط GPS وبناء رحلة كاملة
  static TripEntity analyzeTrip({
    required String deviceId,
    required String deviceName,
    String? plateNumber,
    required List<HistoryEntity> rawPoints,
  }) {
    if (rawPoints.isEmpty) {
      final now = DateTime.now();
      return TripEntity(
        id: '${deviceId}_${now.millisecondsSinceEpoch}',
        deviceId: deviceId,
        deviceName: deviceName,
        plateNumber: plateNumber,
        startTime: now,
        endTime: now,
        points: [],
        stops: [],
        events: [],
      );
    }

    // ترتيب النقاط زمنياً
    final sorted = List<HistoryEntity>.from(rawPoints)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // تحويل إلى GpsPoints
    final gpsPoints = sorted
        .map(
          (e) => GpsPoint(
            lat: e.latitude,
            lng: e.longitude,
            speed: e.speed,
            altitude: e.altitude,
            course: e.course,
            time: e.timestamp,
            rawData: e.otherData,
          ),
        )
        .toList();

    final startTime = gpsPoints.first.time;
    final endTime = gpsPoints.last.time;

    // استخراج التوقفات
    final stops = _extractStops(gpsPoints);

    // استخراج الأحداث
    final events = _buildTimeline(gpsPoints, stops, startTime, endTime);

    return TripEntity(
      id: '${deviceId}_${startTime.millisecondsSinceEpoch}',
      deviceId: deviceId,
      deviceName: deviceName,
      plateNumber: plateNumber,
      startTime: startTime,
      endTime: endTime,
      points: gpsPoints,
      stops: stops,
      events: events,
    );
  }

  /// استخراج فترات التوقف من النقاط
  static List<TripStop> _extractStops(List<GpsPoint> points) {
    final stops = <TripStop>[];
    int? stopStartIndex;
    int stopIndex = 0;

    for (int i = 0; i < points.length; i++) {
      final isStop = points[i].isStop;

      if (isStop && stopStartIndex == null) {
        stopStartIndex = i;
      } else if (!isStop && stopStartIndex != null) {
        final stopDuration = points[i].time.difference(
          points[stopStartIndex].time,
        );
        if (stopDuration.inSeconds >= _minStopDurationSeconds) {
          stops.add(
            TripStop(
              lat: points[stopStartIndex].lat,
              lng: points[stopStartIndex].lng,
              startTime: points[stopStartIndex].time,
              endTime: points[i - 1].time,
              reason: _inferStopReason(
                stopDuration,
                points[stopStartIndex].rawData,
              ),
              index: stopIndex++,
            ),
          );
        }
        stopStartIndex = null;
      }
    }

    // إذا انتهت النقاط وهناك توقف مفتوح
    if (stopStartIndex != null && points.length > stopStartIndex) {
      final stopDuration = points.last.time.difference(
        points[stopStartIndex].time,
      );
      if (stopDuration.inSeconds >= _minStopDurationSeconds) {
        stops.add(
          TripStop(
            lat: points[stopStartIndex].lat,
            lng: points[stopStartIndex].lng,
            startTime: points[stopStartIndex].time,
            endTime: points.last.time,
            reason: _inferStopReason(
              stopDuration,
              points[stopStartIndex].rawData,
            ),
            index: stopIndex,
          ),
        );
      }
    }

    return stops;
  }

  /// استنتاج سبب التوقف من البيانات المتاحة
  static StopReason _inferStopReason(
    Duration duration,
    Map<String, dynamic>? rawData,
  ) {
    // فحص حالة المحرك من البيانات الخام
    if (rawData != null) {
      final engine = rawData['engine'] ?? rawData['ignition'] ?? rawData['acc'];
      if (engine != null) {
        final engineStr = engine.toString().toLowerCase();
        if (engineStr == '0' || engineStr == 'false' || engineStr == 'off') {
          return StopReason.engineOff;
        }
      }
    }

    // استنتاج حسب مدة التوقف
    if (duration.inMinutes > 60) return StopReason.parking;
    if (duration.inMinutes > 15) return StopReason.idle;
    if (duration.inMinutes > 5) return StopReason.traffic;
    return StopReason.unknown;
  }

  /// بناء الخط الزمني التفاعلي
  static List<TripEvent> _buildTimeline(
    List<GpsPoint> points,
    List<TripStop> stops,
    DateTime startTime,
    DateTime endTime,
  ) {
    final events = <TripEvent>[];

    // حدث البداية
    events.add(
      TripEvent(
        time: startTime,
        type: TripEventType.start,
        lat: points.first.lat,
        lng: points.first.lng,
        description: 'بداية الرحلة',
      ),
    );

    // أحداث التوقف
    for (final stop in stops) {
      events.add(
        TripEvent(
          time: stop.startTime,
          type: TripEventType.stop,
          lat: stop.lat,
          lng: stop.lng,
          description: stop.reason.arabicName,
          data: {
            'duration': stop.duration.inSeconds,
            'reason': stop.reason.name,
          },
        ),
      );
    }

    // أحداث تجاوز السرعة
    GpsPoint? overSpeedStart;
    for (final p in points) {
      if (p.speed > 120 && overSpeedStart == null) {
        overSpeedStart = p;
      } else if (p.speed <= 120 && overSpeedStart != null) {
        events.add(
          TripEvent(
            time: overSpeedStart.time,
            type: TripEventType.overSpeed,
            lat: overSpeedStart.lat,
            lng: overSpeedStart.lng,
            description:
                'تجاوز سرعة: ${overSpeedStart.speed.toStringAsFixed(0)} كم/ساعة',
            data: {'speed': overSpeedStart.speed},
          ),
        );
        overSpeedStart = null;
      }
    }

    // حدث النهاية
    events.add(
      TripEvent(
        time: endTime,
        type: TripEventType.end,
        lat: points.last.lat,
        lng: points.last.lng,
        description: 'نهاية الرحلة',
      ),
    );

    // ترتيب الأحداث زمنياً
    events.sort((a, b) => a.time.compareTo(b.time));
    return events;
  }

  /// تجميع نقاط متعددة لأجهزة مختلفة لفترات زمنية مختلفة في رحلات
  /// (للشاشة الرئيسية - نجمع النقاط ضمن نفس الجهاز في رحلة واحدة)
  static List<TripEntity> groupPointsIntoTrips({
    required String deviceId,
    required String deviceName,
    String? plateNumber,
    required List<HistoryEntity> rawPoints,
    Duration maxGapBetweenTrips = const Duration(hours: 2),
  }) {
    if (rawPoints.isEmpty) return [];

    final sorted = List<HistoryEntity>.from(rawPoints)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final trips = <TripEntity>[];
    var currentBatch = <HistoryEntity>[sorted.first];

    for (int i = 1; i < sorted.length; i++) {
      final gap = sorted[i].timestamp.difference(sorted[i - 1].timestamp);
      if (gap > maxGapBetweenTrips) {
        // إغلاق الرحلة الحالية وبدء رحلة جديدة
        if (currentBatch.isNotEmpty) {
          trips.add(
            analyzeTrip(
              deviceId: deviceId,
              deviceName: deviceName,
              plateNumber: plateNumber,
              rawPoints: currentBatch,
            ),
          );
        }
        currentBatch = [sorted[i]];
      } else {
        currentBatch.add(sorted[i]);
      }
    }

    // إضافة آخر رحلة
    if (currentBatch.isNotEmpty) {
      trips.add(
        analyzeTrip(
          deviceId: deviceId,
          deviceName: deviceName,
          plateNumber: plateNumber,
          rawPoints: currentBatch,
        ),
      );
    }

    return trips;
  }
}
