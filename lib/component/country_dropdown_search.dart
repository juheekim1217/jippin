import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/utility/utils.dart';

class CountryDropdownSearch extends StatefulWidget {
  final Function(String?, String?) onChanged;
  final String initialCountryName;
  final dynamic localeProvider;

  const CountryDropdownSearch({super.key, required this.onChanged, required this.initialCountryName, required this.localeProvider});

  @override
  State<CountryDropdownSearch> createState() => _CountryDropdownSearchState();
}

class _CountryDropdownSearchState extends State<CountryDropdownSearch> {
  final dropDownKey = GlobalKey<DropdownSearchState>();

  //final List<String> countryNamesEn = countries.map((country) => country.nameEn).toList();
  //final List<String> countryNamesKo = countries.map((country) => country.nameKo).toList();

  Future<List<Country>> _onFind(BuildContext context, String query) {
    return Future.value(countries.where((country) => country.nameEn.toLowerCase().contains(query.toLowerCase()) || country.nameKo.contains(query)).toList());
  }

  void _onChanged(Country? data, String name) {
    if (data != null) {
      debugPrint('onSelected $name');
      widget.onChanged(data.code, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownSearch<Country>(
        //mode: Mode.custom,
        suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
            iconClosed: Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54),
            iconOpened: Icon(Icons.arrow_drop_up, size: 18, color: Colors.black54),
          ),
        ),
        key: dropDownKey,
        selectedItem: countries.firstWhere((country) => country.nameEn == widget.initialCountryName || country.nameKo == widget.initialCountryName),
        // Optional: Set initial selection
        items: (query, infiniteScrollProps) => _onFind(context, query),
        // Use onFind for asynchronous data fetching
        itemAsString: (Country country) => widget.localeProvider.locale.languageCode == "en" ? country.nameEn : country.nameKo,
        compareFn: (Country? item, Country? selectedItem) => item?.code == selectedItem?.code,
        onChanged: (Country? selectedCountry) {
          if (selectedCountry != null) {
            String selectedName = widget.localeProvider.locale.languageCode == "en" ? selectedCountry.nameEn : selectedCountry.nameKo;

            // Now you can use selectedName as the selected string
            debugPrint("Selected Country: $selectedName");

            // Call your custom logic if needed
            _onChanged(selectedCountry, selectedName);
          }
        },
        // Display country names in English
        decoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(
            fontSize: 14, // Change selected item text size here
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            suffixIcon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
            //icon: Icon(Icons.location_on, color: Colors.black54),
            labelText: AppLocalizations.of(context).selectCountry,
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            // Center text vertically inside the TextFormField
            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            hoverColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0)),
            // Default border (when not focused)
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0)),
            // Border when field is focused
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.blue, width: 1.0)),
          ),
        ),
        popupProps: PopupProps.dialog(
          // Changed to dialog mode
          showSearchBox: true,
          showSelectedItems: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search here...',
              //border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
