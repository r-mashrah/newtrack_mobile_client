import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/services/caching_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<UserEntity> login({
    required String username,
    required String password,
    required String server,
  });

  Future<void> logout();

  Future<UserEntity?> getAuthenticatedUser();

  Future<bool> isAuthenticated();

  Future<void> saveUserCredentials(UserEntity user);

  Future<void> clearUserCredentials();
}

class MockAuthDataSource implements AuthDataSource {
  final CachingService _cachingService;
  final FlutterSecureStorage _secureStorage;

  static const String _userKey = 'authenticated_user';
  static const String _rememberMeKey = 'remember_me';

  MockAuthDataSource(this._cachingService, this._secureStorage);

  UserEntity? _currentUser;

  @override
  Future<UserEntity> login({
    required String username,
    required String password,
    required String server,
  }) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 800));

    // بيانات اعتماد للاختبار
    if (username == 'demo' && password == 'demo123') {
      final user = UserEntity(
        id: 'user_001',
        username: username,
        email: '$username@newtrack.com',
        fullName: 'Demo User',
        authToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      // The UI will be responsible for calling saveUserCredentials if 'remember me' is checked.
      return user;
    }

    if (username == 'admin' && password == 'admin123') {
      final user = UserEntity(
        id: 'user_002',
        username: username,
        email: '$username@newtrack.com',
        fullName: 'System Administrator',
        authToken: 'mock_admin_token_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      // The UI will be responsible for calling saveUserCredentials if 'remember me' is checked.
      return user;
    }

    throw Exception('Invalid credentials. Use demo/demo123 or admin/admin123');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    // عند تسجيل الخروج يدوياً، نقوم بمسح البيانات وحالة "تذكرني"
    await clearUserCredentials();
    await _cachingService.setBool(_rememberMeKey, false);
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentUser != null) return _currentUser;

    // نتحقق أولاً من وجود بيانات مستخدم مخزنة بغض النظر عن مفتاح remember_me 
    // لأننا سنعتمد على وجود البيانات كدليل على حالة المصادقة المستمرة
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson != null) {
      try {
        final userModel = UserModel.fromJson(jsonDecode(userJson));
        _currentUser = userModel.toEntity();
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
    await Future.delayed(const Duration(milliseconds: 100));
    final user = await getAuthenticatedUser();
    return user != null;
  }

  @override
  Future<void> saveUserCredentials(UserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final userModel = UserModel.fromEntity(user);
    final userJson = jsonEncode(userModel.toJson());
    await _secureStorage.write(key: _userKey, value: userJson);
    await _cachingService.setBool(_rememberMeKey, true);
  }

  @override
  Future<void> clearUserCredentials() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _secureStorage.delete(key: _userKey);
  }
}
