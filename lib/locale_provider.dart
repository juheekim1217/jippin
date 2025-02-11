import 'dart:ui';

import 'package:flutter/material.dart';

/// Set Locale(default language) and default country
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language is English
  String _defaultCountry = 'CA'; // Default country
  String _defaultCountryName = 'Canada'; // Default country
  Locale get locale => _locale;

  String get defaultCountry => _defaultCountry;

  String get defaultCountryName => _defaultCountryName;

  LocaleProvider() {
    _setDefaultLocale(); // Set default locale on initialization
    setDefaultCountry("", "");
  }

  void setLocale(Locale locale) {
    if (!['en', 'ko'].contains(locale.languageCode)) return; // Check for supported languages
    _locale = locale;
    notifyListeners(); // Notify the UI about the change
  }

  void _setDefaultLocale() {
    // Get the user's default locale
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    debugPrint("Device Locale: $deviceLocale");
    // Normalize locale to avoid issues like 'en_US' not matching 'en'
    if (deviceLocale.languageCode == 'en') {
      _locale = const Locale('en'); // Force it to 'en' only
    } else if (deviceLocale.languageCode == 'ko') {
      _locale = const Locale('ko');
    } else {
      _locale = const Locale('en'); // Fallback to English if unsupported
    }
    debugPrint("_setDefaultLocale $_locale");
    notifyListeners(); // Notify UI of the locale change
  }

  void setDefaultCountry(String country, String countryName) {
    _defaultCountry = country.isEmpty ? getDefaultCountryCodeByLocale(_locale.languageCode) : country;
    _defaultCountryName = countryName.isEmpty ? getDefaultCountryName(_defaultCountry, _locale.languageCode)! : countryName;
    debugPrint("setDefaultCountry $_defaultCountry $_defaultCountryName");
    notifyListeners(); // Notify the UI about the change
  }

  /// Maps locale language code to a default country.
  String getDefaultCountryCodeByLocale(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'CA'; // Default to Canada for English users
      case 'ko':
        return 'KR'; // Default to South Korea for Korean users
      default:
        return 'CA'; // Fallback country
    }
  }

  String getDefaultCountryNameByLocale(String languageCode) {
    languageCode = languageCode.isEmpty ? _locale.languageCode : languageCode;
    switch (languageCode) {
      case 'en':
        return CountryNames.getCountry(LanguageCode.en, RegionCode.defaultRegion, languageCode);
      case 'ko':
        return CountryNames.getCountry(LanguageCode.ko, RegionCode.defaultRegion, languageCode);
      case 'fr':
        return CountryNames.getCountry(LanguageCode.fr, RegionCode.defaultRegion, languageCode);
      default:
        return CountryNames.getCountry(LanguageCode.en, RegionCode.defaultRegion, languageCode);
    }
  }

  // List of country options
  final List<Map<String, String>> countries = [
    {"code": "AU", "name": "Australia"},
    {"code": "CA", "name": "Canada"},
    {"code": "IE", "name": "Ireland"},
    {"code": "KR", "name": "South Korea"},
    {"code": "NZ", "name": "New Zealand"},
    {"code": "UK", "name": "United Kingdom"},
    {"code": "US", "name": "United States"},
    {"code": "JP", "name": "Japan"},
    {"code": "CN", "name": "China"},
  ];

  final List<Map<String, String>> countriesKo = [
    {"code": "AU", "name": "호주"},
    {"code": "CA", "name": "캐나다"},
    {"code": "IE", "name": "아일랜드"},
    {"code": "KR", "name": "대한민국"},
    {"code": "NZ", "name": "뉴질랜드"},
    {"code": "UK", "name": "영국"},
    {"code": "US", "name": "미국"},
    {"code": "JP", "name": "일본"},
    {"code": "CN", "name": "중국"},
  ];

  String? getDefaultCountryName(String countryCode, String languageCode) {
    String? result = "";
    try {
      final country = languageCode == "en" ? countries.firstWhere((c) => c["code"] == countryCode) : countriesKo.firstWhere((c) => c["code"] == countryCode);
      result = country["name"];
    } catch (e) {
      debugPrint("Exception getDefaultCountryName: $e");
    }
    return result;
  }
}

enum LanguageCode { en, ko, fr }

enum RegionCode { defaultRegion, us, gb, au, kr, ca, fr }

class CountryNames {
  static const Map<LanguageCode, Map<RegionCode, Map<String, String>>> defaultCountries = {
    LanguageCode.en: {
      RegionCode.defaultRegion: {'en': 'Canada', 'ko': '캐나다', 'fr': 'Canada'},
      RegionCode.us: {'en': 'United States', 'ko': '미국', 'fr': 'États-Unis'}, // Added 'fr'
      RegionCode.gb: {'en': 'United Kingdom', 'ko': '영국', 'fr': 'Royaume-Uni'}, // Added 'fr'
      RegionCode.au: {'en': 'Australia', 'ko': '호주', 'fr': 'Australie'}, // Added 'fr'
    },
    LanguageCode.ko: {
      RegionCode.defaultRegion: {'en': 'South Korea', 'ko': '대한민국', 'fr': 'Corée du Sud'}, // Corrected 'fr'
    },
    LanguageCode.fr: {
      RegionCode.defaultRegion: {'en': 'Canada', 'ko': '캐나다', 'fr': 'Canada'},
      RegionCode.fr: {'en': 'France', 'ko': '프랑스', 'fr': 'France'}, // Added 'fr'
    }
  };

  static String getCountry(LanguageCode language, [RegionCode region = RegionCode.defaultRegion, String locale = 'en']) {
    return defaultCountries[language]?[region]?[locale] ?? defaultCountries[language]?[RegionCode.defaultRegion]?[locale] ?? (locale == 'ko' ? '알 수 없음' : 'Unknown'); // Fallback: "Unknown" in English, "알 수 없음" in Korean
  }
}
