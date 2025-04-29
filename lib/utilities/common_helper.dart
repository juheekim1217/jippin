import 'dart:convert';

import 'package:jippin/models/address.dart';

/// compare strings case-insensitive works for all languages
bool equalsIgnoreCase(String? a, String? b) {
  if (a == null || b == null) return false;
  //return RegExp('^${RegExp.escape(b)}\$', caseSensitive: false).hasMatch(a);
  return a == b;
}

/// Checks if [text] contains [query], case-insensitively. Works for all languages.
bool containsIgnoreCase(String? text, String? query) {
  if (text == null || query == null) return false;
  return text.toLowerCase().contains(query.toLowerCase());
}

/// Encode for all languages
String encodeAddressUri(Address address) {
  return base64Url.encode(utf8.encode(jsonEncode(address)));
}
