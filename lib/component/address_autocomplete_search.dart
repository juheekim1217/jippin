import 'package:flutter/material.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/services/country_data_service.dart';

class AddressAutocompleteField extends StatefulWidget {
  final dynamic localeProvider;
  final Function(Address) onChangedAddress;

  const AddressAutocompleteField({
    super.key,
    required this.localeProvider,
    required this.onChangedAddress,
  });

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> filteredCities = [];

  @override
  Widget build(BuildContext context) {
    final langCode = widget.localeProvider.language.code;
    return Form(
      key: formKey,
      child: AdvancedBehaviorAutocomplete<Address>(
        optionsMaxHeight: 300,
        submitSelectedOptionOnly: true,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<Address>.empty();
          }
          String searchKey = textEditingValue.text.toLowerCase();
          List<Address> result = CountryDataService().searchAddressByKey(langCode, searchKey);
          return result;
        },
        displayStringForOption: (Address address) => address.getFullAddress(langCode),
        // Tab key pressed
        onSelected: (Address selection) {
          debugPrint('onSelected $selection');
          widget.onChangedAddress(selection);
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
            child: SizedBox(
              width: 500, //widget.fieldWidth,
              // Prevents text field from overflowing
              child: TextFormField(
                focusNode: focusNode,
                controller: textEditingController,
                // Enter Key pressed
                onFieldSubmitted: (String value) {
                  debugPrint('onFieldSubmitted $value');
                  onFieldSubmitted(); // Proceed with dropdown selection
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
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 18),
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
          );
        },
      ),
    );
  }
}
