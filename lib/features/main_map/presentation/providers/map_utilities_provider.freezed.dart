// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_utilities_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PointOfInterest {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  LatLng get location => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PointOfInterestCopyWith<PointOfInterest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointOfInterestCopyWith<$Res> {
  factory $PointOfInterestCopyWith(
          PointOfInterest value, $Res Function(PointOfInterest) then) =
      _$PointOfInterestCopyWithImpl<$Res, PointOfInterest>;
  @useResult
  $Res call(
      {String id,
      String name,
      LatLng location,
      String type,
      String? description});
}

/// @nodoc
class _$PointOfInterestCopyWithImpl<$Res, $Val extends PointOfInterest>
    implements $PointOfInterestCopyWith<$Res> {
  _$PointOfInterestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = null,
    Object? type = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PointOfInterestImplCopyWith<$Res>
    implements $PointOfInterestCopyWith<$Res> {
  factory _$$PointOfInterestImplCopyWith(_$PointOfInterestImpl value,
          $Res Function(_$PointOfInterestImpl) then) =
      __$$PointOfInterestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      LatLng location,
      String type,
      String? description});
}

/// @nodoc
class __$$PointOfInterestImplCopyWithImpl<$Res>
    extends _$PointOfInterestCopyWithImpl<$Res, _$PointOfInterestImpl>
    implements _$$PointOfInterestImplCopyWith<$Res> {
  __$$PointOfInterestImplCopyWithImpl(
      _$PointOfInterestImpl _value, $Res Function(_$PointOfInterestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = null,
    Object? type = null,
    Object? description = freezed,
  }) {
    return _then(_$PointOfInterestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PointOfInterestImpl implements _PointOfInterest {
  const _$PointOfInterestImpl(
      {required this.id,
      required this.name,
      required this.location,
      required this.type,
      required this.description});

  @override
  final String id;
  @override
  final String name;
  @override
  final LatLng location;
  @override
  final String type;
  @override
  final String? description;

  @override
  String toString() {
    return 'PointOfInterest(id: $id, name: $name, location: $location, type: $type, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointOfInterestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, location, type, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PointOfInterestImplCopyWith<_$PointOfInterestImpl> get copyWith =>
      __$$PointOfInterestImplCopyWithImpl<_$PointOfInterestImpl>(
          this, _$identity);
}

abstract class _PointOfInterest implements PointOfInterest {
  const factory _PointOfInterest(
      {required final String id,
      required final String name,
      required final LatLng location,
      required final String type,
      required final String? description}) = _$PointOfInterestImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  LatLng get location;
  @override
  String get type;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$PointOfInterestImplCopyWith<_$PointOfInterestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Geofence {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<LatLng> get points => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeofenceCopyWith<Geofence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceCopyWith<$Res> {
  factory $GeofenceCopyWith(Geofence value, $Res Function(Geofence) then) =
      _$GeofenceCopyWithImpl<$Res, Geofence>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<LatLng> points,
      Color color,
      String? description});
}

/// @nodoc
class _$GeofenceCopyWithImpl<$Res, $Val extends Geofence>
    implements $GeofenceCopyWith<$Res> {
  _$GeofenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? points = null,
    Object? color = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeofenceImplCopyWith<$Res>
    implements $GeofenceCopyWith<$Res> {
  factory _$$GeofenceImplCopyWith(
          _$GeofenceImpl value, $Res Function(_$GeofenceImpl) then) =
      __$$GeofenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<LatLng> points,
      Color color,
      String? description});
}

/// @nodoc
class __$$GeofenceImplCopyWithImpl<$Res>
    extends _$GeofenceCopyWithImpl<$Res, _$GeofenceImpl>
    implements _$$GeofenceImplCopyWith<$Res> {
  __$$GeofenceImplCopyWithImpl(
      _$GeofenceImpl _value, $Res Function(_$GeofenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? points = null,
    Object? color = null,
    Object? description = freezed,
  }) {
    return _then(_$GeofenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GeofenceImpl implements _Geofence {
  const _$GeofenceImpl(
      {required this.id,
      required this.name,
      required final List<LatLng> points,
      required this.color,
      required this.description})
      : _points = points;

  @override
  final String id;
  @override
  final String name;
  final List<LatLng> _points;
  @override
  List<LatLng> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  final Color color;
  @override
  final String? description;

  @override
  String toString() {
    return 'Geofence(id: $id, name: $name, points: $points, color: $color, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(_points), color, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofenceImplCopyWith<_$GeofenceImpl> get copyWith =>
      __$$GeofenceImplCopyWithImpl<_$GeofenceImpl>(this, _$identity);
}

abstract class _Geofence implements Geofence {
  const factory _Geofence(
      {required final String id,
      required final String name,
      required final List<LatLng> points,
      required final Color color,
      required final String? description}) = _$GeofenceImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  List<LatLng> get points;
  @override
  Color get color;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$GeofenceImplCopyWith<_$GeofenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TrailPoint {
  LatLng get location => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrailPointCopyWith<TrailPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrailPointCopyWith<$Res> {
  factory $TrailPointCopyWith(
          TrailPoint value, $Res Function(TrailPoint) then) =
      _$TrailPointCopyWithImpl<$Res, TrailPoint>;
  @useResult
  $Res call({LatLng location, DateTime timestamp, double? speed});
}

/// @nodoc
class _$TrailPointCopyWithImpl<$Res, $Val extends TrailPoint>
    implements $TrailPointCopyWith<$Res> {
  _$TrailPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? timestamp = null,
    Object? speed = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrailPointImplCopyWith<$Res>
    implements $TrailPointCopyWith<$Res> {
  factory _$$TrailPointImplCopyWith(
          _$TrailPointImpl value, $Res Function(_$TrailPointImpl) then) =
      __$$TrailPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LatLng location, DateTime timestamp, double? speed});
}

/// @nodoc
class __$$TrailPointImplCopyWithImpl<$Res>
    extends _$TrailPointCopyWithImpl<$Res, _$TrailPointImpl>
    implements _$$TrailPointImplCopyWith<$Res> {
  __$$TrailPointImplCopyWithImpl(
      _$TrailPointImpl _value, $Res Function(_$TrailPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? timestamp = null,
    Object? speed = freezed,
  }) {
    return _then(_$TrailPointImpl(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$TrailPointImpl implements _TrailPoint {
  const _$TrailPointImpl(
      {required this.location, required this.timestamp, required this.speed});

  @override
  final LatLng location;
  @override
  final DateTime timestamp;
  @override
  final double? speed;

  @override
  String toString() {
    return 'TrailPoint(location: $location, timestamp: $timestamp, speed: $speed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrailPointImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.speed, speed) || other.speed == speed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, timestamp, speed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrailPointImplCopyWith<_$TrailPointImpl> get copyWith =>
      __$$TrailPointImplCopyWithImpl<_$TrailPointImpl>(this, _$identity);
}

abstract class _TrailPoint implements TrailPoint {
  const factory _TrailPoint(
      {required final LatLng location,
      required final DateTime timestamp,
      required final double? speed}) = _$TrailPointImpl;

  @override
  LatLng get location;
  @override
  DateTime get timestamp;
  @override
  double? get speed;
  @override
  @JsonKey(ignore: true)
  _$$TrailPointImplCopyWith<_$TrailPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MapUtilitiesState {
  List<PointOfInterest> get pointsOfInterest =>
      throw _privateConstructorUsedError;
  List<Geofence> get geofences => throw _privateConstructorUsedError;
  Map<String, List<TrailPoint>> get deviceTrails =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapUtilitiesStateCopyWith<MapUtilitiesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapUtilitiesStateCopyWith<$Res> {
  factory $MapUtilitiesStateCopyWith(
          MapUtilitiesState value, $Res Function(MapUtilitiesState) then) =
      _$MapUtilitiesStateCopyWithImpl<$Res, MapUtilitiesState>;
  @useResult
  $Res call(
      {List<PointOfInterest> pointsOfInterest,
      List<Geofence> geofences,
      Map<String, List<TrailPoint>> deviceTrails,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$MapUtilitiesStateCopyWithImpl<$Res, $Val extends MapUtilitiesState>
    implements $MapUtilitiesStateCopyWith<$Res> {
  _$MapUtilitiesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointsOfInterest = null,
    Object? geofences = null,
    Object? deviceTrails = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      pointsOfInterest: null == pointsOfInterest
          ? _value.pointsOfInterest
          : pointsOfInterest // ignore: cast_nullable_to_non_nullable
              as List<PointOfInterest>,
      geofences: null == geofences
          ? _value.geofences
          : geofences // ignore: cast_nullable_to_non_nullable
              as List<Geofence>,
      deviceTrails: null == deviceTrails
          ? _value.deviceTrails
          : deviceTrails // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TrailPoint>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapUtilitiesStateImplCopyWith<$Res>
    implements $MapUtilitiesStateCopyWith<$Res> {
  factory _$$MapUtilitiesStateImplCopyWith(_$MapUtilitiesStateImpl value,
          $Res Function(_$MapUtilitiesStateImpl) then) =
      __$$MapUtilitiesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PointOfInterest> pointsOfInterest,
      List<Geofence> geofences,
      Map<String, List<TrailPoint>> deviceTrails,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$MapUtilitiesStateImplCopyWithImpl<$Res>
    extends _$MapUtilitiesStateCopyWithImpl<$Res, _$MapUtilitiesStateImpl>
    implements _$$MapUtilitiesStateImplCopyWith<$Res> {
  __$$MapUtilitiesStateImplCopyWithImpl(_$MapUtilitiesStateImpl _value,
      $Res Function(_$MapUtilitiesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointsOfInterest = null,
    Object? geofences = null,
    Object? deviceTrails = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$MapUtilitiesStateImpl(
      pointsOfInterest: null == pointsOfInterest
          ? _value._pointsOfInterest
          : pointsOfInterest // ignore: cast_nullable_to_non_nullable
              as List<PointOfInterest>,
      geofences: null == geofences
          ? _value._geofences
          : geofences // ignore: cast_nullable_to_non_nullable
              as List<Geofence>,
      deviceTrails: null == deviceTrails
          ? _value._deviceTrails
          : deviceTrails // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TrailPoint>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MapUtilitiesStateImpl implements _MapUtilitiesState {
  const _$MapUtilitiesStateImpl(
      {required final List<PointOfInterest> pointsOfInterest,
      required final List<Geofence> geofences,
      required final Map<String, List<TrailPoint>> deviceTrails,
      required this.isLoading,
      required this.error})
      : _pointsOfInterest = pointsOfInterest,
        _geofences = geofences,
        _deviceTrails = deviceTrails;

  final List<PointOfInterest> _pointsOfInterest;
  @override
  List<PointOfInterest> get pointsOfInterest {
    if (_pointsOfInterest is EqualUnmodifiableListView)
      return _pointsOfInterest;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pointsOfInterest);
  }

  final List<Geofence> _geofences;
  @override
  List<Geofence> get geofences {
    if (_geofences is EqualUnmodifiableListView) return _geofences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geofences);
  }

  final Map<String, List<TrailPoint>> _deviceTrails;
  @override
  Map<String, List<TrailPoint>> get deviceTrails {
    if (_deviceTrails is EqualUnmodifiableMapView) return _deviceTrails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deviceTrails);
  }

  @override
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'MapUtilitiesState(pointsOfInterest: $pointsOfInterest, geofences: $geofences, deviceTrails: $deviceTrails, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapUtilitiesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._pointsOfInterest, _pointsOfInterest) &&
            const DeepCollectionEquality()
                .equals(other._geofences, _geofences) &&
            const DeepCollectionEquality()
                .equals(other._deviceTrails, _deviceTrails) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pointsOfInterest),
      const DeepCollectionEquality().hash(_geofences),
      const DeepCollectionEquality().hash(_deviceTrails),
      isLoading,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapUtilitiesStateImplCopyWith<_$MapUtilitiesStateImpl> get copyWith =>
      __$$MapUtilitiesStateImplCopyWithImpl<_$MapUtilitiesStateImpl>(
          this, _$identity);
}

abstract class _MapUtilitiesState implements MapUtilitiesState {
  const factory _MapUtilitiesState(
      {required final List<PointOfInterest> pointsOfInterest,
      required final List<Geofence> geofences,
      required final Map<String, List<TrailPoint>> deviceTrails,
      required final bool isLoading,
      required final String? error}) = _$MapUtilitiesStateImpl;

  @override
  List<PointOfInterest> get pointsOfInterest;
  @override
  List<Geofence> get geofences;
  @override
  Map<String, List<TrailPoint>> get deviceTrails;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$MapUtilitiesStateImplCopyWith<_$MapUtilitiesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
