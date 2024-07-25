import 'package:fcmobile_squad_maker/widgets/player_profile.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class PlayerVersus extends StatelessWidget {
  final dynamic players;
  final dynamic flags;
  final dynamic grade;
  final dynamic clubs;

  const PlayerVersus({super.key, required this.players, this.flags, this.grade, this.clubs});

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
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayerProfile(n: 0, players: players, flags: flags, grade: grade, clubs: clubs),
                Center(
                  child: Container(
                    height: 300,
                      child: Row(
                        children: [
                          VerticalDivider(thickness: 1,color: Colors.black),
                        ],
                      )
                  ),
                ),
                PlayerProfile(n: 1, players: players, flags: flags, grade: grade, clubs: clubs),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width-35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 28.0,
                  columns: [
                    DataColumn(label: Center(child: animated_text(" "+players[0].name))),
                    DataColumn(label: Center(child: Text("선수명"))),
                    DataColumn(label: Center(child: animated_text(" "+players[1].name))),
                  ],
                  rows: [
                    dataRow(players[0].pace, "페이스", players[1].pace),
                    dataRow(players[0].shooting, "슈팅", players[1].shooting),
                    dataRow(players[0].passing, "패스", players[1].passing),
                    dataRow(players[0].agility, "민첩성", players[1].agility),
                    dataRow(players[0].defending, "수비", players[1].defending),
                    dataRow(players[0].physical, "피지컬", players[1].physical),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget animated_text(String text) {
    return Container(
      width: 90,
      child: Marquee(
        text: text,
        velocity: 50.0,
        blankSpace: 50,
        startPadding: 4.0,
        pauseAfterRound: Duration(milliseconds: 2000),
        accelerationDuration: Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }

  DataRow dataRow(int stat1, String stat_name, int stat2) {
    return DataRow(
      cells: [
        DataCell(
            (stat1 > stat2) ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("+${(stat1-stat2).toString()}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                Text(stat1.toString()),
              ],
            ) : Center(child: Text(stat1.toString())),
        ),
        DataCell(Center(child: Text(stat_name))),
        DataCell(
          (stat2 > stat1) ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(stat2.toString()),
              Text("+${(stat2-stat1).toString()}",style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ) : Center(child: Text(stat2.toString())),
        ),
      ],
    );
  }
}
