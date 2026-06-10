import 'setup_models.dart';

/// Device entry from GET /send_command_data (devices_sms / devices_gprs).
class CommandDevice {
  final int id;
  final String name;

  const CommandDevice({required this.id, required this.name});

  factory CommandDevice.fromJson(Map<String, dynamic> json) {
    return CommandDevice(
      id: _parseInt(json['id']),
      name: json['value']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}

/// Command type entry from GET /send_command_data (commands list).
class CommandTypeOption {
  final String id;
  final String label;

  const CommandTypeOption({required this.id, required this.label});

  factory CommandTypeOption.fromJson(Map<String, dynamic> json) {
    return CommandTypeOption(
      id: json['id']?.toString() ?? '',
      label: json['value']?.toString() ?? json['title']?.toString() ?? '',
    );
  }

  bool get isCustom => id == 'custom';
}

/// Full payload from GET /send_command_data.
class SendCommandData {
  final List<CommandDevice> devicesSms;
  final List<CommandDevice> devicesGprs;
  final List<SmsTemplate> smsTemplates;
  final List<SmsTemplate> gprsTemplates;
  final List<CommandTypeOption> commandTypes;

  const SendCommandData({
    this.devicesSms = const [],
    this.devicesGprs = const [],
    this.smsTemplates = const [],
    this.gprsTemplates = const [],
    this.commandTypes = const [],
  });

  factory SendCommandData.fromJson(Map<String, dynamic> json) {
    return SendCommandData(
      devicesSms: _parseDevices(json['devices_sms']),
      devicesGprs: _parseDevices(json['devices_gprs']),
      smsTemplates: _parseTemplates(json['sms_templates']),
      gprsTemplates: _parseTemplates(json['gprs_templates']),
      commandTypes: _parseCommandTypes(json['commands']),
    );
  }

  static List<CommandDevice> _parseDevices(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => CommandDevice.fromJson(Map<String, dynamic>.from(e)))
        .where((d) => d.id > 0)
        .toList();
  }

  static List<SmsTemplate> _parseTemplates(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) {
          final id = e['id']?.toString() ?? '';
          // id "0" = "No template" per API — skip it; UI has its own custom option
          if (id == '0') return null;
          final message = e['message']?.toString() ?? '';
          return SmsTemplate(
            id: id,
            name: e['title']?.toString() ?? e['name']?.toString() ?? '',
            content: message,
          );
        })
        .whereType<SmsTemplate>()
        .where((t) => t.name.isNotEmpty)
        .toList();
  }

  static List<CommandTypeOption> _parseCommandTypes(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => CommandTypeOption.fromJson(Map<String, dynamic>.from(e)))
        .where((c) => c.id.isNotEmpty)
        .toList();
  }
}

/// Debug info captured during command API calls (visible in debug mode only).
class CommandDiagnostic {
  final String url;
  final String method;
  final Map<String, dynamic> requestPayload;
  final int? statusCode;
  final dynamic responseBody;
  final Map<String, String> validationErrors;

  const CommandDiagnostic({
    required this.url,
    required this.method,
    required this.requestPayload,
    this.statusCode,
    this.responseBody,
    this.validationErrors = const {},
  });
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
