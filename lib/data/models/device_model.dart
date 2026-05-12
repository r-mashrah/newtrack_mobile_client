import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/entities/location_entity.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

@freezed
class DeviceModel with _$DeviceModel {
  const factory DeviceModel({
    required String id,
    required String name,
    required String imei,
    String? plateNumber,
    String? simNumber,
    String? model,
    String? icon,
    String? color,
    @Default(true) bool isActive,
    @Default('offline') String status,
    required Map<String, dynamic> lastLocation,
    double? speed,
    double? fuelLevel,
    double? batteryLevel,
    double? temperature,
    String? driverName,
    String? driverPhone,
    String? lastUpdate,
    Map<String, dynamic>? sensors,
    Map<String, dynamic>? additionalData,
  }) = _DeviceModel;

  const DeviceModel._();

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  // تحويل من Model إلى Entity
  DeviceEntity toEntity() {
    return DeviceEntity(
      id: id,
      name: name,
      imei: imei,
      plateNumber: plateNumber,
      simNumber: simNumber,
      model: model,
      icon: icon,
      color: color,
      isActive: isActive,
      status: status,
      lastLocation: LocationEntity(
        latitude: lastLocation['latitude'] as double,
        longitude: lastLocation['longitude'] as double,
        timestamp: DateTime.parse(lastLocation['timestamp'] as String),
        altitude: lastLocation['altitude'] as double?,
        speed: lastLocation['speed'] as double?,
        accuracy: lastLocation['accuracy'] as double?,
        bearing: lastLocation['bearing'] as double?,
      ),
      speed: speed,
      fuelLevel: fuelLevel,
      batteryLevel: batteryLevel,
      temperature: temperature,
      driverName: driverName,
      driverPhone: driverPhone,
      lastUpdate: lastUpdate != null ? DateTime.parse(lastUpdate!) : null,
      sensors: sensors,
      additionalData: additionalData,
    );
  }

  // تحويل من Entity إلى Model
  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      id: entity.id,
      name: entity.name,
      imei: entity.imei,
      plateNumber: entity.plateNumber,
      simNumber: entity.simNumber,
      model: entity.model,
      icon: entity.icon,
      color: entity.color,
      isActive: entity.isActive,
      status: entity.status,
      lastLocation: {
        'latitude': entity.lastLocation.latitude,
        'longitude': entity.lastLocation.longitude,
        'timestamp': entity.lastLocation.timestamp.toIso8601String(),
        if (entity.lastLocation.altitude != null)
          'altitude': entity.lastLocation.altitude,
        if (entity.lastLocation.speed != null)
          'speed': entity.lastLocation.speed,
        if (entity.lastLocation.accuracy != null)
          'accuracy': entity.lastLocation.accuracy,
        if (entity.lastLocation.bearing != null)
          'bearing': entity.lastLocation.bearing,
      },
      speed: entity.speed,
      fuelLevel: entity.fuelLevel,
      batteryLevel: entity.batteryLevel,
      temperature: entity.temperature,
      driverName: entity.driverName,
      driverPhone: entity.driverPhone,
      lastUpdate: entity.lastUpdate?.toIso8601String(),
      sensors: entity.sensors,
      additionalData: entity.additionalData,
    );
  }
}
