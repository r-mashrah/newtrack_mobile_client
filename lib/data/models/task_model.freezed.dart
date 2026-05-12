// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;
  String get invoiceNumber => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String get priority =>
      throw _privateConstructorUsedError; // Low, Medium, High
// Pickup details
  String get pickupAddress => throw _privateConstructorUsedError;
  double get pickupLat => throw _privateConstructorUsedError;
  double get pickupLng => throw _privateConstructorUsedError;
  DateTime get pickupFromDate => throw _privateConstructorUsedError;
  DateTime get pickupToDate =>
      throw _privateConstructorUsedError; // Delivery details
  String get deliveryAddress => throw _privateConstructorUsedError;
  double get deliveryLat => throw _privateConstructorUsedError;
  double get deliveryLng => throw _privateConstructorUsedError;
  DateTime get deliveryFromDate => throw _privateConstructorUsedError;
  DateTime get deliveryToDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String deviceId,
      String deviceName,
      String invoiceNumber,
      String address,
      String? comment,
      String priority,
      String pickupAddress,
      double pickupLat,
      double pickupLng,
      DateTime pickupFromDate,
      DateTime pickupToDate,
      String deliveryAddress,
      double deliveryLat,
      double deliveryLng,
      DateTime deliveryFromDate,
      DateTime deliveryToDate,
      String status});
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? deviceId = null,
    Object? deviceName = null,
    Object? invoiceNumber = null,
    Object? address = null,
    Object? comment = freezed,
    Object? priority = null,
    Object? pickupAddress = null,
    Object? pickupLat = null,
    Object? pickupLng = null,
    Object? pickupFromDate = null,
    Object? pickupToDate = null,
    Object? deliveryAddress = null,
    Object? deliveryLat = null,
    Object? deliveryLng = null,
    Object? deliveryFromDate = null,
    Object? deliveryToDate = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      pickupAddress: null == pickupAddress
          ? _value.pickupAddress
          : pickupAddress // ignore: cast_nullable_to_non_nullable
              as String,
      pickupLat: null == pickupLat
          ? _value.pickupLat
          : pickupLat // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLng: null == pickupLng
          ? _value.pickupLng
          : pickupLng // ignore: cast_nullable_to_non_nullable
              as double,
      pickupFromDate: null == pickupFromDate
          ? _value.pickupFromDate
          : pickupFromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pickupToDate: null == pickupToDate
          ? _value.pickupToDate
          : pickupToDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryLat: null == deliveryLat
          ? _value.deliveryLat
          : deliveryLat // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryLng: null == deliveryLng
          ? _value.deliveryLng
          : deliveryLng // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFromDate: null == deliveryFromDate
          ? _value.deliveryFromDate
          : deliveryFromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryToDate: null == deliveryToDate
          ? _value.deliveryToDate
          : deliveryToDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
          _$TaskModelImpl value, $Res Function(_$TaskModelImpl) then) =
      __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String deviceId,
      String deviceName,
      String invoiceNumber,
      String address,
      String? comment,
      String priority,
      String pickupAddress,
      double pickupLat,
      double pickupLng,
      DateTime pickupFromDate,
      DateTime pickupToDate,
      String deliveryAddress,
      double deliveryLat,
      double deliveryLng,
      DateTime deliveryFromDate,
      DateTime deliveryToDate,
      String status});
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
      _$TaskModelImpl _value, $Res Function(_$TaskModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? deviceId = null,
    Object? deviceName = null,
    Object? invoiceNumber = null,
    Object? address = null,
    Object? comment = freezed,
    Object? priority = null,
    Object? pickupAddress = null,
    Object? pickupLat = null,
    Object? pickupLng = null,
    Object? pickupFromDate = null,
    Object? pickupToDate = null,
    Object? deliveryAddress = null,
    Object? deliveryLat = null,
    Object? deliveryLng = null,
    Object? deliveryFromDate = null,
    Object? deliveryToDate = null,
    Object? status = null,
  }) {
    return _then(_$TaskModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      pickupAddress: null == pickupAddress
          ? _value.pickupAddress
          : pickupAddress // ignore: cast_nullable_to_non_nullable
              as String,
      pickupLat: null == pickupLat
          ? _value.pickupLat
          : pickupLat // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLng: null == pickupLng
          ? _value.pickupLng
          : pickupLng // ignore: cast_nullable_to_non_nullable
              as double,
      pickupFromDate: null == pickupFromDate
          ? _value.pickupFromDate
          : pickupFromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pickupToDate: null == pickupToDate
          ? _value.pickupToDate
          : pickupToDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryLat: null == deliveryLat
          ? _value.deliveryLat
          : deliveryLat // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryLng: null == deliveryLng
          ? _value.deliveryLng
          : deliveryLng // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFromDate: null == deliveryFromDate
          ? _value.deliveryFromDate
          : deliveryFromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryToDate: null == deliveryToDate
          ? _value.deliveryToDate
          : deliveryToDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl implements _TaskModel {
  const _$TaskModelImpl(
      {required this.id,
      required this.title,
      required this.deviceId,
      required this.deviceName,
      required this.invoiceNumber,
      required this.address,
      this.comment,
      this.priority = 'Medium',
      required this.pickupAddress,
      required this.pickupLat,
      required this.pickupLng,
      required this.pickupFromDate,
      required this.pickupToDate,
      required this.deliveryAddress,
      required this.deliveryLat,
      required this.deliveryLng,
      required this.deliveryFromDate,
      required this.deliveryToDate,
      this.status = 'Pending'});

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String deviceId;
  @override
  final String deviceName;
  @override
  final String invoiceNumber;
  @override
  final String address;
  @override
  final String? comment;
  @override
  @JsonKey()
  final String priority;
// Low, Medium, High
// Pickup details
  @override
  final String pickupAddress;
  @override
  final double pickupLat;
  @override
  final double pickupLng;
  @override
  final DateTime pickupFromDate;
  @override
  final DateTime pickupToDate;
// Delivery details
  @override
  final String deliveryAddress;
  @override
  final double deliveryLat;
  @override
  final double deliveryLng;
  @override
  final DateTime deliveryFromDate;
  @override
  final DateTime deliveryToDate;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, deviceId: $deviceId, deviceName: $deviceName, invoiceNumber: $invoiceNumber, address: $address, comment: $comment, priority: $priority, pickupAddress: $pickupAddress, pickupLat: $pickupLat, pickupLng: $pickupLng, pickupFromDate: $pickupFromDate, pickupToDate: $pickupToDate, deliveryAddress: $deliveryAddress, deliveryLat: $deliveryLat, deliveryLng: $deliveryLng, deliveryFromDate: $deliveryFromDate, deliveryToDate: $deliveryToDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.pickupLat, pickupLat) ||
                other.pickupLat == pickupLat) &&
            (identical(other.pickupLng, pickupLng) ||
                other.pickupLng == pickupLng) &&
            (identical(other.pickupFromDate, pickupFromDate) ||
                other.pickupFromDate == pickupFromDate) &&
            (identical(other.pickupToDate, pickupToDate) ||
                other.pickupToDate == pickupToDate) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.deliveryLat, deliveryLat) ||
                other.deliveryLat == deliveryLat) &&
            (identical(other.deliveryLng, deliveryLng) ||
                other.deliveryLng == deliveryLng) &&
            (identical(other.deliveryFromDate, deliveryFromDate) ||
                other.deliveryFromDate == deliveryFromDate) &&
            (identical(other.deliveryToDate, deliveryToDate) ||
                other.deliveryToDate == deliveryToDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        deviceId,
        deviceName,
        invoiceNumber,
        address,
        comment,
        priority,
        pickupAddress,
        pickupLat,
        pickupLng,
        pickupFromDate,
        pickupToDate,
        deliveryAddress,
        deliveryLat,
        deliveryLng,
        deliveryFromDate,
        deliveryToDate,
        status
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(
      this,
    );
  }
}

abstract class _TaskModel implements TaskModel {
  const factory _TaskModel(
      {required final String id,
      required final String title,
      required final String deviceId,
      required final String deviceName,
      required final String invoiceNumber,
      required final String address,
      final String? comment,
      final String priority,
      required final String pickupAddress,
      required final double pickupLat,
      required final double pickupLng,
      required final DateTime pickupFromDate,
      required final DateTime pickupToDate,
      required final String deliveryAddress,
      required final double deliveryLat,
      required final double deliveryLng,
      required final DateTime deliveryFromDate,
      required final DateTime deliveryToDate,
      final String status}) = _$TaskModelImpl;

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get deviceId;
  @override
  String get deviceName;
  @override
  String get invoiceNumber;
  @override
  String get address;
  @override
  String? get comment;
  @override
  String get priority;
  @override // Low, Medium, High
// Pickup details
  String get pickupAddress;
  @override
  double get pickupLat;
  @override
  double get pickupLng;
  @override
  DateTime get pickupFromDate;
  @override
  DateTime get pickupToDate;
  @override // Delivery details
  String get deliveryAddress;
  @override
  double get deliveryLat;
  @override
  double get deliveryLng;
  @override
  DateTime get deliveryFromDate;
  @override
  DateTime get deliveryToDate;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
