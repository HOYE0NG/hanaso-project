import 'package:hanaso_front/page/home/my_page/my_page.dart';
import 'package:hanaso_front/page/home/speaking_page/speaking.dart';
//import 'package:capstone2/page/home/vocabulary_page/vocabulary.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final List<Widget> pages = [
    SpeakingPage(), // 홈 페이지
    //VocabularyPage(), // 단어장 페이지
    //MyPage(), // 마이 페이지
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: '대화',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            label: '단어장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: '학습기록',
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
