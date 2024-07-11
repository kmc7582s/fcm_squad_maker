import 'package:freezed_annotation/freezed_annotation.dart';

part 'clubs.freezed.dart';
part 'clubs.g.dart';

@freezed
class Clubs with _$Clubs {
  factory Clubs ({
    required String club,
    required String img
  }) = _Clubs;

  factory Clubs.fromJson(Map<String, dynamic> json) => _$ClubsFromJson(json);
}