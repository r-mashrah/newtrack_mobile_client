import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/entities/location_entity.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

@freezed
class DeviceModel with _$DeviceModel {
  const factory DeviceModel({
    required String id,
    required String name,
    required String imei,
    String? plateNumber,
    String? simNumber,
    String? model,
    String? icon,
    String? color,
    @Default(true) bool isActive,
    @Default('offline') String status,
    required Map<String, dynamic> lastLocation,
    double? speed,
    double? fuelLevel,
    double? batteryLevel,
    double? temperature,
    String? driverName,
    String? driverPhone,
    String? lastUpdate,
    Map<String, dynamic>? sensors,
    Map<String, dynamic>? additionalData,
  }) = _DeviceModel;

  const DeviceModel._();

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  factory DeviceModel.fromGpswoxJson(Map<String, dynamic> rawJson) {
    // بعض مسارات GPSWox ترسل البيانات في الجذر، وبعضها في device_data
    // لذلك سننشئ دالة مساعدة تبحث في الاثنين لضمان استخراج القيم الصحيحة
    final deviceData = rawJson['device_data'] as Map<String, dynamic>? ?? {};

    dynamic getValue(String key) {
      if (rawJson[key] != null && rawJson[key] != '') return rawJson[key];
      if (deviceData[key] != null && deviceData[key] != '')
        return deviceData[key];
      return null;
    }

    // إصلاح مشكلة التواريخ التي تأتي مع AM/PM من GPSWox
    String parseGpswoxTime(String? timeStr) {
      if (timeStr == null || timeStr.isEmpty || timeStr.toLowerCase().contains('not connected')) {
        return DateTime.now().toIso8601String();
      }
      // التأكد من احتوائه على أرقام ليكون تاريخاً صالحاً
      if (!RegExp(r'\d').hasMatch(timeStr)) {
        return DateTime.now().toIso8601String();
      }
      try {
        // إذا كان التاريخ يحتوي على AM/PM أو تنسيق غير قياسي
        if (timeStr.toLowerCase().contains('am') ||
            timeStr.toLowerCase().contains('pm')) {
          final cleanStr = timeStr
              .replaceAll(RegExp(r'\s*(am|pm)', caseSensitive: false), '')
              .trim();
          return DateTime.parse(
            cleanStr.replaceAll(' ', 'T'),
          ).toIso8601String();
        }
        return DateTime.parse(timeStr.replaceAll(' ', 'T')).toIso8601String();
      } catch (e) {
        // محاولة أخرى للتنسيقات الشائعة في GPSWox
        try {
           return DateTime.parse(timeStr).toIso8601String();
        } catch (_) {
           return DateTime.now().toIso8601String();
        }
      }
    }

    final timestamp = parseGpswoxTime(getValue('time')?.toString());
    
    // معالجة الحالة (Status) بشكل أكثر دقة
    String status = 'offline';
    final onlineValue = getValue('online');
    final speed = double.tryParse(getValue('speed')?.toString() ?? '0') ?? 0.0;
    
    // في نظام GPSWox، غالباً ما يكون 1 أو "online" يعني متصل
    bool isOnline = onlineValue == 1 || 
                    onlineValue == '1' || 
                    onlineValue == true || 
                    onlineValue.toString().toLowerCase() == 'online';

    if (isOnline) {
      if (speed > 5) {
        status = 'moving';
      } else {
        // إذا كان المحرك يعمل (engine) ولكنه لا يتحرك، فهو idle
        final engine = getValue('engine');
        if (engine == 1 || engine == '1' || engine == true) {
          status = 'idle';
        } else {
          status = 'stopped';
        }
      }
    } else if (onlineValue.toString().toLowerCase() == 'ack') {
      status = 'parked';
    }

    return DeviceModel(
      id: getValue('id')?.toString() ?? '',
      name: getValue('name')?.toString() ?? 'Unknown Device',
      imei: getValue('imei')?.toString() ?? '',
      plateNumber: getValue('plate_number')?.toString(),
      simNumber: getValue('sim_number')?.toString(),
      model: getValue('device_model')?.toString(),
      icon: getValue('icon_type')?.toString(),
      color: getValue('tail_color')?.toString(),
      isActive:
          getValue('active') == true ||
          getValue('active') == 1 ||
          getValue('active') == '1',
      status: status,
      lastLocation: {
        'latitude': double.tryParse(getValue('lat')?.toString() ?? '0') ?? 0.0,
        'longitude': double.tryParse(getValue('lng')?.toString() ?? '0') ?? 0.0,
        'timestamp': timestamp,
        'altitude': double.tryParse(getValue('altitude')?.toString() ?? '0'),
        'speed': speed,
        'bearing': double.tryParse(getValue('course')?.toString() ?? '0'),
      },
      speed: speed,
      lastUpdate: timestamp,
      driverName: getValue('driver_name')?.toString(),
      driverPhone: getValue('driver_phone')?.toString(),
      additionalData: rawJson,
    );
  }

  // تحويل من Model إلى Entity
  DeviceEntity toEntity() {
    return DeviceEntity(
      id: id,
      name: name,
      imei: imei,
      group: additionalData?['extracted_group_id']?.toString() ?? additionalData?['group_id']?.toString(),
      plateNumber: plateNumber,
      simNumber: simNumber,
      model: model,
      icon: icon,
      color: color,
      isActive: isActive,
      status: status,
      lastLocation: LocationEntity(
        latitude: lastLocation['latitude'] as double,
        longitude: lastLocation['longitude'] as double,
        timestamp: DateTime.parse(lastLocation['timestamp'] as String),
        altitude: lastLocation['altitude'] as double?,
        speed: lastLocation['speed'] as double?,
        accuracy: lastLocation['accuracy'] as double?,
        bearing: lastLocation['bearing'] as double?,
      ),
      speed: speed,
      fuelLevel: fuelLevel,
      batteryLevel: batteryLevel,
      temperature: temperature,
      driverName: driverName,
      driverPhone: driverPhone,
      lastUpdate: lastUpdate != null ? DateTime.parse(lastUpdate!) : null,
      sensors: sensors,
      additionalData: additionalData,
    );
  }

  // تحويل من Entity إلى Model
  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      id: entity.id,
      name: entity.name,
      imei: entity.imei,
      plateNumber: entity.plateNumber,
      simNumber: entity.simNumber,
      model: entity.model,
      icon: entity.icon,
      color: entity.color,
      isActive: entity.isActive,
      status: entity.status,
      lastLocation: {
        'latitude': entity.lastLocation.latitude,
        'longitude': entity.lastLocation.longitude,
        'timestamp': entity.lastLocation.timestamp.toIso8601String(),
        if (entity.lastLocation.altitude != null)
          'altitude': entity.lastLocation.altitude,
        if (entity.lastLocation.speed != null)
          'speed': entity.lastLocation.speed,
        if (entity.lastLocation.accuracy != null)
          'accuracy': entity.lastLocation.accuracy,
        if (entity.lastLocation.bearing != null)
          'bearing': entity.lastLocation.bearing,
      },
      speed: entity.speed,
      fuelLevel: entity.fuelLevel,
      batteryLevel: entity.batteryLevel,
      temperature: entity.temperature,
      driverName: entity.driverName,
      driverPhone: entity.driverPhone,
      lastUpdate: entity.lastUpdate?.toIso8601String(),
      sensors: entity.sensors,
      additionalData: entity.additionalData,
    );
  }
}
