import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/map_object_entities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final geofencesProvider = StateNotifierProvider<GeofencesNotifier, List<GeofenceEntity>>((ref) {
  return GeofencesNotifier();
});

class GeofencesNotifier extends StateNotifier<List<GeofenceEntity>> {
  GeofencesNotifier() : super([
    GeofenceEntity(
      id: '1',
      name: 'USA',
      points: [],
      color: const Color(0xFF1D99BD),
      createdAt: DateTime(2026, 1, 1, 9, 6, 56),
    ),
    GeofenceEntity(
      id: '2',
      name: 'Yemen',
      points: [
        const LatLng(15.3694, 44.1910),
        const LatLng(15.3694, 45.1910),
        const LatLng(14.3694, 45.1910),
        const LatLng(14.3694, 44.1910),
      ],
      color: const Color(0xFF1D99BD),
      createdAt: DateTime(2026, 1, 1, 8, 23, 37),
    ),
  ]);

  void addGeofence(GeofenceEntity geofence) {
    state = [...state, geofence];
  }

  void updateGeofence(GeofenceEntity geofence) {
    state = [
      for (final g in state)
        if (g.id == geofence.id) geofence else g
    ];
  }

  void removeGeofence(String id) {
    state = state.where((g) => g.id != id).toList();
  }
}

final poiProvider = StateNotifierProvider<POINotifier, List<POIEntity>>((ref) {
  return POINotifier();
});

class POINotifier extends StateNotifier<List<POIEntity>> {
  POINotifier() : super([]);

  void addPOI(POIEntity poi) {
    state = [...state, poi];
  }

  void updatePOI(POIEntity poi) {
    state = [
      for (final p in state)
        if (p.id == poi.id) poi else p
    ];
  }

  void removePOI(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}
