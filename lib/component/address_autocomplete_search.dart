import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/utilities/common_helper.dart';
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
  void initState() {
    super.initState();
    //_loadCities(widget.localeProvider.country.code);
  }

  /// Detect changes in `localeProvider` and reload the cities
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //_loadCities(Provider.of<LocaleProvider>(context).country.code);
  }

  /// Loads city data based on localeProvider
  // Future<void> _loadCities(String countryCode) async {
  //   try {
  //     final langCode = Provider.of<LocaleProvider>(context).language.code;
  //     String provinceName = CountryDataService().findProvinceNameByKey(langCode, review['province']);
  //     String cityName = CountryDataService().findCityNameByKey(langCode, review['province'], review['city']);
  //
  //     setState(() {
  //       states = List<Map<String, dynamic>>.from(jsonData["states"]);
  //       cities.clear(); // Clear previous city data before adding new ones
  //
  //       for (var state in states) {
  //         var stateCities = List<Map<String, dynamic>>.from(state["cities"]);
  //         cities.addAll(stateCities);
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint("Error loading cities: $e");
  //   }
  // }

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
          //String provinceName = CountryDataService().findProvinceNameByKey(langCode, review['province']);
          //String cityName = CountryDataService().findCityNameByKey(langCode, review['province'], review['city']);
          String searchKey = textEditingValue.text.toLowerCase();
          List<Address> result = CountryDataService().getAddressListByKey(langCode, searchKey) ?? [];

          //Iterable<Address> resultProvinces = states.where((item) => item[langCode]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((item) => Address.fromMapState(item, langCode));
          //Iterable<Address> resultCities = cities.where((item) => item[langCode]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((item) => Address.fromMapCity(item, langCode));

          //List<Address> combinedResults = [...resultProvinces, ...resultCities];
          return result;
        },
        displayStringForOption: (Address address) => getFormattedAddress(langCode, address.city, address.province),
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
              width: 500, //widget.fieldWidth, // ✅ Set fixed width instead of Expanded
              // ✅ Prevents text field from overflowing
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
