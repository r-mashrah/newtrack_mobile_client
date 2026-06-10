import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

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

  const TaskModel._();

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  /// تحويل استجابة GPSWox إلى TaskModel
  factory TaskModel.fromGpswoxJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    DateTime _parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      try {
        return dateFormat.parse(value.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    double _parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      deviceId: json['device_id']?.toString() ?? '',
      deviceName: json['device_name']?.toString() ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      address: json['pickup_address']?.toString() ?? json['address']?.toString() ?? '',
      comment: json['comment']?.toString(),
      priority: _parsePriorityFromServer(json['priority']),
      pickupAddress: json['pickup_address']?.toString() ?? '',
      pickupLat: _parseDouble(json['pickup_lat']),
      pickupLng: _parseDouble(json['pickup_lng']),
      pickupFromDate: _parseDate(json['pickup_time_from']),
      pickupToDate: _parseDate(json['pickup_time_to']),
      deliveryAddress: json['delivery_address']?.toString() ?? '',
      deliveryLat: _parseDouble(json['delivery_lat']),
      deliveryLng: _parseDouble(json['delivery_lng']),
      deliveryFromDate: _parseDate(json['delivery_time_from']),
      deliveryToDate: _parseDate(json['delivery_time_to']),
      status: _parseStatusFromServer(json['status']),
    );
  }

  // تحويل أسماء الأولوية إلى أرقام للسيرفر
  static int _priorityToInt(String priority) {
    switch (priority.toLowerCase()) {
      case 'low': return 1;
      case 'medium': return 2;
      case 'high': return 3;
      default: return 2;
    }
  }

  // تحويل أرقام الأولوية من السيرفر إلى أسماء
  static String _parsePriorityFromServer(dynamic value) {
    if (value == null) return 'Medium';
    final intVal = int.tryParse(value.toString());
    switch (intVal) {
      case 1: return 'Low';
      case 2: return 'Medium';
      case 3: return 'High';
      default: return value.toString();
    }
  }

  // تحويل أرقام الحالة من السيرفر إلى أسماء
  static String _parseStatusFromServer(dynamic value) {
    if (value == null) return 'Pending';
    final intVal = int.tryParse(value.toString());
    switch (intVal) {
      case 0: return 'Pending';
      case 1: return 'Assigned';
      case 2: return 'Done';
      default: return value.toString();
    }
  }

  // تحويل اسم الحالة إلى رقم للسيرفر
  static int _statusToInt(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return 0;
      case 'assigned': return 1;
      case 'done': return 2;
      default: return 0;
    }
  }

  /// تحويل TaskModel إلى Map لإرسالها للسيرفر
  Map<String, dynamic> toGpswoxJson() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'title': title,
      'device_id': int.tryParse(deviceId) ?? deviceId,
      'invoice_number': invoiceNumber,
      'comment': comment ?? '',
      'priority': _priorityToInt(priority),
      'status': _statusToInt(status),
      'pickup_address': pickupAddress,
      'pickup_address_lat': pickupLat,
      'pickup_address_lng': pickupLng,
      'pickup_time_from': dateFormat.format(pickupFromDate),
      'pickup_time_to': dateFormat.format(pickupToDate),
      'delivery_address': deliveryAddress,
      'delivery_address_lat': deliveryLat,
      'delivery_address_lng': deliveryLng,
      'delivery_time_from': dateFormat.format(deliveryFromDate),
      'delivery_time_to': dateFormat.format(deliveryToDate),
    };
  }
}
