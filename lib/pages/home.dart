import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user;
  Map<String, dynamic>? _userData;

  _HomePageState({required this.user});

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref().child('users').child(user.uid);
    DatabaseEvent event = await _database.once();
    setState(() {
      _userData = Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "홈",
          style: CustomTextStyle.appbarTitle,
        ),
        centerTitle: false,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_userData?['profile_img'] ?? ''),
                backgroundColor: Colors.white,
              ),
              accountEmail: Text("${user.email}"),
              accountName: Text(_userData?['nickname'] ?? ''),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text("문의"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        )
      ),
      body: Center(
        child: Text("home")
      ),
    );
  }
}
