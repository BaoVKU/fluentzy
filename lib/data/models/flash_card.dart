class FlashCard {
  final String word;
  final String description;
  bool isLearned;

  FlashCard({
    required this.word,
    this.description = '',
    this.isLearned = false,
  });

  FlashCard copy() {
    return FlashCard(
      word: word,
      description: description,
      isLearned: isLearned,
    );
  }

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      word: json['word'] ?? '',
      description: json['description'] ?? '',
      isLearned: json['isLearned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'word': word, 'description': description, 'isLearned': isLearned};
  }
}
