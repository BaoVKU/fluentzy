import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/repositories/quiz_repository.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Quiz> quizzes = QuizRepository().getQuizzes();
  int currentQuestion = 0;
  int? selectedOption;

  void checkAnswer() {
    final bool isCorrect =
        selectedOption == quizzes[currentQuestion].correctOptionIndex;

    // Hiển thị SnackBar với màu sắc tương ứng
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Wrong answer'),
        backgroundColor:
            isCorrect ? Colors.green : Colors.red, // Màu sắc của SnackBar
      ),
    );

    setState(() {
      selectedOption = null;
      currentQuestion++;
    });
  }

  void endQuiz() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= quizzes.length) {
      return Center(child: Text("You completed the quiz!"));
    }

    final quiz = quizzes[currentQuestion];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {context.go(RoutePath.home)},
          icon: SvgPicture.asset("assets/back.svg"),
        ),
        title: const Text("English Quiz"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(quiz.question, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ...List.generate(
              quiz.options.length,
              (index) => ListTile(
                title: Text(quiz.options[index]),
                leading: Radio(
                  value: index,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedOption == null ? null : checkAnswer,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: endQuiz, // Khi nhấn sẽ quay lại trang trước
            //   child: const Text("End Quiz"),
            // ),
          ],
        ),
      ),
    );
  }
}
