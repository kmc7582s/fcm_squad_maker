import 'package:fcmobile_squad_maker/Navigation.dart';
import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/main.dart';
import 'package:fcmobile_squad_maker/pages/member/edit_account.dart';
import 'package:fcmobile_squad_maker/pages/member/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String _statusMessage = '';

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _pwController.text);

      if (userCredential.user != null) {
        setState(() {
          _statusMessage = '로그인 성공';
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Navigation(user: userCredential.user!)));
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = e.message ?? '로그인 실패';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Make your",
                    style: Fonts.largeTitle,
                  ),
                  Text(
                    "Squad",
                    style: Fonts.largeTitle,
                  ),
                  Text(
                    "For FC Mobile",
                    style: Fonts.largeTitle,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 300,
              left: 20,
              right: 20,
              child: Card(
                elevation: 6,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "로그인",
                            style: Fonts.title,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      textField("이메일", _emailController, false),
                      SizedBox(
                        height: 10,
                      ),
                      textField("비밀번호", _pwController, true),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text(
                                "회원가입",
                                style: Fonts.label,
                              ),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SignupPage())),
                            ),
                            TextButton(
                              child: Text(
                                "계정 찾기",
                                style: Fonts.label,
                              ),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => EditAccountPage())),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () => _signIn(), child: Text("로그인")),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget textField(String hint, TextEditingController controller, bool isId) {
    return TextField(
      controller: controller,
      obscureText: isId,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Palette.base3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Palette.base1),
          ),
          label: Text(hint)),
    );
  }
}
