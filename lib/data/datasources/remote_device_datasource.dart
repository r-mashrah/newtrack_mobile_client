import 'dart:async';
import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/device_model.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/entities/location_entity.dart';
import 'mock_device_datasource.dart'; // للحصول على واجهة DeviceDataSource

class RemoteDeviceDataSource implements DeviceDataSource {
  final ApiClient _apiClient;
  
  final List<DeviceEntity> _cachedDevices = [];
  final StreamController<List<DeviceEntity>> _updateController = StreamController.broadcast();

  RemoteDeviceDataSource(this._apiClient);

  @override
  Future<List<DeviceEntity>> getDevices() async {
    try {
      final response = await _apiClient.get(ApiConstants.getDevices);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];
        
        // التعامل مع عدة أشكال محتملة لاستجابة GPSWox
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          items = data['items'];
        } else if (data is Map && data.containsKey('data')) {
          items = data['data'];
        } else if (data is Map) {
          // قد يعيد الخادم الأجهزة كمصفوفة مباشرة في الـ root أو داخل مفتاح آخر
          // نستخرج فقط الـ objects
          items = data.values.where((e) => e is Map || e is List).toList();
          // أحياناً يكون داخل list داخل أول key
          if (items.isNotEmpty && items.first is List) {
            items = items.first;
          }
        }

        final devices = items.map((json) {
          try {
            return DeviceModel.fromGpswoxJson(json as Map<String, dynamic>).toEntity();
          } catch (e) {
            // الاستمرار في التحليل حتى لو فشل جهاز واحد
            print('Error parsing device: $e');
            return null;
          }
        }).whereType<DeviceEntity>().toList();

        _cachedDevices.clear();
        _cachedDevices.addAll(devices);
        _updateController.add(_cachedDevices);

        return _cachedDevices;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Exception('غير مصرح لك - يرجى تسجيل الدخول مجدداً');
      }
      throw Exception('فشل الاتصال بالخادم: ${e.message}');
    } catch (e) {
      throw Exception('فشل جلب الأجهزة: $e');
    }
  }

  @override
  Future<DeviceEntity> getDeviceById(String id) async {
    // في الغالب الـ API الخاص بـ GPSWox يجلب كل الأجهزة مرة واحدة
    if (_cachedDevices.isEmpty) {
      await getDevices();
    }
    
    return _cachedDevices.firstWhere(
      (device) => device.id == id,
      orElse: () => throw Exception('الجهاز غير موجود'),
    );
  }

  @override
  Future<List<DeviceEntity>> getDevicesByStatus(String status) async {
    if (_cachedDevices.isEmpty) {
      await getDevices();
    }
    return _cachedDevices.where((device) => device.status == status).toList();
  }

  @override
  Future<void> addDevice(DeviceEntity device) async {
    // نحتاج لمعرفة الـ Endpoint الحقيقي لـ GPSWox الخاص بالإضافة
    throw UnimplementedError('إضافة جهاز غير مفعلة بعد');
  }

  @override
  Future<void> updateDevice(DeviceEntity device) async {
    throw UnimplementedError('تعديل جهاز غير مفعلة بعد');
  }

  @override
  Future<void> deleteDevice(String id) async {
    throw UnimplementedError('حذف جهاز غير مفعلة بعد');
  }

  @override
  Future<void> updateDeviceLocation(String deviceId, LocationEntity location) async {
    // لا يمكننا تحديث الموقع يدوياً في الخادم من التطبيق
    throw UnsupportedError('لا يمكن تحديث الموقع يدوياً على الخادم');
  }

  @override
  Stream<List<DeviceEntity>> subscribeToLiveUpdates() {
    return _updateController.stream;
  }
}
