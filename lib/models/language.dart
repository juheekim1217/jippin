import 'dart:ui';
import 'package:jippin/models/country.dart';

/// LanguageCode Key value pair
final Map<String, Language> languages = {
  "en": Language("en", Locale('en'), "English", countries["CA"]!),
  "ko": Language("ko", Locale('ko'), "한국어", countries["KR"]!),
};

class Language {
  final String code;
  final Locale locale;
  final String label;
  final Country country;

  Language(this.code, this.locale, this.label, this.country);
}
