import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class FlashCardLearnViewModel extends ChangeNotifier {
  final FlashCardRepository _flashCardRepository;
  FlashCardSet? _flashCardSet;
  FlashCardSet? get flashCardSet => _flashCardSet;
  FlashCardSet? _oldFlashCardSet;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  bool _isCardFlipped = false;
  bool get isCardFlipped => _isCardFlipped;

  FlashCardLearnViewModel(this._flashCardRepository, this._flashCardSet) {
    _oldFlashCardSet = _flashCardSet;
  }

  void nextCard() {
    if (_flashCardSet != null) {
      if (_currentIndex < _flashCardSet!.cards.length - 1) {
        _currentIndex++;
        Logger.error("${_flashCardSet!.toJson()}");
        Logger.error("${_flashCardSet == _oldFlashCardSet}");
        notifyListeners();
      }
    }
  }

  void undoCard() {
    if (_flashCardSet != null) {
      if (_currentIndex > 0) {
        _currentIndex--;
        _flashCardSet!.cards[_currentIndex].isLearned =
            _oldFlashCardSet!.cards[_currentIndex].isLearned;
        notifyListeners();
      }
    }
  }

  void setCardLearned(bool isLearned) {
    if (_flashCardSet != null) {
      _flashCardSet!.cards[_currentIndex].isLearned = isLearned;
      notifyListeners();
    }
  }

  int getTotalCards() {
    return _flashCardSet?.cards.length ?? 0;
  }

  int getLearnedCards() {
    return _flashCardSet?.cards.where((card) => card.isLearned).length ?? 0;
  }

  void flipCard() {
    _isCardFlipped = !_isCardFlipped;
    notifyListeners();
  }

  Future<void> saveFlashCardSet() async {
    if (_checkIfCardSetChanged()) {
      return;
    }
    if (_flashCardSet != null) {
      await _flashCardRepository.saveFlashCardSet(_flashCardSet!);
    }
  }

  bool _checkIfCardSetChanged() {
    for (int i = 0; i < _flashCardSet!.cards.length; i++) {
      if (_flashCardSet!.cards[i].isLearned !=
          _oldFlashCardSet!.cards[i].isLearned) {
        return true;
      }
    }
    return false;
  }
}
