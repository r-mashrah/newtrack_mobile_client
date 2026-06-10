import '../../domain/entities/map_object_entities.dart';

abstract class GeofencesRepository {
  Future<List<GeofenceEntity>> getGeofences();
  Future<void> addGeofence(GeofenceEntity geofence);
  Future<void> updateGeofence(GeofenceEntity geofence);
  Future<void> deleteGeofence(String id);
}
