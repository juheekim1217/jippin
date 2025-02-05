import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddressAutocompleteField extends StatefulWidget {
  const AddressAutocompleteField({super.key});

  @override
  _AddressAutocompleteFieldState createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> filteredCities = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // ✅ Add focus node

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  /// Loads city data once at startup
  Future<void> _loadCities() async {
    final String jsonString = await rootBundle.loadString('assets/json/korea_cities.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      cities = List<Map<String, dynamic>>.from(jsonData["cities"]);
    });
  }

  /// Filters cities based on user input
  List<Map<String, dynamic>> _filterCities(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return cities.where((city) {
      final cityNameKo = city["name"]["ko"].toLowerCase();
      final cityNameEn = city["name"]["en"].toLowerCase();
      return cityNameKo.contains(lowerQuery) || cityNameEn.contains(lowerQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Map<String, dynamic>>(
      hideSuggestionsOnKeyboardHide: false,
      // ✅ Keep dropdown visible for navigation
      textFieldConfiguration: TextFieldConfiguration(
        controller: _controller,
        focusNode: _focusNode, // ✅ Ensure focus is handled correctly
        autofocus: true,
        decoration: InputDecoration(
          labelText: "Search for a city",
          border: OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (query) {
        filteredCities = _filterCities(query);
        return filteredCities;
      },
      itemBuilder: (context, suggestion) {
        final query = _controller.text.toLowerCase();
        final nameKo = suggestion["name"]["ko"];
        final nameEn = suggestion["name"]["en"];

        // Show only the name that contains the query
        final matchingName = nameKo.toLowerCase().contains(query) ? nameKo : nameEn;

        return ListTile(
          title: Text(matchingName),
          onTap: () {
            _controller.text = matchingName;
            _focusNode.unfocus(); // ✅ Hide keyboard after selection
          },
        );
      },
      onSuggestionSelected: (suggestion) {
        final query = _controller.text.toLowerCase();
        final nameKo = suggestion["name"]["ko"];
        final nameEn = suggestion["name"]["en"];

        final selectedText = nameKo.toLowerCase().contains(query) ? nameKo : nameEn;
        _controller.text = selectedText;
        _focusNode.unfocus(); // ✅ Close keyboard on selection
      },
    );
  }
}
