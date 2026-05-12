import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_utilities_provider.freezed.dart';

/// نقطة الاهتمام (PoI)
@freezed
class PointOfInterest with _$PointOfInterest {
  const factory PointOfInterest({
    required String id,
    required String name,
    required LatLng location,
    required String type,
    required String? description,
  }) = _PointOfInterest;
}

/// السور الجغرافي (Geofence)
@freezed
class Geofence with _$Geofence {
  const factory Geofence({
    required String id,
    required String name,
    required List<LatLng> points,
    required Color color,
    required String? description,
  }) = _Geofence;
}

/// نقطة المسار (Trail Point)
@freezed
class TrailPoint with _$TrailPoint {
  const factory TrailPoint({
    required LatLng location,
    required DateTime timestamp,
    required double? speed,
  }) = _TrailPoint;
}

/// حالة أدوات الخريطة
@freezed
class MapUtilitiesState with _$MapUtilitiesState {
  const factory MapUtilitiesState({
    required List<PointOfInterest> pointsOfInterest,
    required List<Geofence> geofences,
    required Map<String, List<TrailPoint>> deviceTrails,
    required bool isLoading,
    required String? error,
  }) = _MapUtilitiesState;

  factory MapUtilitiesState.initial() => const MapUtilitiesState(
    pointsOfInterest: [],
    geofences: [],
    deviceTrails: {},
    isLoading: false,
    error: null,
  );
}

/// Notifier لإدارة أدوات الخريطة
class MapUtilitiesNotifier extends StateNotifier<MapUtilitiesState> {
  MapUtilitiesNotifier() : super(MapUtilitiesState.initial());

  /// إضافة نقطة اهتمام
  void addPointOfInterest(PointOfInterest poi) {
    final updatedList = [...state.pointsOfInterest, poi];
    state = state.copyWith(pointsOfInterest: updatedList);
  }

  /// حذف نقطة اهتمام
  void removePointOfInterest(String id) {
    final updatedList = state.pointsOfInterest
        .where((poi) => poi.id != id)
        .toList();
    state = state.copyWith(pointsOfInterest: updatedList);
  }

  /// إضافة سور جغرافي
  void addGeofence(Geofence geofence) {
    final updatedList = [...state.geofences, geofence];
    state = state.copyWith(geofences: updatedList);
  }

  /// حذف سور جغرافي
  void removeGeofence(String id) {
    final updatedList = state.geofences
        .where((geofence) => geofence.id != id)
        .toList();
    state = state.copyWith(geofences: updatedList);
  }

  /// إضافة نقطة مسار لجهاز معين
  void addTrailPoint(String deviceId, TrailPoint point) {
    final trails = Map<String, List<TrailPoint>>.from(state.deviceTrails);
    if (!trails.containsKey(deviceId)) {
      trails[deviceId] = [];
    }
    trails[deviceId]!.add(point);
    state = state.copyWith(deviceTrails: trails);
  }

  /// مسح مسار جهاز معين
  void clearDeviceTrail(String deviceId) {
    final trails = Map<String, List<TrailPoint>>.from(state.deviceTrails);
    trails.remove(deviceId);
    state = state.copyWith(deviceTrails: trails);
  }

  /// مسح جميع المسارات
  void clearAllTrails() {
    state = state.copyWith(deviceTrails: {});
  }

  /// تحميل البيانات
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// تعيين رسالة خطأ
  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  /// تحميل نقاط الاهتمام (محاكاة)
  void loadPointsOfInterest() {
    final mockPois = [
      const PointOfInterest(
        id: 'poi_1',
        name: 'محطة الوقود',
        location: LatLng(15.3694, 44.1910),
        type: 'gas_station',
        description: 'محطة وقود رئيسية',
      ),
      const PointOfInterest(
        id: 'poi_2',
        name: 'مستشفى',
        location: LatLng(15.3750, 44.1950),
        type: 'hospital',
        description: 'مستشفى عام',
      ),
      const PointOfInterest(
        id: 'poi_3',
        name: 'مطعم',
        location: LatLng(15.3650, 44.1850),
        type: 'restaurant',
        description: 'مطعم تقليدي',
      ),
    ];
    state = state.copyWith(pointsOfInterest: mockPois);
  }

  /// تحميل الأسوار الجغرافية (محاكاة)
  void loadGeofences() {
    final mockGeofences = [
      Geofence(
        id: 'gf_1',
        name: 'منطقة المستودع',
        points: [
          const LatLng(15.3600, 44.1800),
          const LatLng(15.3700, 44.1800),
          const LatLng(15.3700, 44.1900),
          const LatLng(15.3600, 44.1900),
        ],
        color: Colors.blue.withOpacity(0.3),
        description: 'منطقة المستودع الرئيسية',
      ),
      Geofence(
        id: 'gf_2',
        name: 'منطقة الخدمة',
        points: [
          const LatLng(15.3750, 44.1950),
          const LatLng(15.3850, 44.1950),
          const LatLng(15.3850, 44.2050),
          const LatLng(15.3750, 44.2050),
        ],
        color: Colors.green.withOpacity(0.3),
        description: 'منطقة الخدمة الرئيسية',
      ),
    ];
    state = state.copyWith(geofences: mockGeofences);
  }
}

/// Provider لإدارة أدوات الخريطة
final mapUtilitiesNotifierProvider =
    StateNotifierProvider<MapUtilitiesNotifier, MapUtilitiesState>((ref) {
  return MapUtilitiesNotifier();
});

/// Provider لحالة أدوات الخريطة (للقراءة فقط)
final mapUtilitiesStateProvider = Provider<MapUtilitiesState>((ref) {
  return ref.watch(mapUtilitiesNotifierProvider);
});

/// Provider للحصول على نقاط الاهتمام
final pointsOfInterestProvider = Provider<List<PointOfInterest>>((ref) {
  return ref.watch(mapUtilitiesStateProvider).pointsOfInterest;
});

/// Provider للحصول على الأسوار الجغرافية
final geofencesProvider = Provider<List<Geofence>>((ref) {
  return ref.watch(mapUtilitiesStateProvider).geofences;
});

/// Provider للحصول على مسارات الأجهزة
final deviceTrailsProvider = Provider<Map<String, List<TrailPoint>>>((ref) {
  return ref.watch(mapUtilitiesStateProvider).deviceTrails;
});
