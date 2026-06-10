import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/alert_entity.dart';

part 'alert_model.freezed.dart';
part 'alert_model.g.dart';

@freezed
class AlertModel with _$AlertModel {
  const factory AlertModel({
    required String id,
    required String name,
    required String deviceId,
    required String deviceName,
    required String type,
    @Default(false) bool insideGeofence,
    @Default(false) bool outsideGeofence,
    required String notificationType,
    @Default(true) bool isActive,
    @Default(false) bool commandEnabled,
    @Default(0) int overspeed,
    @Default([]) List<String> geofenceIds,
  }) = _AlertModel;

  const AlertModel._();

  factory AlertModel.fromJson(Map<String, dynamic> json) => _$AlertModelFromJson(json);

  factory AlertModel.fromGpswoxJson(Map<String, dynamic> json) {
    List<String> geofences = [];
    if (json['geofences'] != null) {
      if (json['geofences'] is List) {
        geofences = (json['geofences'] as List).map((e) => e.toString()).toList();
      }
    } else if (json['geofence_id'] != null) {
      geofences.add(json['geofence_id'].toString());
    }

    String dId = '';
    if (json['devices'] != null && json['devices'] is List && (json['devices'] as List).isNotEmpty) {
      final item = (json['devices'] as List)[0];
      if (item is Map) {
        dId = item['id']?.toString() ?? item['pivot']?['device_id']?.toString() ?? '';
      } else {
        dId = item.toString();
      }
    } else if (json['device_id'] != null) {
      dId = json['device_id'].toString();
    }

    return AlertModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? json['type']?.toString() ?? 'تنبيه جديد',
      deviceId: dId,
      deviceName: json['device_name']?.toString() ?? json['deviceName']?.toString() ?? 'جهاز غير معروف',
      type: json['type']?.toString() ?? 'custom',
      insideGeofence: json['inside_geofence'] == 1 || json['inside_geofence'] == true || json['inside_geofence'] == '1',
      outsideGeofence: json['outside_geofence'] == 1 || json['outside_geofence'] == true || json['outside_geofence'] == '1',
      notificationType: json['notification_type']?.toString() ?? 'push',
      isActive: json['active'] == 1 || json['active'] == true || json['active'] == '1',
      commandEnabled: json['command_enabled'] == 1 || json['command_enabled'] == true || json['command_enabled'] == '1',
      overspeed: int.tryParse(json['overspeed']?.toString() ?? '0') ?? 0,
      geofenceIds: geofences,
    );
  }

  // تحويل من Model إلى Entity
  AlertEntity toEntity() {
    return AlertEntity(
      id: id,
      name: name,
      deviceId: deviceId,
      deviceName: deviceName,
      type: type,
      insideGeofence: insideGeofence,
      outsideGeofence: outsideGeofence,
      notificationType: notificationType,
      isActive: isActive,
      commandEnabled: commandEnabled,
      overspeed: overspeed,
      geofenceIds: geofenceIds,
    );
  }

  // تحويل من Entity إلى Model
  factory AlertModel.fromEntity(AlertEntity entity) {
    return AlertModel(
      id: entity.id,
      name: entity.name,
      deviceId: entity.deviceId,
      deviceName: entity.deviceName,
      type: entity.type,
      insideGeofence: entity.insideGeofence,
      outsideGeofence: entity.outsideGeofence,
      notificationType: entity.notificationType,
      isActive: entity.isActive,
      commandEnabled: entity.commandEnabled,
      overspeed: entity.overspeed,
      geofenceIds: entity.geofenceIds,
    );
  }
}
