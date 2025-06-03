import 'package:fluentzy/data/models/flash_card.dart';

class FlashCardSet {
  final String id;
  final String userId; // Optional: if you want to associate sets with users
  final String name;
  final List<FlashCard> cards;

  FlashCardSet({
    this.id = '',
    required this.userId,
    required this.name,
    required this.cards,
  });

  FlashCardSet copy() {
    return FlashCardSet(
      id: id,
      userId: userId,
      name: name,
      cards: cards.map((card) => card.copy()).toList(),
    );
  }

  factory FlashCardSet.fromJson(Map<String, dynamic> json) {
    return FlashCardSet(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      cards: (json['cards'] as List).map((e) => FlashCard.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userId': userId,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }
}
