import 'package:freezed_annotation/freezed_annotation.dart';

part 'leagues.freezed.dart';
part 'leagues.g.dart';

@freezed
class Leagues with _$Leagues {
  factory Leagues ({
    required String league,
    required String img
  }) = _Leagues;

  factory Leagues.fromJson(Map<String, dynamic> json) => _$LeaguesFromJson(json);
}