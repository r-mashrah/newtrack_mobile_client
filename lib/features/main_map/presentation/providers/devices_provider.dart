import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/usecases/device_usecases.dart';
import 'devices_notifier.dart';
import 'devices_state.dart';

// ==================== Use Case Providers ====================

final getDevicesUseCaseProvider = Provider<GetDevicesUseCase>((ref) {
  return GetDevicesUseCase(ref.read(deviceRepositoryProvider));
});

final getDeviceByIdUseCaseProvider = Provider<GetDeviceByIdUseCase>((ref) {
  return GetDeviceByIdUseCase(ref.read(deviceRepositoryProvider));
});

final getDevicesByStatusUseCaseProvider = Provider<GetDevicesByStatusUseCase>((ref) {
  return GetDevicesByStatusUseCase(ref.read(deviceRepositoryProvider));
});

final addDeviceUseCaseProvider = Provider<AddDeviceUseCase>((ref) {
  return AddDeviceUseCase(ref.read(deviceRepositoryProvider));
});

final updateDeviceUseCaseProvider = Provider<UpdateDeviceUseCase>((ref) {
  return UpdateDeviceUseCase(ref.read(deviceRepositoryProvider));
});

final deleteDeviceUseCaseProvider = Provider<DeleteDeviceUseCase>((ref) {
  return DeleteDeviceUseCase(ref.read(deviceRepositoryProvider));
});

final subscribeToLiveUpdatesUseCaseProvider = Provider<SubscribeToLiveUpdatesUseCase>((ref) {
  return SubscribeToLiveUpdatesUseCase(ref.read(deviceRepositoryProvider));
});

// ==================== Notifier Provider ====================

final devicesNotifierProvider = StateNotifierProvider<DevicesNotifier, DevicesState>((ref) {
  return DevicesNotifier(
    getDevicesUseCase: ref.read(getDevicesUseCaseProvider),
    subscribeToLiveUpdatesUseCase: ref.read(subscribeToLiveUpdatesUseCaseProvider),
  );
});

// ==================== Computed Providers ====================

/// مزود للأجهزة المتصلة فقط
final onlineDevicesProvider = Provider<AsyncValue<List<DeviceEntity>>>((ref) {
  final state = ref.watch(devicesNotifierProvider);

  return state.when(
    initial: () => const AsyncValue.loading(),
    loading: () => const AsyncValue.loading(),
    loaded: (devices, isRefreshing, filterQuery, statusFilter) {
      final onlineDevices = devices.where((d) => d.isOnline).toList();
      return AsyncValue.data(onlineDevices);
    },
    error: (message, previousDevices) => AsyncValue.error(
      Exception(message),
      StackTrace.current,
    ),
  );
});

/// مزود للأجهزة المتحركة
final movingDevicesProvider = Provider<AsyncValue<List<DeviceEntity>>>((ref) {
  final state = ref.watch(devicesNotifierProvider);

  return state.when(
    initial: () => const AsyncValue.loading(),
    loading: () => const AsyncValue.loading(),
    loaded: (devices, isRefreshing, filterQuery, statusFilter) {
      final movingDevices = devices.where((d) => d.displayStatus == 'moving').toList();
      return AsyncValue.data(movingDevices);
    },
    error: (message, previousDevices) => AsyncValue.error(
      Exception(message),
      StackTrace.current,
    ),
  );
});

/// مزود لإحصائيات الأجهزة
final deviceStatsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(devicesNotifierProvider.notifier);
  return notifier.getStatistics();
});
