import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/setup_datasource.dart';
import '../../../../data/datasources/remote_setup_datasource.dart';
import '../../../../data/models/setup_models.dart';
import '../../../../data/models/command_models.dart';
import '../../../../core/providers/api_client_provider.dart';

final setupDataSourceProvider = Provider<SetupDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteSetupDataSource(apiClient);
});

final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, AsyncValue<UserSettings>>((ref) {
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

/// Official command metadata from GET /send_command_data
final sendCommandDataProvider = FutureProvider<SendCommandData>((ref) async {
  return ref.watch(setupDataSourceProvider).getSendCommandData();
});

final smsTemplatesProvider = FutureProvider<List<SmsTemplate>>((ref) async {
  final data = await ref.watch(sendCommandDataProvider.future);
  return data.smsTemplates;
});

final gprsTemplatesProvider = FutureProvider<List<SmsTemplate>>((ref) async {
  final data = await ref.watch(sendCommandDataProvider.future);
  return data.gprsTemplates;
});

final commandTypesProvider = FutureProvider<List<CommandTypeOption>>((ref) async {
  final data = await ref.watch(sendCommandDataProvider.future);
  return data.commandTypes;
});

final smsGatewaySettingsProvider =
    StateNotifierProvider<SmsGatewayNotifier, AsyncValue<SmsGatewaySettings>>((ref) {
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

// ==================== Command Sending Providers ====================

class CommandSendState {
  final bool isSending;
  final CommandResult? lastResult;

  const CommandSendState({this.isSending = false, this.lastResult});

  CommandSendState copyWith({bool? isSending, CommandResult? lastResult}) {
    return CommandSendState(
      isSending: isSending ?? this.isSending,
      lastResult: lastResult ?? this.lastResult,
    );
  }
}

class GprsCommandNotifier extends StateNotifier<CommandSendState> {
  final SetupDataSource _dataSource;
  GprsCommandNotifier(this._dataSource) : super(const CommandSendState());

  Future<CommandResult> send({
    required String deviceId,
    required String commandType,
    String? message,
    bool autoSendWhenOnline = false,
  }) async {
    state = const CommandSendState(isSending: true);
    final result = await _dataSource.sendGprsCommand(
      deviceId: deviceId,
      commandType: commandType,
      message: message,
      autoSendWhenOnline: autoSendWhenOnline,
    );
    state = CommandSendState(isSending: false, lastResult: result);
    return result;
  }

  void reset() => state = const CommandSendState();
}

class SmsCommandNotifier extends StateNotifier<CommandSendState> {
  final SetupDataSource _dataSource;
  SmsCommandNotifier(this._dataSource) : super(const CommandSendState());

  Future<CommandResult> send({
    required String deviceId,
    required String message,
  }) async {
    state = const CommandSendState(isSending: true);
    final result = await _dataSource.sendSmsCommand(
      deviceId: deviceId,
      message: message,
    );
    state = CommandSendState(isSending: false, lastResult: result);
    return result;
  }

  void reset() => state = const CommandSendState();
}

final gprsCommandProvider =
    StateNotifierProvider.autoDispose<GprsCommandNotifier, CommandSendState>((ref) {
  return GprsCommandNotifier(ref.read(setupDataSourceProvider));
});

final smsCommandProvider =
    StateNotifierProvider.autoDispose<SmsCommandNotifier, CommandSendState>((ref) {
  return SmsCommandNotifier(ref.read(setupDataSourceProvider));
});
