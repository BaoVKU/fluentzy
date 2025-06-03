import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/repositories/flash_card_repository.dart';
import 'package:flutter/material.dart';

class FlashCardListViewModel extends ChangeNotifier {
  final FlashCardRepository _flashCardRepository;
  
  List<FlashCardSet> _flashCardSets = [];
  List<FlashCardSet> get flashCardSets => _flashCardSets;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  FlashCardListViewModel(this._flashCardRepository) {
    _fetchFlashCardSets();
  }

  Future<void> _fetchFlashCardSets() async {
    _isLoading = true;
    notifyListeners();
    _flashCardSets = await _flashCardRepository.fetchFlashCardSets();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteFlashCardSet(String id) async {
    await _flashCardRepository.deleteFlashCardSet(id);
    _fetchFlashCardSets();
  }

  int getTotalCards(int index) {
    return _flashCardSets[index].cards.length;
  }

  int getLearnedCards(int index) {
    return _flashCardSets[index].cards.where((card) => card.isLearned).length;
  }
}
