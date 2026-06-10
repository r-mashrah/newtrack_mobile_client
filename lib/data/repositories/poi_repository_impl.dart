import '../../domain/entities/map_object_entities.dart';
import '../../domain/repositories/poi_repository.dart';
import '../datasources/remote_poi_datasource.dart';

class POIRepositoryImpl implements POIRepository {
  final POIDataSource _dataSource;

  POIRepositoryImpl(this._dataSource);

  @override
  Future<List<POIEntity>> getPOIs() {
    return _dataSource.getPOIs();
  }

  @override
  Future<void> addPOI(POIEntity poi) {
    return _dataSource.addPOI(poi);
  }

  @override
  Future<void> updatePOI(POIEntity poi) {
    return _dataSource.updatePOI(poi);
  }

  @override
  Future<void> deletePOI(String id) {
    return _dataSource.deletePOI(id);
  }
}
