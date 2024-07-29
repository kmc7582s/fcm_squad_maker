import 'dart:async';

import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:fcmobile_squad_maker/models/player.dart';
import 'package:fcmobile_squad_maker/pages/home/add_post_page.dart';
import 'package:fcmobile_squad_maker/pages/home/post_detail.dart';
import 'package:fcmobile_squad_maker/widgets/top_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({required this.user});

  final _database = FirebaseDatabase.instance.ref();
  final User user;
  List<Player> topPlayers = [];

  @override
  void initState() {
    super.initState();
  }

  // 새로고침 함수
  Future<void> _refreshData() async {
    // 네트워크 요청이나 데이터베이스 쿼리 등을 시뮬레이션
    await Future.delayed(Duration(seconds: 2));

    // 데이터 업데이트 (예를 들어, 목록에 새 항목 추가)
    setState(() {
      TopPlayersWidget();
    });
  }

  // 좋아요 기능
  Future<void> _toggleLike(String postId, bool isLiked) async {
    final userId = user.uid; // 현재 사용자의 ID
    final postRef = _database.child('posts/$postId/likes/users/$userId');

    if (isLiked) {
      // 이미 좋아요를 눌렀다면, 좋아요를 취소합니다.
      await postRef.remove();
      await _database.child('posts/$postId/likes/count').set(ServerValue.increment(-1));
    } else {
      // 좋아요를 누르지 않았다면, 좋아요를 추가합니다.
      await postRef.set(true);
      await _database.child('posts/$postId/likes/count').set(ServerValue.increment(1));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPostPage(user: user,))),
        backgroundColor: Colors.blue.withOpacity(0.9),
        child: Icon(Icons.add, color: Colors.white,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Make it round
        ),
        elevation: 4.0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              title: Text(
                "홈",
                style: CustomTextStyle.appbarTitle,
              ),
              centerTitle: false,
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16, left: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.red),
                          Text("Hot Player Top7", style: CustomTextStyle.settingTitle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TopPlayersWidget(), // Assuming this widget is defined elsewhere
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: _database.child('posts').orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No data available')),
                  );
                }

                Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
                List<Map<String, dynamic>> posts = [];
                data.forEach((key, value) => posts.add({"key": key, ...value}));
                posts.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                String _formatTimestamp(int timestamp) {
                  final date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
                  final format = new DateFormat('yyyy년 MM월 dd일 HH:mm');
                  return format.format(date);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final post = posts[index];
                          final postId = post['key'];
                          final likeCount = post['likes']?['count'] ?? 0;
                          final userLiked = post['likes']?['users']?[user.uid] != null;

                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetailPage(post: post, user: user,))),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(posts[index]['profile_img']),
                                radius: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(posts[index]['nickname']),
                                    Text(_formatTimestamp(posts[index]['timestamp'])),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                                      child: Text(posts[index]['text']),
                                    ),
                                    posts[index]['img'] != "" ?
                                    Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(posts[index]['img']),
                                          fit: BoxFit.cover, // Ensure the image covers the container
                                        ),
                                      ),
                                    ) : SizedBox(),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetailPage(post: post, user: user))),
                                            icon: const Icon(Icons.chat_bubble_outline,size: 12,)
                                        ),
                                        Text("댓글"),
                                        IconButton(
                                            onPressed: () => _toggleLike(postId, userLiked),
                                            icon: Icon(userLiked ? Icons.favorite : Icons.favorite_border, color: userLiked? Colors.red : null, size: 12,),
                                        ),
                                        Text("$likeCount"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: posts.length, // The length of the posts list
                  ),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}
