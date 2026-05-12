import 'package:freezed_annotation/freezed_annotation.dart';
import 'location_entity.dart';

part 'device_entity.freezed.dart';

@freezed
class DeviceEntity with _$DeviceEntity {
  const factory DeviceEntity({
    required String id,
    required String name,
    required String imei,
    String? group, // المجموعة التي ينتمي إليها الجهاز
    int? tailLength, // طول الذيل
    String? tailColor, // لون الذيل
    String? markerImage, // صورة العلامة (Marker Image)
    String? movingColor, // لون الحركة
    String? stoppedColor, // لون التوقف
    String? disconnectedColor, // لون قطع الاتصال
    String? idleColor, // لون الخمول للمحرك
    String? plateNumber,
    String? simNumber,
    String? model,
    String? icon,
    String? color,
    @Default(true) bool isActive,
    @Default('offline') String status,
    required LocationEntity lastLocation,
    @Default([]) List<LocationEntity> locationHistory,
    double? speed,
    double? fuelLevel,
    double? batteryLevel,
    double? temperature,
    String? driverName,
    String? driverPhone,
    DateTime? lastUpdate,
    Map<String, dynamic>? sensors,
    Map<String, dynamic>? additionalData,
  }) = _DeviceEntity;

  const DeviceEntity._();

  bool get isOnline {
    if (lastUpdate == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastUpdate!);
    return difference.inMinutes <= 5;
  }

  String get displayStatus {
    if (!isOnline) return 'offline';
    if (speed != null && speed! > 5) return 'moving';
    if (speed != null && speed! <= 5) return 'stopped';
    return 'parked';
  }
}
