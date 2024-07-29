import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final User user;
  const PostDetailPage({super.key, required this.post, required this.user});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState(post: post, user: user);
}

class _PostDetailPageState extends State<PostDetailPage> {
  _PostDetailPageState({required this.user, required this.post});
  final Map<String, dynamic> post;
  final User user;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final _userUpdateRef = FirebaseDatabase.instance.ref().child('users');
  final TextEditingController _commentController = TextEditingController();
  String _nickname = '';
  String _profileImg = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String _formatTimestamp(int timestamp) {
    final date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    final format = new DateFormat('yyyy-MM-dd HH:mm');
    return format.format(date);
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      final author = user.displayName ?? 'Anonymous'; // or any user name field
      final postId = post['key'];

      final newCommentRef = _database.ref('posts/$postId/comments').push();
      await newCommentRef.set({
        'text': text,
        'author': _nickname,
        'author_img' : _profileImg,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      _commentController.clear();

      // Close the keyboard
      FocusScope.of(context).unfocus();
    }
  }

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post['profile_img']),
                    radius: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['nickname'], style: CustomTextStyle.postprofile,),
                        Text(_formatTimestamp(post['timestamp'])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(post['text'], style: CustomTextStyle.content,),
                ],
              ),
            ),
            post['img'] != "" ?
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(post['img']),
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
              ),
            ) : SizedBox(),
            const Padding(
              padding: EdgeInsets.only(top:12.0, left: 12.0),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline,size: 20,),
                  SizedBox(width: 8,),
                  Text("댓글",style: CustomTextStyle.settingTitle,)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(_profileImg),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: '댓글을 작성하세요...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addComment,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: StreamBuilder(
                      stream: _database.ref('posts/${post['key']}/comments').orderByChild('timestamp').onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                          return Center(child: Text('No comments yet'));
                        }

                        Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
                        List<Map<String, dynamic>> comments = [];
                        data.forEach((key, value) => comments.add({"key": key, ...value}));
                        comments.sort((a, b) => a['timestamp'].compareTo(b['timestamp'])); // sort by timestamp

                        return ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Container(
                              padding: EdgeInsets.only(top: 10, left: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(backgroundImage: NetworkImage(comment['author_img']), radius: 18,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10,bottom: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comment['author']),
                                        Text(_formatTimestamp(comment['timestamp'])),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(comment['text']),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            );
                          },
                        );
                      },
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
