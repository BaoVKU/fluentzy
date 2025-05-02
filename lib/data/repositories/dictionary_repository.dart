import 'package:fluentzy/data/models/dictionary_entry.dart';
import 'package:fluentzy/data/services/dictionary_service.dart';

class DictionaryRepository {
  final DictionaryService _dictionaryService;
  DictionaryRepository(this._dictionaryService);

  Future<DictionaryEntry?> getDefinition(String word) async {
    final List<DictionaryEntry> entries;
    try {
      entries = await _dictionaryService.fetchWord(word);
    } catch (e) {
      return null;
    }
    if (entries.isEmpty) {
      return null;
    }
    return entries.first;
  }
}
