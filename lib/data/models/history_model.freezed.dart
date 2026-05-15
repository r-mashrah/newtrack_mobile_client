// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) {
  return _HistoryModel.fromJson(json);
}

/// @nodoc
mixin _$HistoryModel {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  double get altitude => throw _privateConstructorUsedError;
  double get course => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  Map<String, dynamic>? get otherData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HistoryModelCopyWith<HistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryModelCopyWith<$Res> {
  factory $HistoryModelCopyWith(
          HistoryModel value, $Res Function(HistoryModel) then) =
      _$HistoryModelCopyWithImpl<$Res, HistoryModel>;
  @useResult
  $Res call(
      {double lat,
      double lng,
      double speed,
      double altitude,
      double course,
      String time,
      Map<String, dynamic>? otherData});
}

/// @nodoc
class _$HistoryModelCopyWithImpl<$Res, $Val extends HistoryModel>
    implements $HistoryModelCopyWith<$Res> {
  _$HistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? speed = null,
    Object? altitude = null,
    Object? course = null,
    Object? time = null,
    Object? otherData = freezed,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: null == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double,
      course: null == course
          ? _value.course
          : course // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      otherData: freezed == otherData
          ? _value.otherData
          : otherData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryModelImplCopyWith<$Res>
    implements $HistoryModelCopyWith<$Res> {
  factory _$$HistoryModelImplCopyWith(
          _$HistoryModelImpl value, $Res Function(_$HistoryModelImpl) then) =
      __$$HistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double lat,
      double lng,
      double speed,
      double altitude,
      double course,
      String time,
      Map<String, dynamic>? otherData});
}

/// @nodoc
class __$$HistoryModelImplCopyWithImpl<$Res>
    extends _$HistoryModelCopyWithImpl<$Res, _$HistoryModelImpl>
    implements _$$HistoryModelImplCopyWith<$Res> {
  __$$HistoryModelImplCopyWithImpl(
      _$HistoryModelImpl _value, $Res Function(_$HistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? speed = null,
    Object? altitude = null,
    Object? course = null,
    Object? time = null,
    Object? otherData = freezed,
  }) {
    return _then(_$HistoryModelImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: null == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double,
      course: null == course
          ? _value.course
          : course // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      otherData: freezed == otherData
          ? _value._otherData
          : otherData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryModelImpl extends _HistoryModel {
  const _$HistoryModelImpl(
      {required this.lat,
      required this.lng,
      required this.speed,
      required this.altitude,
      required this.course,
      required this.time,
      final Map<String, dynamic>? otherData})
      : _otherData = otherData,
        super._();

  factory _$HistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryModelImplFromJson(json);

  @override
  final double lat;
  @override
  final double lng;
  @override
  final double speed;
  @override
  final double altitude;
  @override
  final double course;
  @override
  final String time;
  final Map<String, dynamic>? _otherData;
  @override
  Map<String, dynamic>? get otherData {
    final value = _otherData;
    if (value == null) return null;
    if (_otherData is EqualUnmodifiableMapView) return _otherData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'HistoryModel(lat: $lat, lng: $lng, speed: $speed, altitude: $altitude, course: $course, time: $time, otherData: $otherData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryModelImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality()
                .equals(other._otherData, _otherData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng, speed, altitude,
      course, time, const DeepCollectionEquality().hash(_otherData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryModelImplCopyWith<_$HistoryModelImpl> get copyWith =>
      __$$HistoryModelImplCopyWithImpl<_$HistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryModelImplToJson(
      this,
    );
  }
}

abstract class _HistoryModel extends HistoryModel {
  const factory _HistoryModel(
      {required final double lat,
      required final double lng,
      required final double speed,
      required final double altitude,
      required final double course,
      required final String time,
      final Map<String, dynamic>? otherData}) = _$HistoryModelImpl;
  const _HistoryModel._() : super._();

  factory _HistoryModel.fromJson(Map<String, dynamic> json) =
      _$HistoryModelImpl.fromJson;

  @override
  double get lat;
  @override
  double get lng;
  @override
  double get speed;
  @override
  double get altitude;
  @override
  double get course;
  @override
  String get time;
  @override
  Map<String, dynamic>? get otherData;
  @override
  @JsonKey(ignore: true)
  _$$HistoryModelImplCopyWith<_$HistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
