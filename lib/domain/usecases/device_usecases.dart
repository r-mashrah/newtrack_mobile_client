import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetDevicesUseCase {
  final DeviceRepository repository;

  GetDevicesUseCase(this.repository);

  Future<List<DeviceEntity>> call() async {
    return repository.getDevices();
  }
}

class GetDeviceByIdUseCase {
  final DeviceRepository repository;

  GetDeviceByIdUseCase(this.repository);

  Future<DeviceEntity> call(String id) async {
    return repository.getDeviceById(id);
  }
}

class GetDevicesByStatusUseCase {
  final DeviceRepository repository;

  GetDevicesByStatusUseCase(this.repository);

  Future<List<DeviceEntity>> call(String status) async {
    return repository.getDevicesByStatus(status);
  }
}

class AddDeviceUseCase {
  final DeviceRepository repository;

  AddDeviceUseCase(this.repository);

  Future<void> call(DeviceEntity device) async {
    return repository.addDevice(device);
  }
}

class UpdateDeviceUseCase {
  final DeviceRepository repository;

  UpdateDeviceUseCase(this.repository);

  Future<void> call(DeviceEntity device) async {
    return repository.updateDevice(device);
  }
}

class DeleteDeviceUseCase {
  final DeviceRepository repository;

  DeleteDeviceUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteDevice(id);
  }
}

class SubscribeToLiveUpdatesUseCase {
  final DeviceRepository repository;

  SubscribeToLiveUpdatesUseCase(this.repository);

  Stream<List<DeviceEntity>> call() {
    return repository.subscribeToLiveUpdates();
  }
}
