class QuizProgress {
  final String quizId;
  final List<Map<String, bool>> answers;

  QuizProgress({required this.quizId, required this.answers});

  factory QuizProgress.fromJson(Map<String, dynamic> json) {
    return QuizProgress(
      quizId: json['quizId'] as String,
      answers: List<Map<String, bool>>.from(
        (json['answers'] as List).map((item) => Map<String, bool>.from(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'answers': answers};
  }
}
