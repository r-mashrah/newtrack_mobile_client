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
    String parseGpswoxTime(String? timeStr) {
      if (timeStr == null || timeStr.isEmpty) {
        return DateTime.now().toIso8601String();
      }
      try {
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
        try {
          return DateTime.parse(timeStr).toIso8601String();
        } catch (_) {
          return DateTime.now().toIso8601String();
        }
      }
    }

    // دعم مفاتيح timestamp أو time
    final rawTime = json['time']?.toString() ?? json['timestamp']?.toString();
    String? finalTimeStr = rawTime;
    
    // إذا كان بصيغة unix timestamp رقمية نقوم بتحويلها لتاريخ مقروء
    if (rawTime != null && int.tryParse(rawTime) != null) {
      finalTimeStr = DateTime.fromMillisecondsSinceEpoch(int.parse(rawTime) * 1000).toIso8601String();
    }
    
    final parsedTime = parseGpswoxTime(finalTimeStr);

    return HistoryModel(
      lat: double.tryParse(json['lat']?.toString() ?? json['latitude']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? json['longitude']?.toString() ?? '0') ?? 0.0,
      speed: double.tryParse(json['speed']?.toString() ?? '0') ?? 0.0,
      altitude: double.tryParse(json['altitude']?.toString() ?? '0') ?? 0.0,
      course: double.tryParse(json['course']?.toString() ?? '0') ?? 0.0,
      time: parsedTime,
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
      timestamp: DateTime.parse(time),
      otherData: otherData,
    );
  }
}
