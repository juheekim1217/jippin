import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jippin/models/country.dart';
import 'package:jippin/models/language.dart';

/// Set Locale(default language) and default country
class LocaleProvider extends ChangeNotifier {
  Locale _locale = languages.entries.first.value.locale; // Default language
  Language _language = languages.entries.first.value; // Default country
  Country _country = languages.entries.first.value.country; // Default country
  String _currentRoute = "/"; // ✅ Store the current route (default is home)

  Locale get locale => _locale;

  Language get language => _language; // en, ko

  Country get country => _country;

  String get currentRoute => _currentRoute; // ✅ Getter for the stored route

  LocaleProvider() {
    /// Set default locale and country based on the user device on initialization
    Locale deviceLocale = PlatformDispatcher.instance.locale; // Get the user's default locale
    //Locale deviceLocale = ui.PlatformDispatcher.instance.locale;
    //Locale deviceLocale = Localizations.localeOf(context);

    if (languages.containsKey(deviceLocale.languageCode)) {
      _locale = languages[deviceLocale.languageCode]!.locale;
      _language = languages[deviceLocale.languageCode]!;
    }
    if (countries.containsKey(deviceLocale.countryCode)) {
      _country = countries[deviceLocale.countryCode]!;
    }
    debugPrint("\ninit: $deviceLocale/${_language.code}/${_country.code}");
    notifyListeners(); // Notify UI of the locale change
  }

  void setLocaleLanguage(Language language, String route) {
    _currentRoute = route; // ✅ Store the current route before changing language
    if (languages.containsKey(language.code)) {
      _locale = languages[language.code]!.locale;
      _language = language;
    }
    debugPrint("setLanguage ${_locale.languageCode}");
    notifyListeners(); // Notify the UI about the change
  }

  void setCountry(String countryCode, String countryName, String route) {
    _currentRoute = route; // ✅ Store the current route before changing language
    if (countryCode.isNotEmpty && countries.containsKey(countryCode)) {
      _country = countries[countryCode]!;
    }
    debugPrint("setDefaultCountry ${_country.code}");
    notifyListeners(); // Notify the UI about the change
  }
}
