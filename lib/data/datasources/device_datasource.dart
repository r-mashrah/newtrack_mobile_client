import 'dart:async';
import '../../domain/entities/device_entity.dart';
import '../../domain/entities/location_entity.dart';

abstract class DeviceDataSource {
  Future<List<DeviceEntity>> getDevices();
  Future<DeviceEntity> getDeviceById(String id);
  Future<List<DeviceEntity>> getDevicesByStatus(String status);
  Future<void> addDevice(DeviceEntity device);
  Future<void> updateDevice(DeviceEntity device);
  Future<void> deleteDevice(String id);
  Future<void> updateDeviceLocation(String deviceId, LocationEntity location);
  Stream<List<DeviceEntity>> subscribeToLiveUpdates();
}
