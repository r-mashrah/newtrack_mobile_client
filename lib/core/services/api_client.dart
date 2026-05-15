import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late final Dio _dio;
  String? _userApiHash;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // إضافة Interceptor للطباعة أثناء الـ Debugging
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Dio get dio => _dio;
  String? get userApiHash => _userApiHash;

  /// تعيين الـ Hash الخاص بالمستخدم بعد تسجيل الدخول
  void setUserApiHash(String hash) {
    _userApiHash = hash;
  }

  /// إزالة الـ Hash عند تسجيل الخروج
  void clearUserApiHash() {
    _userApiHash = null;
  }

  /// إضافة الـ Hash تلقائياً للمعاملات
  Map<String, dynamic> _appendHash(Map<String, dynamic>? params) {
    final Map<String, dynamic> mergedParams = params != null ? Map.from(params) : {};
    if (_userApiHash != null) {
      mergedParams['user_api_hash'] = _userApiHash;
    }
    return mergedParams;
  }

  // Basic HTTP GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: _appendHash(queryParameters),
      options: options,
    );
  }

  // Basic HTTP POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // في الـ POST في GPSWox أحياناً يُرسل الـ hash كـ query parameter 
    // وأحياناً في الـ form-data. نحن نضيفه كـ query افتراضياً
    return await _dio.post(
      path,
      data: data,
      queryParameters: _appendHash(queryParameters),
      options: options,
    );
  }
}
