import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> login({
    required String username,
    required String password,
    required String server,
  }) async {
    try {
      final user = await _dataSource.login(
        username: username,
        password: password,
        server: server,
      );

      // يمكن إضافة منطق إضافي هنا
      // مثل التحقق من صلاحيات المستخدم
      // أو تسجيل حدث تسجيل الدخول

      return user;
    } catch (e) {
      // معالجة الأخطاء وتحويلها إلى استثناءات منطقية
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    try {
      return await _dataSource.getAuthenticatedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await _dataSource.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveUserCredentials(UserEntity user) async {
    try {
      await _dataSource.saveUserCredentials(user);
    } catch (e) {
      throw Exception('Failed to save credentials: ${e.toString()}');
    }
  }

  @override
  Future<void> clearUserCredentials() async {
    try {
      await _dataSource.clearUserCredentials();
    } catch (e) {
      throw Exception('Failed to clear credentials: ${e.toString()}');
    }
  }
}
