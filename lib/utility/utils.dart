import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client
final supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const preloader = Center(child: CircularProgressIndicator(color: Colors.orange));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

/// Simple sized box to space out form elements
const int smallScreenWidth = 600; // Mobile
const int mediumScreenWidth = 1024; // Tablet
const int largeScreenWidth = 1440; // Desktop & Larger Screens

// Map of values to display text
final Map<String, String> sortOptions = {
  'most_recent': 'Most recent',
  'highest_rating': 'Highest rating',
  'lowest_rating': 'Lowest rating',
};

// List of available languages
final List<Map<String, String>> languages = [
  {"locale": 'en', "label": "English"},
  {"locale": 'ko', "label": "한국어"},
];

// List of country options
final List<Map<String, String>> countriesEn = [
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

String? getCountryCode(String countryName) {
  String? result = "";
  try {
    final combinedCountries = [...countriesEn, ...countriesKo];
    final country = combinedCountries.firstWhere((c) => c["name"] == countryName);
    result = country["code"];
  } catch (e) {
    debugPrint(e.toString());
  }
  return result;
}

String? getCountryName(String countryCode, String languageCode) {
  String? result = "";
  try {
    final country = languageCode == "en" ? countriesEn.firstWhere((c) => c["code"] == countryCode) : countriesKo.firstWhere((c) => c["code"] == countryCode);
    result = country["name"];
  } catch (e) {
    debugPrint(e.toString());
  }
  return result;
}

class Country {
  final String code;
  final String nameEn;
  final String nameKo;

  //final IconData icon;

  Country(this.code, this.nameEn, this.nameKo);
}

final List<Country> countries = [
  Country("AU", "Australia", "호주"),
  Country("CA", "Canada", "캐나다"),
  Country("IE", "Ireland", "아일랜드"),
  Country("KR", "South Korea", "대한민국"),
  Country("NZ", "New Zealand", "뉴질랜드"),
  Country("UK", "United Kingdom", "영국"),
  Country("US", "United States", "미국"),
  Country("JP", "Japan", "일본"),
  Country("CN", "China", "중국"),
];
