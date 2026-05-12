import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_model.freezed.dart';
part 'alert_model.g.dart';

@freezed
class AlertModel with _$AlertModel {
  const factory AlertModel({
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
  }) = _AlertModel;

  factory AlertModel.fromJson(Map<String, dynamic> json) => _$AlertModelFromJson(json);
}
