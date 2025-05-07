class QuizResult {
  final int correctAnswers;
  final int totalQuestions;

  QuizResult({required this.correctAnswers, required this.totalQuestions});

  double get score => (correctAnswers / totalQuestions) * 100;

  String get resultMessage {
    if (score >= 90) {
      return 'Excellent!';
    } else if (score >= 70) {
      return 'Good Job!';
    } else {
      return 'Try Again!';
    }
  }
}
