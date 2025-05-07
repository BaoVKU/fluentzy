// quiz_repository.dart
import '../models/quiz_model.dart';

class QuizRepository {
  List<Quiz> getQuizzes() {
    return [
      Quiz(
        question: "What is the synonym of 'happy'?",
        options: ["Sad", "Joyful", "Angry", "Cry"],
        correctOptionIndex: 1,
      ),
      Quiz(
        question: "What is the opposite of 'big'?",
        options: ["Large", "Huge", "Tiny", "Massive"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "Which of these is the capital of France?",
        options: ["London", "Berlin", "Paris", "Madrid"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "Which planet is known as the Red Planet?",
        options: ["Earth", "Mars", "Jupiter", "Venus"],
        correctOptionIndex: 1,
      ),
      Quiz(
        question: "Who wrote 'Romeo and Juliet'?",
        options: ["Shakespeare", "Dickens", "Hemingway", "Twain"],
        correctOptionIndex: 0,
      ),
      Quiz(
        question: "What is the square root of 64?",
        options: ["6", "7", "8", "9"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "What is the largest ocean on Earth?",
        options: ["Atlantic", "Indian", "Arctic", "Pacific"],
        correctOptionIndex: 3,
      ),
      Quiz(
        question: "Which animal is known as the King of the Jungle?",
        options: ["Elephant", "Tiger", "Lion", "Bear"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "What is the chemical symbol for water?",
        options: ["H2O", "O2", "CO2", "H2"],
        correctOptionIndex: 0,
      ),
      Quiz(
        question: "Which country is known as the Land of the Rising Sun?",
        options: ["China", "South Korea", "Japan", "India"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "What is the currency of the United Kingdom?",
        options: ["Euro", "Pound", "Dollar", "Yen"],
        correctOptionIndex: 1,
      ),
      Quiz(
        question: "What is the tallest mountain in the world?",
        options: ["Mount Everest", "K2", "Kangchenjunga", "Mount Kilimanjaro"],
        correctOptionIndex: 0,
      ),
      Quiz(
        question: "What color do you get when you mix red and yellow?",
        options: ["Orange", "Purple", "Green", "Blue"],
        correctOptionIndex: 0,
      ),
      Quiz(
        question: "What is the boiling point of water?",
        options: ["90°C", "95°C", "100°C", "105°C"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "Which element has the chemical symbol 'O'?",
        options: ["Oxygen", "Osmium", "Ozone", "Opium"],
        correctOptionIndex: 0,
      ),
      Quiz(
        question: "What is the fastest land animal?",
        options: ["Cheetah", "Lion", "Tiger", "Leopard"],
        correctOptionIndex: 0,
      ),
      Quiz(
        question: "What is the national flower of Japan?",
        options: ["Rose", "Tulip", "Cherry Blossom", "Lily"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "Which country is famous for the Great Wall?",
        options: ["India", "China", "Russia", "Mexico"],
        correctOptionIndex: 1,
      ),
      Quiz(
        question: "Which of these is a primary color?",
        options: ["Orange", "Green", "Yellow", "Purple"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "What is the capital of Japan?",
        options: ["Seoul", "Beijing", "Tokyo", "Osaka"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "What is the smallest continent?",
        options: ["Africa", "Asia", "Australia", "Europe"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "Which of these animals is a mammal?",
        options: ["Shark", "Eagle", "Dolphin", "Lizard"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "Which is the largest planet in the solar system?",
        options: ["Earth", "Mars", "Jupiter", "Saturn"],
        correctOptionIndex: 2,
      ),
      Quiz(
        question: "What is the largest desert in the world?",
        options: ["Sahara", "Arabian", "Gobi", "Antarctic"],
        correctOptionIndex: 3,
      ),
      Quiz(
        question: "Which country is the Eiffel Tower located in?",
        options: ["France", "Germany", "Italy", "Spain"],
        correctOptionIndex: 0,
      )
    ];
  }
}
