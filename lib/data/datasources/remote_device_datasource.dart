import 'dart:async';
import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/device_model.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/entities/location_entity.dart';
import 'device_datasource.dart'; // للحصول على واجهة DeviceDataSource

class RemoteDeviceDataSource implements DeviceDataSource {
  final ApiClient _apiClient;

  final List<DeviceEntity> _cachedDevices = [];
  Map<String, Map<String, dynamic>> _staticDeviceData = {};
  bool _hasFetchedStaticData = false;
  late final StreamController<List<DeviceEntity>> _updateController;
  Timer? _pollingTimer;

  RemoteDeviceDataSource(this._apiClient) {
    _updateController = StreamController<List<DeviceEntity>>.broadcast(
      onListen: _startPolling,
      onCancel: _stopPolling,
    );
  }

  void _startPolling() {
    // جلب البيانات فوراً ثم بدء المؤقت
    getDevices();
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      getDevices();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _extractStaticData(dynamic source) {
    if (source is List) {
      for (var item in source) {
        _extractStaticData(item);
      }
    } else if (source is Map) {
      if (source.containsKey('id') && (source.containsKey('device_data') || source.containsKey('plate_number'))) {
        final id = source['id'].toString();
        _staticDeviceData[id] = source as Map<String, dynamic>;
      } else if (source.containsKey('items') && source['items'] is List) {
        _extractStaticData(source['items']);
      } else {
        for (var value in source.values) {
          if (value is Map || value is List) {
            _extractStaticData(value);
          }
        }
      }
    }
  }

  @override
  Future<List<DeviceEntity>> getDevices() async {
    try {
      if (!_hasFetchedStaticData) {
        try {
          final configResponse = await _apiClient.get('${ApiConstants.apiBase}/devices');
          if (configResponse.statusCode == 200 && configResponse.data != null) {
            _staticDeviceData.clear();
            _extractStaticData(configResponse.data);
            _hasFetchedStaticData = true;
          }
        } catch (e) {
          print('Error fetching static device data: $e');
        }
      }

      final response = await _apiClient.get(ApiConstants.getDevices);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // طباعة البيانات الخام للمساعدة في التصحيح (Debug)
        print('Raw GPSWox Data: $data');

        List<dynamic> allDeviceJson = [];

        // دالة مساعدة لاستخراج الأجهزة بشكل متداخل
        void extractDevices(dynamic source, {String? groupId}) {
          if (source is List) {
            for (var item in source) {
              extractDevices(item, groupId: groupId);
            }
          } else if (source is Map) {
            // إذا كان يحتوي على imei أو lat فهو غالباً جهاز
            if (source.containsKey('imei') ||
                source.containsKey('lat') ||
                source.containsKey('device_data')) {
              // الحقن اليدوي للجروب
              if (groupId != null) {
                source['extracted_group_id'] = groupId;
              }
              allDeviceJson.add(source);
            }
            // إذا كان يحتوي على items فهو غالباً مجموعة تحتوي على أجهزة
            else if (source.containsKey('items') && source['items'] is List) {
              final newGroupId = source['id']?.toString();
              extractDevices(source['items'], groupId: newGroupId);
            }
            // البحث في أي خرائط متداخلة أخرى (مثل المفاتيح "0", "1" التي يستخدمها GPSWox أحياناً)
            else {
              for (var value in source.values) {
                if (value is Map || value is List) {
                  extractDevices(value, groupId: groupId);
                }
              }
            }
          }
        }

        extractDevices(data);

        final devices = allDeviceJson
            .map((json) {
              try {
                final Map<String, dynamic> mergedJson = Map<String, dynamic>.from(json as Map);
                final id = mergedJson['id']?.toString();
                if (id != null && _staticDeviceData.containsKey(id)) {
                  final staticData = _staticDeviceData[id]!;
                  final fieldsToCopy = ['plate_number', 'sim_number', 'device_model', 'registration_number', 'object_owner', 'vin', 'tail_length', 'tail_color', 'icon_type', 'group_id'];
                  for (var field in fieldsToCopy) {
                    if (staticData[field] != null) mergedJson[field] = staticData[field];
                  }
                  
                  if (staticData['device_data'] != null && staticData['device_data'] is Map) {
                     final staticDeviceData = staticData['device_data'] as Map<String, dynamic>;
                     if (mergedJson['device_data'] == null) {
                         mergedJson['device_data'] = Map<String, dynamic>.from(staticDeviceData);
                     } else if (mergedJson['device_data'] is Map) {
                         final liveDeviceData = mergedJson['device_data'] as Map;
                         for (var key in staticDeviceData.keys) {
                            liveDeviceData[key] = staticDeviceData[key];
                         }
                     }
                  }
                }

                return DeviceModel.fromGpswoxJson(
                  mergedJson,
                ).toEntity();
              } catch (e) {
                print('Error parsing device: $e');
                return null;
              }
            })
            .whereType<DeviceEntity>()
            .toList();

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
    try {
      _hasFetchedStaticData = false;
      final requestData = <String, dynamic>{
        'name': device.name,
        'imei': device.imei,
      };

      if (device.plateNumber != null && device.plateNumber!.isNotEmpty) {
        requestData['plate_number'] = device.plateNumber;
      }
      if (device.simNumber != null && device.simNumber!.isNotEmpty) {
        requestData['sim_number'] = device.simNumber;
      }
      if (device.model != null && device.model!.isNotEmpty) {
        requestData['device_model'] = device.model;
      }
      if (device.group != null && device.group!.isNotEmpty && device.group != 'Ungrouped') {
        final groupId = int.tryParse(device.group!);
        if (groupId != null) {
          requestData['group_id'] = groupId;
        }
      }

      if (device.additionalData != null) {
        requestData.addAll(device.additionalData!);
      }

      final response = await _apiClient.post(
        ApiConstants.addDevice,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data['status'] == 0) {
          String errorMessage = 'فشل إضافة الجهاز';
          if (data.containsKey('message') &&
              data['message'] != null &&
              data['message'].toString().isNotEmpty) {
            errorMessage = data['message'].toString();
          } else if (data.containsKey('errors') && data['errors'] is Map) {
            final errorsMap = data['errors'] as Map;
            final errorList = [];
            for (var key in errorsMap.keys) {
              final val = errorsMap[key];
              if (val is List) {
                errorList.add('$key: ${val.join(", ")}');
              } else {
                errorList.add('$key: $val');
              }
            }
            if (errorList.isNotEmpty) {
              errorMessage = errorList.join('\n');
            }
          }
          throw Exception(errorMessage);
        }
        // تحديث القائمة بعد الإضافة الناجحة
        await getDevices();
      } else {
        throw Exception('فشل إضافة الجهاز: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'تعذر إضافة الجهاز';
      if (e.response?.data != null && e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('message')) {
          errorMessage = data['message'].toString();
        }
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          final errorList = [];
          for (var key in errorsMap.keys) {
            final val = errorsMap[key];
            if (val is List) {
              errorList.add('$key: ${val.join(", ")}');
            } else {
              errorList.add('$key: $val');
            }
          }
          if (errorList.isNotEmpty) {
            errorMessage += '\n' + errorList.join('\n');
          }
        }
      } else {
        errorMessage = 'خطأ خادم: ${e.response?.statusCode ?? e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<void> updateDevice(DeviceEntity device) async {
    try {
      _hasFetchedStaticData = false;
      final requestData = <String, dynamic>{
        'id': device.id, // Usually GPSWox uses 'id' for editing, let's use both or check API
        'device_id': device.id, 
        'name': device.name,
        'imei': device.imei,
      };

      if (device.plateNumber != null && device.plateNumber!.isNotEmpty) {
        requestData['plate_number'] = device.plateNumber;
      }
      if (device.simNumber != null && device.simNumber!.isNotEmpty) {
        requestData['sim_number'] = device.simNumber;
      }
      if (device.model != null && device.model!.isNotEmpty) {
        requestData['device_model'] = device.model;
      }
      
      // Fix for 400 Bad Request: group_id must be an integer, not string or 'Ungrouped'
      if (device.group != null && device.group!.isNotEmpty && device.group != 'Ungrouped') {
        final groupId = int.tryParse(device.group!);
        if (groupId != null) {
          requestData['group_id'] = groupId;
        }
      }

      final response = await _apiClient.post(
        ApiConstants.editDevice,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data['status'] == 0) {
          String errorMessage = 'فشل تعديل الجهاز';
          if (data.containsKey('message') && data['message'] != null) {
            errorMessage = data['message'].toString();
          }
          throw Exception(errorMessage);
        }
        await getDevices();
      } else {
        throw Exception('فشل تعديل الجهاز: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'تعذر تعديل الجهاز';
      if (e.response?.data != null && e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('message')) {
          errorMessage = data['message'].toString();
        }
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          final errorList = [];
          for (var key in errorsMap.keys) {
            final val = errorsMap[key];
            if (val is List) {
              errorList.add('$key: ${val.join(", ")}');
            } else {
              errorList.add('$key: $val');
            }
          }
          if (errorList.isNotEmpty) {
            errorMessage += '\n' + errorList.join('\n');
          }
        }
      } else {
        errorMessage = 'خطأ خادم: ${e.response?.statusCode ?? e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  @override
  Future<void> deleteDevice(String id) async {
    try {
      _hasFetchedStaticData = false;
      final response = await _apiClient.post(
        ApiConstants.destroyDevice,
        data: {'device_id': id},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data['status'] == 0) {
          throw Exception(data['message'] ?? 'فشل حذف الجهاز');
        }
        await getDevices();
      } else {
        throw Exception('فشل حذف الجهاز: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('تعذر حذف الجهاز: $e');
    }
  }

  @override
  Future<void> updateDeviceLocation(
    String deviceId,
    LocationEntity location,
  ) async {
    // لا يمكننا تحديث الموقع يدوياً في الخادم من التطبيق
    throw UnsupportedError('لا يمكن تحديث الموقع يدوياً على الخادم');
  }

  @override
  Stream<List<DeviceEntity>> subscribeToLiveUpdates() {
    return _updateController.stream;
  }
}
