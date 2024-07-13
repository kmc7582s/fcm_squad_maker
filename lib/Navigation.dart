import 'package:fcmobile_squad_maker/pages/player_list.dart';
import 'package:fcmobile_squad_maker/pages/squad_list.dart';
import 'package:fcmobile_squad_maker/pages/squad_maker.dart';
import 'package:fcmobile_squad_maker/pages/home.dart';
import 'package:fcmobile_squad_maker/pages/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  final User user;

  const Navigation({
    required this.user,
  Key? key}) : super(key: key);

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
          children: [HomePage(), SquadListPage(), PlayerListPage(), SettingPage(user: user)],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() {
          selectedIndex = value;
        }),
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: "홈",
              selectedIcon: Icon(
                Icons.home_rounded,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )
          ),
          NavigationDestination(
              icon: Icon(Icons.gamepad),
              label: "스쿼드 메이커",
              selectedIcon: Icon(
                Icons.gamepad,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )
          ),
          NavigationDestination(
              icon: Icon(Icons.person),
              label: "선수 정보",
              selectedIcon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )
          ),
          NavigationDestination(
              icon: Icon(Icons.settings),
              label: "설정",
              selectedIcon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )
          ),
        ],
        animationDuration: const Duration(milliseconds: 100),
      ),
    );
  }
}
