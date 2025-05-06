import 'package:fluentzy/data/models/meaning.dart';

class DictionaryEntry {
  final String word;
  final String phonetic;
  final List<Meaning> meanings;

  DictionaryEntry({
    required this.word,
    required this.phonetic,
    required this.meanings,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      meanings:
          (json['meanings'] as List).map((e) => Meaning.fromJson(e)).toList(),
    );
  }
}
