import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddressAutocompleteField extends StatefulWidget {
  @override
  _AddressAutocompleteField createState() => _AddressAutocompleteField();
}

class _AddressAutocompleteField extends State<AddressAutocompleteField> {
  List<Map<String, dynamic>> cities = [];

  @override
  void initState() {
    super.initState();
    print("initState ");
    loadCities();
  }

  Future<List<Map<String, dynamic>>> loadCities() async {
    final String jsonString = await rootBundle.loadString('assets/json/korea_cities.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    cities = List<Map<String, dynamic>>.from(jsonData["cities"]);
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Map<String, dynamic>>(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
          labelText: "Search for a city",
          border: OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (query) {
        return cities.where((city) {
          final cityNameKo = city["name"]["ko"].toLowerCase();
          final cityNameEn = city["name"]["en"].toLowerCase();
          return cityNameKo.contains(query.toLowerCase()) || cityNameEn.contains(query.toLowerCase());
        }).toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text("${suggestion['name']['ko']} (${suggestion['province']['ko']})"),
          subtitle: Text("${suggestion['name']['en']} - ${suggestion['province']['en']}"),
        );
      },
      onSuggestionSelected: (suggestion) {
        print("Selected: ${suggestion['name']['ko']} in ${suggestion['province']['ko']}");
      },
    );
  }
}
