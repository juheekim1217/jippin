import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';

import 'package:jippin/models/address.dart';

class AddressAutocompleteField extends StatefulWidget {
  final double fieldWidth;
  final dynamic localeProvider;
  final Function(Address) onChanged;

  const AddressAutocompleteField({
    super.key,
    required this.fieldWidth,
    required this.localeProvider,
    required this.onChanged,
  });

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> filteredCities = [];

  // final TextEditingController _controller = TextEditingController();
  // final FocusNode _focusNode = FocusNode(); // ✅ Add focus node

  @override
  void initState() {
    super.initState();
    _loadCities(widget.localeProvider.country.code);
  }

  /// Detect changes in `localeProvider` and reload the cities
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _localeProvider = Provider.of<LocaleProvider>(context);
    _loadCities(_localeProvider.country.code);
  }

  /// Loads city data based on localeProvider
  Future<void> _loadCities(String countryCode) async {
    try {
      print("loadcities");
      final String jsonString = await rootBundle.loadString('assets/json/country/$countryCode.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        states = List<Map<String, dynamic>>.from(jsonData["states"]);
        cities.clear(); // Clear previous city data before adding new ones

        for (var state in states) {
          var stateCities = List<Map<String, dynamic>>.from(state["cities"]);
          cities.addAll(stateCities);
        }
      });
    } catch (e) {
      print("Error loading cities: $e");
    }
  }

  /// Filters cities based on user input
  // List<Map<String, dynamic>> _filterCities(String query) {
  //   if (query.isEmpty) return [];
  //   final lowerQuery = query.toLowerCase();
  //   return cities.where((city) {
  //     final cityNameKo = city["name"]["ko"].toLowerCase();
  //     final cityNameEn = city["name"]["en"].toLowerCase();
  //     return cityNameKo.contains(lowerQuery) || cityNameEn.contains(lowerQuery);
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32, // Match the height of other menu items
      width: widget.fieldWidth,
      child: Form(
        key: formKey,
        child: AdvancedBehaviorAutocomplete<Address>(
          optionsMaxHeight: 300,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Address>.empty();
            }
            //return const Iterable<String>.empty();
            //Iterable<Address> resultStates = states.where((item) => item["name"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((item) => item["name"]!);
            Iterable<Address> resultStates = states.where((item) => item["n"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((item) => Address.fromMapState(item));
            // city name only
            Iterable<Address> resultCities = cities.where((item) => item["n"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((item) => Address.fromMapCity(item));
            //Iterable<String> resultCities = cities.where((item) => item["fn"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((item) => item["fn"]!);
            // var resultCities = states.expand((state) {
            //   return state["cities"].where((city) => city["n"] != null && city["n"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((city) => "${city["n"]}, ${state["name"]}");
            // }).toList();
            List<Address> combinedResults = [...resultStates, ...resultCities];
            return combinedResults;
          },
          displayStringForOption: (Address address) => address.fullName,
          // ✅ Show fullName in dropdown
          // Tab key pressed
          onSelected: (Address selection) {
            debugPrint('onSelected $selection');
            //String? selectionCode = getCountryCode(selection);
            widget.onChanged(selection);
          },
          moveFocusNext: false,
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return Tooltip(
              message: textEditingController.text, // Shows full text on hover
              waitDuration: Duration(milliseconds: 500),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Align icon and text field properly
                children: [
                  Icon(Icons.location_on, color: Colors.black54), // ✅ Icon outside the field
                  SizedBox(width: 4), // ✅ Adjust spacing between icon and text field
                  Expanded(
                    // ✅ Prevents text field from overflowing
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: textEditingController,
                      // Enter Key pressed
                      onFieldSubmitted: (String value) {
                        debugPrint('onFieldSubmitted $value');
                        onFieldSubmitted();
                      },
                      onChanged: (value) {
                        //debugPrint('onChanged $value');
                      },
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).search_location,
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),

                        // Center text vertically inside the TextFormField
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),

                        // Default border (when not focused)
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color: Colors.grey, // 🔹 Change border color when not focused
                            width: 1.5,
                          ),
                        ),

                        // Border when field is focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color: Colors.blue, // 🔹 Change border color when focused
                            width: 2.0,
                          ),
                        ),

                        // Border when there's an error
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color: Colors.red, // 🔹 Change border color for error state
                            width: 2.0,
                          ),
                        ),

                        // Border when user is typing but error is still there
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color: Colors.redAccent, // 🔹 Change border color for focused error
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    // return TextFormField(
    //   hideSuggestionsOnKeyboardHide: false,
    //   // ✅ Keep dropdown visible for navigation
    //   textFieldConfiguration: TextFieldConfiguration(
    //     controller: _controller,
    //     focusNode: _focusNode, // ✅ Ensure focus is handled correctly
    //     autofocus: true,
    //     decoration: InputDecoration(
    //       labelText: "Search for a city",
    //       border: OutlineInputBorder(),
    //     ),
    //   ),
    //   suggestionsCallback: (query) {
    //     filteredCities = _filterCities(query);
    //     return filteredCities;
    //   },
    //   itemBuilder: (context, suggestion) {
    //     final query = _controller.text.toLowerCase();
    //     final nameKo = suggestion["name"]["ko"];
    //     final nameEn = suggestion["name"]["en"];
    //
    //     // Show only the name that contains the query
    //     final matchingName = nameKo.toLowerCase().contains(query) ? nameKo : nameEn;
    //
    //     return ListTile(
    //       title: Text(matchingName),
    //       onTap: () {
    //         _controller.text = matchingName;
    //         _focusNode.unfocus(); // ✅ Hide keyboard after selection
    //       },
    //     );
    //   },
    //   onSuggestionSelected: (suggestion) {
    //     final query = _controller.text.toLowerCase();
    //     final nameKo = suggestion["name"]["ko"];
    //     final nameEn = suggestion["name"]["en"];
    //
    //     final selectedText = nameKo.toLowerCase().contains(query) ? nameKo : nameEn;
    //     _controller.text = selectedText;
    //     _focusNode.unfocus(); // ✅ Close keyboard on selection
    //   },
    // );
  }
}
