import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/pages/squadmaker/create_squad.dart';
import 'package:fcmobile_squad_maker/pages/squadmaker/squad_maker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SquadListPage extends StatefulWidget {
  const SquadListPage({super.key});

  @override
  State<SquadListPage> createState() => _SquadListPageState();
}

class _SquadListPageState extends State<SquadListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "내 스쿼드",
          style: CustomTextStyle.appbarTitle,
        ),
        centerTitle: false,
        actions: [
          IconButton(icon:const Icon(IconSrc.add), onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateSquadPage()));
          }),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No user logged in'));
          }
          User? user = snapshot.data!;
          return StreamBuilder(
              stream: _database.child('users').child(user.uid).child('squads').onValue,
              builder: (context, event) {
                if (event.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (event.hasError) {
                  return const Center(child: Text('Error loading squads'));
                }
                if (!event.hasData || event.data!.snapshot.value == null) {
                  return const Center(child: Text('No squads found'));
                }
                Map<dynamic, dynamic> squads = event.data!.snapshot.value as Map;
                List<Map<String, dynamic>> squadList = [];
                squads.forEach((key, value) {
                  squadList.add({
                    'id': key,
                    'squadtitle': value['squadtitle'],
                    'teams': value['teams'],
                    'formation': value['formation'],
                    'team_logo': value['team_logo'],
                  });
                });
                return ListView.separated(
                  itemCount: squadList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(squadList[index]['team_logo'], width: 35, height: 35,),
                      title: Text(squadList[index]['squadtitle']),
                      subtitle: Text('평균 OVR | Formation: ${squadList[index]['formation']}'),
                      trailing: PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text("찜하기"),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text("삭제"),
                            onTap: () => _database.child('users').child(user.uid).child('squads').child(squadList[index]['id']).remove(),
                          )
                        ],
                        icon: Icon(Icons.more_vert),
                      ),
                      onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SquadMakerPage(player: '',))),
                    );
                  },
                  separatorBuilder: (context,index) {
                    return Divider();
                  },
                );
              }
          );
        },
      ),
    );
  }
}
