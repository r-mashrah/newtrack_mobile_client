import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    @JsonKey(name: 'user_api_hash') required String userApiHash,
    required String createdAt,
    Map<String, dynamic>? preferences,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // تحويل من Model إلى Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      userApiHash: userApiHash,
      createdAt: DateTime.parse(createdAt),
      preferences: preferences,
    );
  }

  // تحويل من Entity إلى Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      avatarUrl: entity.avatarUrl,
      userApiHash: entity.userApiHash,
      createdAt: entity.createdAt.toIso8601String(),
      preferences: entity.preferences,
    );
  }
}
