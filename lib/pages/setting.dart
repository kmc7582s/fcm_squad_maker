import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/pages/member/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required User user});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: null,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text("닉네임"),
                    Text("이메일"),
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Text("내가 쓴 글"),
          ),
          Container(
            child: Text("비밀번호 변경"),
          ),
          Container(
            child: Text("문의"),
          ),
          Container(
            child: Text("버전"),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: const Text("로그아웃"),
            ),
          ),
        ],
      ),
    );
  }
}
