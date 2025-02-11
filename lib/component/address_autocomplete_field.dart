import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';

class AddressAutocompleteField extends StatefulWidget {
  const AddressAutocompleteField({super.key});

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
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
    return SizedBox(
      height: 32, // Match the height of other menu items
      //width: widget.width,
      child: Form(
        //key: formKey,
        child: AdvancedBehaviorAutocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return const Iterable<String>.empty();
            //return countries.where((country) => country["name"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((country) => country["name"]!);
          },
          // Tab key pressed
          onSelected: (String selection) {
            debugPrint('onSelected $selection');
            //String? selectionCode = getCountryCode(selection);
            //widget.onChanged(selectionCode);
          },
          moveFocusNext: false,
          //initialValue: TextEditingValue(text: widget.initialCountryName),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required Entry';
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Select Country",
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
