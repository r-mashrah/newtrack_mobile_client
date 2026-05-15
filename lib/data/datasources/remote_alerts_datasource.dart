import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/alert_model.dart';
import '../../domain/entities/alert_entity.dart';

abstract class AlertsDataSource {
  Future<List<AlertEntity>> getAlerts();
  Future<void> addAlert(AlertEntity alert);
  Future<void> updateAlert(AlertEntity alert);
  Future<void> deleteAlert(String id);
  Future<void> toggleAlertStatus(String id, bool isActive);
}

class RemoteAlertsDataSource implements AlertsDataSource {
  final ApiClient _apiClient;

  RemoteAlertsDataSource(this._apiClient);

  @override
  Future<List<AlertEntity>> getAlerts() async {
    try {
      final response = await _apiClient.get(ApiConstants.getAlerts);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];
        
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          items = data['items'];
        }

        return items.map((json) {
          return AlertModel.fromGpswoxJson(json as Map<String, dynamic>).toEntity();
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
  Future<void> addAlert(AlertEntity alert) async {
    // POST /api/add_alert
    throw UnimplementedError('Add alert API not mapped yet');
  }

  @override
  Future<void> updateAlert(AlertEntity alert) async {
    // POST /api/edit_alert
    throw UnimplementedError('Update alert API not mapped yet');
  }

  @override
  Future<void> deleteAlert(String id) async {
    // POST /api/destroy_alert
    throw UnimplementedError('Delete alert API not mapped yet');
  }

  @override
  Future<void> toggleAlertStatus(String id, bool isActive) async {
    // Depends on specific GPSWox implementation
    throw UnimplementedError('Toggle alert API not mapped yet');
  }
}
