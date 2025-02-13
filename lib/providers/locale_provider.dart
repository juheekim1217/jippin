import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jippin/models/country.dart';
import 'package:jippin/models/language.dart';

/// supported locales languageCode key value pair
final Map<String, Locale> locales = {
  "en": Locale('en'),
  "ko": Locale('ko'),
};

/// Set Locale(default language) and default country
class LocaleProvider extends ChangeNotifier {
  Locale _locale = locales.entries.first.value; // Default language
  Language _language = languages.entries.first.value; // Default country
  Country _country = languages.entries.first.value.country; // Default country

  Locale get locale => _locale;

  Language get language => _language;

  Country get country => _country;

  LocaleProvider() {
    /// Set default locale and country based on the user device on initialization
    Locale deviceLocal = PlatformDispatcher.instance.locale; // Get the user's default locale
    if (languages.containsKey(deviceLocal.languageCode)) {
      _locale = locales[deviceLocal.languageCode]!;
      _language = languages[deviceLocal.languageCode]!;
    }
    if (countries.containsKey(deviceLocal.countryCode)) {
      _country = countries[deviceLocal.countryCode]!;
    }
    debugPrint("\ninit: $deviceLocal/${_language.code}/${_country.code}");
    notifyListeners(); // Notify UI of the locale change
  }

  void setLanguage(Language language) {
    if (languages.containsKey(language.code)) {
      _locale = locales[language.code]!;
      _language = language;
    }
    debugPrint("setLanguage ${_locale.languageCode}");
    notifyListeners(); // Notify the UI about the change
  }

  void setCountry(String countryCode, String countryName) {
    if (countryCode.isNotEmpty && countries.containsKey(countryCode)) {
      _country = countries[countryCode]!;
    }
    debugPrint("setDefaultCountry ${_country.code}");
    notifyListeners(); // Notify the UI about the change
  }
}
