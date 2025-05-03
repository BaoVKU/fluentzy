import 'package:fluentzy/data/models/flash_card.dart';
import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class FlashCardEditViewModel extends ChangeNotifier {
  final FlashCardRepository _flashCardRepository;
  FlashCardSet? _flashCardSet;
  FlashCardSet? get flashCardSet => _flashCardSet;
  bool _isOperationSuccessful = false;
  bool get isOperationSuccessful => _isOperationSuccessful;
  FlashCardEditViewModel(this._flashCardRepository, this._flashCardSet);

  Future<void> saveFlashCardSet({
    required String setName,
    required List<TextEditingController> wordControllers,
    required List<TextEditingController> descControllers,
  }) async {
    final List<FlashCard> validCards = [];

    for (int i = 0; i < wordControllers.length; i++) {
      final word = wordControllers[i].text.trim();
      if (word.isEmpty) continue;

      final description = descControllers[i].text.trim();
      validCards.add(FlashCard(word: word, description: description));
    }

    final flashCardSet = FlashCardSet(
      id: _flashCardSet?.id ?? '',
      name: setName.trim(),
      cards: validCards,
    );

    await _flashCardRepository.saveFlashCardSet(flashCardSet);

    _isOperationSuccessful = true;
    notifyListeners();
  }
}
