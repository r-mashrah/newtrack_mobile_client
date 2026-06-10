import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/map_object_entities.dart';
import '../../../../core/providers/repository_providers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final geofencesProvider =
    StateNotifierProvider<GeofencesNotifier, AsyncValue<List<GeofenceEntity>>>((
      ref,
    ) {
      return GeofencesNotifier(ref);
    });

class GeofencesNotifier
    extends StateNotifier<AsyncValue<List<GeofenceEntity>>> {
  final Ref _ref;

  GeofencesNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadGeofences();
  }

  Future<void> loadGeofences() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(geofencesRepositoryProvider);
      final geofences = await repository.getGeofences();
      state = AsyncValue.data(geofences);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addGeofence(GeofenceEntity geofence) async {
    try {
      final repository = _ref.read(geofencesRepositoryProvider);
      await repository.addGeofence(geofence);
      await loadGeofences(); // Refresh from server
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateGeofence(GeofenceEntity geofence) async {
    try {
      final repository = _ref.read(geofencesRepositoryProvider);
      await repository.updateGeofence(geofence);
      await loadGeofences(); // Refresh from server
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> removeGeofence(String id) async {
    try {
      final repository = _ref.read(geofencesRepositoryProvider);
      await repository.deleteGeofence(id);
      await loadGeofences(); // Refresh from server
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final poiProvider = StateNotifierProvider<POINotifier, AsyncValue<List<POIEntity>>>((ref) {
  return POINotifier(ref);
});

class POINotifier extends StateNotifier<AsyncValue<List<POIEntity>>> {
  final Ref _ref;

  POINotifier(this._ref) : super(const AsyncValue.loading()) {
    loadPOIs();
  }

  Future<void> loadPOIs() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(poiRepositoryProvider);
      final pois = await repository.getPOIs();
      state = AsyncValue.data(pois);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPOI(POIEntity poi) async {
    try {
      final repository = _ref.read(poiRepositoryProvider);
      await repository.addPOI(poi);
      await loadPOIs(); // Refresh from server
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updatePOI(POIEntity poi) async {
    try {
      final repository = _ref.read(poiRepositoryProvider);
      await repository.updatePOI(poi);
      await loadPOIs(); // Refresh from server
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> removePOI(String id) async {
    try {
      final repository = _ref.read(poiRepositoryProvider);
      await repository.deletePOI(id);
      await loadPOIs(); // Refresh from server
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
