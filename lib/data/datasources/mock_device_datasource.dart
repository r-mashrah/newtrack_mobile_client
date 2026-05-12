import 'dart:async';
import 'dart:math';
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

class MockDeviceDataSource implements DeviceDataSource {
  final List<DeviceEntity> _mockDevices = [];
  final StreamController<List<DeviceEntity>> _updateController = StreamController.broadcast();
  Timer? _updateTimer;

  MockDeviceDataSource() {
    _initializeMockDevices();
    _startLiveUpdates();
  }

  void _initializeMockDevices() {
    final baseLocations = [
      LocationEntity(
        latitude: 15.3694,
        longitude: 44.1910,
        timestamp: DateTime.now(),
      ),
      LocationEntity(
        latitude: 15.3547,
        longitude: 44.2067,
        timestamp: DateTime.now(),
      ),
      LocationEntity(
        latitude: 15.3423,
        longitude: 44.2012,
        timestamp: DateTime.now(),
      ),
      LocationEntity(
        latitude: 15.3589,
        longitude: 44.2134,
        timestamp: DateTime.now(),
      ),
      LocationEntity(
        latitude: 15.3656,
        longitude: 44.1987,
        timestamp: DateTime.now(),
      ),
    ];

    final deviceNames = [
      'Toyota Camry - صالح',
      'Honda Civic - أحمد',
      'Ford Ranger - محمد',
      'Nissan Patrol - خالد',
      'Hyundai Elantra - يوسف',
    ];

    final colors = ['red', 'blue', 'green', 'orange', 'purple'];

    for (int i = 0; i < 5; i++) {
      _mockDevices.add(
        DeviceEntity(
          id: 'device_${i + 1}',
          name: deviceNames[i],
          imei: 'IMEI_${100000000000000 + i}',
          group: i == 0 ? 'Group A' : null,
          tailLength: 10,
          tailColor: '#FF0000',
          markerImage: 'car',
          movingColor: '#00FF00',
          stoppedColor: '#FF0000',
          disconnectedColor: '#808080',
          idleColor: '#FFFF00',
          plateNumber: 'YEM-${1000 + i}',
          simNumber: 'SIM_${700000000 + i}',
          model: i % 2 == 0 ? 'Toyota' : 'Honda',
          color: colors[i],
          lastLocation: baseLocations[i],
          status: i == 0 ? 'moving' : (i == 1 ? 'stopped' : 'offline'),
          speed: i == 0 ? 45.5 : (i == 1 ? 0.0 : null),
          fuelLevel: 60.0 + (i * 5.0),
          batteryLevel: 80.0 - (i * 3.0),
          driverName: 'Driver ${i + 1}',
          driverPhone: '777${1000000 + i}',
          lastUpdate: DateTime.now().subtract(Duration(minutes: i * 2)),
        ),
      );
    }
  }

  void _startLiveUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateDevicePositions();
      _updateController.add(List.from(_mockDevices));
    });
  }

  void _updateDevicePositions() {
    final random = Random();

    for (int i = 0; i < _mockDevices.length; i++) {
      final device = _mockDevices[i];
      if (device.status == 'moving') {
        // تحديث موقع الجهاز المتحرك
        final newLat = device.lastLocation.latitude + 
            (random.nextDouble() - 0.5) * 0.001;
        final newLng = device.lastLocation.longitude + 
            (random.nextDouble() - 0.5) * 0.001;
        final newSpeed = 30.0 + random.nextDouble() * 40.0;

        _mockDevices[i] = device.copyWith(
          lastLocation: LocationEntity(
            latitude: newLat,
            longitude: newLng,
            timestamp: DateTime.now(),
          ),
          speed: newSpeed,
          lastUpdate: DateTime.now(),
        );
      }
    }
  }

  @override
  Future<List<DeviceEntity>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockDevices);
  }

  @override
  Future<DeviceEntity> getDeviceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final device = _mockDevices.firstWhere(
      (device) => device.id == id,
      orElse: () => throw Exception('Device not found'),
    );
    return device;
  }

  @override
  Future<List<DeviceEntity>> getDevicesByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDevices.where((device) => device.status == status).toList();
  }

  @override
  Future<void> addDevice(DeviceEntity device) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockDevices.add(device);
    _updateController.add(List.from(_mockDevices));
  }

  @override
  Future<void> updateDevice(DeviceEntity device) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockDevices.indexWhere((d) => d.id == device.id);
    if (index != -1) {
      _mockDevices[index] = device;
      _updateController.add(List.from(_mockDevices));
    }
  }

  @override
  Future<void> deleteDevice(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockDevices.removeWhere((device) => device.id == id);
    _updateController.add(List.from(_mockDevices));
  }

  @override
  Future<void> updateDeviceLocation(String deviceId, LocationEntity location) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockDevices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _mockDevices[index] = _mockDevices[index].copyWith(
        lastLocation: location,
        lastUpdate: DateTime.now(),
      );
      _updateController.add(List.from(_mockDevices));
    }
  }

  @override
  Stream<List<DeviceEntity>> subscribeToLiveUpdates() {
    return _updateController.stream;
  }

  void dispose() {
    _updateTimer?.cancel();
    _updateController.close();
  }
}
