import 'package:flutter/material.dart';
import 'package:hanaso_front/model/sentence.dart';
import 'package:hanaso_front/service/api_client.dart';
import 'package:audioplayers/audioplayers.dart';

class SentencePage extends StatefulWidget {
  final int theme;
  final String themeName;

  SentencePage({required this.theme, required this.themeName});

  @override
  _SentencePageState createState() => _SentencePageState();
}

class _SentencePageState extends State<SentencePage> {
  late Future<List<Sentence>> futureSentences;
  int currentIndex = 0; // Add this line
  int totalLength = 0;

  @override
  void initState() {
    super.initState();
    futureSentences = ApiClient().getSentences(widget.theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.themeName}')),
      body: FutureBuilder<List<Sentence>>(
        future: futureSentences,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            totalLength = snapshot.data!.length;
            return SentenceTile(
              sentence: snapshot.data![currentIndex],
              currentIndex: currentIndex,
              // Pass currentIndex to SentenceTile
              totalLength: totalLength,
              onNext: () {
                setState(() {
                  if (currentIndex < snapshot.data!.length - 1) {
                    currentIndex++;
                  }
                });
              },
              onPrev: () {
                setState(() {
                  if (currentIndex > 0) {
                    currentIndex--;
                  }
                });
              },
            ); // Change this line
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class _SentenceTileState extends State<SentenceTile> {
  String? selectedChoice;
  bool? isCorrect;
  late List<String> shuffledChoices;
  late AudioPlayer player;
  late ApiClient _apiClient;


  @override
  void initState() {
    super.initState();
    shuffledChoices = List<String>.from(widget.sentence.choices);
    shuffledChoices.shuffle();
    player = AudioPlayer();
    _apiClient = ApiClient();
  }

  @override
  void dispose() async {
    player.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SentenceTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sentence != widget.sentence) {
      shuffledChoices = List<String>.from(widget.sentence.choices);
      shuffledChoices.shuffle();
      setState(() {
        selectedChoice = null;
        isCorrect = null;
      });
    }
  }

  Future<void> _playAudio(String text) async {
    try {

      String audioUrl = await _apiClient.fetchAudioUrl(text);
      await player.setVolume(1.0);
      await player.play(DeviceFileSource(audioUrl));
    } catch (e) {
      print('Failed to play audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String sentenceWithBlank = widget.sentence.sentence
        .replaceAll(widget.sentence.blankWord, '______');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.currentIndex + 1}/${widget.totalLength}',
          // Display currentIndex and totalLength
          style: TextStyle(fontSize: 24),
        ),
    Container(

    margin: const EdgeInsets.only(left:20.0,right:20.0), // Add padding here
    child:
    Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.volume_up),
                onPressed:() {
                  _playAudio(widget.sentence.sentence); // Play the sentence audio
                },
              ),
              Expanded( // Add this line
                child: Text(
                  sentenceWithBlank,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],

        ),
    ),
        Text(
          widget.sentence.koreanMeaning,
          style: TextStyle(fontSize: 18),
        ),
        ...shuffledChoices.map((choice) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            // Decrease vertical padding
            child: ElevatedButton(
              child: Text(
                choice,
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                setState(() {
                  selectedChoice = choice;
                  isCorrect = choice == widget.sentence.blankWord;
                });
                if (isCorrect!) {
                  await player.play(AssetSource('correct_sound.mp3'));
                } else {
                  await player.play(AssetSource('wrong_sound.mp3'));
                }
              },
            ),
          );
        }).toList(),
        if (selectedChoice != null)
          Text(
            isCorrect! ? 'O' : 'X',
            style: TextStyle(
              fontSize: 30,
              color: isCorrect! ? Colors.green : Colors.red,
            ),
          )
        else
          SizedBox(height: 45),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                disabledForegroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: widget.currentIndex > 0 ? widget.onPrev : null,
            ),
            ElevatedButton(
              child: Icon(Icons.arrow_forward),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                disabledForegroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: widget.currentIndex < widget.totalLength - 1
                  ? widget.onNext
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class SentenceTile extends StatefulWidget {
  final Sentence sentence;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final int currentIndex;
  final int totalLength;

  SentenceTile({
    required this.sentence,
    required this.onNext,
    required this.onPrev,
    required this.currentIndex, // Add this line
    required this.totalLength, // Add this line
  });

  @override
  _SentenceTileState createState() => _SentenceTileState();
}
