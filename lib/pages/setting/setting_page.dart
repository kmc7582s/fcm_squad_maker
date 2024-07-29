import 'dart:async';
import 'dart:io';

import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/pages/member/login_page.dart';
import 'package:fcmobile_squad_maker/pages/setting/edit_nickname_page.dart';
import 'package:fcmobile_squad_maker/pages/setting/edit_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  final User user;
  const SettingPage({super.key, required this.user});

  @override
  State<SettingPage> createState() => _SettingPageState(user: user);
}

class _SettingPageState extends State<SettingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user;
  final _userUpdateRef = FirebaseDatabase.instance.ref().child('users');
  String _nickname = '';
  String _profileImg = '';
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _imageUrl = '';

  _SettingPageState({required this.user});

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 프로필 이미지 변경
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    User? user = _auth.currentUser;
    if (user != null && _image != null) {
      final storageRef = FirebaseStorage.instance.ref().child('users').child('${user.uid}.png');

      try {
        await storageRef.putFile(_image!);
        String imageUrl = await storageRef.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
        _updateProfilePictureUrl();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _updateProfilePictureUrl() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      await userRef.update({
        'profile_img': _imageUrl,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }).catchError((error) {
        print('Error updating profile picture URL: $error');
      });
    }
  }

  // 닉네임, 프로필 이미지 업데이트
  Future<void> _fetchUserData() async {
    final DatabaseReference _database = _userUpdateRef.child(user.uid);

    _database.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _nickname = data['nickname'] ?? 'Unknown';
          _profileImg = data['profile_img'] ?? 'Unknown';
        });
      }
    });
  }

  // 로그아웃
  Future<void> _signOut(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('로그아웃 확인'),
            content: const Text('로그아웃 하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await _auth.signOut();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  } catch (e) {
                    // 로그아웃 오류 처리
                    print('로그아웃 오류: $e');
                  }
                },
                child: const Text('로그아웃'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('취소'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그아웃 오류"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_profileImg),
                        ),
                        Positioned(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              FontAwesomeIcons.camera,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_nickname,style: CustomTextStyle.label,),
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
              title: const Text("내 평가",  style: CustomTextStyle.settingLabel),
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
