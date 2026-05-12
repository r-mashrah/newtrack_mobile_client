// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      address: json['address'] as String,
      comment: json['comment'] as String?,
      priority: json['priority'] as String? ?? 'Medium',
      pickupAddress: json['pickupAddress'] as String,
      pickupLat: (json['pickupLat'] as num).toDouble(),
      pickupLng: (json['pickupLng'] as num).toDouble(),
      pickupFromDate: DateTime.parse(json['pickupFromDate'] as String),
      pickupToDate: DateTime.parse(json['pickupToDate'] as String),
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryLat: (json['deliveryLat'] as num).toDouble(),
      deliveryLng: (json['deliveryLng'] as num).toDouble(),
      deliveryFromDate: DateTime.parse(json['deliveryFromDate'] as String),
      deliveryToDate: DateTime.parse(json['deliveryToDate'] as String),
      status: json['status'] as String? ?? 'Pending',
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'invoiceNumber': instance.invoiceNumber,
      'address': instance.address,
      'comment': instance.comment,
      'priority': instance.priority,
      'pickupAddress': instance.pickupAddress,
      'pickupLat': instance.pickupLat,
      'pickupLng': instance.pickupLng,
      'pickupFromDate': instance.pickupFromDate.toIso8601String(),
      'pickupToDate': instance.pickupToDate.toIso8601String(),
      'deliveryAddress': instance.deliveryAddress,
      'deliveryLat': instance.deliveryLat,
      'deliveryLng': instance.deliveryLng,
      'deliveryFromDate': instance.deliveryFromDate.toIso8601String(),
      'deliveryToDate': instance.deliveryToDate.toIso8601String(),
      'status': instance.status,
    };
