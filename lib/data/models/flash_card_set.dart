import 'package:fluentzy/data/models/flash_card.dart';

class FlashCardSet {
  final String id;
  final String name;
  final List<FlashCard> cards;

  FlashCardSet({this.id = '', required this.name, required this.cards});

  FlashCardSet copy() {
    return FlashCardSet(
      id: id,
      name: name,
      cards: cards.map((card) => card.copy()).toList(),
    );
  }

  factory FlashCardSet.fromJson(Map<String, dynamic> json) {
    return FlashCardSet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cards: (json['cards'] as List).map((e) => FlashCard.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'cards': cards.map((card) => card.toJson()).toList()};
  }
}
