import '../../domain/entities/map_object_entities.dart';

abstract class GeofencesRepository {
  Future<List<GeofenceEntity>> getGeofences();
}
