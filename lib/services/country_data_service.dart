import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:jippin/models/province.dart';

class CountryDataService {
  static final CountryDataService _instance = CountryDataService._internal();

  factory CountryDataService() => _instance;

  CountryDataService._internal();

  Map<String, dynamic>? _countryData;
  Map<String, dynamic>? _provinceData;
  String? _loadedCountryCode;
  Map<String, Province> _provinceMap = {};

  /// public getter
  Map<String, dynamic>? get countryData => _countryData;

  Map<String, dynamic>? get provinceData => _provinceData;

  Map<String, Province> get provinceMap => _provinceMap;

  /// loads country json data as per the selected country
  Future<void> loadCountryData(String countryCode) async {
    if (_countryData != null && _loadedCountryCode == countryCode) return;

    final String jsonString = await rootBundle.loadString('assets/json/country/$countryCode.json');
    _countryData = json.decode(jsonString);
    _provinceData = _countryData!["states"] as Map<String, dynamic>;
    _loadedCountryCode = countryCode;

    _provinceMap = _provinceData!.map((key, value) {
      return MapEntry(
        key,
        Province(
          en: value["en"] ?? '',
          ko: value["ko"] ?? '',
          type: value["type"] ?? '',
          cities: value["cities"] ?? {},
        ),
      );
    });
  }

  List<Address> searchAddressByKey(String langCode, String keyword) {
    final List<Address> matches = [];
    for (final stateEntry in _provinceData!.entries) {
      final stateData = stateEntry.value as Map<String, dynamic>;
      if (containsIgnoreCase(stateData[langCode], keyword)) {
        matches.add(Address(province: stateData['en'], provinceKo: stateData['ko']));
      }
      final cities = stateData['cities'] as Map<String, dynamic>;
      for (final cityEntry in cities.entries) {
        final cityData = cityEntry.value as Map<String, dynamic>;
        if (containsIgnoreCase(cityData[langCode], keyword)) {
          matches.add(Address(province: stateData['en'], city: cityData['en'], provinceKo: stateData['ko'], cityKo: cityData['ko']));
        }
      }
    }
    return matches;
  }

  String findProvinceNameByKey(String langCode, String stateKey) {
    if (langCode == 'en') return stateKey;

    String result = stateKey;
    if (_provinceData != null) {
      final stateData = _provinceData![stateKey];
      if (stateData != null) {
        result = stateData[langCode] ?? stateKey;
      }
    }
    return result;
  }

  /// Find specific city by cityKey
  String findCityNameByKey(String langCode, String stateKey, String cityKey) {
    if (langCode == 'en') return cityKey;

    String result = cityKey;
    if (_provinceData != null) {
      final stateData = _provinceData![stateKey];
      if (stateData != null) {
        final Map<String, dynamic> cities = stateData['cities'] ?? {};
        if (cities.containsKey(cityKey)) {
          final cityData = cities[cityKey];
          result = cityData[langCode] ?? cityKey;
        }
      }
    }
    return result;
  }

  /// Returns a formatted address string based on the given language code.
  String getFullAddress(String langCode, String stateKey, String cityKey) {
    String name = stateKey;
    if (_provinceData != null) {
      final stateData = _provinceData![stateKey];
      if (stateData != null) {
        final Map<String, dynamic> cities = stateData['cities'] ?? {};
        if (cities.containsKey(cityKey)) {
          final cityData = cities[cityKey];
          // format full address by language code
          if (langCode == "ko") {
            name = "${stateData['ko']} ${cityData['ko']}";
          } else {
            name = "${cityData['en']}, ${stateData['en']}"; // English address format
          }
        }
      }
    }
    return name;
  }
}
