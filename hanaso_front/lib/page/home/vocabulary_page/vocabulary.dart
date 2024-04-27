import 'package:flutter/material.dart';
import 'package:hanaso_front/interface/user_interface.dart';
import 'package:hanaso_front/page/home/vocabulary_page/word_page.dart';

class VocabularyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: ListView(
          children: [
            SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Text('단어장',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

            // ここに全てのカテゴリーリストを追加
            Container(
              margin: const EdgeInsets.only(
                  top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
              child: Column(
                children: [
                  _buildFavoriteTheme(),
                  _buildCategoryList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteTheme() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // Add padding around each card
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: kBorderColor.withOpacity(kBorderOpacity),
              width: kBorderWidth),
          borderRadius: BorderRadius.circular(6),
        ),
        child: InkWell(
          child: ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            title: Text('즐겨찾기'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: 즐겨찾기 페이지로 이동
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    //dummy (not using api, just static)
    // カテゴリーの名前と画像のリスト
    List<Map<String, dynamic>> categories = [
      {'id': 1, 'name': '공항에서', 'image': 'assets/airplane1.png', 'level': 2},
      {'id': 4, 'name': '식당에서', 'image': 'assets/restaurant1.png', 'level': 2},
      {'id': 3, 'name': '영화관에서', 'image': 'assets/theater1.png', 'level': 2},
      {
        'id': 2,
        'name': '편의점에서',
        'image': 'assets/convenience1.png',
        'level': 2
      },
      {'id': 5, 'name': '호텔에서', 'image': 'assets/hotel.png', 'level': 1},

      // その他のカテゴリー項目...
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          // Add padding around each card
          child: Card.outlined(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: kBorderColor.withOpacity(kBorderOpacity),
                  width: kBorderWidth),
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              child: ListTile(
                leading: ClipOval(
                  child: Image.asset(
                    categories[index]['image'],
                    width: 35, // Adjust the size as needed
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(categories[index]['name']),
                subtitle: Text('Level ${categories[index]['level']}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  navigateToPage(context, categories[index]['id']);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

void navigateToPage(BuildContext context, int id) {
  Widget page = WordPage(id: id);

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
