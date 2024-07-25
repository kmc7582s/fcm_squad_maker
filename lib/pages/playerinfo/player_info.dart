import 'dart:async';

import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class PlayerDetailPage extends StatefulWidget {
  final dynamic player;
  final dynamic flagUrl;
  final dynamic classUrl;
  final dynamic clubUrl;

  const PlayerDetailPage(
      {required this.player,
      required this.flagUrl,
      required this.classUrl,
      required this.clubUrl,
      Key? key})
      : super(key: key);

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState(
      player: player, flagUrl: flagUrl, classUrl: classUrl, clubUrl: clubUrl);
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  final dynamic player;
  final dynamic flagUrl;
  final dynamic classUrl;
  final dynamic clubUrl;

  _PlayerDetailPageState(
      {required this.player,
        required this.flagUrl,
        required this.classUrl,
        required this.clubUrl,
      });


  List<int> enforce = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> evolution = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> stat_title = ['페이스', '슈팅', '패스', '민첩성', '수비', '피지컬'];
  List<List<int>> test = [[0, 0], [1, 3], [2, 6], [3, 10], [4, 14], [5, 18], [6, 24], [7, 31], [8, 39], [9, 48], [10, 60]];
  int _enforce = 0;
  int _evolution = 0;
  int _increase = 0;

  //좋아요 기능
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference likeRef = FirebaseDatabase.instance.ref('player');
  StreamSubscription<DatabaseEvent>? _userSubscription;
  StreamSubscription<DatabaseEvent>? _totalSubscription;
  int _likeCount = 0;
  bool _isLiked = false;
  String _uid = '';

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    User? user = _auth.currentUser;

    setState(() {
      _uid = user!.uid;
    });

    for (int i=0; i<=53; i++) {
      if (player.id == i) {
        _userSubscription = likeRef.child('$i').child('likes').child('users').child(_uid).onValue.listen((event) {
          final dynamic data = event.snapshot.value;
          if (mounted) {
            setState(() {
              _isLiked = data != null ? data['isLiked'] : false;
            });
          }
        });

        _totalSubscription = likeRef.child('$i').child('likes').child('total').onValue.listen((event) {
          final dynamic data = event.snapshot.value;
          if (mounted) {
            setState(() {
              _likeCount = data ?? 0;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _totalSubscription?.cancel();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      for (int i=0; i<=53; i++) {
        if (player.id == i) {
          likeRef.child('$i').child('likes').child('users').child(_uid).set({
            'isLiked' : _isLiked,
          });
        }
        if (player.id == i) {
          likeRef.child('$i').child('likes').child('total').set(ServerValue.increment(_isLiked ? 1 : -1));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name, style: CustomTextStyle.appbarTitle,),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        actions: [
          IconButton(
            onPressed: _toggleLike,
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : null,),
          ),
          Text("$_likeCount"),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 10),
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
                    style: CustomTextStyle.gradeTitle
                  ),
                  Text(
                    player.name,
                    style: CustomTextStyle.playerTitle
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
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    player.position +
                        " " +
                        (player.overall + _enforce + _increase).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: positionColor(player.position)),
                  ),
                  Text("foot (L:${player.l_foot} R:${player.r_foot})"),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                    value: _enforce,
                    items: enforce
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text("강화 $e"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _enforce = value!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: _evolution,
                    items: test
                        .map((e) => DropdownMenuItem(
                              value: e[0],
                              child: Text("진화 ${e[0]}"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _evolution = value!;
                        if (player.overall >= 110) {
                          _increase = test[_evolution][1];
                        } else {
                          _increase = test[_evolution][1] - test[_evolution][0];
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PlayerStatGauge(player.pace + _enforce + _increase,
                          stat_title[0].toString()),
                      PlayerStatGauge(player.shooting + _enforce + _increase,
                          stat_title[1].toString()),
                      PlayerStatGauge(player.passing + _enforce + _increase,
                          stat_title[2].toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PlayerStatGauge(player.agility + _enforce + _increase,
                          stat_title[3].toString()),
                      PlayerStatGauge(player.defending + _enforce + _increase,
                          stat_title[4].toString()),
                      PlayerStatGauge(player.physical + _enforce + _increase,
                          stat_title[5].toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget PlayerStatGauge(int stat, String stat_title) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: AnimatedRadialGauge(
            builder: (context, child, value) => RadialGaugeLabel(
              value: stat.toDouble(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            duration: const Duration(milliseconds: 700),
            radius: 100,
            value: stat.toDouble(),
            alignment: Alignment.center,
            axis: const GaugeAxis(
              min: 0,
              max: 310,
              degrees: 240,
              style: GaugeAxisStyle(
                thickness: 10,
                segmentSpacing: 8,
              ),
              pointer: GaugePointer.circle(
                radius: 7,
                color: Colors.orange,
              ),
              progressBar: GaugeProgressBar.rounded(
                gradient: GaugeAxisGradient(colors: [Colors.yellow,Colors.orange]),
              ),
              segments: [
                GaugeSegment(
                  from: 0,
                  to: 103.3,
                  color: Color(0xFFD9DEEB),
                  cornerRadius: Radius.circular(15),
                ),
                GaugeSegment(
                  from: 103.3,
                  to: 206.6,
                  color: Color(0xFFD9DEEB),
                  cornerRadius: Radius.circular(15),
                ),
                GaugeSegment(
                  from: 206.6,
                  to: 310,
                  color: Color(0xFFD9DEEB),
                  cornerRadius: Radius.circular(15),
                ),
              ],
            ),
          ),
        ),
        Text(
          stat_title,
          style: CustomTextStyle.statLabel,
        ),
      ],
    );
  }
}
