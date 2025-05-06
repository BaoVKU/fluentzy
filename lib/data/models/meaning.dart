import 'package:fluentzy/data/models/definition.dart';

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions:
          (json['definitions'] as List)
              .map((e) => Definition.fromJson(e))
              .toList(),
    );
  }
}
