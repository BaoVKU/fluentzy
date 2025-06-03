import 'package:fluentzy/data/models/quiz_lesson.dart';
import 'package:fluentzy/data/models/quiz_progress.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';

class QuizLearnViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  QuizLesson? _lesson;
  QuizLesson? get lesson => _lesson;

  bool _isResultShown = false;
  bool get isResultShown => _isResultShown;

  bool _isAnswerCorrect = false;
  bool get isAnswerCorrect => _isAnswerCorrect;

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;

  int _selectedAnswerIndex = -1;
  int get selectedAnswerIndex => _selectedAnswerIndex;

  List<Map<String, bool>> _answers = [];
  List<Map<String, bool>> get answers => _answers;

  late List<Map<String, dynamic>> _answerButtonStates;
  List<Map<String, dynamic>> get answerButtonStates => _answerButtonStates;

  QuizLearnViewModel(this._lessonRepository, _lessonId) {
    _fetchLessonById(id: _lessonId);
  }

  void _fetchLessonById({required id}) async {
    if (_lesson != null) return;
    _lesson = await _lessonRepository.fetchQuizLessonById(id);
    _answerButtonStates = List.generate(
      _lesson!.questions.length,
      (index) => {
        'backgroundColor': AppColors.background,
        'borderColor': AppColors.border,
        'borderWidth': 2,
      },
    );
    notifyListeners();
  }
  
  void _updateAnswerButtonStates({
    int? selectedIndex,
    bool showResult = false,
    bool isCorrect = false,
    int? correctIndex,
  }) {
    for (int i = 0; i < _answerButtonStates.length; i++) {
      if (showResult) {
        if (i == selectedIndex) {
          _answerButtonStates[i]['backgroundColor'] =
              isCorrect ? AppColors.successLight : AppColors.errorLight;
          _answerButtonStates[i]['borderColor'] =
              isCorrect ? AppColors.success : AppColors.error;
          _answerButtonStates[i]['borderWidth'] = 2;
        } else if (i == correctIndex) {
          _answerButtonStates[i]['backgroundColor'] = AppColors.successLight;
          _answerButtonStates[i]['borderColor'] = AppColors.success;
          _answerButtonStates[i]['borderWidth'] = 2;
        } else {
          _answerButtonStates[i]['backgroundColor'] = AppColors.background;
          _answerButtonStates[i]['borderColor'] = AppColors.border;
          _answerButtonStates[i]['borderWidth'] = 1;
        }
      } else {
        _answerButtonStates[i]['backgroundColor'] =
            i == selectedIndex
                ? AppColors.surfacePrimary
                : AppColors.background;
        _answerButtonStates[i]['borderColor'] =
            i == selectedIndex ? AppColors.primary : AppColors.border;
        _answerButtonStates[i]['borderWidth'] = i == selectedIndex ? 2 : 1;
      }
    }
  }

  void _resetAnswerButtonStates() {
    for (final state in _answerButtonStates) {
      state['backgroundColor'] = AppColors.background;
      state['borderColor'] = AppColors.border;
      state['borderWidth'] = 1;
    }
  }

  void selectAnswer(int index) {
    _selectedAnswerIndex = index;
    _updateAnswerButtonStates(selectedIndex: index);
    notifyListeners();
  }

  void showResult() {
    _isResultShown = true;
    final correctIdx = _lesson?.questions[_currentQuestionIndex].correctIndex;
    _isAnswerCorrect = correctIdx == _selectedAnswerIndex;
    _answers.add({_selectedAnswerIndex.toString(): _isAnswerCorrect});
    _updateAnswerButtonStates(
      selectedIndex: _selectedAnswerIndex,
      showResult: true,
      isCorrect: _isAnswerCorrect,
      correctIndex: correctIdx,
    );
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _lesson!.questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = -1;
      _isResultShown = false;
      _resetAnswerButtonStates();
      notifyListeners();
    } else {
      // Handle end of quiz logic here
    }
  }

  Future<void> saveProgress() async {
    if (_lesson == null) return;
    final QuizProgress progress = QuizProgress(
      quizId: _lesson!.id,
      answers: _answers,
    );
    await _lessonRepository.saveQuizProgress(quizProgress: progress);
  }
}
