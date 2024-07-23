import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/models/club/clubs.dart';
import 'package:fcmobile_squad_maker/models/league/leagues.dart';
import 'package:fcmobile_squad_maker/pages/squadmaker/squad_maker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateSquadPage extends StatefulWidget {
  const CreateSquadPage({super.key});

  @override
  State<CreateSquadPage> createState() => _CreateSquadPageState();
}

class _CreateSquadPageState extends State<CreateSquadPage> {
  final List<String> categories_team = ['Premier League','Laliga','Bundesliga','Ligue 1','Serie A','Major League Soccer','ROSHN Saudi League'];
  final Map<String, List<String>> team = {
    'Premier League': ['Liverpool','Tottenham Hotspur','Arsenal','Newcastle United','Manchester City'],
    'Laliga': ['FC Barcelona','Real Madrid','Valencia CF','Real Sociedad','Girona FC','Atletico de Madrid'],
    'Bundesliga' : ['Bayer 04 Leverkusen','FC Bayern Munich','VfB Stuttgart'],
    'Ligue 1' : ['Paris Saint-Germain'],
    'Serie A' : ['Milan','Napoli FC','Sassuolo','Juventus','Inter'],
    'Major League Soccer' : ['Inter Miami'],
    'ROSHN Saudi League' : ['Al Nassr', 'Al lttihad', 'Al Ahli'],
  };

  final List<String> categories = ['3back', '4back', '5back'];
  final Map<String, List<String>> formation = {
    '3back': ['3-4-1-2', '3-4-2-1', '3-5-2'],
    '4back': ['4-2-4', '4-3-3', '4-3-2-1', '4-4-2'],
    '5back': ['5-2-1-2', '5-2-2-1', '5-3-2']
  };

  List<Leagues> leagues = [];
  List<Clubs> clubs = [];

  final _titleController = TextEditingController();
  String selectedLeague = 'Premier League';
  String selectedFormation = '3back';
  late String selectedOption1;
  late String selectedOption2;

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

  String? getClubUrl(String club) {
    for (var clubs in clubs) {
      if (clubs.club == club) {
        return clubs.img;
      }
    }
    return null;
  }

  String? getLeagueUrl(String league) {
    for (var leagues in leagues) {
      if (leagues.league == league) {
        return leagues.img;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadClubs();
    _loadLeagues();
    selectedOption1 = team[selectedLeague]!.first;
    selectedOption2 = formation[selectedFormation]!.first; // 초기 선택 옵션 설정
  }

  final _auth = FirebaseAuth.instance;

  Future<void> createSquad() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference _database = FirebaseDatabase.instance.ref().child('users').child('${user.uid}').child('squads').push();
      String squadId = _database.key!;
      _database.set({
        'id' : squadId,
        'squadtitle' : _titleController.text.trim(),
        'teams' : selectedOption1,
        'formation' : selectedOption2,
        'team_logo' : getClubUrl(selectedOption1).toString(),
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SquadMakerPage(player: '',)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("스쿼드 생성"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 12.0),
              child: Row(
                children: [
                  Text("스쿼드 제목",style: Fonts.subtitle2,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "스쿼드 제목을 입력해주세요.",
                  hintStyle: TextStyle(color: Palette.base3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 12.0, right: 12),
              child: Card(
                color: Colors.grey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("팀 선택",style: Fonts.subtitle2,),
                          Container(
                            width: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: selectedOption1,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  selectedOption1 = newValue;
                                });
                              },
                              items: team[selectedLeague]!
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Row(
                                  children: [
                                    Image.network(getClubUrl(value).toString(),width: 20,height: 20,),
                                    Text(" "+value),
                                  ],
                                ));
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: categories_team.map((String category) {
                        return RadioListTile<String>(
                            title: Row(
                              children: [
                                Image.network(getLeagueUrl(category).toString(),width: 30,height: 30,),
                                SizedBox(width: 10,),
                                Text(category),
                              ],
                            ),
                            value: category,
                            groupValue: selectedLeague,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedLeague = value;
                                selectedOption1 = team[selectedLeague]!.first;
                              });
                            });
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          Text("포메이션 선택",style: Fonts.subtitle2,),
                          SizedBox(width: 100),
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
                                value: selectedOption2,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                onChanged: (dynamic newValue) {
                                  setState(() {
                                    selectedOption2 = newValue;
                                    print(selectedOption2);
                                  });
                                },
                                items: formation[selectedFormation]!
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
                              setState(() {
                                selectedFormation = value;
                                selectedOption2 = formation[selectedFormation]!.first;
                              });
                            });
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                createSquad();
              },
              child: Text("생성", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: Colors.blue
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
