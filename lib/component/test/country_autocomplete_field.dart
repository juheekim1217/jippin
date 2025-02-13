import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';

///Enter key
// onChanged e
// onFieldSubmitted e
// onSelected South Korea
// setDefaultCountry KR
// _fetchAllReviews 10
// _applySearchFilter
//
/// Tab Key
// onChanged e
// onSelected South Korea
// setDefaultCountry KR
// _fetchAllReviews 10
// _applySearchFilter
//
//
/// Mouse click
// onChanged e
// onSelected South Korea
// setDefaultCountry KR
// _fetchAllReviews 10
// _applySearchFilter

class CountryAutoCompleteField extends StatefulWidget {
  final double width;
  final Function(String?, String?) onChanged;
  final String initialCountryName;

  const CountryAutoCompleteField({
    super.key,
    required this.width,
    required this.onChanged,
    required this.initialCountryName,
  });

  @override
  State<CountryAutoCompleteField> createState() => _CountryDropdownTextFieldState();
}

class _CountryDropdownTextFieldState extends State<CountryAutoCompleteField> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 150, // Set your minimum width here
      ),
      child: SizedBox(
        height: 32, // Match the height of other menu items
        width: widget.width,
        child: Form(
          key: formKey,
          child: AdvancedBehaviorAutocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              // if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
              // }
              //final combinedCountries = [...countriesEn, ...countriesKo];
              //return combinedCountries.where((country) => country["name"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((country) => country["name"]!);
            },
            // Tab key pressed
            onSelected: (String selection) {
              debugPrint('onSelected $selection');
              //String? selectionCode = getCountryCode(selection);
              // ✅ Update controller directly without setState
              // if (selectionCode!.isEmpty) {
              //   _controller.clear();
              // } else {
              //   _controller.text = selection;
              //   widget.onChanged(selectionCode, selection);
              // }
              //widget.onChanged(selectionCode, selection);
            },
            moveFocusNext: false,
            initialValue: TextEditingValue(text: widget.initialCountryName),
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              //_controller = textEditingController; // Assign the controller to _controller
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
                          debugPrint('onChanged $value');
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
                          labelText: AppLocalizations.of(context).selectCountry,
                          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),

                          // Center text vertically inside the TextFormField
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),

                          // Default border (when not focused)
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: Colors.grey, // 🔹 Change border color when not focused
                                  width: 1.0)),

                          // Border when field is focused
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: Colors.blue, // 🔹 Change border color when focused
                                  width: 2.0)),

                          // Border when there's an error
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: Colors.red, // 🔹 Change border color for error state
                                  width: 2.0)),

                          // Border when user is typing but error is still there
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  color: Colors.redAccent, // 🔹 Change border color for focused error
                                  width: 2.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// List of country options
// final List<Map<String, String>> countriesEn = [
//   {"code": "AU", "name": "Australia"},
//   {"code": "CA", "name": "Canada"},
//   {"code": "IE", "name": "Ireland"},
//   {"code": "KR", "name": "South Korea"},
//   {"code": "NZ", "name": "New Zealand"},
//   {"code": "UK", "name": "United Kingdom"},
//   {"code": "US", "name": "United States"},
//   {"code": "JP", "name": "Japan"},
//   {"code": "CN", "name": "China"},
// ];
//
// final List<Map<String, String>> countriesKo = [
//   {"code": "AU", "name": "호주"},
//   {"code": "CA", "name": "캐나다"},
//   {"code": "IE", "name": "아일랜드"},
//   {"code": "KR", "name": "대한민국"},
//   {"code": "NZ", "name": "뉴질랜드"},
//   {"code": "UK", "name": "영국"},
//   {"code": "US", "name": "미국"},
//   {"code": "JP", "name": "일본"},
//   {"code": "CN", "name": "중국"},
// ];
//
// String? getCountryCode(String countryName) {
//   String? result = "";
//   try {
//     final combinedCountries = [...countriesEn, ...countriesKo];
//     final country = combinedCountries.firstWhere((c) => c["name"] == countryName);
//     result = country["code"];
//   } catch (e) {
//     debugPrint(e.toString());
//   }
//   return result;
// }
//
// String? getCountryName(String countryCode, String languageCode) {
//   String? result = "";
//   try {
//     final country = languageCode == "en" ? countriesEn.firstWhere((c) => c["code"] == countryCode) : countriesKo.firstWhere((c) => c["code"] == countryCode);
//     result = country["name"];
//   } catch (e) {
//     debugPrint(e.toString());
//   }
//   return result;
// }
