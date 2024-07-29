import 'package:fcmobile_squad_maker/pages/playerinfo/player_list.dart';
import 'package:fcmobile_squad_maker/pages/squadmaker/squad_list.dart';
import 'package:fcmobile_squad_maker/pages/home/home.dart';
import 'package:fcmobile_squad_maker/pages/setting/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  final User user;

  const Navigation({
    required this.user,
  super.key});

  @override
  State<Navigation> createState() => _NavigationState(user: user);
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  final User user;

  _NavigationState({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: selectedIndex,
          children: [HomePage(user: user), const SquadListPage(), const PlayerListPage(), SettingPage(user: user)],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 8,
        shadowColor: Colors.grey.shade900,
        backgroundColor: Colors.white,
        height: 60,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() {
          selectedIndex = value;
        }),
        indicatorColor: Colors.white,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_rounded, color: Colors.grey,),
              label: "홈",
              selectedIcon: Icon(
                Icons.home_rounded,
                color: Colors.black,
              )
          ),
          NavigationDestination(
              icon: Icon(Icons.gamepad, color: Colors.grey,),
              label: "스쿼드 메이커",
              selectedIcon: Icon(
                Icons.gamepad,
                color: Colors.black,
              )
          ),
          NavigationDestination(
              icon: Icon(Icons.person, color: Colors.grey,),
              label: "선수 정보",
              selectedIcon: Icon(
                Icons.person,
                color: Colors.black,
              )
          ),
          NavigationDestination(
              icon: Icon(Icons.settings, color: Colors.grey,),
              label: "설정",
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.black,
              )
          ),
        ],
        animationDuration: const Duration(milliseconds: 100),
      ),
    );
  }
}
