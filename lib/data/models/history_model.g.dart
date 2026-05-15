// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryModelImpl _$$HistoryModelImplFromJson(Map<String, dynamic> json) =>
    _$HistoryModelImpl(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      course: (json['course'] as num).toDouble(),
      time: json['time'] as String,
      otherData: json['otherData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$HistoryModelImplToJson(_$HistoryModelImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'speed': instance.speed,
      'altitude': instance.altitude,
      'course': instance.course,
      'time': instance.time,
      'otherData': instance.otherData,
    };
