import 'package:dio/dio.dart';

/// Maps API / network errors to user-friendly Arabic messages.
/// Never exposes DioException, stack traces, or raw technical details to end users.
class ApiErrorMapper {
  ApiErrorMapper._();

  static String fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode != null) {
      return fromHttpResponse(statusCode: statusCode, data: data);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال — تحقق من الشبكة وحاول مجدداً';
      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم — تحقق من الإنترنت';
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';
      default:
        return 'خطأ في الاتصال — تحقق من الشبكة وحاول مجدداً';
    }
  }

  static String fromHttpResponse({
    required int statusCode,
    dynamic data,
  }) {
    final extracted = extractMessage(data);
    if (extracted != null && extracted.isNotEmpty) {
      return extracted;
    }

    switch (statusCode) {
      case 400:
        return 'طلب غير صالح — تحقق من البيانات المدخلة';
      case 401:
        return 'انتهت الجلسة — يرجى تسجيل الدخول مجدداً';
      case 403:
        return 'لا تملك صلاحية لتنفيذ هذا الإجراء';
      case 404:
        return 'الخدمة غير موجودة على الخادم';
      case 422:
        return 'بيانات ناقصة أو غير صحيحة';
      case 500:
      case 502:
      case 503:
        return 'خطأ داخلي في الخادم — حاول لاحقاً';
      default:
        return 'حدث خطأ (كود $statusCode)';
    }
  }

  /// Extracts a human-readable message from GPSWox-style API responses.
  static String? extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) return data.trim();

    if (data is Map) {
      // Direct message fields
      for (final key in ['message', 'msg', 'response', 'error']) {
        final val = data[key];
        if (val is String && val.trim().isNotEmpty) return val.trim();
      }

      // Laravel-style validation errors: { errors: { field: ["msg"] } }
      final errors = data['errors'];
      if (errors is Map) {
        final messages = <String>[];
        errors.forEach((_, value) {
          if (value is List) {
            for (final item in value) {
              final text = item?.toString().trim();
              if (text != null && text.isNotEmpty) messages.add(text);
            }
          } else {
            final text = value?.toString().trim();
            if (text != null && text.isNotEmpty) messages.add(text);
          }
        });
        if (messages.isNotEmpty) return messages.join('\n');
      }

      // statusCode + message combo
      if (data['status'] == 0 || data['status'] == false) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'فشلت العملية';
      }
    }

    return null;
  }

  static Map<String, String> extractValidationErrors(dynamic data) {
    final result = <String, String>{};
    if (data is! Map) return result;

    final errors = data['errors'];
    if (errors is! Map) return result;

    errors.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        result[key.toString()] = value.first.toString();
      } else if (value != null) {
        result[key.toString()] = value.toString();
      }
    });
    return result;
  }

  static bool isSuccessResponse(dynamic data) {
    if (data == null) return false;
    if (data is Map) {
      final status = data['status'];
      if (status == 1 || status == true || status == '1') return true;
      final statusStr = status?.toString().toLowerCase();
      if (statusStr == 'ok' || statusStr == 'success') return true;
      final success = data['success'];
      if (success == true || success == 1 || success == '1') return true;
      final result = data['result']?.toString().toLowerCase();
      if (result == 'success' || result == 'ok') return true;
      if (!data.containsKey('error') &&
          !data.containsKey('errors') &&
          status == null &&
          success == null) {
        return true;
      }
    }
    return false;
  }
}
