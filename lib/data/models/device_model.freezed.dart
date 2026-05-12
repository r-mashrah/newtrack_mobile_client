// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) {
  return _DeviceModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imei => throw _privateConstructorUsedError;
  String? get plateNumber => throw _privateConstructorUsedError;
  String? get simNumber => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get lastLocation => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get fuelLevel => throw _privateConstructorUsedError;
  double? get batteryLevel => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  String? get driverName => throw _privateConstructorUsedError;
  String? get driverPhone => throw _privateConstructorUsedError;
  String? get lastUpdate => throw _privateConstructorUsedError;
  Map<String, dynamic>? get sensors => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceModelCopyWith<DeviceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceModelCopyWith<$Res> {
  factory $DeviceModelCopyWith(
          DeviceModel value, $Res Function(DeviceModel) then) =
      _$DeviceModelCopyWithImpl<$Res, DeviceModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String imei,
      String? plateNumber,
      String? simNumber,
      String? model,
      String? icon,
      String? color,
      bool isActive,
      String status,
      Map<String, dynamic> lastLocation,
      double? speed,
      double? fuelLevel,
      double? batteryLevel,
      double? temperature,
      String? driverName,
      String? driverPhone,
      String? lastUpdate,
      Map<String, dynamic>? sensors,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$DeviceModelCopyWithImpl<$Res, $Val extends DeviceModel>
    implements $DeviceModelCopyWith<$Res> {
  _$DeviceModelCopyWithImpl(this._value, this._then);

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
    Object? plateNumber = freezed,
    Object? simNumber = freezed,
    Object? model = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? isActive = null,
    Object? status = null,
    Object? lastLocation = null,
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
              as Map<String, dynamic>,
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
              as String?,
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
}

/// @nodoc
abstract class _$$DeviceModelImplCopyWith<$Res>
    implements $DeviceModelCopyWith<$Res> {
  factory _$$DeviceModelImplCopyWith(
          _$DeviceModelImpl value, $Res Function(_$DeviceModelImpl) then) =
      __$$DeviceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String imei,
      String? plateNumber,
      String? simNumber,
      String? model,
      String? icon,
      String? color,
      bool isActive,
      String status,
      Map<String, dynamic> lastLocation,
      double? speed,
      double? fuelLevel,
      double? batteryLevel,
      double? temperature,
      String? driverName,
      String? driverPhone,
      String? lastUpdate,
      Map<String, dynamic>? sensors,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$DeviceModelImplCopyWithImpl<$Res>
    extends _$DeviceModelCopyWithImpl<$Res, _$DeviceModelImpl>
    implements _$$DeviceModelImplCopyWith<$Res> {
  __$$DeviceModelImplCopyWithImpl(
      _$DeviceModelImpl _value, $Res Function(_$DeviceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imei = null,
    Object? plateNumber = freezed,
    Object? simNumber = freezed,
    Object? model = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? isActive = null,
    Object? status = null,
    Object? lastLocation = null,
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
    return _then(_$DeviceModelImpl(
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
          ? _value._lastLocation
          : lastLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
              as String?,
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
@JsonSerializable()
class _$DeviceModelImpl extends _DeviceModel {
  const _$DeviceModelImpl(
      {required this.id,
      required this.name,
      required this.imei,
      this.plateNumber,
      this.simNumber,
      this.model,
      this.icon,
      this.color,
      this.isActive = true,
      this.status = 'offline',
      required final Map<String, dynamic> lastLocation,
      this.speed,
      this.fuelLevel,
      this.batteryLevel,
      this.temperature,
      this.driverName,
      this.driverPhone,
      this.lastUpdate,
      final Map<String, dynamic>? sensors,
      final Map<String, dynamic>? additionalData})
      : _lastLocation = lastLocation,
        _sensors = sensors,
        _additionalData = additionalData,
        super._();

  factory _$DeviceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String imei;
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
  final Map<String, dynamic> _lastLocation;
  @override
  Map<String, dynamic> get lastLocation {
    if (_lastLocation is EqualUnmodifiableMapView) return _lastLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lastLocation);
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
  final String? lastUpdate;
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
    return 'DeviceModel(id: $id, name: $name, imei: $imei, plateNumber: $plateNumber, simNumber: $simNumber, model: $model, icon: $icon, color: $color, isActive: $isActive, status: $status, lastLocation: $lastLocation, speed: $speed, fuelLevel: $fuelLevel, batteryLevel: $batteryLevel, temperature: $temperature, driverName: $driverName, driverPhone: $driverPhone, lastUpdate: $lastUpdate, sensors: $sensors, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imei, imei) || other.imei == imei) &&
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
            const DeepCollectionEquality()
                .equals(other._lastLocation, _lastLocation) &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        imei,
        plateNumber,
        simNumber,
        model,
        icon,
        color,
        isActive,
        status,
        const DeepCollectionEquality().hash(_lastLocation),
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
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      __$$DeviceModelImplCopyWithImpl<_$DeviceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceModelImplToJson(
      this,
    );
  }
}

abstract class _DeviceModel extends DeviceModel {
  const factory _DeviceModel(
      {required final String id,
      required final String name,
      required final String imei,
      final String? plateNumber,
      final String? simNumber,
      final String? model,
      final String? icon,
      final String? color,
      final bool isActive,
      final String status,
      required final Map<String, dynamic> lastLocation,
      final double? speed,
      final double? fuelLevel,
      final double? batteryLevel,
      final double? temperature,
      final String? driverName,
      final String? driverPhone,
      final String? lastUpdate,
      final Map<String, dynamic>? sensors,
      final Map<String, dynamic>? additionalData}) = _$DeviceModelImpl;
  const _DeviceModel._() : super._();

  factory _DeviceModel.fromJson(Map<String, dynamic> json) =
      _$DeviceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imei;
  @override
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
  Map<String, dynamic> get lastLocation;
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
  String? get lastUpdate;
  @override
  Map<String, dynamic>? get sensors;
  @override
  Map<String, dynamic>? get additionalData;
  @override
  @JsonKey(ignore: true)
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
