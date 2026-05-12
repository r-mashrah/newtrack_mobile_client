import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  /// الحالة الأولية
  const factory AuthState.initial() = _Initial;

  /// حالة التحميل
  const factory AuthState.loading() = _Loading;

  /// حالة المصادقة الناجحة
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;

  /// حالة عدم المصادقة
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// حالة الخطأ
  const factory AuthState.error({
    required String message,
    required String code,
    UserEntity? previousUser,
  }) = _Error;

  const AuthState._();

  /// للتحقق إذا كانت الحالة تحميل
  bool get isLoading => this is _Loading;

  /// للتحقق إذا كانت الحالة مصادقة
  bool get isAuthenticated => this is _Authenticated;

  /// للتحقق إذا كانت الحالة خطأ
  bool get hasError => this is _Error;

  /// الحصول على المستخدم الحالي
  UserEntity? get user => when(
    initial: () => null,
    loading: () => null,
    authenticated: (user) => user,
    unauthenticated: () => null,
    error: (message, code, previousUser) => previousUser,
  );
}
