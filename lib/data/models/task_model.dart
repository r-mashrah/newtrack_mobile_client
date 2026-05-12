import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    required String deviceId,
    required String deviceName,
    required String invoiceNumber,
    required String address,
    String? comment,
    @Default('Medium') String priority, // Low, Medium, High
    
    // Pickup details
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required DateTime pickupFromDate,
    required DateTime pickupToDate,
    
    // Delivery details
    required String deliveryAddress,
    required double deliveryLat,
    required double deliveryLng,
    required DateTime deliveryFromDate,
    required DateTime deliveryToDate,
    
    @Default('Pending') String status,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}
