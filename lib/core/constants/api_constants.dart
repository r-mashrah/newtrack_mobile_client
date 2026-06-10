class ApiConstants {
  // رابط السيرفر الأساسي
  static const String baseUrl = 'http://82.114.179.170:30080';
  static const String apiBase = '$baseUrl/api';

  // Auth Endpoints
  static const String login = '$apiBase/login';

  // Devices Endpoints
  static const String getDevices = '$apiBase/get_devices';
  static const String addDevice = '$apiBase/add_device';
  static const String editDevice = '$apiBase/edit_device';
  static const String destroyDevice = '$apiBase/destroy_device';

  // Device Groups Endpoints
  static const String getDeviceGroups = '$apiBase/devices_groups';
  static const String addDeviceGroup = '$apiBase/devices_groups/store';
  // editDeviceGroup needs {id} replaced at runtime
  static const String editDeviceGroupBase = '$apiBase/devices_groups/update';
  static const String destroyDeviceGroupBase =
      '$apiBase/devices_groups/destroy';

  // History Endpoints
  static const String getHistory = '$apiBase/get_history';

  // Alerts Endpoints
  static const String getAlerts = '$apiBase/get_alerts';
  static const String addAlert = '$apiBase/add_alert';
  static const String editAlert = '$apiBase/edit_alert';
  static const String destroyAlert = '$apiBase/destroy_alert';

  // Events Endpoints
  static const String getEvents = '$apiBase/get_events';

  // Tasks Endpoints
  static const String getTasks = '$apiBase/get_tasks';
  static const String addTask = '$apiBase/add_task';
  static const String editTaskBase =
      '$apiBase/edit_task'; // Usage: $editTaskBase/{id}
  static const String destroyTask = '$apiBase/destroy_task';

  // Geofences Endpoints
  static const String getGeofences = '$apiBase/get_geofences';
  static const String addGeofence = '$apiBase/add_geofence';
  static const String editGeofence = '$apiBase/edit_geofence';
  static const String destroyGeofence = '$apiBase/destroy_geofence';

  // POI (Map Icons) Endpoints
  static const String getPois = '$apiBase/get_user_map_icons';
  static const String addPoi = '$apiBase/add_map_icon';
  static const String editPoi = '$apiBase/edit_map_icon';
  static const String destroyPoi = '$apiBase/destroy_map_icon';

  // Commands Endpoints (see stoplight1.json — Command tag)
  static const String sendCommandData = '$apiBase/send_command_data';
  static const String sendGprsCommand = '$apiBase/send_gprs_command';
  static const String sendSmsCommand = '$apiBase/send_sms_command';
  static const String getDeviceCommands = '$apiBase/get_device_commands';
  static const String getUserGprsTemplates = '$apiBase/get_user_gprs_templates';
  static const String getUserSmsTemplates = '$apiBase/get_user_sms_templates';

  // Setup Endpoints (SMS gateway status)
  static const String editSetupData = '$apiBase/edit_setup_data';

  // Sensors
  static const String getSensors = '$apiBase/get_sensors';

  // Drivers / Users
  static const String getDeviceUsers = '$apiBase/get_device_users_list';

  // Settings
  static const int connectTimeout = 30000; // 30 ثانية
  static const int receiveTimeout = 30000; // 30 ثانية
}
