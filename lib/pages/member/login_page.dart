import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/main.dart';
import 'package:fcmobile_squad_maker/pages/member/signup_page.dart';
import 'package:fcmobile_squad_maker/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  String _statusMessage = '';
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _pwController.text);
      if (userCredential.user != null) {
        setState(() {
          _statusMessage = '로그인 성공';
          print(_statusMessage);
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyApp()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _statusMessage = '등록되지 않은 이메일입니다';
        } else if (e.code == 'wrong-password') {
          _statusMessage = '비밀번호가 틀렸습니다';
        } else {
          _statusMessage = e.code;
        }
        print(_statusMessage);
      });
    }
  }

  Future<void> _sendEditPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _statusMessage = '비밀번호 재설정 이메일이 발송되었습니다.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = '오류: 이메일을 입력해주세요.';
      });
    } finally {
      setState(() {
        _isLoading = false;
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
      child: Container(
        color: const Color(0xFF2A2B2F),
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
                  const Text(
                    "Make your\nSquad\nFor FC Mobile",
                    style: CustomTextStyle.loginTitle,
                  ).animate(adapter: ValueAdapter(0.5)).shimmer(
                      colors: [
                        const Color(0xFF0fff37),
                        const Color(0xFF15ff4c),
                        const Color(0xFF1aff61),
                        const Color(0xFF20ff75),
                        const Color(0xFF26ff8a),
                        const Color(0xFF2bff9f),
                        const Color(0xFF31ffb4),
                        const Color(0xFF37ffc8),
                      ]
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .saturate(delay: 1.seconds, duration: 1.seconds)
                      .then()
                      .tint(color: const Color(0xFF80DDFF)),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "로그인",
                            style: CustomTextStyle.label,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      textField("이메일", _emailController, false),
                      const SizedBox(
                        height: 10,
                      ),
                      textField("비밀번호", _pwController, true),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text(
                                "회원가입",
                                style: CustomTextStyle.sublabel,
                              ),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SignupPage())),
                            ),
                            TextButton(
                              onPressed: _sendEditPassword,
                              child: const Text(
                                "비밀번호 찾기",
                                style:  CustomTextStyle.sublabel,
                              )
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () => _signIn(),
                          child: const Text("로그인")
                      ),
                      Text(_statusMessage, style: TextStyle(color: Colors.red),)
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
}
