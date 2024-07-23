import 'package:fcmobile_squad_maker/pages/squadmaker/search_player.dart';
import 'package:fcmobile_squad_maker/widgets/formation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../config/assets.dart';

class SquadMakerPage extends StatefulWidget {
  final dynamic player;

  const SquadMakerPage({super.key, required this.player});

  @override
  State<SquadMakerPage> createState() => _SquadMakerPageState(player: player);
}

class _SquadMakerPageState extends State<SquadMakerPage> with SingleTickerProviderStateMixin {
  final dynamic player;
  List<String> fw = ['ST','LW','RW','LF','RF','CF'];
  List<String> mf = ['CAM','LM','CM','RM','CDM'];
  List<String> df = ['LWB','LB','CB','RB','RWB'];
  List<String> gk = ['GK'];

  _SquadMakerPageState({required this.player});

  final List<int> _FW = [];
  final List<int> _MF = [];
  final List<int> _DF = [];
  final List<int> _GK = [];

  final List<List<int>> formation = [
    [1, 2],      // Forwards
    [3, 0, 0, 0],  // Midfielders
    [0, 0, 0, 0],  // Defenders
    [0],        // Goalkeeper
  ];

  @override
  void initState () {
    super.initState();
  }

  final _auth = FirebaseAuth.instance;

  Future<void> Squad() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference _database = FirebaseDatabase.instance.ref().child('users').child('${user.uid}').child('squads');
      _database.child('${_database.key!}').set({
        'average_ovr' : '',
        'player' : '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("스쿼드 메이커"),
        centerTitle: false,
        actions: [
          IconButton(
              icon:Icon(Icons.save),
              onPressed: () {}
          ),
          IconButton(icon:Icon(Icons.menu),onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: formation.map((line) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: line.map((player) {
                              return Draggable<int>(
                                data: player,
                                feedback: _buildPlayerIcon(),
                                child: _buildPlayerIcon(),
                                childWhenDragging: Container(),
                                onDragCompleted: () {},
                              );
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

  Widget _buildPlayerIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'P',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
