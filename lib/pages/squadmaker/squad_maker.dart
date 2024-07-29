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
  final String squadId;

  const SquadMakerPage({super.key, required this.squadId});

  @override
  State<SquadMakerPage> createState() => _SquadMakerPageState(squadId: squadId);
}

class _SquadMakerPageState extends State<SquadMakerPage> with SingleTickerProviderStateMixin {
  _SquadMakerPageState({required this.squadId});

  final String squadId;
  List<List<dynamic>> formation = [];
  final _auth = FirebaseAuth.instance;
  String? formationString;
  int? lastRowIdx;
  int? lastColIdx;

  final List<String> fw_2 = ['ST', 'ST'];
  final List<String> fw_3 = ['LW', 'ST', 'RW'];
  final List<String> fw_4 = ['LW', 'ST', 'ST', 'RW'];

  final List<String> mf_2 = ['CM', 'CM'];
  final List<String> mf_3 = ['CM', 'CM', 'CM'];
  final List<String> mf_4 = ['LM', 'CM', 'CM', 'RM'];
  final List<String> mf_5 = ['LM', 'CDM', 'CDM', 'CM', 'RM'];

  final List<String> df_3 = ['CB', 'CB', "CB"];
  final List<String> df_4 = ['LB', 'CB', "CB", "RB"];
  final List<String> df_5 = ['LWB', 'CB', "CB", "CB", "RWB"];

  String? selectedOption;
  String selectedFormation = '3back';
  final List<String> categories = ['3back', '4back', '5back'];
  final Map<String, List<String>> formationList = {
    '3back': ['3-4-3','3-5-2'],
    '4back': ['4-2-4', '4-3-3', '4-4-2'],
    '5back': ['5-3-2']
  };

  @override
  void initState () {
    super.initState();
    _loadClass();
    _fetchFormation();
    _loadPlayers();
    selectedOption = formationList[selectedFormation]!.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 선수 데이터 호출
  List<Player> players = [];

  Future<void> _loadPlayers() async {
    final snapshot = await FirebaseDatabase.instance.ref('player').get();
    if (snapshot.exists) {
      final playerList = snapshot.value as List<dynamic>;
      setState(() {
        players = playerList
            .map((playerJson) =>
            Player.fromJson(Map<String, dynamic>.from(playerJson)))
            .toList();
      });
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

    if (formation.isNotEmpty) {
      for (int i = 0; i < newFormation.length; i++) {
        for (int j = 0; j < newFormation[i].length; j++) {
          if (i < formation.length && j < formation[i].length) {
            newFormation[i][j] = formation[i][j] ?? newFormation[i][j];
          }
        }
      }
    }
  }

  Future<void> _navigateAndAddPlayer(BuildContext context, int rowIdx, int colIdx) async {
    final selectedPlayer = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Search()));

    if (selectedPlayer != null) {
      // Fetch player details from Firebase
      final playerId = selectedPlayer;
      Player playerInfo = players[playerId];

      bool isDuplicate = formation.any((row) => row.contains(playerInfo));

      // Add player to the formation
      setState(() {
        if (isDuplicate) {
          if (lastRowIdx != null && lastColIdx != null) {
            formation[lastRowIdx!][lastColIdx!] = playerInfo;
          }
        } else {
          formation[rowIdx][colIdx] = playerInfo;
        }
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
          .child(squadId);

      try {
        // 포메이션 문자열 가져오기
        final formationSnapshot = await formationRef.child('formation').once();
        if (formationSnapshot.snapshot.exists) {
          String? formationString = formationSnapshot.snapshot.value as String?;
          if (formationString != null) {
            setFormation(formationString); // 기존 포메이션 유지
          }
        }

        // 선수 데이터 가져오기
        final squadSnapshot = await formationRef.child('squad').once();
        if (squadSnapshot.snapshot.exists) {
          Map<dynamic, dynamic> data = squadSnapshot.snapshot.value as Map<dynamic, dynamic>;

          List<dynamic> playerData = data['player'] as List<dynamic>;

          final newFormation = formation.asMap().entries.map((entry) {
            int rowIdx = entry.key;
            List<dynamic> row = playerData.length > rowIdx ? playerData[rowIdx] as List<dynamic>? ?? [] : [];

            return row.asMap().entries.map((rowEntry) {
              int colIdx = rowEntry.key;
              dynamic item = rowEntry.value;

              if (item is Map) {
                return Player?.fromJson(Map<String, dynamic>.from(item));
              }
              return null;
            }).toList();
          }).toList();

          setState(() {
            formation = newFormation; // 데이터 업데이트
          });

        } else {
          // squad 데이터가 없을 경우 기존 데이터 유지
          setState(() {
            formation = formation.map((row) => row.map((item) => item).toList()).toList();
          });
        }
      } catch (error) {
        print('Failed to fetch formation: $error');
      }
    }
  }

  // 스쿼드 저장
  Future<void> saveFormation(List<List<dynamic>> formation) async {
    User? user = _auth.currentUser;
    // 변환된 JSON 형태로 저장하기
    final formationJson = formation.map((row) {
      return row.map((item) {
        if (item is Player) {
          return item.toJson();
        }
        return item;
      }).toList();
    }).toList();

    // Firebase 데이터베이스 참조
    DatabaseReference formationRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user!.uid)
        .child('squads')
        .child(squadId);

    // Firebase에 저장
    await formationRef.child('squad').set({
      'player' : formationJson,
    }).then((_) {
      print('Formation saved successfully');
    }).catchError((error) {
      print('Failed to save formation: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async => {
            await saveFormation(formation),
            Navigator.pop(context, true)
          },
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text("스쿼드 메이커"),
        centerTitle: false,
        actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Text("포메이션 변경"),
                    onTap: _changeFormation
                ),
              ],
              icon: Icon(Icons.menu),
            )
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
                const Padding(
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

  _changeFormation() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('포메이션 변경'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          value: selectedOption,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              selectedOption = newValue;
                              print(selectedOption);
                            });
                          },
                          items: formationList[selectedFormation]!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: categories.map((String category) {
                  return RadioListTile<String>(
                      title: Text(category),
                      value: category,
                      groupValue: selectedFormation,
                      onChanged: (dynamic value) {
                        setState(() async {
                          selectedFormation = value;
                          selectedOption = formationList[selectedFormation]!.first;
                        });
                      });
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  Navigator.of(context).pop();
                  setFormation(selectedFormation);
                } catch (e) {
                  print('오류: $e');
                }
              },
              child: const Text('변경'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}