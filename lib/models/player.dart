import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  factory Player({
    required int id,
    required String name,
    required String nation,
    required String club,
    required String position,
    required String grade,
    required int overall,
    required int pace,
    required int shooting,
    required int passing,
    required int agility,
    required int defending,
    required int physical,
    required int l_foot,
    required int r_foot,
    @Default({}) dynamic likes,
    @Default('') String img,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

