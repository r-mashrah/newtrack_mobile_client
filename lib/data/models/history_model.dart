import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/history_entity.dart';

part 'history_model.freezed.dart';
part 'history_model.g.dart';

@freezed
class HistoryModel with _$HistoryModel {
  const factory HistoryModel({
    required double lat,
    required double lng,
    required double speed,
    required double altitude,
    required double course,
    required String time,
    Map<String, dynamic>? otherData,
  }) = _HistoryModel;

  const HistoryModel._();

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  factory HistoryModel.fromGpswoxJson(Map<String, dynamic> json) {
    return HistoryModel(
      lat: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '0') ?? 0.0,
      speed: double.tryParse(json['speed']?.toString() ?? '0') ?? 0.0,
      altitude: double.tryParse(json['altitude']?.toString() ?? '0') ?? 0.0,
      course: double.tryParse(json['course']?.toString() ?? '0') ?? 0.0,
      time: json['time']?.toString() ?? DateTime.now().toIso8601String(),
      otherData: json,
    );
  }

  HistoryEntity toEntity() {
    return HistoryEntity(
      latitude: lat,
      longitude: lng,
      speed: speed,
      altitude: altitude,
      course: course,
      timestamp: DateTime.tryParse(time) ?? DateTime.now(),
      otherData: otherData,
    );
  }
}
