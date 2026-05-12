// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imei => throw _privateConstructorUsedError;
  String? get group =>
      throw _privateConstructorUsedError; // المجموعة التي ينتمي إليها الجهاز
  int? get tailLength => throw _privateConstructorUsedError; // طول الذيل
  String? get tailColor => throw _privateConstructorUsedError; // لون الذيل
  String? get markerImage =>
      throw _privateConstructorUsedError; // صورة العلامة (Marker Image)
  String? get movingColor => throw _privateConstructorUsedError; // لون الحركة
  String? get stoppedColor => throw _privateConstructorUsedError; // لون التوقف
  String? get disconnectedColor =>
      throw _privateConstructorUsedError; // لون قطع الاتصال
  String? get idleColor =>
      throw _privateConstructorUsedError; // لون الخمول للمحرك
  String? get plateNumber => throw _privateConstructorUsedError;
  String? get simNumber => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  LocationEntity get lastLocation => throw _privateConstructorUsedError;
  List<LocationEntity> get locationHistory =>
      throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get fuelLevel => throw _privateConstructorUsedError;
  double? get batteryLevel => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  String? get driverName => throw _privateConstructorUsedError;
  String? get driverPhone => throw _privateConstructorUsedError;
  DateTime? get lastUpdate => throw _privateConstructorUsedError;
  Map<String, dynamic>? get sensors => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceEntityCopyWith<DeviceEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceEntityCopyWith<$Res> {
  factory $DeviceEntityCopyWith(
          DeviceEntity value, $Res Function(DeviceEntity) then) =
      _$DeviceEntityCopyWithImpl<$Res, DeviceEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String imei,
      String? group,
      int? tailLength,
      String? tailColor,
      String? markerImage,
      String? movingColor,
      String? stoppedColor,
      String? disconnectedColor,
      String? idleColor,
      String? plateNumber,
      String? simNumber,
      String? model,
      String? icon,
      String? color,
      bool isActive,
      String status,
      LocationEntity lastLocation,
      List<LocationEntity> locationHistory,
      double? speed,
      double? fuelLevel,
      double? batteryLevel,
      double? temperature,
      String? driverName,
      String? driverPhone,
      DateTime? lastUpdate,
      Map<String, dynamic>? sensors,
      Map<String, dynamic>? additionalData});

  $LocationEntityCopyWith<$Res> get lastLocation;
}

/// @nodoc
class _$DeviceEntityCopyWithImpl<$Res, $Val extends DeviceEntity>
    implements $DeviceEntityCopyWith<$Res> {
  _$DeviceEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imei = null,
    Object? group = freezed,
    Object? tailLength = freezed,
    Object? tailColor = freezed,
    Object? markerImage = freezed,
    Object? movingColor = freezed,
    Object? stoppedColor = freezed,
    Object? disconnectedColor = freezed,
    Object? idleColor = freezed,
    Object? plateNumber = freezed,
    Object? simNumber = freezed,
    Object? model = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? isActive = null,
    Object? status = null,
    Object? lastLocation = null,
    Object? locationHistory = null,
    Object? speed = freezed,
    Object? fuelLevel = freezed,
    Object? batteryLevel = freezed,
    Object? temperature = freezed,
    Object? driverName = freezed,
    Object? driverPhone = freezed,
    Object? lastUpdate = freezed,
    Object? sensors = freezed,
    Object? additionalData = freezed,
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
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
      tailLength: freezed == tailLength
          ? _value.tailLength
          : tailLength // ignore: cast_nullable_to_non_nullable
              as int?,
      tailColor: freezed == tailColor
          ? _value.tailColor
          : tailColor // ignore: cast_nullable_to_non_nullable
              as String?,
      markerImage: freezed == markerImage
          ? _value.markerImage
          : markerImage // ignore: cast_nullable_to_non_nullable
              as String?,
      movingColor: freezed == movingColor
          ? _value.movingColor
          : movingColor // ignore: cast_nullable_to_non_nullable
              as String?,
      stoppedColor: freezed == stoppedColor
          ? _value.stoppedColor
          : stoppedColor // ignore: cast_nullable_to_non_nullable
              as String?,
      disconnectedColor: freezed == disconnectedColor
          ? _value.disconnectedColor
          : disconnectedColor // ignore: cast_nullable_to_non_nullable
              as String?,
      idleColor: freezed == idleColor
          ? _value.idleColor
          : idleColor // ignore: cast_nullable_to_non_nullable
              as String?,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      simNumber: freezed == simNumber
          ? _value.simNumber
          : simNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastLocation: null == lastLocation
          ? _value.lastLocation
          : lastLocation // ignore: cast_nullable_to_non_nullable
              as LocationEntity,
      locationHistory: null == locationHistory
          ? _value.locationHistory
          : locationHistory // ignore: cast_nullable_to_non_nullable
              as List<LocationEntity>,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      fuelLevel: freezed == fuelLevel
          ? _value.fuelLevel
          : fuelLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      driverPhone: freezed == driverPhone
          ? _value.driverPhone
          : driverPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdate: freezed == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sensors: freezed == sensors
          ? _value.sensors
          : sensors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationEntityCopyWith<$Res> get lastLocation {
    return $LocationEntityCopyWith<$Res>(_value.lastLocation, (value) {
      return _then(_value.copyWith(lastLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeviceEntityImplCopyWith<$Res>
    implements $DeviceEntityCopyWith<$Res> {
  factory _$$DeviceEntityImplCopyWith(
          _$DeviceEntityImpl value, $Res Function(_$DeviceEntityImpl) then) =
      __$$DeviceEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String imei,
      String? group,
      int? tailLength,
      String? tailColor,
      String? markerImage,
      String? movingColor,
      String? stoppedColor,
      String? disconnectedColor,
      String? idleColor,
      String? plateNumber,
      String? simNumber,
      String? model,
      String? icon,
      String? color,
      bool isActive,
      String status,
      LocationEntity lastLocation,
      List<LocationEntity> locationHistory,
      double? speed,
      double? fuelLevel,
      double? batteryLevel,
      double? temperature,
      String? driverName,
      String? driverPhone,
      DateTime? lastUpdate,
      Map<String, dynamic>? sensors,
      Map<String, dynamic>? additionalData});

  @override
  $LocationEntityCopyWith<$Res> get lastLocation;
}

/// @nodoc
class __$$DeviceEntityImplCopyWithImpl<$Res>
    extends _$DeviceEntityCopyWithImpl<$Res, _$DeviceEntityImpl>
    implements _$$DeviceEntityImplCopyWith<$Res> {
  __$$DeviceEntityImplCopyWithImpl(
      _$DeviceEntityImpl _value, $Res Function(_$DeviceEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imei = null,
    Object? group = freezed,
    Object? tailLength = freezed,
    Object? tailColor = freezed,
    Object? markerImage = freezed,
    Object? movingColor = freezed,
    Object? stoppedColor = freezed,
    Object? disconnectedColor = freezed,
    Object? idleColor = freezed,
    Object? plateNumber = freezed,
    Object? simNumber = freezed,
    Object? model = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? isActive = null,
    Object? status = null,
    Object? lastLocation = null,
    Object? locationHistory = null,
    Object? speed = freezed,
    Object? fuelLevel = freezed,
    Object? batteryLevel = freezed,
    Object? temperature = freezed,
    Object? driverName = freezed,
    Object? driverPhone = freezed,
    Object? lastUpdate = freezed,
    Object? sensors = freezed,
    Object? additionalData = freezed,
  }) {
    return _then(_$DeviceEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
      tailLength: freezed == tailLength
          ? _value.tailLength
          : tailLength // ignore: cast_nullable_to_non_nullable
              as int?,
      tailColor: freezed == tailColor
          ? _value.tailColor
          : tailColor // ignore: cast_nullable_to_non_nullable
              as String?,
      markerImage: freezed == markerImage
          ? _value.markerImage
          : markerImage // ignore: cast_nullable_to_non_nullable
              as String?,
      movingColor: freezed == movingColor
          ? _value.movingColor
          : movingColor // ignore: cast_nullable_to_non_nullable
              as String?,
      stoppedColor: freezed == stoppedColor
          ? _value.stoppedColor
          : stoppedColor // ignore: cast_nullable_to_non_nullable
              as String?,
      disconnectedColor: freezed == disconnectedColor
          ? _value.disconnectedColor
          : disconnectedColor // ignore: cast_nullable_to_non_nullable
              as String?,
      idleColor: freezed == idleColor
          ? _value.idleColor
          : idleColor // ignore: cast_nullable_to_non_nullable
              as String?,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      simNumber: freezed == simNumber
          ? _value.simNumber
          : simNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastLocation: null == lastLocation
          ? _value.lastLocation
          : lastLocation // ignore: cast_nullable_to_non_nullable
              as LocationEntity,
      locationHistory: null == locationHistory
          ? _value._locationHistory
          : locationHistory // ignore: cast_nullable_to_non_nullable
              as List<LocationEntity>,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      fuelLevel: freezed == fuelLevel
          ? _value.fuelLevel
          : fuelLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      driverPhone: freezed == driverPhone
          ? _value.driverPhone
          : driverPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdate: freezed == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sensors: freezed == sensors
          ? _value._sensors
          : sensors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$DeviceEntityImpl extends _DeviceEntity {
  const _$DeviceEntityImpl(
      {required this.id,
      required this.name,
      required this.imei,
      this.group,
      this.tailLength,
      this.tailColor,
      this.markerImage,
      this.movingColor,
      this.stoppedColor,
      this.disconnectedColor,
      this.idleColor,
      this.plateNumber,
      this.simNumber,
      this.model,
      this.icon,
      this.color,
      this.isActive = true,
      this.status = 'offline',
      required this.lastLocation,
      final List<LocationEntity> locationHistory = const [],
      this.speed,
      this.fuelLevel,
      this.batteryLevel,
      this.temperature,
      this.driverName,
      this.driverPhone,
      this.lastUpdate,
      final Map<String, dynamic>? sensors,
      final Map<String, dynamic>? additionalData})
      : _locationHistory = locationHistory,
        _sensors = sensors,
        _additionalData = additionalData,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String imei;
  @override
  final String? group;
// المجموعة التي ينتمي إليها الجهاز
  @override
  final int? tailLength;
// طول الذيل
  @override
  final String? tailColor;
// لون الذيل
  @override
  final String? markerImage;
// صورة العلامة (Marker Image)
  @override
  final String? movingColor;
// لون الحركة
  @override
  final String? stoppedColor;
// لون التوقف
  @override
  final String? disconnectedColor;
// لون قطع الاتصال
  @override
  final String? idleColor;
// لون الخمول للمحرك
  @override
  final String? plateNumber;
  @override
  final String? simNumber;
  @override
  final String? model;
  @override
  final String? icon;
  @override
  final String? color;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final String status;
  @override
  final LocationEntity lastLocation;
  final List<LocationEntity> _locationHistory;
  @override
  @JsonKey()
  List<LocationEntity> get locationHistory {
    if (_locationHistory is EqualUnmodifiableListView) return _locationHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationHistory);
  }

  @override
  final double? speed;
  @override
  final double? fuelLevel;
  @override
  final double? batteryLevel;
  @override
  final double? temperature;
  @override
  final String? driverName;
  @override
  final String? driverPhone;
  @override
  final DateTime? lastUpdate;
  final Map<String, dynamic>? _sensors;
  @override
  Map<String, dynamic>? get sensors {
    final value = _sensors;
    if (value == null) return null;
    if (_sensors is EqualUnmodifiableMapView) return _sensors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DeviceEntity(id: $id, name: $name, imei: $imei, group: $group, tailLength: $tailLength, tailColor: $tailColor, markerImage: $markerImage, movingColor: $movingColor, stoppedColor: $stoppedColor, disconnectedColor: $disconnectedColor, idleColor: $idleColor, plateNumber: $plateNumber, simNumber: $simNumber, model: $model, icon: $icon, color: $color, isActive: $isActive, status: $status, lastLocation: $lastLocation, locationHistory: $locationHistory, speed: $speed, fuelLevel: $fuelLevel, batteryLevel: $batteryLevel, temperature: $temperature, driverName: $driverName, driverPhone: $driverPhone, lastUpdate: $lastUpdate, sensors: $sensors, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imei, imei) || other.imei == imei) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.tailLength, tailLength) ||
                other.tailLength == tailLength) &&
            (identical(other.tailColor, tailColor) ||
                other.tailColor == tailColor) &&
            (identical(other.markerImage, markerImage) ||
                other.markerImage == markerImage) &&
            (identical(other.movingColor, movingColor) ||
                other.movingColor == movingColor) &&
            (identical(other.stoppedColor, stoppedColor) ||
                other.stoppedColor == stoppedColor) &&
            (identical(other.disconnectedColor, disconnectedColor) ||
                other.disconnectedColor == disconnectedColor) &&
            (identical(other.idleColor, idleColor) ||
                other.idleColor == idleColor) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.simNumber, simNumber) ||
                other.simNumber == simNumber) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastLocation, lastLocation) ||
                other.lastLocation == lastLocation) &&
            const DeepCollectionEquality()
                .equals(other._locationHistory, _locationHistory) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.fuelLevel, fuelLevel) ||
                other.fuelLevel == fuelLevel) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverPhone, driverPhone) ||
                other.driverPhone == driverPhone) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate) &&
            const DeepCollectionEquality().equals(other._sensors, _sensors) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        imei,
        group,
        tailLength,
        tailColor,
        markerImage,
        movingColor,
        stoppedColor,
        disconnectedColor,
        idleColor,
        plateNumber,
        simNumber,
        model,
        icon,
        color,
        isActive,
        status,
        lastLocation,
        const DeepCollectionEquality().hash(_locationHistory),
        speed,
        fuelLevel,
        batteryLevel,
        temperature,
        driverName,
        driverPhone,
        lastUpdate,
        const DeepCollectionEquality().hash(_sensors),
        const DeepCollectionEquality().hash(_additionalData)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceEntityImplCopyWith<_$DeviceEntityImpl> get copyWith =>
      __$$DeviceEntityImplCopyWithImpl<_$DeviceEntityImpl>(this, _$identity);
}

abstract class _DeviceEntity extends DeviceEntity {
  const factory _DeviceEntity(
      {required final String id,
      required final String name,
      required final String imei,
      final String? group,
      final int? tailLength,
      final String? tailColor,
      final String? markerImage,
      final String? movingColor,
      final String? stoppedColor,
      final String? disconnectedColor,
      final String? idleColor,
      final String? plateNumber,
      final String? simNumber,
      final String? model,
      final String? icon,
      final String? color,
      final bool isActive,
      final String status,
      required final LocationEntity lastLocation,
      final List<LocationEntity> locationHistory,
      final double? speed,
      final double? fuelLevel,
      final double? batteryLevel,
      final double? temperature,
      final String? driverName,
      final String? driverPhone,
      final DateTime? lastUpdate,
      final Map<String, dynamic>? sensors,
      final Map<String, dynamic>? additionalData}) = _$DeviceEntityImpl;
  const _DeviceEntity._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get imei;
  @override
  String? get group;
  @override // المجموعة التي ينتمي إليها الجهاز
  int? get tailLength;
  @override // طول الذيل
  String? get tailColor;
  @override // لون الذيل
  String? get markerImage;
  @override // صورة العلامة (Marker Image)
  String? get movingColor;
  @override // لون الحركة
  String? get stoppedColor;
  @override // لون التوقف
  String? get disconnectedColor;
  @override // لون قطع الاتصال
  String? get idleColor;
  @override // لون الخمول للمحرك
  String? get plateNumber;
  @override
  String? get simNumber;
  @override
  String? get model;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  bool get isActive;
  @override
  String get status;
  @override
  LocationEntity get lastLocation;
  @override
  List<LocationEntity> get locationHistory;
  @override
  double? get speed;
  @override
  double? get fuelLevel;
  @override
  double? get batteryLevel;
  @override
  double? get temperature;
  @override
  String? get driverName;
  @override
  String? get driverPhone;
  @override
  DateTime? get lastUpdate;
  @override
  Map<String, dynamic>? get sensors;
  @override
  Map<String, dynamic>? get additionalData;
  @override
  @JsonKey(ignore: true)
  _$$DeviceEntityImplCopyWith<_$DeviceEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
