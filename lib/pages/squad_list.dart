import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:fcmobile_squad_maker/pages/squad_maker.dart';
import 'package:flutter/material.dart';

class SquadListPage extends StatefulWidget {
  const SquadListPage({super.key});

  @override
  State<SquadListPage> createState() => _SquadListPageState();
}

class _SquadListPageState extends State<SquadListPage> {
  final String my_squad_title = '';
  final List<dynamic> create = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 스쿼드"),
        centerTitle: false,
        actions: [
          IconButton(icon:Icon(IconSrc.add),onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SquadMakerPage()))),
          IconButton(icon:Icon(IconSrc.delete),onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: create.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(my_squad_title),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SquadMakerPage()))
          );
        },
      ),
    );
  }
}
