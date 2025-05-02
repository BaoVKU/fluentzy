import 'dart:convert';
import 'package:fluentzy/data/models/dictionary_entry.dart';
import 'package:http/http.dart' as http;

class DictionaryService {
  static const _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<List<DictionaryEntry>> fetchWord(String word) async {
    final url = Uri.parse('$_baseUrl$word');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => DictionaryEntry.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load word definition');
    }
  }
}
