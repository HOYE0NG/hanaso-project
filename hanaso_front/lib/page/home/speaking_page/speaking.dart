import 'package:flutter/material.dart';
//import user interface
import 'package:hanaso_front/interface/user_interface.dart';

class SpeakingPage extends StatelessWidget {
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
              child: Text('추천 테마',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            // ここにカテゴリーグリッドリストを追加(category grid list)
            Container(
              margin: const EdgeInsets.only(
                  top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
              child: _buildCategoryGrid(),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Text('전체 테마',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            // ここに全てのカテゴリーリストを追加
            Container(
              margin: const EdgeInsets.only(
                  top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
              child: _buildCategoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    // カテゴリーの名前と画像のリスト (static.. not using api;()
    List<Map<String, dynamic>> categories = [
      {'id':1,'name': '편의점에서', 'image': 'assets/convenience1.png'},
      {'id':2,'name': '공항에서', 'image': 'assets/airplane1.png'},
      {'id':3,'name': '영화관에서', 'image': 'assets/theater1.png'},
      {'id':4,'name': '식당에서', 'image': 'assets/restaurant1.png'},
    ];

    // グリッドリストを作成
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // スクロールしないように設定
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return InkWell(
              onTap: () {
                navigateToPage(context, categories[index]['id']);
              },
              child: Container(
                //margin: EdgeInsets.symmetric(horizontal: 10),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: kBorderColor.withOpacity(kBorderOpacity),
                        width: kBorderWidth
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align text to the start
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset(categories[index]['image']!,
                              width: 80, height: 80),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        // Add padding to the left of the text
                        child: Text(categories[index]['name']!),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryList() {
    //dummy (not using api, just static)
    // カテゴリーの名前と画像のリスト
    List<Map<String, dynamic>> categories = [
      {'id':2,'name': '공항에서', 'image': 'assets/airplane1.png', 'level': 2},
      {'id':4,'name': '식당에서', 'image': 'assets/restaurant1.png', 'level': 2},
      {'id':3,'name': '영화관에서', 'image': 'assets/theater1.png', 'level': 2},
      {'id':1,'name': '편의점에서', 'image': 'assets/convenience1.png', 'level': 2},
      {'id':5,'name': '호텔에서', 'image': 'assets/hotel.png', 'level': 1},

      // その他のカテゴリー項目...
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0), // Add padding around each card
          child: Card.outlined(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kBorderColor.withOpacity(kBorderOpacity),
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

//how can i use this function both in grid and list?
//-> add 'id' to the map and pass it to the function
void navigateToPage(BuildContext context, int id) {
  Widget page;
  switch (id) {
    case 1:
      page = ConvenienceStorePage();
      break;
    case 2:
      page = AirportPage();
      break;
    case 3:
      page = MovieTheaterPage();
      break;
    case 4:
      page = RestaurantPage();
      break;
    case 5:
      page = RestaurantPage();
      break;
    default:
      page = RestaurantPage(); // TODO: fix it to the default page
      break;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}


//TODO: it would be better to separate each page into different files(in my opinion!)
// 以下のように各ページのダミークラスを作成します
class ConvenienceStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('편의점에서')));
}

class AirportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('공항에서')));
}

class MovieTheaterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('영화관에서')));
}

class RestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('식당에서')));
}
class HotelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('호텔에서')));
}
class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('기본페이지')));
}