class QuranWord {
  final int id;
  final String arabic;
  final String transcription;
  final String translation;
  bool isLearned;

  QuranWord({
    required this.id,
    required this.arabic,
    required this.transcription,
    required this.translation,
    this.isLearned = false,
  });

  factory QuranWord.fromJson(Map<String, dynamic> json) {
    return QuranWord(
      id: json['id'],
      arabic: json['arabic'],
      transcription: json['transcription'],
      translation: json['translation'],
      isLearned: json['isLearned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic': arabic,
      'transcription': transcription,
      'translation': translation,
      'isLearned': isLearned,
    };
  }
}
