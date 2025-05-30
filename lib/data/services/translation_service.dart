import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class TranslationService {
  Future<String> translate(
    String sourceLangCode,
    String targetLangCode,
    String text,
  ) async {
    final encodedText = Uri.encodeComponent(text);
    final url =
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$sourceLangCode&tl=$targetLangCode&dt=t&q=$encodedText';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data[0][0][0];
      } else {
        throw Exception('Failed to translate text: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }
}
