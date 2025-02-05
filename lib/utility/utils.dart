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
final List<Map<String, String>> countries = [
  {"code": "AU", "name": "Australia"},
  {"code": "CA", "name": "Canada"},
  {"code": "IE", "name": "Ireland"},
  {"code": "KR", "name": "South Korea"},
  {"code": "NZ", "name": "New Zealand"},
  {"code": "UK", "name": "United Kingdom"},
  {"code": "US", "name": "United States"},
  {"code": "JP", "name": "Japan"},
  {"code": "Other", "name": "Other"},
];

String? getCountryCode(String countryName) {
  String? result = "";
  try {
    final country = countries.firstWhere((c) => c["name"] == countryName);
    result = country["code"];
  } catch (e) {
    debugPrint(e.toString());
  }
  return result;
}

String? getCountryName(String countryCode) {
  String? result = "";
  try {
    final country = countries.firstWhere((c) => c["code"] == countryCode);
    result = country["name"];
  } catch (e) {
    debugPrint(e.toString());
  }
  return result;
}
