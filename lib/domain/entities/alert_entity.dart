import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_entity.freezed.dart';

@freezed
class AlertEntity with _$AlertEntity {
  const factory AlertEntity({
    required String id,
    required String name,
    required String deviceId,
    required String deviceName,
    required String type,
    @Default(false) bool insideGeofence,
    @Default(false) bool outsideGeofence,
    required String notificationType,
    @Default(true) bool isActive,
    @Default(false) bool commandEnabled,
  }) = _AlertEntity;
}
