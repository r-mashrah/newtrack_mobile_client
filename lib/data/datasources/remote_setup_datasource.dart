import 'package:dio/dio.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_error_mapper.dart';
import '../../core/constants/api_constants.dart';
import '../models/setup_models.dart';
import '../models/command_models.dart';
import 'setup_datasource.dart';

class RemoteSetupDataSource implements SetupDataSource {
  final ApiClient _apiClient;

  UserSettings _settings = UserSettings();

  RemoteSetupDataSource(this._apiClient);

  @override
  Future<UserSettings> getUserSettings() async => _settings;

  @override
  Future<void> updateUserSettings(UserSettings settings) async {
    _settings = settings;
  }

  @override
  Future<List<VehicleGroup>> getVehicleGroups() async {
    final Map<String, VehicleGroup> groupsMap = {};

    try {
      final groupsResponse = await _apiClient.get(ApiConstants.getDeviceGroups);
      if (groupsResponse.statusCode == 200 && groupsResponse.data != null) {
        final data = groupsResponse.data;
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map) {
          if (data.containsKey('data')) {
            items = data['data'] as List? ?? [];
          } else if (data.containsKey('items')) {
            items = data['items'] as List? ?? [];
          } else if (data.containsKey('groups')) {
            items = data['groups'] as List? ?? [];
          }
        }

        for (var item in items) {
          if (item is Map && item['id'] != null) {
            final String id = item['id'].toString();
            final String title =
                item['title']?.toString() ?? item['name']?.toString() ?? 'مجموعة';
            groupsMap[id] = VehicleGroup(id: id, name: title, deviceIds: []);
          }
        }
      }
    } catch (_) {}

    try {
      final response = await _apiClient.get(ApiConstants.getDevices);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List) {
          for (var item in data) {
            if (item is Map &&
                item.containsKey('items') &&
                item.containsKey('title')) {
              final String id = item['id']?.toString() ?? '';
              final String title = item['title']?.toString() ?? 'مجموعة';

              final groupDevices = (item['items'] as List?)
                      ?.map((d) => d['id']?.toString() ?? '')
                      .where((deviceId) => deviceId.isNotEmpty)
                      .toList() ??
                  [];

              if (id.isNotEmpty) {
                groupsMap[id] = VehicleGroup(
                  id: id,
                  name: title,
                  deviceIds: groupDevices,
                );
              }
            }
          }
        }
      }
    } catch (_) {}

    final groups = groupsMap.values.toList();

    if (groups.isEmpty) {
      groups.add(VehicleGroup(
        id: 'all',
        name: 'جميع الأجهزة',
        deviceIds: [],
      ));
    }

    return groups;
  }

  @override
  Future<List<Driver>> getDrivers() async {
    try {
      final response = await _apiClient.get(ApiConstants.getDeviceUsers);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          items = data['items'];
        }

        return items.map((json) {
          return Driver(
            id: json['id']?.toString() ?? '',
            name: json['name']?.toString() ?? json['email']?.toString() ?? '',
            phone: json['phone']?.toString() ?? '',
          );
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<List<AppEvent>> getEvents() async {
    try {
      final response = await _apiClient.get(ApiConstants.getEvents);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          items = data['items'];
        }

        return items.map((json) {
          return AppEvent(
            id: json['id']?.toString() ?? '',
            type: json['type']?.toString() ??
                json['alert_type']?.toString() ??
                'info',
            message: json['message']?.toString() ??
                json['description']?.toString() ??
                '',
            timestamp: DateTime.tryParse(
              json['time']?.toString() ??
                  json['created_at']?.toString() ??
                  '',
            ),
          );
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<SendCommandData> getSendCommandData() async {
    final response = await _apiClient.get(ApiConstants.sendCommandData);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return SendCommandData.fromJson(data);
      }
      if (data is Map) {
        return SendCommandData.fromJson(Map<String, dynamic>.from(data));
      }
    }

    throw Exception('تعذر تحميل بيانات الأوامر (كود ${response.statusCode})');
  }

  @override
  Future<List<SmsTemplate>> getSmsTemplates() async {
    try {
      final data = await getSendCommandData();
      return data.smsTemplates;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<SmsTemplate>> getGprsTemplates() async {
    try {
      final data = await getSendCommandData();
      return data.gprsTemplates;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<SmsGatewaySettings> getSmsGatewaySettings() async {
    try {
      final response = await _apiClient.get(ApiConstants.editSetupData);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Map<String, dynamic>? item;
        if (data is Map) {
          final rawItem = data['item'];
          if (rawItem is Map) {
            item = Map<String, dynamic>.from(rawItem);
          }
        }

        if (item != null) {
          final gateway = item['sms_gateway'];
          final enabled = gateway == 1 ||
              gateway == '1' ||
              gateway == true ||
              gateway == 'true';
          return SmsGatewaySettings(
            enabled: enabled,
            gatewayType: _gatewayTypeLabel(gateway),
            url: item['sms_gateway_url']?.toString(),
          );
        }
      }
    } catch (_) {}

    return SmsGatewaySettings(enabled: false);
  }

  @override
  Future<void> updateSmsGatewaySettings(SmsGatewaySettings settings) async {}

  String _gatewayTypeLabel(dynamic gateway) {
    if (gateway == 1 || gateway == '1') return 'server gateway';
    return 'غير مفعّل';
  }

  @override
  Future<CommandResult> sendGprsCommand({
    required String deviceId,
    required String commandType,
    String? message,
    bool autoSendWhenOnline = false,
  }) async {
    final deviceIdInt = int.tryParse(deviceId);
    if (deviceIdInt == null || deviceIdInt <= 0) {
      return CommandResult.failure(
        message: 'معرف الجهاز غير صالح',
        errorCode: 'validation',
      );
    }

    if (commandType.isEmpty) {
      return CommandResult.failure(
        message: 'نوع الأمر مطلوب',
        errorCode: 'validation',
      );
    }

    final messageText = (message ?? '').trim();
    if (commandType == 'custom' && messageText.isEmpty) {
      return CommandResult.failure(
        message: 'نص الأمر مطلوب للأوامر المخصصة',
        errorCode: 'validation',
      );
    }

    final payload = <String, dynamic>{
      'device_id': deviceIdInt,
      'type': commandType,
      if (messageText.isNotEmpty) 'message': messageText,
      if (autoSendWhenOnline) 'auto_send_when_online': '1',
    };

    return _postCommand(
      url: ApiConstants.sendGprsCommand,
      payload: payload,
      successFallback: 'تم إرسال أمر GPRS بنجاح',
      failureFallback: 'فشل إرسال أمر GPRS',
    );
  }

  @override
  Future<CommandResult> sendSmsCommand({
    required String deviceId,
    required String message,
  }) async {
    final deviceIdInt = int.tryParse(deviceId);
    if (deviceIdInt == null || deviceIdInt <= 0) {
      return CommandResult.failure(
        message: 'معرف الجهاز غير صالح',
        errorCode: 'validation',
      );
    }

    final messageText = message.trim();
    if (messageText.isEmpty) {
      return CommandResult.failure(
        message: 'نص الرسالة مطلوب',
        errorCode: 'validation',
      );
    }

    final gateway = await getSmsGatewaySettings();
    if (!gateway.enabled) {
      return CommandResult.failure(
        message:
            'بوابة SMS غير مفعّلة على الخادم.\n'
            'يرجى تفعيلها من إعدادات الحساب على لوحة التحكم.',
        errorCode: 'sms_gateway_disabled',
      );
    }

    final formData = FormData();
    formData.fields.add(MapEntry('message', messageText));
    formData.fields.add(MapEntry('devices[]', deviceIdInt.toString()));

    final payload = <String, dynamic>{
      'message': messageText,
      'devices[]': deviceIdInt,
    };

    return _postCommand(
      url: ApiConstants.sendSmsCommand,
      formData: formData,
      payload: payload,
      successFallback: 'تم إرسال رسالة SMS بنجاح',
      failureFallback: 'فشل إرسال رسالة SMS',
    );
  }

  Future<CommandResult> _postCommand({
    required String url,
    Map<String, dynamic>? payload,
    FormData? formData,
    required String successFallback,
    required String failureFallback,
  }) async {
    final diagnosticPayload = payload ?? {};

    try {
      final response = await _apiClient.post(
        url,
        data: formData ?? FormData.fromMap(payload!),
        options: Options(
          contentType: formData != null ? 'multipart/form-data' : null,
          validateStatus: (status) => status != null,
        ),
      );

      final statusCode = response.statusCode ?? 0;
      final data = response.data;

      final diagnostic = CommandDiagnostic(
        url: url,
        method: 'POST',
        requestPayload: diagnosticPayload,
        statusCode: statusCode,
        responseBody: data,
        validationErrors: ApiErrorMapper.extractValidationErrors(data),
      );

      if (statusCode == 200 || statusCode == 201) {
        if (ApiErrorMapper.isSuccessResponse(data)) {
          final msg = ApiErrorMapper.extractMessage(data) ?? successFallback;
          return CommandResult.success(message: msg, diagnostic: diagnostic);
        }
        final errMsg = ApiErrorMapper.extractMessage(data) ?? failureFallback;
        return CommandResult.failure(
          message: errMsg,
          errorCode: statusCode.toString(),
          rawResponse: _asMap(data),
          diagnostic: diagnostic,
        );
      }

      final errMsg = ApiErrorMapper.fromHttpResponse(
        statusCode: statusCode,
        data: data,
      );
      return CommandResult.failure(
        message: errMsg,
        errorCode: statusCode.toString(),
        rawResponse: _asMap(data),
        diagnostic: diagnostic,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final diagnostic = CommandDiagnostic(
        url: url,
        method: 'POST',
        requestPayload: diagnosticPayload,
        statusCode: statusCode,
        responseBody: data,
        validationErrors: ApiErrorMapper.extractValidationErrors(data),
      );
      return CommandResult.failure(
        message: ApiErrorMapper.fromDioException(e),
        errorCode: statusCode?.toString() ?? 'network_error',
        rawResponse: _asMap(data),
        diagnostic: diagnostic,
      );
    } catch (_) {
      return CommandResult.failure(
        message: 'حدث خطأ غير متوقع — حاول مجدداً',
        errorCode: 'unknown',
        diagnostic: CommandDiagnostic(
          url: url,
          method: 'POST',
          requestPayload: diagnosticPayload,
        ),
      );
    }
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
