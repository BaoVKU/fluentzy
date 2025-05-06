import 'package:language_code/language_code.dart';

enum SupportLanguage {
  english(LanguageCodes.en, 'assets/english.svg'),
  vietnamese(LanguageCodes.vi, 'assets/vietnamese.svg');

  final LanguageCodes languageCode;
  final String flagAssetPath;
  const SupportLanguage(this.languageCode, this.flagAssetPath);
}
