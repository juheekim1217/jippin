import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jippin/models/country.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';

class CountryDropdown extends StatefulWidget {
  final String label;
  final void Function(Country?)? onChanged;

  //final List<Country> itemList;

  const CountryDropdown({super.key, required this.label, this.onChanged});

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final dropDownKey = GlobalKey<DropdownSearchState>();

  Future<List<Country>> _onFind(BuildContext context, String query) {
    return Future.value(searchCountries(query));
  }

  void _onChanged(Country? data, String name) {
    if (data != null) {
      //widget.onChanged(data.code, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    String initialCountryName = localeProvider.country.nameEn;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Tooltip(
        message: getCountry(initialCountryName).getCountryName(localeProvider.locale.languageCode), // Tooltip shows selected country name
        waitDuration: const Duration(milliseconds: 500), // Optional: Delay before showing
        child: DropdownSearch<Country>(
          //mode: Mode.custom,
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54),
              iconOpened: Icon(Icons.arrow_drop_up, size: 18, color: Colors.black54),
            ),
          ),
          key: dropDownKey,
          selectedItem: getCountry(initialCountryName),
          // Optional: Set initial selection
          items: (query, infiniteScrollProps) => _onFind(context, query),
          //items: widget.itemList,
          itemAsString: (Country country) => country.getCountryName(localeProvider.locale.languageCode),
          compareFn: (Country? item, Country? selectedItem) => item?.code == selectedItem?.code,
          onChanged: (Country? selectedCountry) {
            if (selectedCountry != null) {
              String selectedName = selectedCountry.getCountryName(localeProvider.locale.languageCode);
              _onChanged(selectedCountry, selectedName);
              widget.onChanged?.call(selectedCountry); // 👈 send back province code
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
              labelText: widget.label,
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
                hintText: widget.label,
                //border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
