class QuizQuestion {
  String question;
  List<String> answers;
  int correctIndex;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
      'correctIndex': correctIndex,
    };
  }
}