import 'package:flutter/material.dart';
import 'package:hanaso_front/model/sentence.dart';
import 'package:hanaso_front/service/api_client.dart';

class SentencePage extends StatefulWidget {
  final int theme;

  SentencePage({required this.theme});

  @override
  _SentencePageState createState() => _SentencePageState();
}

class _SentencePageState extends State<SentencePage> {
  late Future<List<Sentence>> futureSentences;

  @override
  void initState() {
    super.initState();
    futureSentences = ApiClient().getSentences(widget.theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('테마별 연습')),
      body: FutureBuilder<List<Sentence>>(
        future: futureSentences,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SentenceTile(sentence: snapshot.data![index]);
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

class SentenceTile extends StatelessWidget {
  final Sentence sentence;

  SentenceTile({required this.sentence});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sentence.sentence),
      subtitle: Text(sentence.koreanMeaning),
    );
  }
}