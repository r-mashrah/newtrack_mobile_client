import '../models/setup_models.dart';

abstract class SetupDataSource {
  Future<UserSettings> getUserSettings();
  Future<void> updateUserSettings(UserSettings settings);
  Future<List<VehicleGroup>> getVehicleGroups();
  Future<List<Driver>> getDrivers();
  Future<List<AppEvent>> getEvents();
  Future<List<SmsTemplate>> getSmsTemplates();
  Future<List<SmsTemplate>> getGprsTemplates();
  Future<SmsGatewaySettings> getSmsGatewaySettings();
  Future<void> updateSmsGatewaySettings(SmsGatewaySettings settings);
}

class MockSetupDataSource implements SetupDataSource {
  UserSettings _settings = UserSettings();
  SmsGatewaySettings _smsSettings = SmsGatewaySettings();

  @override
  Future<UserSettings> getUserSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _settings;
  }

  @override
  Future<void> updateUserSettings(UserSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _settings = settings;
  }

  @override
  Future<List<VehicleGroup>> getVehicleGroups() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      VehicleGroup(id: '1', name: 'مجموعة الأمانة', deviceIds: ['device_1', 'device_2']),
      VehicleGroup(id: '2', name: 'مجموعة تعز', deviceIds: ['device_3']),
      VehicleGroup(id: '3', name: 'مجموعة عدن', deviceIds: ['device_4', 'device_5']),
    ];
  }

  @override
  Future<List<Driver>> getDrivers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Driver(id: '1', name: 'صالح محمد', phone: '777111222', rfid: 'RFID001'),
      Driver(id: '2', name: 'أحمد علي', phone: '777333444', rfid: 'RFID002'),
      Driver(id: '3', name: 'خالد وليد', phone: '777555666', rfid: 'RFID003'),
    ];
  }

  @override
  Future<List<AppEvent>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AppEvent(id: '1', type: 'overspeed', message: 'تجاوز السرعة: سيارة صالح', timestamp: DateTime.now()),
      AppEvent(id: '2', type: 'geofence', message: 'دخول المنطقة: سيارة أحمد', timestamp: DateTime.now().subtract(Duration(hours: 1))),
      AppEvent(id: '3', type: 'maintenance', message: 'تنبيه صيانة: سيارة خالد', timestamp: DateTime.now().subtract(Duration(days: 1))),
    ];
  }

  @override
  Future<List<SmsTemplate>> getSmsTemplates() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      SmsTemplate(id: '1', name: 'تنبيه السرعة', content: 'السرعة الحالية هي %SPEED%'),
      SmsTemplate(id: '2', name: 'تنبيه الموقع', content: 'الموقع الحالي: %LAT%, %LNG%'),
    ];
  }

  @override
  Future<List<SmsTemplate>> getGprsTemplates() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      SmsTemplate(id: '1', name: 'إيقاف المحرك', content: 'engine_stop'),
      SmsTemplate(id: '2', name: 'تشغيل المحرك', content: 'engine_resume'),
    ];
  }

  @override
  Future<SmsGatewaySettings> getSmsGatewaySettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _smsSettings;
  }

  @override
  Future<void> updateSmsGatewaySettings(SmsGatewaySettings settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _smsSettings = settings;
  }
}
