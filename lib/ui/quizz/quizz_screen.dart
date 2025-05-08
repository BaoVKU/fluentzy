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
  List<Quiz> quizzes = [];
  int currentQuestion = 0;
  int? selectedOption;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    quizzes = await QuizRepository().getQuizzes();
    setState(() {
      isLoading = false;
    });
  }

  void checkAnswer() {
    final bool isCorrect =
        selectedOption == quizzes[currentQuestion].correctOptionIndex;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Wrong answer'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );

    setState(() {
      selectedOption = null;
      currentQuestion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentQuestion >= quizzes.length) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.go(RoutePath.home),
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          title: const Text("Quiz Complete"),
          backgroundColor: AppColors.background,
        ),
        body: const Center(
          child: Text(
            "You completed the quiz!",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    final quiz = quizzes[currentQuestion];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(RoutePath.home),
          icon: SvgPicture.asset("assets/back.svg"),
        ),
        title: const Text("English Quiz"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                quiz.question,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
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
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                onPressed: selectedOption == null ? null : checkAnswer,
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
