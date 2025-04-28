import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jippin/models/address.dart';

class CountryDataService {
  static final CountryDataService _instance = CountryDataService._internal();

  factory CountryDataService() => _instance;

  CountryDataService._internal();

  Map<String, dynamic>? _countryData;
  Map<String, dynamic>? _provinceData;
  String? _loadedCountryCode;

  Future<void> loadCountryData(String countryCode) async {
    if (_countryData != null && _loadedCountryCode == countryCode) return;

    final String jsonString = await rootBundle.loadString('assets/json/country/$countryCode.json');
    _countryData = json.decode(jsonString);
    _provinceData = _countryData!["states"] as Map<String, dynamic>;
    _loadedCountryCode = countryCode;
  }

  Map<String, dynamic>? get countryData => _countryData;

  List<Address>? getAddressListByKey(String langCode, String key) {
    List<Map<String, dynamic>> stateList = List<Map<String, dynamic>>.from(_countryData!["states"] ?? []);
    List<Map<String, dynamic>> cityList = [];
    for (var state in stateList) {
      var stateCities = List<Map<String, dynamic>>.from(state["cities"]);
      cityList.addAll(stateCities);
    }

    Iterable<Address> resultProvinces = stateList.where((item) => item[langCode]!.toLowerCase().contains(key.toLowerCase())).map((item) => Address.fromMapState(item, langCode));
    Iterable<Address> resultCities = cityList.where((item) => item[langCode]!.toLowerCase().contains(key.toLowerCase())).map((item) => Address.fromMapCity(item, langCode));

    List<Address> result = [...resultProvinces, ...resultCities];

    return result;
  }

  /// 🔥 Find state by stateKey
  // Map<String, String>? findProvinceByKey(String stateKey) {
  //   if (_provinceData == null) return null;
  //   final stateData = _provinceData![stateKey];
  //   if (stateData == null) return null;
  //
  //   return {
  //     'state_en': stateData['en'] ?? '',
  //     'state_ko': stateData['ko'] ?? '',
  //     'type': stateData['type'] ?? '',
  //   };
  // }

  /// 🔥 Find specific city by cityKey
  // Map<String, String>? findCityByKey(String stateKey, String cityKey) {
  //   if (_provinceData != null) {
  //     final stateData = _provinceData![stateKey];
  //     if (stateData != null) {
  //       final Map<String, dynamic> cities = stateData['cities'] ?? {};
  //       if (cities.containsKey(cityKey)) {
  //         final cityData = cities[cityKey];
  //         return {
  //           'state_en': stateData['en'] ?? '',
  //           'state_ko': stateData['ko'] ?? '',
  //           'city_en': cityData['en'] ?? '',
  //           'city_ko': cityData['ko'] ?? '',
  //         };
  //       }
  //     }
  //   }
  //   return null; // not found
  // }

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

  /// 🔥 Find specific city by cityKey
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
}
