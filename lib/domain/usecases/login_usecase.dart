import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String username,
    required String password,
    required String server,
  }) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    if (server.isEmpty) {
      throw ArgumentError('Server cannot be empty');
    }

    return repository.login(
      username: username,
      password: password,
      server: server,
    );
  }
}
