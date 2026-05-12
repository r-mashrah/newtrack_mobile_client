import '../entities/user_entity.dart';

abstract class AuthRepository {
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
