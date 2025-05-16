import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jippin/models/province.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/services/country_data_service.dart';
import 'package:jippin/models/country.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';

class ProvinceDropdown extends StatefulWidget {
  final String label;
  final Country? country;
  final void Function(Province?)? onChanged;
  final bool required;

  const ProvinceDropdown({
    super.key,
    required this.label,
    this.country,
    this.onChanged,
    this.required = false,
  });

  @override
  State<ProvinceDropdown> createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  final dropDownKey = GlobalKey<DropdownSearchState<Province>>();
  List<Province> itemList = CountryDataService().provinceMap.values.toList();
  Province? selectedItem;

  Future<List<Province>> _onFind(String filter, String languageCode) async {
    if (widget.country != null) {
      try {
        await CountryDataService().loadCountryData(widget.country!.code);
        itemList = CountryDataService().provinceMap.values.toList();
        debugPrint("Loaded country data for ${widget.country!.code}");
      } catch (e) {
        debugPrint("Failed to load country data: $e");
      }
    }
    return itemList.where((p) => p.getName(languageCode).toLowerCase().contains(filter.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final langCode = localeProvider.locale.languageCode;

    return FormField<Province>(
      validator: widget.required ? (value) => value == null ? local.required : null : null,
      builder: (FormFieldState<Province> state) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: Tooltip(
            message: selectedItem?.getName(langCode) ?? '',
            waitDuration: const Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<Province>(
                  key: dropDownKey,
                  items: (query, _) => _onFind(query, langCode),
                  itemAsString: (item) => item.getName(langCode),
                  compareFn: (a, b) => a.en == b.en,
                  selectedItem: selectedItem,
                  onChanged: (Province? selected) {
                    setState(() {
                      selectedItem = selected;
                      state.didChange(selected); // 👈 update form field state
                    });
                    widget.onChanged?.call(selected);
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
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: const BorderSide(color: Colors.blue)),
                      errorText: state.errorText, // 👈 show error
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
