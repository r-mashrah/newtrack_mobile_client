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
        
        if (data is Map) {
          // GPSWox يرجع { status: 1, items: { alerts: [...] } }
          if (data.containsKey('items')) {
            final itemsObj = data['items'];
            if (itemsObj is Map && itemsObj.containsKey('alerts')) {
              items = itemsObj['alerts'] as List<dynamic>;
            } else if (itemsObj is List) {
              items = itemsObj;
            }
          } else if (data.containsKey('alerts')) {
            final alertsObj = data['alerts'];
            if (alertsObj is List) items = alertsObj;
          }
        } else if (data is List) {
          items = data;
        }

        return items.map((json) {
          return AlertModel.fromGpswoxJson(json as Map<String, dynamic>).toEntity();
        }).toList();
      } else {
        return [];
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
    try {
      int zone = 0;
      if (alert.insideGeofence) zone = 1;
      else if (alert.outsideGeofence) zone = 2;

      final Map<String, dynamic> body = {
        'name': alert.name,
        'type': alert.type,
        'devices': [int.tryParse(alert.deviceId) ?? alert.deviceId],
        'zone': zone,
        'notifications': {
          'push': {
            'active': alert.notificationType == 'push' ? 1 : 0
          }
        },
        'active': alert.isActive ? 1 : 0,
        'schedule': false,
      };

      if (alert.commandEnabled) {
        body['command'] = {
          'active': 1,
          'type': 'custom' // Replace with appropriate command type if supported
        };
      }

      if (alert.type == 'overspeed') {
        body['overspeed'] = alert.overspeed;
      } else if (alert.type == 'stop_duration') {
        body['stop_duration'] = alert.overspeed;
      } else if (alert.type == 'offline_duration') {
        body['offline_duration'] = alert.overspeed;
      } else if (alert.type == 'idle_duration') {
        body['idle_duration'] = alert.overspeed;
      } else if (alert.type == 'ignition_duration') {
        body['ignition_duration'] = alert.overspeed;
      }

      if (alert.geofenceIds.isNotEmpty) {
        final gIds = alert.geofenceIds.map((id) => int.tryParse(id) ?? id).toList();
        if (alert.type.contains('geofence')) {
          body['geofences'] = gIds;
        }
        if (zone > 0) {
          body['zones'] = gIds;
        }
      }
      
      final response = await _apiClient.post(
        ApiConstants.addAlert,
        data: body,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to add alert: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while adding alert: ${e.message}');
    }
  }

  @override
  Future<void> updateAlert(AlertEntity alert) async {
    try {
      int zone = 0;
      if (alert.insideGeofence) zone = 1;
      else if (alert.outsideGeofence) zone = 2;

      final Map<String, dynamic> body = {
        'id': alert.id,
        'name': alert.name,
        'type': alert.type,
        'devices': [int.tryParse(alert.deviceId) ?? alert.deviceId],
        'zone': zone,
        'notifications': {
          'push': {
            'active': alert.notificationType == 'push' ? 1 : 0
          }
        },
        'active': alert.isActive ? 1 : 0,
        'schedule': false,
      };

      if (alert.commandEnabled) {
        body['command'] = {
          'active': 1,
          'type': 'custom'
        };
      }

      if (alert.type == 'overspeed') {
        body['overspeed'] = alert.overspeed;
      } else if (alert.type == 'stop_duration') {
        body['stop_duration'] = alert.overspeed;
      } else if (alert.type == 'offline_duration') {
        body['offline_duration'] = alert.overspeed;
      } else if (alert.type == 'idle_duration') {
        body['idle_duration'] = alert.overspeed;
      } else if (alert.type == 'ignition_duration') {
        body['ignition_duration'] = alert.overspeed;
      }

      if (alert.geofenceIds.isNotEmpty) {
        final gIds = alert.geofenceIds.map((id) => int.tryParse(id) ?? id).toList();
        if (alert.type.contains('geofence')) {
          body['geofences'] = gIds;
        }
        if (zone > 0) {
          body['zones'] = gIds;
        }
      }

      final response = await _apiClient.post(
        ApiConstants.editAlert,
        data: body,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to update alert: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while updating alert: ${e.message}');
    }
  }

  @override
  Future<void> deleteAlert(String id) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.destroyAlert,
        data: FormData.fromMap({'id': id}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete alert: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error while deleting alert: ${e.message}');
    }
  }

  @override
  Future<void> toggleAlertStatus(String id, bool isActive) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.editAlert,
        data: FormData.fromMap({
          'id': id,
          'active': isActive ? '1' : '0',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle alert status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error while toggling alert: ${e.message}');
    }
  }
}
