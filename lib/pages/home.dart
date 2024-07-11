import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
        centerTitle: false,
        actions: [
          IconButton(icon:Icon(IconSrc.bell_alt), onPressed: () {  },),
        ],
      ),
      body: Center(
        child: Text("home"),
      ),
    );
  }
}
