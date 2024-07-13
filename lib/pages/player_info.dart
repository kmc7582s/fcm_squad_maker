import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:fcmobile_squad_maker/widgets/player_stat_gauge.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class PlayerDetailPage extends StatefulWidget {
  final dynamic player;
  final dynamic flagUrl;
  final dynamic classUrl;
  final dynamic clubUrl;

  const PlayerDetailPage({
    required this.player,
    required this.flagUrl,
    required this.classUrl,
    required this.clubUrl,
    Key? key}) : super(key: key);

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState(player: player, flagUrl: flagUrl, classUrl: classUrl, clubUrl: clubUrl);
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  final dynamic player;
  final dynamic flagUrl;
  final dynamic classUrl;
  final dynamic clubUrl;
  List<int> enforce = [0,1,2,3,4,5,6,7,8,9,10];
  List<int> evolution = [0,1,2,3,4,5,6,7,8,9,10];
  int _enforce = 0;
  int _evolution = 0;

  _PlayerDetailPageState({
    required this.player,
    required this.flagUrl,
    required this.classUrl,
    required this.clubUrl
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 10, right: 10,bottom: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(classUrl, width: 120, height: 120),
                      Image.network(player.img, width: 120, height: 120),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.grade,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      player.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Image.network(flagUrl, width: 30),
                        Text(" " + player.nation),
                      ],
                    ),
                    Row(
                      children: [
                        Image.network(clubUrl, width: 30),
                        Text(" " + player.club),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20,),
                    Text(player.position+" "+player.overall.toString()),
                    Text("foot (L:"+player.l_foot.toString()+" R:"+player.r_foot.toString()+")"),
                    SizedBox(height: 20,),
                    DropdownButton(
                      value: _enforce,
                      items: enforce.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("강화 $e"),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _enforce = value!;
                        });
                      },
                    ),
                    DropdownButton(
                      value: _evolution,
                      items: evolution.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("진화 $e"),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _evolution = value!;
                        });
                      },
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                shadowColor: Colors.black,
                color: Colors.grey.shade300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PlayerStatGauge(stat: player.pace),
                        PlayerStatGauge(stat: player.shooting),
                        PlayerStatGauge(stat: player.passing),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PlayerStatGauge(stat: player.agility),
                        PlayerStatGauge(stat: player.defending),
                        PlayerStatGauge(stat: player.physical),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
