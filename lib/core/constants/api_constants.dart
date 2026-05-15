class ApiConstants {
  // رابط السيرفر الأساسي
  static const String baseUrl = 'http://82.114.179.170:30080';
  static const String apiBase = '$baseUrl/api';

  // Auth Endpoints
  static const String login = '$apiBase/login';
  
  // Devices Endpoints
  static const String getDevices = '$apiBase/get_devices';
  
  // History Endpoints
  static const String getHistory = '$apiBase/get_history';
  
  // Alerts Endpoints
  static const String getAlerts = '$apiBase/get_alerts';
  
  // Geofences Endpoints
  static const String getGeofences = '$apiBase/get_geofences';
  
  // Settings
  static const int connectTimeout = 30000; // 30 ثانية
  static const int receiveTimeout = 30000; // 30 ثانية
}
