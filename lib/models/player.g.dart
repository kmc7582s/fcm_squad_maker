// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nation: json['nation'] as String,
      club: json['club'] as String,
      position: json['position'] as String,
      grade: json['grade'] as String,
      overall: (json['overall'] as num).toInt(),
      pace: (json['pace'] as num).toInt(),
      shooting: (json['shooting'] as num).toInt(),
      passing: (json['passing'] as num).toInt(),
      agility: (json['agility'] as num).toInt(),
      defending: (json['defending'] as num).toInt(),
      physical: (json['physical'] as num).toInt(),
      l_foot: (json['l_foot'] as num).toInt(),
      r_foot: (json['r_foot'] as num).toInt(),
      likes: json['likes'] ?? const {},
      img: json['img'] as String? ?? '',
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nation': instance.nation,
      'club': instance.club,
      'position': instance.position,
      'grade': instance.grade,
      'overall': instance.overall,
      'pace': instance.pace,
      'shooting': instance.shooting,
      'passing': instance.passing,
      'agility': instance.agility,
      'defending': instance.defending,
      'physical': instance.physical,
      'l_foot': instance.l_foot,
      'r_foot': instance.r_foot,
      'likes': instance.likes,
      'img': instance.img,
    };
