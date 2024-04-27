class Word {
  final String id;
  final String word;
  final String meaning;
  final bool isStar;
  final String soundUrl;

  Word({required this.id, required this.word, required this.meaning, required this.isStar, required this.soundUrl});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['_id'],
      word: json['word'],
      meaning: json['meaning'],
      isStar: json['isStar'],
      soundUrl: json['soundUrl'],
    );
  }
}