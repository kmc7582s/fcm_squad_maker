import 'package:fcmobile_squad_maker/models/class/class.dart';
import 'package:fcmobile_squad_maker/models/club/clubs.dart';
import 'package:fcmobile_squad_maker/models/flag/flags.dart';
import 'package:fcmobile_squad_maker/models/league/leagues.dart';
import 'package:fcmobile_squad_maker/models/player.dart';
import 'package:fcmobile_squad_maker/widgets/player_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<Player> players = [];
  List<Class> grade = [];
  List<Leagues> leagues = [];
  List<Clubs> clubs = [];
  List<Flags> flags = [];
  List<String> stat = ['페이스','슈팅','패스','민첩성','수비','피지컬'];

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

  //선수검색 기능
  String searchText = "";

  void searchEvent(BuildContext context, int index) {
    String content = players[index].name;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContentPage(content: content)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("선수 검색"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchBar(
              leading: Icon(Icons.search),
              hintText: '선수명을 입력해주세요.',
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                dynamic player = players[index];
                dynamic flagUrl = getFlagUrl(player.nation);
                dynamic classUrl = getClassUrl(player.grade);
                dynamic clubUrl = getClubUrl(player.club);
            
                if (searchText.isNotEmpty &&
                    !players[index]
                        .name
                        .toLowerCase()
                        .contains(searchText.toLowerCase())) {
                  return SizedBox.shrink();
                } else {
                  return Card(
                      child: Row(
                        children: [
                          Expanded(child: PlayerList(classUrl, flagUrl!, clubUrl, player, context)),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text("선수 선택"),
                                onTap: () => Navigator.pop(context, player.id),
                              ),
                            ],
                            icon: Icon(Icons.add),
                          ),
                        ],
                      )
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  final String content;

  const ContentPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(content),
      ),
    );
  }
}
