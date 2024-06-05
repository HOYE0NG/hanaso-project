class Sentence {
  final int theme;
  final String sentence;
  final String blankWord;
  final String koreanMeaning;
  final List<String> choices;

  Sentence({
    required this.theme,
    required this.sentence,
    required this.blankWord,
    required this.koreanMeaning,
    required this.choices,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {

    return Sentence(
      theme: json['theme'],
      sentence: json['sentence'],
      blankWord: json['blankWord'],
      koreanMeaning: json['koreanMeaning'],
      choices: List<String>.from(json['choices'].map((x) => x)),
    );
  }

}