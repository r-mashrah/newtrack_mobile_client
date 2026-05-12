// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertModelImpl _$$AlertModelImplFromJson(Map<String, dynamic> json) =>
    _$AlertModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      type: json['type'] as String,
      insideGeofence: json['insideGeofence'] as bool? ?? false,
      outsideGeofence: json['outsideGeofence'] as bool? ?? false,
      notificationType: json['notificationType'] as String,
      isActive: json['isActive'] as bool? ?? true,
      commandEnabled: json['commandEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$AlertModelImplToJson(_$AlertModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'type': instance.type,
      'insideGeofence': instance.insideGeofence,
      'outsideGeofence': instance.outsideGeofence,
      'notificationType': instance.notificationType,
      'isActive': instance.isActive,
      'commandEnabled': instance.commandEnabled,
    };
