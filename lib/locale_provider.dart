import 'dart:ui';

import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language is English

  Locale get locale => _locale;

  LocaleProvider() {
    _setDefaultLocale(); // Set default locale on initialization
  }

  void setLocale(Locale locale) {
    if (!['en', 'ko'].contains(locale.languageCode)) return; // Check for supported languages
    _locale = locale;
    notifyListeners(); // Notify the UI about the change
  }

  void _setDefaultLocale() {
    // Get the user's default locale
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    print("Device Locale: $deviceLocale");

    // List of supported locales
    // const List<Locale> supportedLocales = [
    //   Locale('en'), // English
    //   Locale('ko'), // Korean
    // ];

    // Check if the device's locale is supported
    //if (supportedLocales.any((locale) => locale.languageCode == deviceLocale.languageCode)) {
    //_locale = deviceLocale; // Use the device's locale if supported

    // Normalize locale to avoid issues like 'en_US' not matching 'en'
    if (deviceLocale.languageCode == 'en') {
      _locale = const Locale('en'); // Force it to 'en' only
    } else if (deviceLocale.languageCode == 'ko') {
      _locale = const Locale('ko');
    } else {
      _locale = const Locale('en'); // Fallback to English if unsupported
    }

    notifyListeners(); // Notify UI of the locale change
  }
}
