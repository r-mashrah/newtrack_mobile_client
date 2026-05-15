import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_entity.freezed.dart';

@freezed
class HistoryEntity with _$HistoryEntity {
  const factory HistoryEntity({
    required double latitude,
    required double longitude,
    required double speed,
    required double altitude,
    required double course,
    required DateTime timestamp,
    Map<String, dynamic>? otherData,
  }) = _HistoryEntity;
}
