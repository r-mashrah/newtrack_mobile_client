import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/geofence_model.dart';
import '../../domain/entities/map_object_entities.dart';

abstract class GeofencesDataSource {
  Future<List<GeofenceEntity>> getGeofences();
  Future<void> addGeofence(GeofenceEntity geofence);
  Future<void> updateGeofence(GeofenceEntity geofence);
  Future<void> deleteGeofence(String id);
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
          if (data['items'] is List) {
            items = data['items'];
          } else if (data['items'] is Map && data['items'].containsKey('geofences')) {
            items = data['items']['geofences'];
          }
        } else if (data is Map && data.containsKey('geofences')) {
          items = data['geofences'];
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

  @override
  Future<void> addGeofence(GeofenceEntity geofence) async {
    try {
      final String hexColor = '#${geofence.color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      
      final Map<String, dynamic> body = {
        'name': geofence.name,
        'active': true,
        'polygon_color': hexColor,
        'type': 'polygon', // Currently we only support polygons drawing
        'polygon': geofence.points.map((p) => {
          'lat': p.latitude,
          'lng': p.longitude,
        }).toList(),
      };

      final response = await _apiClient.post(
        ApiConstants.addGeofence,
        data: body,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to add geofence: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
         throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while adding geofence: ${e.message}');
    }
  }

  @override
  Future<void> updateGeofence(GeofenceEntity geofence) async {
    try {
      final String hexColor = '#${geofence.color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      
      final Map<String, dynamic> body = {
        'id': int.tryParse(geofence.id) ?? geofence.id,
        'name': geofence.name,
        'active': true,
        'polygon_color': hexColor,
        'type': 'polygon',
        'polygon': geofence.points.map((p) => {
          'lat': p.latitude,
          'lng': p.longitude,
        }).toList(),
      };

      final response = await _apiClient.post(
        ApiConstants.editGeofence,
        data: body,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to update geofence: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
         throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while updating geofence: ${e.message}');
    }
  }

  @override
  Future<void> deleteGeofence(String id) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.destroyGeofence,
        data: {
          'id': int.tryParse(id) ?? id,
        },
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to delete geofence: ${response.statusCode}');
      }
    } on DioException catch (e) {
       if (e.response?.data != null) {
         throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while deleting geofence: ${e.message}');
    }
  }
}
