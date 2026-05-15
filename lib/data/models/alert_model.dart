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
  }) = _AlertModel;

  const AlertModel._();

  factory AlertModel.fromJson(Map<String, dynamic> json) => _$AlertModelFromJson(json);

  factory AlertModel.fromGpswoxJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Alert',
      deviceId: json['device_id']?.toString() ?? '',
      deviceName: json['device_name']?.toString() ?? 'Unknown Device',
      type: json['type']?.toString() ?? 'custom',
      insideGeofence: json['inside_geofence'] == 1 || json['inside_geofence'] == true,
      outsideGeofence: json['outside_geofence'] == 1 || json['outside_geofence'] == true,
      notificationType: json['notification_type']?.toString() ?? 'push',
      isActive: json['active'] == 1 || json['active'] == true,
      commandEnabled: json['command_enabled'] == 1 || json['command_enabled'] == true,
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
    );
  }
}
