import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsViewModel extends ChangeNotifier {
  SharedPreferences? pref;
  String _todayTipQuote = "";
  String get todayTipQuote => _todayTipQuote;
  StatisticsViewModel() {
    init();
  }

  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
    int lastTipQuoteIndex = pref?.getInt('lastTipQuoteIndex') ?? 0;
    String? lastDateStr = pref?.getString('lastActiveDate');
    DateTime today = DateTime.now();
    DateTime lastDate =
        lastDateStr != null ? DateTime.parse(lastDateStr) : today;
    final difference =
        today
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;
    if (difference >= 1 && lastTipQuoteIndex < _tipsAndQuotes.length - 1) {
      lastTipQuoteIndex++;
      pref?.setInt('lastTipQuoteIndex', lastTipQuoteIndex);
      pref?.setString('lastActiveDate', today.toIso8601String());
    }

    _todayTipQuote = _tipsAndQuotes[lastTipQuoteIndex];

    notifyListeners();
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
