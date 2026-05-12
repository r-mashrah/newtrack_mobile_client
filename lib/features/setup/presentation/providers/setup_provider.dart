import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/mock_setup_datasource.dart';
import '../../../../data/models/setup_models.dart';

final setupDataSourceProvider = Provider<SetupDataSource>((ref) {
  return MockSetupDataSource();
});

final userSettingsProvider = StateNotifierProvider<UserSettingsNotifier, AsyncValue<UserSettings>>((ref) {
  return UserSettingsNotifier(ref.watch(setupDataSourceProvider));
});

class UserSettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  final SetupDataSource _dataSource;
  UserSettingsNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _dataSource.getUserSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSettings(UserSettings settings) async {
    try {
      await _dataSource.updateUserSettings(settings);
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final vehicleGroupsProvider = FutureProvider<List<VehicleGroup>>((ref) async {
  return ref.watch(setupDataSourceProvider).getVehicleGroups();
});

final driversProvider = FutureProvider<List<Driver>>((ref) async {
  return ref.watch(setupDataSourceProvider).getDrivers();
});

final eventsProvider = FutureProvider<List<AppEvent>>((ref) async {
  return ref.watch(setupDataSourceProvider).getEvents();
});

final smsTemplatesProvider = FutureProvider<List<SmsTemplate>>((ref) async {
  return ref.watch(setupDataSourceProvider).getSmsTemplates();
});

final gprsTemplatesProvider = FutureProvider<List<SmsTemplate>>((ref) async {
  return ref.watch(setupDataSourceProvider).getGprsTemplates();
});

final smsGatewaySettingsProvider = StateNotifierProvider<SmsGatewayNotifier, AsyncValue<SmsGatewaySettings>>((ref) {
  return SmsGatewayNotifier(ref.watch(setupDataSourceProvider));
});

class SmsGatewayNotifier extends StateNotifier<AsyncValue<SmsGatewaySettings>> {
  final SetupDataSource _dataSource;
  SmsGatewayNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _dataSource.getSmsGatewaySettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSettings(SmsGatewaySettings settings) async {
    try {
      await _dataSource.updateSmsGatewaySettings(settings);
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
