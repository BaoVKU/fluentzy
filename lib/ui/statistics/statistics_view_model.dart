import 'package:collection/collection.dart';
import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/models/quiz_lesson.dart';
import 'package:fluentzy/data/models/quiz_progress.dart';
import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/models/speaking_progress.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class StatisticsViewModel extends ChangeNotifier {
  final PreferenceService _preferenceService;
  final LessonRepository _lessonRepository;
  final FlashCardRepository _flashCardRepository;

  List<FlashCardSet> _flashCardSets = [];
  List<FlashCardSet> get flashCardSets => _flashCardSets;

  List<SpeakingLesson> _speakingLessons = [];
  List<SpeakingLesson> get speakingLessons => _speakingLessons;

  List<SpeakingProgress> _speakingProgresses = [];
  List<SpeakingProgress> get speakingProgresses => _speakingProgresses;

  List<QuizLesson> _quizLessons = [];
  List<QuizLesson> get quizLessons => _quizLessons;

  List<QuizProgress> _quizProgresses = [];
  List<QuizProgress> get quizProgresses => _quizProgresses;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _todayTipQuote = "";
  String get todayTipQuote => _todayTipQuote;

  StatisticsViewModel(
    this._preferenceService,
    this._lessonRepository,
    this._flashCardRepository,
  ) {
    _initSharedPreferences();
    _initDatas();
  }

  Future<void> _initDatas() async {
    _isLoading = true;
    notifyListeners();
    _flashCardSets = await _flashCardRepository.fetchFlashCardSets();
    _speakingLessons = await _lessonRepository.fetchSpeakingLessons();
    _speakingProgresses = await _lessonRepository.fetchSpeakingProgresses();
    _quizLessons = await _lessonRepository.fetchQuizLessons();
    _quizProgresses = await _lessonRepository.fetchQuizProgresses();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initSharedPreferences() async {
    int lastTipIndex = _preferenceService.fetchLastTipIndex();
    String lastDateStr = _preferenceService.fetchLastActiveDateStr();
    Logger.error("Last tip index: $lastTipIndex");
    Logger.error("Last active date: $lastDateStr");
    DateTime today = DateTime.now();
    DateTime lastDate =
        lastDateStr.isNotEmpty ? DateTime.parse(lastDateStr) : today;
    Logger.error("Last active date: ${lastDate.toIso8601String()}");
    final difference =
        today
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;
    if (difference >= 1 && lastTipIndex < _tipsAndQuotes.length - 1) {
      lastTipIndex++;
      await _preferenceService.updateLastTipIndex(lastTipIndex);
      await _preferenceService.updateLastActiveDateStr(today.toIso8601String());
    }

    _todayTipQuote = _tipsAndQuotes[lastTipIndex];

    notifyListeners();
  }

  int countCompletedFlashCardSets() {
    return _flashCardSets
        .where((fs) => fs.cards.every((card) => card.isLearned))
        .length;
  }

  int countLearnedWords() {
    return _flashCardSets.fold<int>(
      0,
      (sum, cardSet) =>
          sum + cardSet.cards.where((card) => card.isLearned).length,
    );
  }

  int countTotalWords() {
    return _flashCardSets.fold<int>(
      0,
      (sum, cardSet) => sum + cardSet.cards.length,
    );
  }

  int countCompletedSpeakingLessons() {
    return _speakingLessons.where((lesson) {
      final progress = _speakingProgresses.firstWhereOrNull(
        (p) => p.lessonId == lesson.id,
      );
      return progress != null &&
          progress.lastDoneIndex == lesson.sentences.length - 1;
    }).length;
  }

  int countCompletedQuizLessons() {
    return _quizLessons.where((lesson) {
      final progress = _quizProgresses.firstWhereOrNull(
        (p) => p.quizId == lesson.id,
      );
      return progress != null;
    }).length;
  }

  int countCorrectedQuizAnswers() {
    return _quizProgresses.fold<int>(0, (sum, progress) {
      int correctCount = progress.answers.where((a) => a.values.first).length;
      return sum + correctCount;
    });
  }

  int countTotalQuizAnswers() {
    return _quizLessons.fold<int>(
      0,
      (sum, lesson) => sum + lesson.questions.length,
    );
  }

  final List<String> _tipsAndQuotes = [
    "The secret of getting ahead is getting started.",
    "Mistakes are proof that you are trying.",
    "Practice makes progress.",
    "You don’t have to be perfect to be amazing.",
    "Small steps every day lead to big results.",
    "Success is the sum of small efforts, repeated day in and day out. r",
    "Believe in yourself. You can do it.",
    "Learning another language is like becoming another person. ",
    "Never give up. Great things take time.",
    "Push yourself, because no one else is going to do it for you.",
    "Learn 5 new words a day and use them in a sentence.",
    "Speak out loud to improve pronunciation and fluency.",
    "Watch English movies or shows with subtitles.",
    "Practice shadowing: repeat what you hear as quickly and accurately as possible.",
    "Use flashcards daily to review vocabulary.",
    "Record yourself speaking and listen to it to spot mistakes.",
    "Listen to English podcasts during free time.",
    "Try thinking in English instead of translating in your head.",
    "Read children’s books in English for simple grammar and vocabulary.",
    "Don’t be afraid to make mistakes — they help you learn faster.",
  ];

  (String, Color) getLevelBadge(double accuracy) {
    if (accuracy >= 90) {
      return ("C2", Colors.teal);
    } else if (accuracy >= 75) {
      return ("C1", Colors.indigo);
    } else if (accuracy >= 60) {
      return ("B2", Colors.deepPurple);
    } else if (accuracy >= 40) {
      return ("B1", Colors.blue);
    } else if (accuracy >= 20) {
      return ("A2", Colors.lightBlue);
    } else {
      return ("A1", Colors.grey);
    }
  }
}
