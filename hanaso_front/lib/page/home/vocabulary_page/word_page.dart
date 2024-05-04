import 'package:flutter/material.dart';
import 'package:hanaso_front/model/word.dart';
import 'package:hanaso_front/service/api_client.dart';

class WordPage extends StatefulWidget {
  final int id;

  WordPage({required this.id});

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late Future<List<Word>> futureWords;

  @override
  void initState() {
    super.initState();
    futureWords = ApiClient().getWords(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('단어장')),
      body: FutureBuilder<List<Word>>(
        future: futureWords,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return WordTile(word: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
// In `lib/page/vocabulary_page/word_page.dart`

class WordTile extends StatefulWidget {
  final Word word;

  WordTile({required this.word});

  @override
  _WordTileState createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  bool isStar=false;

  @override
  void initState() {
    super.initState();
    isStar = widget.word.isStar;
  }

  void toggleStar() async {
    try {
      if (isStar) {
        //print('removeFavorite');
        await ApiClient().removeFavorite(widget.word.id);
      } else {
        //print('addFavorite');
        await ApiClient().addFavorite(widget.word.id);
      }
      setState(() {
        isStar = !isStar;
        //print(isStar);
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
      padding: EdgeInsets.symmetric(horizontal: 3.0), // 좌우 패딩 추가
      decoration: BoxDecoration(
       // border: Border.all(color: kBorderColor.withOpacity(kBorderOpacity), width: kBorderWidth), // 테두리 추가
        //borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
      ),
      child: ListTile(
        title: Text(widget.word.word),
        subtitle: Text(widget.word.meaning),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isStar ? Icons.star : Icons.star_border),
              onPressed: toggleStar,
            ),
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                // TODO: Implement sound playing functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}