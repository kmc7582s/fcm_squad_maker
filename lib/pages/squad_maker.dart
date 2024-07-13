import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/widgets/formation.dart';
import 'package:flutter/material.dart';

import '../config/assets.dart';

class SquadMakerPage extends StatefulWidget {
  const SquadMakerPage({super.key});

  @override
  State<SquadMakerPage> createState() => _SquadMakerPageState();
}

class _SquadMakerPageState extends State<SquadMakerPage> with SingleTickerProviderStateMixin {
  final List<String> formation_5back = ['5-2-1-2','5-2-2-1','5-3-2','5-4-1'];
  final List<String> formation_4back = ['4-1-4-1','4-2-4','4-2-2-2','4-3-3','4-3-1-2','4-3-2-1','4-4-2','4-5-1'];
  final List<String> formation_3back = ['3-4-1-2','3-4-2-1','3-5-2','3-5-1-1'];
  TabController? _tabController;

  @override
  void initState () {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("스쿼드 메이커"),
        centerTitle: false,
        actions: [
          IconButton(icon:Icon(Icons.save),onPressed: () {}),
          IconButton(icon:Icon(Icons.menu),onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "스쿼드 정보"),
              Tab(text: "선수 리스트"),
              Tab(text: "스쿼드",)
            ],
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      TextField(),
                    ],
                  ),
                  ListView.builder(
                    itemCount: 11,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("POSITION"),
                        onTap: () {
                          //선수 정보 데이터를 불러와야됨 (검색 기능이 포함된)

                        },
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: Image.asset(
                              field,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "포메이션",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    "평균 OVR",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              child: Container(
                                height: constraints.maxHeight * 1/2,
                                width: constraints.maxWidth,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FW(),
                                    FW(),
                                    FW()
                                  ],
                                ),
                              )
                          ),
                          Positioned(
                            top: constraints.maxHeight * 1/4,
                            child: Container(
                              height: constraints.maxHeight * 2/5,
                              width: constraints.maxWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  MF(),
                                  MF(),
                                  MF(),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top : constraints.maxHeight * 3/5,
                              child: Container(
                                height: constraints.maxHeight * 1/5,
                                width: constraints.maxWidth,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DF(),
                                    DF(),
                                    DF(),
                                    DF(),
                                  ],
                                ),
                              )
                          ),
                          Positioned(
                            top : constraints.maxHeight * 4/5,
                            height: constraints.maxHeight * 1/7,
                            width: constraints.maxWidth,
                            child: GK(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
