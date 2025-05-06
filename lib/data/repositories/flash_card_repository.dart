import 'package:fluentzy/data/models/flash_card_set.dart';
import 'package:fluentzy/data/services/flash_card_service.dart';

class FlashCardRepository {
  final FlashCardService _flashCardService;
  FlashCardRepository(this._flashCardService);

  Future<List<FlashCardSet>> fetchFlashCardSets() async {
    return await _flashCardService.fetchFlashCardSets();
  }

  Future<FlashCardSet?> fetchFlashCardSetById(String id) async {
    return await _flashCardService.fetchFlashCardSetById(id);
  }

  Future<String> saveFlashCardSet(FlashCardSet cardSet) async {
    if (cardSet.id.isEmpty) {
      return await _flashCardService.createFlashCardSet(cardSet);
    } else {
      return await _flashCardService.updateFlashCardSet(cardSet);
    }
  }

  Future<void> deleteFlashCardSet(String id) async {
    await _flashCardService.deleteFlashCardSet(id);
  }
}
