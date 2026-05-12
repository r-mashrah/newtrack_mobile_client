import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_entity.freezed.dart';

@freezed
class ServerEntity with _$ServerEntity {
  const factory ServerEntity({
    required String id,
    required String name,
    required String url,
    required String apiUrl,
    String? description,
    @Default(true) bool isActive,
    @Default(false) bool isDefault,
    Map<String, dynamic>? config,
  }) = _ServerEntity;

  const ServerEntity._();

  String get displayName => description ?? name;
}
