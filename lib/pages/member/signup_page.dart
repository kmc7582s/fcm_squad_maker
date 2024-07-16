import 'dart:io';

import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwcheckController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  String statusMessage = '';
  File? selectedImage;

  Future<void> _signUp() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _pwController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = e.message ?? '회원가입 실패';
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print("no select image");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FCM 스쿼드 메이커"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedImage != null ? FileImage(File(selectedImage!.path)) : null,
                    child: selectedImage == null ? IconButton(onPressed: _pickImage, icon: Icon(Icons.image),iconSize: 50,) : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 6,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "회원가입",
                              style: Fonts.title,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        textTitle("닉네임"),
                        textField("서비스를 이용할 닉네임을 입력해주세요", _nameController, false),
                        const SizedBox(
                          height: 15,
                        ),
                        textTitle("이메일"),
                        textField("abc@gmail.com", _emailController, false),
                        const SizedBox(
                          height: 15,
                        ),
                        textTitle("비밀번호"),
                        textField("특수문자, 대문자, 소문자", _pwController, true),
                        const SizedBox(
                          height: 15,
                        ),
                        textTitle("비밀번호 확인"),
                        textField("특수문자, 대문자, 소문자", _pwcheckController, true),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _signUp,
                          child: Text("Sign Up"),
                        ),
                        Text(statusMessage),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String hint, TextEditingController controller, bool isId) {
    return TextField(
      controller: controller,
      obscureText: isId,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Palette.base3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Palette.base1),
          ),
      ),
    );
  }

  Widget textTitle(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: Fonts.parag4,
        ),
      ],
    );
  }

  Widget imageProgile() {
    return Center(
      child: Stack(),
    );
  }
}
