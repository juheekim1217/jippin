import 'dart:ui';

import 'package:flutter/material.dart';

/// Set Locale(default language) and default country
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language is English
  String _defaultCountry = 'CA'; // Default country

  Locale get locale => _locale;

  String get defaultCountry => _defaultCountry;

  LocaleProvider() {
    _setDefaultLocale(); // Set default locale on initialization
    _setDefaultCountry();
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

  void setDefaultCountry(String country) {
    _defaultCountry = country;
    debugPrint("setDefaultCountry $_defaultCountry");
    notifyListeners(); // Notify the UI about the change
  }

  void _setDefaultCountry() {
    _defaultCountry = getDefaultCountryForLocale(_locale.languageCode);
    debugPrint("_setDefaultCountry $_defaultCountry");
    notifyListeners();
  }

  /// Maps locale language code to a default country.
  String getDefaultCountryForLocale(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'CA'; // Default to Canada for English users
      case 'ko':
        return 'KR'; // Default to South Korea for Korean users
      default:
        return 'CA'; // Fallback country
    }
  }
}
