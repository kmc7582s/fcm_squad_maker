import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditNicknamePage extends StatefulWidget {
  const EditNicknamePage({super.key,required this.user});
  final User user;

  @override
  State<EditNicknamePage> createState() => _EditNicknamePageState(user: user);
}

class _EditNicknamePageState extends State<EditNicknamePage> {
  _EditNicknamePageState({required this.user});

  final User user;
  final _nicknameController = TextEditingController();
  DatabaseReference _database = FirebaseDatabase.instance.ref().child('users');
  Map<String, dynamic>? _userData;
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DatabaseEvent event = await _database.child(user.uid).once();
    setState(() {
      _userData = Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  Future<void> editUserName() async {
    _database.child(user.uid).update({
      'nickname': _nicknameController.text.trim(),
    });
    setState(() {
      statusMessage = '닉네임 변경이 완료되었습니다.';
    });
    await user.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () async {
            await user.reload();
            Navigator.pop(context);
          },
        ),
        title: const Text("닉네임 변경"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.only(top:200,left: 30, right: 30),
          child: Card(
            elevation: 6,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("기존 닉네임 : ${_userData?['nickname']}", style: CustomTextStyle.settingTitle,),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
                  child: textField("변경할 닉네임을 입력해주세요.", _nicknameController, false),
                ),
                Text(statusMessage, style: CustomTextStyle.statemessage,),
                ElevatedButton(onPressed: () {editUserName();}, child: Text("변경")),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

