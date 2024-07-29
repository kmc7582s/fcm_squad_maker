import 'dart:async';
import 'dart:io';

import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/pages/member/login_page.dart';
import 'package:fcmobile_squad_maker/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final ImagePicker _picker = ImagePicker();
  String statusMessage = '';
  File? selectedImage;
  bool _isLoading = false;

  // 에러 메시지
  String _errorText = '';

  void _validateInput(String value) {
    // 패턴 정의: 특수문자, 영문자, 숫자 검증
    final RegExp specialCharPattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final RegExp letterPattern = RegExp(r'[a-zA-Z]');
    final RegExp numberPattern = RegExp(r'[0-9]');

    if (value.isEmpty) {
      setState(() {
        _errorText = '입력값이 비어 있습니다.';
      });
    } else if (!specialCharPattern.hasMatch(value)) {
      setState(() {
        _errorText = '특수문자가 포함되어야 합니다.';
      });
    } else if (!letterPattern.hasMatch(value)) {
      setState(() {
        _errorText = '영문자가 포함되어야 합니다.';
      });
    } else if (!numberPattern.hasMatch(value)) {
      setState(() {
        _errorText = '숫자가 포함되어야 합니다.';
      });
    } else {
      setState(() {
        _errorText = ''; // 유효성 검사 통과
      });
    }
  }

  Future<void> _signUp() async {
    if (_errorText.isEmpty) {
      // 패스워드가 유효하지 않으면 회원가입을 진행하지 않음
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _pwController.text.trim()
        );

        User? user = userCredential.user;
        if (user != null) {
          await user.sendEmailVerification();
          setState(() {
            statusMessage = '인증 이메일이 발송되었습니다. 이메일을 확인해주세요.';
            _isLoading = true;
          });

          // 이메일 인증을 확인하는 로직
          _checkEmailVerified(user);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          statusMessage = e.message ?? '회원가입 실패';
        });
      }
    } else {
      _errorText;
    }
  }

  Future<void> _checkEmailVerified(User user) async {
    while (!user.emailVerified) {
      await Future.delayed(Duration(seconds: 3));
      await user.reload();
      user = _auth.currentUser!;
    }

    setState(() {
      statusMessage = '이메일 인증 완료';
      _isLoading = false;
    });

    String? profileImageUrl;
    if (selectedImage != null) {
      profileImageUrl = await _uploadImage(selectedImage!);
    }

    _database.child("users").child(user.uid).set({
      'uid': user.uid,
      'nickname': _nameController.text.trim(),
      'profile_img': profileImageUrl ?? '',
    });

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'users/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      setState(() {
        statusMessage = '이미지 업로드 실패: $e';
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("FCM 스쿼드 메이커"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: 50,
                    backgroundImage: selectedImage != null ? FileImage(File(selectedImage!.path)) : null,
                    child: selectedImage == null ? IconButton(onPressed: _pickImage, icon: Icon(Icons.image),iconSize: 40,color: Colors.black,) : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.grey.shade200,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "회원가입",
                              style: CustomTextStyle.label,
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
                        TextField(
                          controller: _pwController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "특수문자, 영문자, 숫자",
                            hintStyle: const TextStyle(color: Palette.base3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Palette.base1),
                            ),
                            errorText: _errorText,
                          ),
                          onChanged: _validateInput,
                        ),
                        SizedBox(height: 10,),
                        _isLoading
                            ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                            : ElevatedButton(
                          onPressed: () {
                            _validateInput(_pwController.text);
                            _signUp();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(400, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: Colors.black
                          ),
                          child: const Text("Sign Up", style: CustomTextStyle.signUplabel),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14,left: 8,right: 8),
                          child: Text(statusMessage, style: TextStyle(color: Colors.red),),
                        ),
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

  Widget textTitle(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: CustomTextStyle.settingLabel2,
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
