import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/poi_model.dart';
import '../../domain/entities/map_object_entities.dart';

abstract class POIDataSource {
  Future<List<POIEntity>> getPOIs();
  Future<void> addPOI(POIEntity poi);
  Future<void> updatePOI(POIEntity poi);
  Future<void> deletePOI(String id);
}

class RemotePOIDataSource implements POIDataSource {
  final ApiClient _apiClient;

  RemotePOIDataSource(this._apiClient);

  @override
  Future<List<POIEntity>> getPOIs() async {
    try {
      final response = await _apiClient.get(ApiConstants.getPois);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          if (data['items'] is List) {
            items = data['items'];
          } else if (data['items'] is Map &&
              data['items'].containsKey('mapIcons')) {
            items = data['items']['mapIcons'];
          }
        } else if (data is Map && data.containsKey('mapIcons')) {
          items = data['mapIcons'];
        }

        return items.map((json) {
          return POIModel.fromGpswoxJson(
            json as Map<String, dynamic>,
          ).toEntity();
        }).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> addPOI(POIEntity poi) async {
    try {
      int validIconId = 1;
      try {
        final iconsResponse = await _apiClient.get('/api/get_map_icons');
        if (iconsResponse.statusCode == 200 && iconsResponse.data != null) {
          final iconsData = iconsResponse.data;
          if (iconsData is Map && iconsData.containsKey('items')) {
            final items = iconsData['items'];
            if (items is List && items.isNotEmpty) {
              validIconId =
                  int.tryParse(items.first['id']?.toString() ?? '1') ?? 1;
            } else if (items is Map && items.isNotEmpty) {
              final firstValue = items.values.first;
              validIconId =
                  int.tryParse(firstValue['id']?.toString() ?? '1') ?? 1;
            }
          }
        }
      } catch (e) {
        print('Error fetching map icons: $e');
      }

      final Map<String, dynamic> body = {
        'name': poi.name,
        'description': poi.description ?? '',
        'active': true,
        'map_icon_id': validIconId,
        'coordinates':
            '{"lat":${poi.position.latitude},"lng":${poi.position.longitude}}',
      };

      final response = await _apiClient.post(ApiConstants.addPoi, data: body);

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to add POI: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while adding POI: ${e.message}');
    }
  }

  @override
  Future<void> updatePOI(POIEntity poi) async {
    try {
      int validIconId = 1;
      try {
        final iconsResponse = await _apiClient.get('/api/get_map_icons');
        if (iconsResponse.statusCode == 200 && iconsResponse.data != null) {
          final iconsData = iconsResponse.data;
          if (iconsData is Map && iconsData.containsKey('items')) {
            final items = iconsData['items'];
            if (items is List && items.isNotEmpty) {
              validIconId =
                  int.tryParse(items.first['id']?.toString() ?? '1') ?? 1;
            } else if (items is Map && items.isNotEmpty) {
              final firstValue = items.values.first;
              validIconId =
                  int.tryParse(firstValue['id']?.toString() ?? '1') ?? 1;
            }
          }
        }
      } catch (e) {
        print('Error fetching map icons: $e');
      }

      final Map<String, dynamic> body = {
        'id': int.tryParse(poi.id) ?? poi.id,
        'name': poi.name,
        'description': poi.description ?? '',
        'active': true,
        'map_icon_id': validIconId,
        'coordinates':
            '{"lat":${poi.position.latitude},"lng":${poi.position.longitude}}',
      };

      final response = await _apiClient.post(ApiConstants.editPoi, data: body);

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to update POI: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while updating POI: ${e.message}');
    }
  }

  @override
  Future<void> deletePOI(String id) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.destroyPoi,
        data: {'id': int.tryParse(id) ?? id},
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to delete POI: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while deleting POI: ${e.message}');
    }
  }
}
