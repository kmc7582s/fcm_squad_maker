import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:flutter/material.dart';

class PlayerProfile extends StatelessWidget {
  final int n;
  final dynamic players;
  final dynamic flags;
  final dynamic grade;
  final dynamic clubs;

  const PlayerProfile({super.key, required this.n, required this.players, required this.flags, required this.grade, required this.clubs});

  String? getFlagUrl(String nation) {
    for (var flag in flags) {
      if (flag.nation == nation) {
        return flag.img;
      }
    }
    return null; // 국기를 찾지 못한 경우
  }

  String? getClassUrl(String pClass) {
    for (var grade in grade) {
      if (grade.grade == pClass) {
        return grade.img;
      }
    }
    return null;
  }

  String? getClubUrl(String club) {
    for (var clubs in clubs) {
      if (clubs.club == club) {
        return clubs.img;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              getClassUrl(players[n].grade).toString(),
              width: 140,
              height: 140,
            ),
            Image.network(
              players[n].img,
              width: 140,
              height: 140,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               Text(players[n].grade,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
              Text(
                players[n].name,
                style: Fonts.player,
              ),
              Row(
                children: [
                  Text("${players[n].position} ${players[n].overall}", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: positionColor(players[n].position.toString()))),
                  const SizedBox(width: 20,),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red
                        ),
                        child: Text(players[n].l_foot.toString()),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Container(
                          alignment: Alignment.center,
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue
                          ),
                          child: const Text("L",style: TextStyle(fontSize: 7),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red
                        ),
                        child: Text(players[n].r_foot.toString()),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Container(
                          alignment: Alignment.center,
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue
                          ),
                          child: const Text("R",style: TextStyle(fontSize: 7),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Image.network(getFlagUrl(players[n].nation).toString(),width: 30,height: 30),
            Text(" ${players[n].nation}")
          ],
        ),
        Row(
          children: [
            Image.network(getClubUrl(players[n].club).toString(),width: 30,height: 30),
            Text(" ${players[n].club}")
          ],
        ),
      ],
    );
  }
}
