import 'dart:io';

import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPostPage extends StatefulWidget {
  final User user;
  const AddPostPage({super.key, required this.user});

  @override
  State<AddPostPage> createState() => _AddPostPageState(user: user);
}

class _AddPostPageState extends State<AddPostPage> {
  _AddPostPageState({required this.user});

  final _database = FirebaseDatabase.instance.ref();
  final User user;
  File? _image;
  final picker = ImagePicker();
  String postContent = '';
  String _nickname = '';
  String _profileImg = '';
  String postId = '';
  final _userRef = FirebaseDatabase.instance.ref().child('users');

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage(postId);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _uploadImage(String postId) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${user.uid}/$postId.png');
    final uploadTask = storageReference.putFile(_image!);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _fetchUserData() async {
    final DatabaseReference _database = _userRef.child(user.uid);

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

  void _addPost() async {
    if (postContent.isNotEmpty) {
      String postId = _database.child('posts').push().key!;
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(postId);
      }
      _database.child('posts/$postId').set({
        'user' : user.uid,
        'nickname' : _nickname,
        'profile_img' : _profileImg,
        'text': postContent,
        'img': imageUrl ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
      setState(() {
        postContent = '';
        _image = null;
      });
      // Close the keyboard
      FocusScope.of(context).unfocus();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        backgroundColor: Colors.white,
        title: Text("게시물 추가"),
        actions: [
          TextButton(onPressed: _addPost, child: Text("등록")),
        ],
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.black
                    ),
                    child: _image != null ? GestureDetector(onTap: _getImage,child: Image.file(_image!),) : IconButton(
                      icon: Icon(Icons.photo, color: Colors.white,),
                      onPressed: _getImage,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top:10, left: 12.0),
                    child: Row(
                      children: [
                        Text("설명",style: CustomTextStyle.settingTitle,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            postContent = value;
                          },
                          decoration: const InputDecoration(labelText: '내용을 입력하세요 (최대 10줄)'),
                          maxLines: 10,
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return "내용을 입력하세요";
                            } return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
