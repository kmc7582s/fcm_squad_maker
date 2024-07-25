import 'dart:async';

import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/pages/member/login_page.dart';
import 'package:fcmobile_squad_maker/pages/setting/edit_nickname_page.dart';
import 'package:fcmobile_squad_maker/pages/setting/edit_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final User user;
  const SettingPage({super.key, required this.user});

  @override
  State<SettingPage> createState() => _SettingPageState(user: user);
}

class _SettingPageState extends State<SettingPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _userData;
  final User user;

  _SettingPageState({required this.user});

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

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그아웃 오류"))
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "내 정보",
          style: CustomTextStyle.appbarTitle,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_userData?['profile_img'] ?? ''),
                  ),
                ),
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${_userData?['nickname'] ?? 'Default Nickname'}",style: CustomTextStyle.label,),
                      const SizedBox(height: 8,),
                      Text("email: ${user.email}",style: CustomTextStyle.settingLabel2,),
                      const SizedBox(height: 4,),
                      Text("uid: ${user.uid}",overflow:TextOverflow.fade,style: CustomTextStyle.settingLabel2,),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top:20.0, left: 12.0),
              child: Row(
                children: [
                  Text("Information",style: CustomTextStyle.settingTitle,)
                ],
              ),
            ),
            ListTile(
              title: const Text("내가 쓴 글",  style: CustomTextStyle.settingLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              title: const Text("내가 좋아요 한 글",  style: CustomTextStyle.settingLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 12.0),
              child: Row(
                children: [
                  Text("Account",style: CustomTextStyle.settingTitle,)
                ],
              ),
            ),
            ListTile(
              title: const Text("닉네임 변경", style: CustomTextStyle.settingLabel,),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditNicknamePage(user: user))),
            ),
            ListTile(
              title: const Text("비밀번호 변경",  style: CustomTextStyle.settingLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPasswordPage(user: user))),
            ),
            const Padding(
              padding: EdgeInsets.only(top:20.0, left: 12.0),
              child: Row(
                children: [
                  Text("Service",style: CustomTextStyle.settingTitle,)
                ],
              ),
            ),
            ListTile(
              title: const Text("문의",  style: CustomTextStyle.settingLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const ListTile(
              title: Text("버전",  style: CustomTextStyle.settingLabel),
              trailing: Text("v1.0.0", style: CustomTextStyle.versionLabel),
            ),
            const Divider(),
            ListTile(
              title: const Center(child: Text("로그아웃", style: TextStyle(color: Colors.red),)),
              onTap: () {_signOut(context);},
            ),
          ],
        ),
      ),
    );
  }
}
