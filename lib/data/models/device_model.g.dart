// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceModelImpl _$$DeviceModelImplFromJson(Map<String, dynamic> json) =>
    _$DeviceModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imei: json['imei'] as String,
      plateNumber: json['plateNumber'] as String?,
      simNumber: json['simNumber'] as String?,
      model: json['model'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String? ?? 'offline',
      lastLocation: json['lastLocation'] as Map<String, dynamic>,
      speed: (json['speed'] as num?)?.toDouble(),
      fuelLevel: (json['fuelLevel'] as num?)?.toDouble(),
      batteryLevel: (json['batteryLevel'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      lastUpdate: json['lastUpdate'] as String?,
      sensors: json['sensors'] as Map<String, dynamic>?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DeviceModelImplToJson(_$DeviceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imei': instance.imei,
      'plateNumber': instance.plateNumber,
      'simNumber': instance.simNumber,
      'model': instance.model,
      'icon': instance.icon,
      'color': instance.color,
      'isActive': instance.isActive,
      'status': instance.status,
      'lastLocation': instance.lastLocation,
      'speed': instance.speed,
      'fuelLevel': instance.fuelLevel,
      'batteryLevel': instance.batteryLevel,
      'temperature': instance.temperature,
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
      'lastUpdate': instance.lastUpdate,
      'sensors': instance.sensors,
      'additionalData': instance.additionalData,
    };
