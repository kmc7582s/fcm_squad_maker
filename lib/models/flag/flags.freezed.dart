// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flags.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Flags _$FlagsFromJson(Map<String, dynamic> json) {
  return _Flags.fromJson(json);
}

/// @nodoc
mixin _$Flags {
  String get nation => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlagsCopyWith<Flags> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlagsCopyWith<$Res> {
  factory $FlagsCopyWith(Flags value, $Res Function(Flags) then) =
      _$FlagsCopyWithImpl<$Res, Flags>;
  @useResult
  $Res call({String nation, String img});
}

/// @nodoc
class _$FlagsCopyWithImpl<$Res, $Val extends Flags>
    implements $FlagsCopyWith<$Res> {
  _$FlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nation = null,
    Object? img = null,
  }) {
    return _then(_value.copyWith(
      nation: null == nation
          ? _value.nation
          : nation // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlagsImplCopyWith<$Res> implements $FlagsCopyWith<$Res> {
  factory _$$FlagsImplCopyWith(
          _$FlagsImpl value, $Res Function(_$FlagsImpl) then) =
      __$$FlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nation, String img});
}

/// @nodoc
class __$$FlagsImplCopyWithImpl<$Res>
    extends _$FlagsCopyWithImpl<$Res, _$FlagsImpl>
    implements _$$FlagsImplCopyWith<$Res> {
  __$$FlagsImplCopyWithImpl(
      _$FlagsImpl _value, $Res Function(_$FlagsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nation = null,
    Object? img = null,
  }) {
    return _then(_$FlagsImpl(
      nation: null == nation
          ? _value.nation
          : nation // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlagsImpl implements _Flags {
  _$FlagsImpl({required this.nation, required this.img});

  factory _$FlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlagsImplFromJson(json);

  @override
  final String nation;
  @override
  final String img;

  @override
  String toString() {
    return 'Flags(nation: $nation, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlagsImpl &&
            (identical(other.nation, nation) || other.nation == nation) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, nation, img);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FlagsImplCopyWith<_$FlagsImpl> get copyWith =>
      __$$FlagsImplCopyWithImpl<_$FlagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlagsImplToJson(
      this,
    );
  }
}

abstract class _Flags implements Flags {
  factory _Flags({required final String nation, required final String img}) =
      _$FlagsImpl;

  factory _Flags.fromJson(Map<String, dynamic> json) = _$FlagsImpl.fromJson;

  @override
  String get nation;
  @override
  String get img;
  @override
  @JsonKey(ignore: true)
  _$$FlagsImplCopyWith<_$FlagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
