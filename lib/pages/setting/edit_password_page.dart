import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key, required this.user});
  final User user;

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState(user: user);
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  _EditPasswordPageState({required this.user});

  final User user;
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  DatabaseReference _database = FirebaseDatabase.instance.ref().child('users');
  Map<String, dynamic>? _userData;
  String statusMessage = '';
  bool _isLoading = false;

  Future<void> _sendEditPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        statusMessage = '비밀번호 재설정 이메일이 발송되었습니다.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = '오류: 이메일을 입력해주세요.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("비밀번호 변경"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.only(top:200,left: 30, right: 30),
          child: Card(
            elevation: 6,
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("비밀번호 변경", style: CustomTextStyle.settingTitle,),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 10),
                  child: textField("이메일을 입력해주세요.", _emailController, false),
                ),
                Text("비밀번호는 6개월마다 변경하는 것을 권장합니다.", style: TextStyle(color: Colors.grey.shade700),),
                SizedBox(height: 20,),
                Text(statusMessage, style: CustomTextStyle.statemessage,),
                _isLoading ?
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
                  : ElevatedButton(
                  onPressed: _sendEditPassword,
                  child: Text("Send"),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
