import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/models/class/class.dart';
import 'package:fcmobile_squad_maker/models/club/clubs.dart';
import 'package:fcmobile_squad_maker/models/flag/flags.dart';
import 'package:fcmobile_squad_maker/widgets/player_profile.dart';
import 'package:flutter/material.dart';

class PlayerVersus extends StatelessWidget {
  final dynamic players;
  final dynamic flags;
  final dynamic grade;
  final dynamic clubs;

  const PlayerVersus({super.key, required this.players, this.flags, this.grade, this.clubs});

  String? getFlagUrl(String nation) {
    for (var flag in flags) {
      if (flag.nation == nation) {
        return flag.img;
      }
    }
    return null; // 국기를 찾지 못한 경우
  }

  String? getClassUrl(String p_class) {
    for (var grade in grade) {
      if (grade.grade == p_class) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("선수비교"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFbdc3c7),
              Color(0xFF000C40),
            ]
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayerProfile(n: 0, players: players, flags: flags, grade: grade, clubs: clubs),
                Container(
                  height: 300,
                    child: Row(
                      children: [
                        VerticalDivider(thickness: 1,color: Colors.black),
                      ],
                    )
                ),
                PlayerProfile(n: 1, players: players, flags: flags, grade: grade, clubs: clubs),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 28.0,
                  columns: [
                    DataColumn(label: Text(players[0].name)),
                    DataColumn(label: Text("선수명")),
                    DataColumn(label: Text(players[1].name)),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(players[0].pace.toString())),
                        DataCell(Text("페이스")),
                        DataCell(Text(players[1].pace.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(players[0].shooting.toString())),
                        DataCell(Text("슈팅")),
                        DataCell(Text(players[1].shooting.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(players[0].passing.toString())),
                        DataCell(Text("패스")),
                        DataCell(Text(players[1].passing.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(players[0].agility.toString())),
                        DataCell(Text("민첩성")),
                        DataCell(Text(players[1].agility.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(players[0].defending.toString())),
                        DataCell(Text("수비")),
                        DataCell(Text(players[1].defending.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(players[0].physical.toString())),
                        DataCell(Text("피지컬")),
                        DataCell(Text(players[1].physical.toString())),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
