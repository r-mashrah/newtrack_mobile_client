import '../models/setup_models.dart';
import '../models/command_models.dart';

abstract class SetupDataSource {
  Future<UserSettings> getUserSettings();
  Future<void> updateUserSettings(UserSettings settings);
  Future<List<VehicleGroup>> getVehicleGroups();
  Future<List<Driver>> getDrivers();
  Future<List<AppEvent>> getEvents();

  /// GET /send_command_data — official source for templates, devices, command types.
  Future<SendCommandData> getSendCommandData();

  Future<List<SmsTemplate>> getSmsTemplates();
  Future<List<SmsTemplate>> getGprsTemplates();

  /// GET /edit_setup_data — reads sms_gateway status from server.
  Future<SmsGatewaySettings> getSmsGatewaySettings();
  Future<void> updateSmsGatewaySettings(SmsGatewaySettings settings);

  /// POST /send_gprs_command
  /// [commandType] — command id from send_command_data.commands (e.g. engineStop, custom)
  /// [message] — required for type=custom or template-based commands
  Future<CommandResult> sendGprsCommand({
    required String deviceId,
    required String commandType,
    String? message,
    bool autoSendWhenOnline = false,
  });

  /// POST /send_sms_command
  /// Required: message (string), devices (array of integer device IDs)
  Future<CommandResult> sendSmsCommand({
    required String deviceId,
    required String message,
  });
}
