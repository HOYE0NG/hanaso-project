import 'package:hanaso_front/page/home/my_page/my_page.dart';
import 'package:hanaso_front/page/home/speaking_page/speaking.dart';
import 'package:hanaso_front/page/home/vocabulary_page/vocabulary.dart';
import 'package:hanaso_front/page/home/home_page/home_page.dart';
import 'package:hanaso_front/page/home/chat_page/chat_page.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hanaso_front/interface/user_interface.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final List<Widget> pages = [
    HomePage(),// 홈 페이지
    VocabularyPage(),  // 단어장 페이지
    SpeakingPage(), // 홈 페이지//TODO: 여기 수정하기
    MyPage(), // 마이페이지
    ChatPage() // 자유대화->언어레벨측정 페이지
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 35),
        centerTitle: true,// 앱 로고
        actions: <Widget>[
          IconButton(
            icon: FutureBuilder<String>(
              future: SharedPreferences.getInstance().then((prefs) {
                  String? relativeUrl = prefs.getString('userProfileImageUrl');
                  return Future.value(relativeUrl != null ? '$BASE_URL/api/img' + relativeUrl : '');
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                  return Icon(Icons.account_circle);
                } else {
                  return ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // 외곽선의 색상
                          width: 1, // 외곽선의 두께
                        ),
                        shape: BoxShape.circle, // 외곽선의 모양
                      ),
                      child: Image.network(snapshot.data!, fit: BoxFit.cover, width: 30, height: 30),
                    ),
                  );
                }
              },
            ),
            onPressed: () {
              //TODO: 아이콘 누르면-> 로그아웃 하기 뜨기
              
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '단어장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette_rounded),
            label: '테마',
          ),
        //마이페이지
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '마이페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker),
            label: '자기소개',
          ),
        ],
        currentIndex: index,
        selectedItemColor: Colors.amber[800],
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: pages,
        ),
      ),
    );
  }
}


