// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clubs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Clubs _$ClubsFromJson(Map<String, dynamic> json) {
  return _Clubs.fromJson(json);
}

/// @nodoc
mixin _$Clubs {
  String get club => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClubsCopyWith<Clubs> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubsCopyWith<$Res> {
  factory $ClubsCopyWith(Clubs value, $Res Function(Clubs) then) =
      _$ClubsCopyWithImpl<$Res, Clubs>;
  @useResult
  $Res call({String club, String img});
}

/// @nodoc
class _$ClubsCopyWithImpl<$Res, $Val extends Clubs>
    implements $ClubsCopyWith<$Res> {
  _$ClubsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? club = null,
    Object? img = null,
  }) {
    return _then(_value.copyWith(
      club: null == club
          ? _value.club
          : club // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubsImplCopyWith<$Res> implements $ClubsCopyWith<$Res> {
  factory _$$ClubsImplCopyWith(
          _$ClubsImpl value, $Res Function(_$ClubsImpl) then) =
      __$$ClubsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String club, String img});
}

/// @nodoc
class __$$ClubsImplCopyWithImpl<$Res>
    extends _$ClubsCopyWithImpl<$Res, _$ClubsImpl>
    implements _$$ClubsImplCopyWith<$Res> {
  __$$ClubsImplCopyWithImpl(
      _$ClubsImpl _value, $Res Function(_$ClubsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? club = null,
    Object? img = null,
  }) {
    return _then(_$ClubsImpl(
      club: null == club
          ? _value.club
          : club // ignore: cast_nullable_to_non_nullable
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
class _$ClubsImpl implements _Clubs {
  _$ClubsImpl({required this.club, required this.img});

  factory _$ClubsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubsImplFromJson(json);

  @override
  final String club;
  @override
  final String img;

  @override
  String toString() {
    return 'Clubs(club: $club, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubsImpl &&
            (identical(other.club, club) || other.club == club) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, club, img);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubsImplCopyWith<_$ClubsImpl> get copyWith =>
      __$$ClubsImplCopyWithImpl<_$ClubsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubsImplToJson(
      this,
    );
  }
}

abstract class _Clubs implements Clubs {
  factory _Clubs({required final String club, required final String img}) =
      _$ClubsImpl;

  factory _Clubs.fromJson(Map<String, dynamic> json) = _$ClubsImpl.fromJson;

  @override
  String get club;
  @override
  String get img;
  @override
  @JsonKey(ignore: true)
  _$$ClubsImplCopyWith<_$ClubsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
