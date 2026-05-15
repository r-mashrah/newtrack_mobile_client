// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HistoryEntity {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  double get altitude => throw _privateConstructorUsedError;
  double get course => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get otherData => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HistoryEntityCopyWith<HistoryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryEntityCopyWith<$Res> {
  factory $HistoryEntityCopyWith(
          HistoryEntity value, $Res Function(HistoryEntity) then) =
      _$HistoryEntityCopyWithImpl<$Res, HistoryEntity>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      double speed,
      double altitude,
      double course,
      DateTime timestamp,
      Map<String, dynamic>? otherData});
}

/// @nodoc
class _$HistoryEntityCopyWithImpl<$Res, $Val extends HistoryEntity>
    implements $HistoryEntityCopyWith<$Res> {
  _$HistoryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = null,
    Object? altitude = null,
    Object? course = null,
    Object? timestamp = null,
    Object? otherData = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
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
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      otherData: freezed == otherData
          ? _value.otherData
          : otherData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryEntityImplCopyWith<$Res>
    implements $HistoryEntityCopyWith<$Res> {
  factory _$$HistoryEntityImplCopyWith(
          _$HistoryEntityImpl value, $Res Function(_$HistoryEntityImpl) then) =
      __$$HistoryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      double speed,
      double altitude,
      double course,
      DateTime timestamp,
      Map<String, dynamic>? otherData});
}

/// @nodoc
class __$$HistoryEntityImplCopyWithImpl<$Res>
    extends _$HistoryEntityCopyWithImpl<$Res, _$HistoryEntityImpl>
    implements _$$HistoryEntityImplCopyWith<$Res> {
  __$$HistoryEntityImplCopyWithImpl(
      _$HistoryEntityImpl _value, $Res Function(_$HistoryEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = null,
    Object? altitude = null,
    Object? course = null,
    Object? timestamp = null,
    Object? otherData = freezed,
  }) {
    return _then(_$HistoryEntityImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
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
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      otherData: freezed == otherData
          ? _value._otherData
          : otherData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$HistoryEntityImpl implements _HistoryEntity {
  const _$HistoryEntityImpl(
      {required this.latitude,
      required this.longitude,
      required this.speed,
      required this.altitude,
      required this.course,
      required this.timestamp,
      final Map<String, dynamic>? otherData})
      : _otherData = otherData;

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double speed;
  @override
  final double altitude;
  @override
  final double course;
  @override
  final DateTime timestamp;
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
    return 'HistoryEntity(latitude: $latitude, longitude: $longitude, speed: $speed, altitude: $altitude, course: $course, timestamp: $timestamp, otherData: $otherData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryEntityImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._otherData, _otherData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      latitude,
      longitude,
      speed,
      altitude,
      course,
      timestamp,
      const DeepCollectionEquality().hash(_otherData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryEntityImplCopyWith<_$HistoryEntityImpl> get copyWith =>
      __$$HistoryEntityImplCopyWithImpl<_$HistoryEntityImpl>(this, _$identity);
}

abstract class _HistoryEntity implements HistoryEntity {
  const factory _HistoryEntity(
      {required final double latitude,
      required final double longitude,
      required final double speed,
      required final double altitude,
      required final double course,
      required final DateTime timestamp,
      final Map<String, dynamic>? otherData}) = _$HistoryEntityImpl;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get speed;
  @override
  double get altitude;
  @override
  double get course;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get otherData;
  @override
  @JsonKey(ignore: true)
  _$$HistoryEntityImplCopyWith<_$HistoryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
