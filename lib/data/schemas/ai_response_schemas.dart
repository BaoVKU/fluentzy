import 'package:google_generative_ai/google_generative_ai.dart';

class AiResponseSchemas {
  static final pronunciationChecking = Schema.object(
    properties: {
      'rate': Schema.integer(
        description: 'Pronunciation accuracy rate in percentage',
      ),
      'ipa': Schema.string(
        description: 'IPA (International Phonetic Alphabet) representation',
      ),
      'feedback': Schema.string(
        description: 'Feedback for pronunciation improvement',
      ),
    },
    description: 'Response for pronunciation checking',
    requiredProperties: ['rate', 'ipa', 'feedback'],
  );

  static final objectDetection = Schema.object(
    properties: {
      'name': Schema.string(description: 'Detected object name in English'),
    },
    description: 'Response for object detection',
    requiredProperties: ['name'],
  );

  static final flashCardsSuggestion = Schema.array(
    items: Schema.object(
      properties: {
        'word': Schema.string(description: 'Card English word'),
        'description': Schema.string(
          description:
              'Definition or translation(preferrer) of word above in given language',
        ),
      },
      requiredProperties: ['word', 'description'],
    ),
    description: 'Response for flashcard set(list) suggestion',
  );
}
