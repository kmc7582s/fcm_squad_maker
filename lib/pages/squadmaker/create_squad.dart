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
    '3back': ['3-4-3','3-5-2'],
    '4back': ['4-2-4', '4-3-3', '4-4-2'],
    '5back': ['5-3-2']
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
      DatabaseReference _database = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('squads').push();
      String squadId = _database.key!;
      _database.set({
        'id' : squadId,
        'squadtitle' : _titleController.text.trim(),
        'teams' : selectedOption1,
        'formation' : selectedOption2,
        'team_logo' : getClubUrl(selectedOption1).toString(),
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SquadMakerPage(squadId: squadId,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("스쿼드 생성"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 16.0),
              child: Row(
                children: [
                  Text("스쿼드 제목",style: CustomTextStyle.createsquadTitle,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 16, right: 16),
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("팀 선택",style: CustomTextStyle.createsquadTitle,),
                          DropdownButton<String>(
                            value: selectedLeague,
                            items: team.keys.map((String league) {
                              return DropdownMenuItem<String>(
                                value: league,
                                child: Row(
                                  children: [
                                    Image.network(getLeagueUrl(league).toString(),width: 20,height: 20,),
                                    const SizedBox(width: 20,),
                                    Text(league),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLeague = newValue!;
                                selectedOption1 = '';
                              });
                              _showTeamDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(getClubUrl(selectedOption1).toString(),width: 25,height: 25,),
                          const SizedBox(width: 10,),
                          Text(selectedOption1, style: CustomTextStyle.label,),
                        ],
                      ),
                    )
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
                          const Text("포메이션 선택",style: CustomTextStyle.createsquadTitle,),
                          const SizedBox(width: 100),
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
                                icon: const Icon(Icons.arrow_drop_down),
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
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: () {
                createSquad();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: Colors.blue
              ),
              child: const Text("생성", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
  void _showTeamDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('팀 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: team[selectedLeague]!.map((String team) {
                return ListTile(
                  title: Row(
                    children: [
                      Image.network(getClubUrl(team).toString(),width: 20, height: 20,),
                      SizedBox(width: 10,),
                      Text(team),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedOption1 = team;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
