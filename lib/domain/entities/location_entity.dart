import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_entity.freezed.dart';

@freezed
class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    double? altitude,
    double? speed,
    double? accuracy,
    double? bearing,
    Map<String, dynamic>? additionalData,
  }) = _LocationEntity;

  const LocationEntity._();

  bool get isValid {
    return latitude >= -90 && latitude <= 90 &&
           longitude >= -180 && longitude <= 180;
  }
}
