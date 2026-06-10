import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/caching_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_datasource.dart'; // للحصول على واجهة AuthDataSource

class RemoteAuthDataSource implements AuthDataSource {
  final ApiClient _apiClient;
  final CachingService _cachingService;
  final FlutterSecureStorage _secureStorage;

  static const String _userKey = 'authenticated_user';
  static const String _rememberMeKey = 'remember_me';

  RemoteAuthDataSource(
    this._apiClient,
    this._cachingService,
    this._secureStorage,
  );

  UserEntity? _currentUser;

  @override
  Future<UserEntity> login({
    required String username,
    required String password,
    required String server,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': username, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        // التحقق من الاستجابة حسب هيكلية GPSWox
        if (data['status'] == 1 ||
            data['status'] == true ||
            data['user_api_hash'] != null) {
          final userApiHash = data['user_api_hash'];

          // إنشاء الكيان الخاص بالمستخدم
          final user = UserEntity(
            id: username, // كمعرف مؤقت بما أن تسجيل الدخول قد لا يعيد كامل تفاصيل المستخدم
            username: username,
            email: username,
            userApiHash: userApiHash,
            createdAt: DateTime.now(),
          );

          _currentUser = user;
          _apiClient.setUserApiHash(userApiHash);

          return user;
        } else {
          throw Exception(
            data['message'] ?? 'فشل تسجيل الدخول: تحقق من بياناتك',
          );
        }
      } else {
        throw Exception('خطأ في السيرفر: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('بيانات تسجيل الدخول غير صحيحة');
      } else if (e.response?.statusCode == 401) {
        throw Exception('غير مصرح لك بالدخول');
      }
      throw Exception('فشل الاتصال: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _apiClient.clearUserApiHash();
    await clearUserCredentials();
    await _cachingService.setBool(_rememberMeKey, false);
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    if (_currentUser != null) return _currentUser;

    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson != null) {
      try {
        final userModel = UserModel.fromJson(jsonDecode(userJson));
        _currentUser = userModel.toEntity();
        // إعادة تعيين الـ hash في عميل الـ API
        _apiClient.setUserApiHash(_currentUser!.userApiHash);
        return _currentUser;
      } catch (e) {
        await clearUserCredentials();
        return null;
      }
    }

    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getAuthenticatedUser();
    return user != null;
  }

  @override
  Future<void> saveUserCredentials(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    final userJson = jsonEncode(userModel.toJson());
    await _secureStorage.write(key: _userKey, value: userJson);
    await _cachingService.setBool(_rememberMeKey, true);
  }

  @override
  Future<void> clearUserCredentials() async {
    await _secureStorage.delete(key: _userKey);
  }
}
