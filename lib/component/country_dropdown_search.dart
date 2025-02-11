import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/utility/utils.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';

class CountryDropdownSearch extends StatefulWidget {
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
  State<CountryDropdownSearch> createState() => _CountryDropdownSearchState();
}

class _CountryDropdownSearchState extends State<CountryDropdownSearch> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Searchable Dropdown Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownSearch<String>(
          mode: Mode.MENU,
          // You can change to Mode.BOTTOM_SHEET or Mode.DIALOG
          showSearchBox: true,
          items: countries,
          label: "Select Country",
          hint: "Search and select a country",
          validator: (value) => value == null ? "Required field" : null,
          onChanged: (String? selectedCountry) {
            if (selectedCountry != null) {
              print("Selected: $selectedCountry");
            }
          },
          selectedItem: "South Korea",
          // Optional: Set an initial value
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }
}
