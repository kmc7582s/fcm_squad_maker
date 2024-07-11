// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leagues.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Leagues _$LeaguesFromJson(Map<String, dynamic> json) {
  return _Leagues.fromJson(json);
}

/// @nodoc
mixin _$Leagues {
  String get league => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeaguesCopyWith<Leagues> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaguesCopyWith<$Res> {
  factory $LeaguesCopyWith(Leagues value, $Res Function(Leagues) then) =
      _$LeaguesCopyWithImpl<$Res, Leagues>;
  @useResult
  $Res call({String league, String img});
}

/// @nodoc
class _$LeaguesCopyWithImpl<$Res, $Val extends Leagues>
    implements $LeaguesCopyWith<$Res> {
  _$LeaguesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? league = null,
    Object? img = null,
  }) {
    return _then(_value.copyWith(
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaguesImplCopyWith<$Res> implements $LeaguesCopyWith<$Res> {
  factory _$$LeaguesImplCopyWith(
          _$LeaguesImpl value, $Res Function(_$LeaguesImpl) then) =
      __$$LeaguesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String league, String img});
}

/// @nodoc
class __$$LeaguesImplCopyWithImpl<$Res>
    extends _$LeaguesCopyWithImpl<$Res, _$LeaguesImpl>
    implements _$$LeaguesImplCopyWith<$Res> {
  __$$LeaguesImplCopyWithImpl(
      _$LeaguesImpl _value, $Res Function(_$LeaguesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? league = null,
    Object? img = null,
  }) {
    return _then(_$LeaguesImpl(
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
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
class _$LeaguesImpl implements _Leagues {
  _$LeaguesImpl({required this.league, required this.img});

  factory _$LeaguesImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaguesImplFromJson(json);

  @override
  final String league;
  @override
  final String img;

  @override
  String toString() {
    return 'Leagues(league: $league, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaguesImpl &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, league, img);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaguesImplCopyWith<_$LeaguesImpl> get copyWith =>
      __$$LeaguesImplCopyWithImpl<_$LeaguesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaguesImplToJson(
      this,
    );
  }
}

abstract class _Leagues implements Leagues {
  factory _Leagues({required final String league, required final String img}) =
      _$LeaguesImpl;

  factory _Leagues.fromJson(Map<String, dynamic> json) = _$LeaguesImpl.fromJson;

  @override
  String get league;
  @override
  String get img;
  @override
  @JsonKey(ignore: true)
  _$$LeaguesImplCopyWith<_$LeaguesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
