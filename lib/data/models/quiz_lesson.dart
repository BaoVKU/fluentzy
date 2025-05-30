import 'package:fluentzy/data/models/quiz_question.dart';

class QuizLesson {
  String id;
  String name;
  List<QuizQuestion> questions;
  
  QuizLesson({
    required this.id,
    required this.name,
    required this.questions,
  });

  factory QuizLesson.fromJson(Map<String, dynamic> json) {
    return QuizLesson(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}