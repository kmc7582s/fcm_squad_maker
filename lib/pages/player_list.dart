import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/models/club/clubs.dart';
import 'package:fcmobile_squad_maker/pages/player_info.dart';
import 'package:fcmobile_squad_maker/pages/player_versus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fcmobile_squad_maker/models/player.dart';
import 'package:fcmobile_squad_maker/models/class/class.dart';
import '../config/assets.dart';
import '../models/flag/flags.dart';
import '../models/league/leagues.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  List<Player> players = [];
  List<Class> grade = [];
  List<Leagues> leagues = [];
  List<Clubs> clubs = [];
  List<Flags> flags = [];
  List<String> stat = ['페이스','슈팅','패스','민첩성','수비','피지컬'];
  List<String> fw = ['ST','LW','RW','LF','RF','CF'];
  List<String> mf = ['CAM','LM','CM','RM','CDM'];
  List<String> df = ['LWB','LB','CB','RB','RWB'];
  List<String> gk = ['GK'];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
    _loadClass();
    _loadClubs();
    _loadFlags();
    _loadLeagues();
  }

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

  Future<void> _loadLeagues() async {
    final snapshot = await FirebaseDatabase.instance.ref('leagues_img').get();
    if (snapshot.exists) {
      final leagueList = snapshot.value as List<dynamic>;
      setState(() {
        leagues = leagueList
            .map((leagueJson) =>
                Leagues.fromJson(Map<String, dynamic>.from(leagueJson)))
            .toList();
      });
    }
  }

  Future<void> _loadClubs() async {
    final snapshot = await FirebaseDatabase.instance.ref('clubs_img').get();
    if (snapshot.exists) {
      final clubList = snapshot.value as List<dynamic>;
      setState(() {
        clubs = clubList
            .map((clubJson) =>
                Clubs.fromJson(Map<String, dynamic>.from(clubJson)))
            .toList();
      });
    }
  }

  Future<void> _loadFlags() async {
    final snapshot = await FirebaseDatabase.instance.ref('flags_img').get();
    if (snapshot.exists) {
      final flagList = snapshot.value as List<dynamic>;
      setState(() {
        flags = flagList
            .map((flagJson) =>
                Flags.fromJson(Map<String, dynamic>.from(flagJson)))
            .toList();
      });
    }
  }

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

  //선수비교 기능
  dynamic selectedPlayers = [];

  bool isVisible = false;

  void _onChanged(dynamic value) {
    setState(() {
      if (selectedPlayers.contains(value)) {
        selectedPlayers.remove(value);
      } else if (selectedPlayers.length < 2) {
        selectedPlayers.add(value);
      }
    });
  }

  void _navigateAndDisplayPlayers(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PlayerVersus(players: selectedPlayers, flags: flags, grade: grade, clubs: clubs)));
    if (mounted) {
      setState(() {
        selectedPlayers = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("선수 정보"),
        centerTitle: false,
        actions: [
          IconButton(
            icon:Icon(IconSrc.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(IconSrc.versus,size: 24,),
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
                selectedPlayers = [];
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  dynamic player = players[index];
                  dynamic flagUrl = getFlagUrl(player.nation);
                  dynamic classUrl = getClassUrl(player.grade);
                  dynamic clubUrl = getClubUrl(player.club);

                  Color positionColor;
                  if (fw.contains(player.position)) {
                    positionColor = Palette.fwColor;
                  } else if (mf.contains(player.position)){
                    positionColor = Palette.mfColor;
                  } else if (df.contains(player.position)) {
                    positionColor = Palette.dfColor;
                  } else if (gk.contains(player.position)) {
                    positionColor = Palette.gkColor;
                  } else {
                    positionColor = Palette.base1;
                  }

                  return Card(
                    child: Row(
                      children: [
                        Visibility(
                          visible: isVisible,
                          child: Radio<Player>(
                            value: player,
                            groupValue: selectedPlayers.contains(player) ? player : null,
                            onChanged: (Player? value) {
                              if (value != null) _onChanged(value);
                              print(selectedPlayers);
                              if (selectedPlayers.length == 2) {
                                _navigateAndDisplayPlayers(context);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
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
                            title: Text(player.name, overflow: TextOverflow.fade,maxLines: 1,),
                            subtitle: Row(
                              children: [
                                Image.network(flagUrl.toString(),width: 30,height: 30,),
                                Text(" "+player.nation,overflow: TextOverflow.fade ,maxLines: 1)
                              ],
                            ),
                            trailing: Container(
                              child: Text(
                                player.position+"  "+player.overall.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: positionColor,
                                ),
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => PlayerDetailPage(player: player, flagUrl: flagUrl, classUrl: classUrl, clubUrl: clubUrl)));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
