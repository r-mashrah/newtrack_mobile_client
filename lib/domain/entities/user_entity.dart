import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String username,
    required String email,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    required String userApiHash,
    required DateTime createdAt,
    Map<String, dynamic>? preferences,
  }) = _UserEntity;

  const UserEntity._();

  bool get isAuthenticated => userApiHash.isNotEmpty;
}
