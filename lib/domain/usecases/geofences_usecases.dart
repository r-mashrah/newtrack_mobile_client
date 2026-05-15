import '../entities/map_object_entities.dart';
import '../repositories/geofences_repository.dart';

class GetGeofencesUseCase {
  final GeofencesRepository repository;
  GetGeofencesUseCase(this.repository);

  Future<List<GeofenceEntity>> call() async {
    return repository.getGeofences();
  }
}
