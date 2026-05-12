import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/login_usecase.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/usecases/logout_usecase.dart';
import '../../../../domain/usecases/check_auth_status_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final AuthRepository _authRepository;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _authRepository = authRepository,
        super(const AuthState.initial());

  /// تسجيل الدخول
  Future<void> login({
    required String username,
    required String password,
    required String server,
    bool rememberMe = false,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _loginUseCase(
        username: username,
        password: password,
        server: server,
      );

      if (rememberMe) {
        await _authRepository.saveUserCredentials(user);
      } else {
        await _authRepository.clearUserCredentials();
      }

      state = AuthState.authenticated(user);
    } on ArgumentError catch (e) {
      state = AuthState.error(
        message: e.message ?? 'Invalid input',
        code: 'VALIDATION_ERROR',
      );
    } catch (e) {
      state = AuthState.error(
        message: e.toString(),
        code: 'LOGIN_ERROR',
      );
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    state = const AuthState.loading();

    try {
      await _logoutUseCase();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(
        message: e.toString(),
        code: 'LOGOUT_ERROR',
        previousUser: state.user,
      );
    }
  }

  /// التحقق من حالة المصادقة
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();

    try {
      // ignore: unused_local_variable
      final isAuthenticated = await _checkAuthStatusUseCase();

      final user = await _authRepository.getAuthenticatedUser();

      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// مسح حالة الخطأ
  void clearError() {
    state = const AuthState.unauthenticated();
  }

  /// تحديث بيانات المستخدم
  void updateUser(UserEntity user) {
    state = AuthState.authenticated(user);
  }
}
