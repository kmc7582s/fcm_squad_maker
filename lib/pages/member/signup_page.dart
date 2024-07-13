import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String statusMessage = '';

  Future<void> _signUp() async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: _emailController.text, password: _pwController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = e.message ?? '회원가입 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: " Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: _pwController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: _signUp,
                child: Text("Sign Up"),
              ),
              SizedBox(height: 20),
              Text(statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
