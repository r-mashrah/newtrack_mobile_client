import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/geofence_model.dart';
import '../../domain/entities/map_object_entities.dart';

abstract class GeofencesDataSource {
  Future<List<GeofenceEntity>> getGeofences();
}

class RemoteGeofencesDataSource implements GeofencesDataSource {
  final ApiClient _apiClient;

  RemoteGeofencesDataSource(this._apiClient);

  @override
  Future<List<GeofenceEntity>> getGeofences() async {
    try {
      final response = await _apiClient.get(ApiConstants.getGeofences);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];
        
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          items = data['items'];
        }

        return items.map((json) {
          return GeofenceModel.fromGpswoxJson(json as Map<String, dynamic>).toEntity();
        }).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return []; // Endpoint might not exist on some server versions, return empty
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
