// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServerEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get apiUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  Map<String, dynamic>? get config => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServerEntityCopyWith<ServerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerEntityCopyWith<$Res> {
  factory $ServerEntityCopyWith(
          ServerEntity value, $Res Function(ServerEntity) then) =
      _$ServerEntityCopyWithImpl<$Res, ServerEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      String apiUrl,
      String? description,
      bool isActive,
      bool isDefault,
      Map<String, dynamic>? config});
}

/// @nodoc
class _$ServerEntityCopyWithImpl<$Res, $Val extends ServerEntity>
    implements $ServerEntityCopyWith<$Res> {
  _$ServerEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? apiUrl = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? config = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      apiUrl: null == apiUrl
          ? _value.apiUrl
          : apiUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerEntityImplCopyWith<$Res>
    implements $ServerEntityCopyWith<$Res> {
  factory _$$ServerEntityImplCopyWith(
          _$ServerEntityImpl value, $Res Function(_$ServerEntityImpl) then) =
      __$$ServerEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      String apiUrl,
      String? description,
      bool isActive,
      bool isDefault,
      Map<String, dynamic>? config});
}

/// @nodoc
class __$$ServerEntityImplCopyWithImpl<$Res>
    extends _$ServerEntityCopyWithImpl<$Res, _$ServerEntityImpl>
    implements _$$ServerEntityImplCopyWith<$Res> {
  __$$ServerEntityImplCopyWithImpl(
      _$ServerEntityImpl _value, $Res Function(_$ServerEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? apiUrl = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? config = freezed,
  }) {
    return _then(_$ServerEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      apiUrl: null == apiUrl
          ? _value.apiUrl
          : apiUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      config: freezed == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ServerEntityImpl extends _ServerEntity {
  const _$ServerEntityImpl(
      {required this.id,
      required this.name,
      required this.url,
      required this.apiUrl,
      this.description,
      this.isActive = true,
      this.isDefault = false,
      final Map<String, dynamic>? config})
      : _config = config,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final String apiUrl;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isDefault;
  final Map<String, dynamic>? _config;
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ServerEntity(id: $id, name: $name, url: $url, apiUrl: $apiUrl, description: $description, isActive: $isActive, isDefault: $isDefault, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      url,
      apiUrl,
      description,
      isActive,
      isDefault,
      const DeepCollectionEquality().hash(_config));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerEntityImplCopyWith<_$ServerEntityImpl> get copyWith =>
      __$$ServerEntityImplCopyWithImpl<_$ServerEntityImpl>(this, _$identity);
}

abstract class _ServerEntity extends ServerEntity {
  const factory _ServerEntity(
      {required final String id,
      required final String name,
      required final String url,
      required final String apiUrl,
      final String? description,
      final bool isActive,
      final bool isDefault,
      final Map<String, dynamic>? config}) = _$ServerEntityImpl;
  const _ServerEntity._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get url;
  @override
  String get apiUrl;
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  bool get isDefault;
  @override
  Map<String, dynamic>? get config;
  @override
  @JsonKey(ignore: true)
  _$$ServerEntityImplCopyWith<_$ServerEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
