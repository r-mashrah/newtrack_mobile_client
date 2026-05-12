// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_style_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapStyleState {
  MapStyleType get currentStyle => throw _privateConstructorUsedError;
  bool get showTrail => throw _privateConstructorUsedError;
  bool get showGeofences => throw _privateConstructorUsedError;
  bool get showPoI => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapStyleStateCopyWith<MapStyleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapStyleStateCopyWith<$Res> {
  factory $MapStyleStateCopyWith(
          MapStyleState value, $Res Function(MapStyleState) then) =
      _$MapStyleStateCopyWithImpl<$Res, MapStyleState>;
  @useResult
  $Res call(
      {MapStyleType currentStyle,
      bool showTrail,
      bool showGeofences,
      bool showPoI});
}

/// @nodoc
class _$MapStyleStateCopyWithImpl<$Res, $Val extends MapStyleState>
    implements $MapStyleStateCopyWith<$Res> {
  _$MapStyleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStyle = null,
    Object? showTrail = null,
    Object? showGeofences = null,
    Object? showPoI = null,
  }) {
    return _then(_value.copyWith(
      currentStyle: null == currentStyle
          ? _value.currentStyle
          : currentStyle // ignore: cast_nullable_to_non_nullable
              as MapStyleType,
      showTrail: null == showTrail
          ? _value.showTrail
          : showTrail // ignore: cast_nullable_to_non_nullable
              as bool,
      showGeofences: null == showGeofences
          ? _value.showGeofences
          : showGeofences // ignore: cast_nullable_to_non_nullable
              as bool,
      showPoI: null == showPoI
          ? _value.showPoI
          : showPoI // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapStyleStateImplCopyWith<$Res>
    implements $MapStyleStateCopyWith<$Res> {
  factory _$$MapStyleStateImplCopyWith(
          _$MapStyleStateImpl value, $Res Function(_$MapStyleStateImpl) then) =
      __$$MapStyleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MapStyleType currentStyle,
      bool showTrail,
      bool showGeofences,
      bool showPoI});
}

/// @nodoc
class __$$MapStyleStateImplCopyWithImpl<$Res>
    extends _$MapStyleStateCopyWithImpl<$Res, _$MapStyleStateImpl>
    implements _$$MapStyleStateImplCopyWith<$Res> {
  __$$MapStyleStateImplCopyWithImpl(
      _$MapStyleStateImpl _value, $Res Function(_$MapStyleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStyle = null,
    Object? showTrail = null,
    Object? showGeofences = null,
    Object? showPoI = null,
  }) {
    return _then(_$MapStyleStateImpl(
      currentStyle: null == currentStyle
          ? _value.currentStyle
          : currentStyle // ignore: cast_nullable_to_non_nullable
              as MapStyleType,
      showTrail: null == showTrail
          ? _value.showTrail
          : showTrail // ignore: cast_nullable_to_non_nullable
              as bool,
      showGeofences: null == showGeofences
          ? _value.showGeofences
          : showGeofences // ignore: cast_nullable_to_non_nullable
              as bool,
      showPoI: null == showPoI
          ? _value.showPoI
          : showPoI // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MapStyleStateImpl implements _MapStyleState {
  const _$MapStyleStateImpl(
      {required this.currentStyle,
      required this.showTrail,
      required this.showGeofences,
      required this.showPoI});

  @override
  final MapStyleType currentStyle;
  @override
  final bool showTrail;
  @override
  final bool showGeofences;
  @override
  final bool showPoI;

  @override
  String toString() {
    return 'MapStyleState(currentStyle: $currentStyle, showTrail: $showTrail, showGeofences: $showGeofences, showPoI: $showPoI)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapStyleStateImpl &&
            (identical(other.currentStyle, currentStyle) ||
                other.currentStyle == currentStyle) &&
            (identical(other.showTrail, showTrail) ||
                other.showTrail == showTrail) &&
            (identical(other.showGeofences, showGeofences) ||
                other.showGeofences == showGeofences) &&
            (identical(other.showPoI, showPoI) || other.showPoI == showPoI));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentStyle, showTrail, showGeofences, showPoI);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapStyleStateImplCopyWith<_$MapStyleStateImpl> get copyWith =>
      __$$MapStyleStateImplCopyWithImpl<_$MapStyleStateImpl>(this, _$identity);
}

abstract class _MapStyleState implements MapStyleState {
  const factory _MapStyleState(
      {required final MapStyleType currentStyle,
      required final bool showTrail,
      required final bool showGeofences,
      required final bool showPoI}) = _$MapStyleStateImpl;

  @override
  MapStyleType get currentStyle;
  @override
  bool get showTrail;
  @override
  bool get showGeofences;
  @override
  bool get showPoI;
  @override
  @JsonKey(ignore: true)
  _$$MapStyleStateImplCopyWith<_$MapStyleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
