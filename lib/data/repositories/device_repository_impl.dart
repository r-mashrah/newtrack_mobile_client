import '../../domain/entities/device_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_datasource.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDataSource _dataSource;

  DeviceRepositoryImpl(this._dataSource);

  @override
  Future<List<DeviceEntity>> getDevices() async {
    try {
      return await _dataSource.getDevices();
    } catch (e) {
      throw Exception('Failed to get devices: ${e.toString()}');
    }
  }

  @override
  Future<DeviceEntity> getDeviceById(String id) async {
    try {
      return await _dataSource.getDeviceById(id);
    } catch (e) {
      throw Exception('Failed to get device: ${e.toString()}');
    }
  }

  @override
  Future<List<DeviceEntity>> getDevicesByStatus(String status) async {
    try {
      return await _dataSource.getDevicesByStatus(status);
    } catch (e) {
      throw Exception('Failed to get devices by status: ${e.toString()}');
    }
  }

  @override
  Future<void> addDevice(DeviceEntity device) async {
    try {
      await _dataSource.addDevice(device);
    } catch (e) {
      throw Exception('Failed to add device: ${e.toString()}');
    }
  }

  @override
  Future<void> updateDevice(DeviceEntity device) async {
    try {
      await _dataSource.updateDevice(device);
    } catch (e) {
      throw Exception('Failed to update device: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDevice(String id) async {
    try {
      await _dataSource.deleteDevice(id);
    } catch (e) {
      throw Exception('Failed to delete device: ${e.toString()}');
    }
  }

  @override
  Future<void> updateDeviceLocation(String deviceId, LocationEntity location) async {
    try {
      await _dataSource.updateDeviceLocation(deviceId, location);
    } catch (e) {
      throw Exception('Failed to update device location: ${e.toString()}');
    }
  }

  @override
  Stream<List<DeviceEntity>> subscribeToLiveUpdates() {
    try {
      return _dataSource.subscribeToLiveUpdates();
    } catch (e) {
      throw Exception('Failed to subscribe to live updates: ${e.toString()}');
    }
  }
}
