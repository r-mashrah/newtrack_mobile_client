import '../../domain/entities/map_object_entities.dart';
import '../../domain/repositories/geofences_repository.dart';
import '../datasources/remote_geofences_datasource.dart';

class GeofencesRepositoryImpl implements GeofencesRepository {
  final GeofencesDataSource _dataSource;

  GeofencesRepositoryImpl(this._dataSource);

  @override
  Future<List<GeofenceEntity>> getGeofences() async {
    return await _dataSource.getGeofences();
  }
}
