import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jippin/models/country.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';

class CountryDropdown extends StatefulWidget {
  final String label;
  final void Function(Country?)? onChanged;
  final bool required;

  const CountryDropdown({
    super.key,
    required this.label,
    this.onChanged,
    this.required = false,
  });

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final dropDownKey = GlobalKey<DropdownSearchState<Country>>();
  Country? selectedItem;

  Future<List<Country>> _onFind(BuildContext context, String query) {
    return Future.value(searchCountries(query));
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final langCode = localeProvider.locale.languageCode;
    final initialCountry = getCountry(localeProvider.country.nameEn);

    return FormField<Country>(
      validator: widget.required
          ? (value) {
              if (selectedItem == null && initialCountry.code.isEmpty) {
                return local.required; // "Please select a country"
              }
              return null;
            }
          : null,
      builder: (state) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: Tooltip(
            message: selectedItem?.getCountryName(langCode) ?? '',
            waitDuration: const Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<Country>(
                  key: dropDownKey,
                  selectedItem: selectedItem ?? initialCountry,
                  items: (query, _) => _onFind(context, query),
                  itemAsString: (item) => item.getCountryName(langCode),
                  compareFn: (a, b) => a.code == b.code,
                  onChanged: (selectedCountry) {
                    setState(() {
                      selectedItem = selectedCountry;
                      state.didChange(selectedCountry); // update validator
                    });
                    widget.onChanged?.call(selectedCountry);
                  },
                  suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                      iconClosed: const Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54),
                      iconOpened: const Icon(Icons.arrow_drop_up, size: 18, color: Colors.black54),
                    ),
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    baseStyle: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24.0)), borderSide: BorderSide(color: Colors.blue)),
                      errorText: state.errorText,
                    ),
                  ),
                  popupProps: PopupProps.dialog(
                    showSearchBox: true,
                    showSelectedItems: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(hintText: widget.label),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
