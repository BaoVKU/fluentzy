import 'package:fluentzy/data/services/translation_service.dart';

class TranslationRepository {
  final TranslationService _translationService;
  TranslationRepository(this._translationService);

  Future<String?> translate(
    String sourceLangCode,
    String targetLangCode,
    String text,
  ) async {
    try {
      return await _translationService.translate(
        sourceLangCode,
        targetLangCode,
        text,
      );
    } catch (e) {
      // Handle exceptions, e.g., log them or show a message to the user
      return null;
    }
  }
}
