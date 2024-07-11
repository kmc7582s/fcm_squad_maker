import 'package:fcmobile_squad_maker/Navigation.dart';
import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();


  // void signUp() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //           email: email.value.text.trim(),
  //           password: password.value.text.trim())
  //         .then((value) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         })
  //
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 100,
                left: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Make your",style: Fonts.largeTitle,),
                    Text("Squad",style: Fonts.largeTitle,),
                    Text("For FC Mobile",style: Fonts.largeTitle,),
                  ],
                ),
              ),
              Positioned(
                top: 350,
                left: 24,
                right: 24,
                child: Card(
                  elevation: 8,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      textField("이메일",emailController,true),
                      SizedBox(height: 10,),
                      textField("비밀번호", pwController,false),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Text("")
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
     )
    );
  }

  Widget textField(String hint, TextEditingController controller, bool isId) {
    return TextField(
      controller: controller,
      obscureText: isId=false,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Palette.base3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.base1)
          )
      ),
    );
  }
}
