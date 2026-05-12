class UserSettings {
  final String distanceUnit;
  final String capacityUnit;
  final String altitudeUnit;
  final String startOfWeek;
  final String timezone;
  final String daylightSaving;
  final String languageCode;

  UserSettings({
    this.distanceUnit = 'kilometer',
    this.capacityUnit = 'liter',
    this.altitudeUnit = 'meter',
    this.startOfWeek = 'Monday',
    this.timezone = 'UTC +3:00',
    this.daylightSaving = 'Automatic',
    this.languageCode = 'ar',
  });

  UserSettings copyWith({
    String? distanceUnit,
    String? capacityUnit,
    String? altitudeUnit,
    String? startOfWeek,
    String? timezone,
    String? daylightSaving,
    String? languageCode,
  }) {
    return UserSettings(
      distanceUnit: distanceUnit ?? this.distanceUnit,
      capacityUnit: capacityUnit ?? this.capacityUnit,
      altitudeUnit: altitudeUnit ?? this.altitudeUnit,
      startOfWeek: startOfWeek ?? this.startOfWeek,
      timezone: timezone ?? this.timezone,
      daylightSaving: daylightSaving ?? this.daylightSaving,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class VehicleGroup {
  final String id;
  final String name;
  final List<String> deviceIds;

  VehicleGroup({
    required this.id,
    required this.name,
    this.deviceIds = const [],
  });
}

class Driver {
  final String id;
  final String name;
  final String phone;
  final String? rfid;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    this.rfid,
  });
}

class AppEvent {
  final String id;
  final String type;
  final String message;
  final DateTime timestamp;

  AppEvent({
    required this.id,
    required this.type,
    required this.message,
    required DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();
}

class SmsTemplate {
  final String id;
  final String name;
  final String content;

  SmsTemplate({
    required this.id,
    required this.name,
    required this.content,
  });
}

class SmsGatewaySettings {
  final bool enabled;
  final String gatewayType;
  final String? url;
  final String? apiKey;

  SmsGatewaySettings({
    this.enabled = false,
    this.gatewayType = 'server gateway',
    this.url,
    this.apiKey,
  });

  SmsGatewaySettings copyWith({
    bool? enabled,
    String? gatewayType,
    String? url,
    String? apiKey,
  }) {
    return SmsGatewaySettings(
      enabled: enabled ?? this.enabled,
      gatewayType: gatewayType ?? this.gatewayType,
      url: url ?? this.url,
      apiKey: apiKey ?? this.apiKey,
    );
  }
}
