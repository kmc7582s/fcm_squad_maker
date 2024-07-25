import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/models/class/class.dart';
import 'package:fcmobile_squad_maker/models/player.dart';
import 'package:fcmobile_squad_maker/pages/squadmaker/search_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../config/assets.dart';

class SquadMakerPage extends StatefulWidget {
  final dynamic player;
  final String squadId;

  const SquadMakerPage({super.key, required this.player, required this.squadId});

  @override
  State<SquadMakerPage> createState() => _SquadMakerPageState(player: player, squadId: squadId);
}

class _SquadMakerPageState extends State<SquadMakerPage> with SingleTickerProviderStateMixin {
  _SquadMakerPageState({required this.player, required this.squadId});

  final String squadId;
  final dynamic player;
  List<List<dynamic>> formation = [];
  final _auth = FirebaseAuth.instance;
  String? formationString;
  int? lastRowIdx;
  int? lastColIdx;

  @override
  void initState () {
    super.initState();
    _loadClass();
    _fetchFormation();
  }

  void setFormation(String formationString) {
    List<String> positions = formationString.split('-');

    int fwCount = int.parse(positions[0]);
    int mfCount = int.parse(positions[1]);
    int dfCount = int.parse(positions[2]);

    List<List<dynamic>> newFormation = [
      List.filled(dfCount, null),
      List.filled(mfCount, null),
      List.filled(fwCount, null),
      [null], // Goalkeeper position
    ];

    setState(() {
      this.formationString = formationString;
      formation = newFormation;
    });
  }

  Future<void> _navigateAndAddPlayer(BuildContext context, int rowIdx, int colIdx) async {
    final Player? player = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Search()));
    bool isDuplicate = formation.any((row) => row.contains(player));
    if (isDuplicate) {
      if (lastRowIdx != null && lastColIdx != null) {
        setState(() {
          formation[lastRowIdx!][lastColIdx!] = player;
        });
      }
    } else {
      setState(() {
        formation[rowIdx][colIdx] = player;
      });
    }
  }

  Future<void> _fetchFormation() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference formationRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('squads')
          .child(squadId)
          .child('formation');

      formationRef.once().then((event) {
        if (event.snapshot.exists) {
          String? formationString = event.snapshot.value as String?;
          if (formationString != null) {
            setFormation("${formationString}");
          }
        }
      }).catchError((error) {
        print('Error fetching formation: $error');
      });

      print(formationString);
    }
  }

  // 선수 클래스 바탕 불러오기
  List<Class> grade = [];

  Future<void> _loadClass() async {
    final snapshot = await FirebaseDatabase.instance.ref('class_img').get();
    if (snapshot.exists) {
      final classList = snapshot.value as List<dynamic>;
      setState(() {
        grade = classList
            .map((classJson) =>
            Class.fromJson(Map<String, dynamic>.from(classJson)))
            .toList();
      });
    }
  }

  String getClassUrl(String p_class) {
    for (var grade in grade) {
      if (grade.grade == p_class) {
        return grade.img;
      }
    }
    return '';
  }

  // 파이어베이스 데이터 저장
  Future<void> Squad() async {
    User? user = _auth.currentUser;
    dynamic _formation = formation;
    if (user != null) {
      setState(() {
        DatabaseReference database = FirebaseDatabase.instance.ref('users').child(user.uid).child('squads').child(squadId);
        database.update({
          'average_ovr' : 1,
          'player' : {_formation},
        });
      });
    }
    print(formation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {
            Squad(),
            Navigator.pop(context)
          },
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text("스쿼드 메이커"),
        centerTitle: false,
        actions: [
          IconButton(
              icon:Icon(Icons.save),
              onPressed: () {
                print(player);
                print(formation);
                Squad();
              }
          ),
          IconButton(icon:Icon(Icons.menu),onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '포메이션 : $formationString',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "평균 Overall",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Image.asset(
                          field,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: formation.asMap().entries.map((entry) {
                            int rowIdx = entry.key;
                            List<dynamic> line = entry.value;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: line.asMap().entries.map((entry) {
                                int colIdx = entry.key;
                                dynamic player = entry.value;
                                return _buildPlayerIcon(player, rowIdx, colIdx);
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ]
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerIcon(dynamic player, int rowIdx, int colIdx) {
    return Column(
      children: [
        player != null && player.position != null ? Text(player.position, style: TextStyle(color: positionColor(player.position), fontFamily: "Pretendard", fontSize: 15, fontWeight: FontWeight.w600)) : Text(""),
        InkWell(
          child: player != null && player.img != null ?
          Stack(
            alignment: Alignment.center,
            children:
            [
              Image.network(getClassUrl(player.grade), width: 70,height: 70,),
              Image.network(player.img, width: 70,height: 70,),
            ],
          )
              : Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Palette.basepl,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.add),
            ),
          ),
          onTap: () {
            _navigateAndAddPlayer(context, rowIdx, colIdx);
            print(formation);
          }
        ),
        Text(player != null ? player.name : "player", style: CustomTextStyle.playerName,),
      ],
    );
  }
}
