import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:flutter/material.dart';

class SquadListPage extends StatefulWidget {
  const SquadListPage({super.key});

  @override
  State<SquadListPage> createState() => _SquadListPageState();
}

class _SquadListPageState extends State<SquadListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 스쿼드"),
        centerTitle: false,
        actions: [
          IconButton(icon:Icon(IconSrc.add),onPressed: () {},),
          IconButton(icon:Icon(IconSrc.delete),onPressed: () {},),
        ],
      ),
      body: ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) {

        },
      ),
    );
  }
}
