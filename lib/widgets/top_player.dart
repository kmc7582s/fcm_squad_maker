import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/models/class/class.dart';
import 'package:fcmobile_squad_maker/models/club/clubs.dart';
import 'package:fcmobile_squad_maker/models/flag/flags.dart';
import 'package:fcmobile_squad_maker/models/league/leagues.dart';
import 'package:fcmobile_squad_maker/models/player.dart';
import 'package:fcmobile_squad_maker/pages/playerinfo/player_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TopPlayersWidget extends StatefulWidget {
  @override
  _TopPlayersWidgetState createState() => _TopPlayersWidgetState();
}

class _TopPlayersWidgetState extends State<TopPlayersWidget> {
  List<Player> topPlayers = [];

  @override
  void initState() {
    super.initState();
    _fetchTopPlayers();
    _loadTopPlayers();
    _loadClubs();
    _loadFlags();
    _loadClass();
  }

  List<Class> grade = [];
  List<Clubs> clubs = [];
  List<Flags> flags = [];

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

  Future<List<Player>> _fetchTopPlayers() async {
    // Firebase에서 선수 데이터를 가져옴
    final snapshot = await FirebaseDatabase.instance.ref('player').get();
    if (snapshot.exists) {
      final playerList = snapshot.value as List<dynamic>;
      List<Player> players = playerList
          .map((playerJson) => Player.fromJson(Map<String, dynamic>.from(playerJson)))
          .toList();

      // 좋아요 수를 기준으로 내림차순 정렬하고 상위 7명 선택
      players.sort((a, b)=>b.likes['total'].compareTo(a.likes['total']));
      return players.take(7).toList();
    }
    return [];
  }


  Future<void> _loadTopPlayers() async {
    List<Player> players = await _fetchTopPlayers();
    setState(() {
      topPlayers = players;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // 높이는 필요한 대로 조절
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: topPlayers.isNotEmpty
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: topPlayers.map((player) => _buildPlayerCard(player)).toList(),
        ),
      )
          : const Center(child: CircularProgressIndicator()), // 로딩 상태 표시
    );
  }

  Widget _buildPlayerCard(Player player) {
    dynamic flagUrl = getFlagUrl(player.nation);
    dynamic classUrl = getClassUrl(player.grade);
    dynamic clubUrl = getClubUrl(player.club);

    return GestureDetector(
      child: Card(
        color: Colors.blue.shade100,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
          width: 100,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red,size: 15,),
                  Text(" ${player.likes['total']}"),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(classUrl, width: 80, height: 80,),
                    Image.network(player.img, width: 80, height: 80,),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(player.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PlayerDetailPage(player: player, flagUrl: flagUrl, classUrl: classUrl, clubUrl: clubUrl))
      ),
    );
  }
}
