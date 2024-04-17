import 'package:flutter/material.dart';

class SpeakingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hanaso'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // アカウントアクション
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('추천 테마',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            // ここにカテゴリーグリッドリストを追加
            _buildCategoryGrid(),
            SizedBox(height: 20),
            Text('전체 테마',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            // ここに全てのカテゴリーリストを追加
            _buildCategoryList(),
          ],
        ),
      ),

    );
  }

  Widget _buildCategoryGrid() {
    // カテゴリーの名前と画像のリスト
    List<Map<String, String>> categories = [
      {'name': '편의점에서', 'image': 'assets/convenience1.png'},
      {'name': '공항에서', 'image': 'assets/airplane1.png'},
      {'name': '영화관에서', 'image': 'assets/theater1.png'},
      {'name': '식당에서', 'image': 'assets/restaurant1.png'},
    ];

    // グリッドリストを作成
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // スクロールしないように設定
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
    return GestureDetector(
    onTap: () {
      // カテゴリーに応じたアクションを定義
      switch (index) {
        case 0: // 「편의점에서」がタップされた時
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConvenienceStorePage()),
          );
          break;
        case 1: // 「공항에서」がタップされた時
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AirportPage()),
          );
          break;
        case 2: // 「영화관에서」がタップされた時
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieTheaterPage()),
          );
          break;
        case 3: // 「식당에서」がタップされた時
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RestaurantPage()),
          );
          break;
      }
    },

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(categories[index]['image']!, width: 80, height: 80),
              // 画像アイコン
              SizedBox(height: 8),
              // スペースを追加
              Text(categories[index]['name']!),
              // カテゴリー名
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryList() {  //dummy
    // カテゴリーの名前と画像のリスト
    List<Map<String, dynamic>> categories = [
      {'name': '공항에서', 'image': 'assets/airplane1.png'},
      {'name': '식당에서', 'image': 'assets/restaurant1.png'},
      {'name': '영화관에서', 'image': 'assets/theater1.png'},
      {'name': '편의점에서', 'image': 'assets/convenience1.png'},
      {'name': '호텔에서', 'image': 'assets/hotel.png'},

      // その他のカテゴリー項目...
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.asset(
              categories[index]['image'],
              width: 56, // サイズは適宜調整
              height: 56,
            ),
            title: Text(categories[index]['name']),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // タップされたときの動作をここに追加
              // 例: Navigator.push(...)
            },
          ),
        );
      },
    );
  }
}

// 以下のように各ページのダミークラスを作成します
class ConvenienceStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('편의점에서')));
}

class AirportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('공항에서')));
}

class MovieTheaterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('영화관에서')));
}

class RestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('식당에서')));
}

