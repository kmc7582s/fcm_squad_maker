import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/pages/playerinfo/player_info.dart';
import 'package:flutter/material.dart';

Widget PlayerList(String classUrl, String flagUrl, String clubUrl, dynamic player, BuildContext context) {
  if (player == null || flagUrl == null || clubUrl == null) {
    return Container(child: Text("error"),); // 또는 적절한 대체 위젯
  }

  return ListTile(
    leading: classUrl != null
        ? Stack(
      alignment: Alignment.center,
      children: [
        Image.network(
          classUrl,
          width: 60,
          height: 60,
        ),
        Image.network(
          player.img,
          width: 50,
          height: 50,
        )
      ],
    )
        : null,
    title: Text(player.name, style: CustomTextStyle.playersTitle, overflow: TextOverflow.fade,maxLines: 1,),
    subtitle: Row(
      children: [
        Image.network(flagUrl.toString(),width: 30,height: 30,),
        Text(" "+player.nation,overflow: TextOverflow.fade ,maxLines: 1)
      ],
    ),
    trailing: Text(
      player.position+"  "+player.overall.toString(),
      style: TextStyle(
        fontFamily: "Pretendard",
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: positionColor(player.position.toString()),
      ),
    ),
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PlayerDetailPage(player: player, flagUrl: flagUrl, classUrl: classUrl, clubUrl: clubUrl)));
    },
  );
}