import '../entities/map_object_entities.dart';

abstract class POIRepository {
  Future<List<POIEntity>> getPOIs();
  Future<void> addPOI(POIEntity poi);
  Future<void> updatePOI(POIEntity poi);
  Future<void> deletePOI(String id);
}
