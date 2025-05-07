// quiz_model.dart
class Quiz {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Quiz({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}
