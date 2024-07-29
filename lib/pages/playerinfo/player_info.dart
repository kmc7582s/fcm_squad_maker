import 'dart:async';

import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  DatabaseReference _rateRef = FirebaseDatabase.instance.ref('player');
  StreamSubscription<DatabaseEvent>? _userSubscription;
  StreamSubscription<DatabaseEvent>? _totalSubscription;
  int _likeCount = 0;
  bool _isLiked = false;
  String _uid = '';
  String _nickname = '';
  String _profileImg = '';
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _initUser();
    _fetchUserData();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _totalSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initUser() async {
    User? user = _auth.currentUser;

    setState(() {
      _uid = user!.uid;
    });

    _userSubscription = likeRef.child(player.id.toString()).child('likes').child('users').child(_uid).onValue.listen((event) {
      final dynamic data = event.snapshot.value;
      if (mounted) {
        setState(() {
          _isLiked = data != null ? data['isLiked'] : false;
        });
      }
    });

    _totalSubscription = likeRef.child(player.id.toString()).child('likes').child('total').onValue.listen((event) {
      final dynamic data = event.snapshot.value;
      if (mounted) {
        setState(() {
          _likeCount = data ?? 0;
        });
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      likeRef.child(player.id.toString()).child('likes').child('users').child(_uid).set({
        'isLiked' : _isLiked,
      });

      likeRef.child(player.id.toString()).child('likes').child('total').set(ServerValue.increment(_isLiked ? 1 : -1));
    });
  }

  Future<void> _fetchUserData() async {
    final _userUpdateRef = FirebaseDatabase.instance.ref().child('users');
    final DatabaseReference _database = _userUpdateRef.child(_uid);

    _database.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _nickname = data['nickname'] ?? 'Unknown';
          _profileImg = data['profile_img'] ?? 'Unknown';
        });
      }
    });
  }

  Future<void> _updateRate(double rate) async {
    _rateRef.child(player.id.toString()).child('rating').child('users').child(_uid).set({
      'nickname' : _nickname,
      'profile_img' : _profileImg,
      'rate' : rate,
    });
  }

  Future<void> _RateDialog(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("선수 평가"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  updateOnDrag: true,
                  itemSize: 30,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _updateRate(_rating);
                  Navigator.of(context).pop();
                },
                child: Text("제출"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text("취소"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그아웃 오류"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
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
                color: Colors.grey.shade100,
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
                color: Colors.grey.shade100,
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
            Padding(
              padding: EdgeInsets.only(top:12.0, left: 16.0),
              child: Row(
                children: [
                  Text("선수 평가",style: CustomTextStyle.settingTitle,),
                  TextButton(onPressed: () => _RateDialog(context), child: Text("선수 평가하기")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: StreamBuilder<DatabaseEvent>(
                          stream: _rateRef.child(player.id.toString()).child('rating').child('users').onValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                              return Center(child: Text('No rating data'));
                            }

                            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
                            List<Map<String, dynamic>> ratings = [];
                            data.forEach((key, value) => ratings.add({
                              "rate": value["rate"] is double ? value["rate"] : (value["rate"] as num?)?.toDouble() ?? 0.0,
                              "nickname": value["nickname"] ?? 'Unknown',
                              "profile_img": value["profile_img"] ?? '',
                            }));

                            // 평균 레이팅 계산
                            double averageRating = 0;
                            if (ratings.isNotEmpty) {
                              double totalRating = ratings.map((rating) => rating["rate"] as double).reduce((a, b) => a + b);
                              averageRating = totalRating / ratings.length;
                            }
                            print(ratings);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RatingBarIndicator(
                                        rating: averageRating,
                                        itemBuilder: (context, index) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Text("평균 : $averageRating"),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: ratings.length,
                                    itemBuilder: (context, index) {
                                      final rating = ratings[index];
                                      final nickname = rating["nickname"];
                                      final profile_img = rating['profile_img'];
                                      final rate = rating["rate"];
                                  
                                      return ListTile(
                                        leading: CircleAvatar(backgroundImage: NetworkImage(profile_img), radius: 18,),
                                        title: Text(nickname),
                                        subtitle: Text('rating: $rate'),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
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


