import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/models/club/clubs.dart';
import 'package:fcmobile_squad_maker/pages/playerinfo/player_versus.dart';
import 'package:fcmobile_squad_maker/widgets/player_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fcmobile_squad_maker/models/player.dart';
import 'package:fcmobile_squad_maker/models/class/class.dart';
import '../../config/assets.dart';
import '../../models/flag/flags.dart';
import '../../models/league/leagues.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {

  _PlayerListPageState();
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
        isVisible = false;
      });
    }
  }

  //선수검색 기능
  String searchText = "";
  bool _isSearchBarVisible = false;

  void searchEvent(BuildContext context, int index) {
    String content = players[index].name;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>ContentPage(content : content))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "선수 정보",
          style: CustomTextStyle.appbarTitle,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon:Icon(IconSrc.search),
            onPressed: () {
              setState(() {
                _isSearchBarVisible = !_isSearchBarVisible;
                searchText = "";
              });
            },
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
          Visibility(
            visible: _isSearchBarVisible,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 310,
                    child: SearchBar(
                      hintText: '선수명을 입력해주세요.',
                      leading: const Icon(Icons.search),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: IconButton(icon: Icon(Icons.filter_list), onPressed: () {  },),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  dynamic player = players[index];
                  dynamic flagUrl = getFlagUrl(player.nation);
                  dynamic classUrl = getClassUrl(player.grade);
                  dynamic clubUrl = getClubUrl(player.club);

                  if(searchText.isNotEmpty && !players[index].name.toLowerCase().contains(searchText.toLowerCase())) {
                    return SizedBox.shrink();
                  } else {
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
                          Expanded(child: PlayerList(classUrl, flagUrl!, clubUrl, player, context)),
                        ],
                      ),
                    );
                  }

                }),
          ),
        ],
      ),
    );
  }
}

// 선택한 항목의 내용을 보여주는 추가 페이지
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
