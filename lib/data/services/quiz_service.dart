import 'dart:convert';

import 'package:fluentzy/data/models/quiz_lesson.dart';
class QuizService {
  final String fakeQuizJson = """
  {
  "id": "89898",
  "name": "English Grammar Quiz – Beginner Level",
  "questions": [
    {
      "question": "She ____ to school every day.",
      "answers": ["go", "going", "goes", "gone"],
      "correctIndex": 2
    },
    {
      "question": "I saw ____ elephant at the zoo.",
      "answers": ["a", "an", "the", "no article"],
      "correctIndex": 1
    },
    {
      "question": "The book is ____ the table.",
      "answers": ["on", "in", "at", "by"],
      "correctIndex": 0
    },
    {
      "question": "They ____ playing football now.",
      "answers": ["is", "are", "was", "were"],
      "correctIndex": 1
    },
    {
      "question": "He ____ his homework yesterday.",
      "answers": ["do", "does", "did", "doing"],
      "correctIndex": 2
    },
    {
      "question": "We ____ to the cinema last week.",
      "answers": ["go", "went", "going", "gone"],
      "correctIndex": 1
    },
    {
      "question": "She is ____ than her brother.",
      "answers": ["tall", "taller", "tallest", "more tall"],
      "correctIndex": 1
    },
    {
      "question": "I have never ____ sushi before.",
      "answers": ["eat", "eats", "eating", "eaten"],
      "correctIndex": 3
    },
    {
      "question": "They will ____ a party next week.",
      "answers": ["have", "has", "had", "having"],
      "correctIndex": 0
    },
    {
      "question": "The weather is very ____ today.",
      "answers": ["nice", "nicely", "nicer", "nicest"],
      "correctIndex": 0
    }
  ]
}
""";

  QuizLesson fetchFakeLesson() {
    final Map<String, dynamic> data = json.decode(fakeQuizJson);
    return QuizLesson.fromJson(data);
  }
}