import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/models/city.dart';
import 'package:jippin/models/province.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';

class CityDropdown extends StatefulWidget {
  final String label;
  final Province? province;
  final bool required;
  final void Function(City?)? onChanged;

  const CityDropdown({
    super.key,
    required this.label,
    this.province,
    this.required = false,
    this.onChanged,
  });

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  final dropDownKey = GlobalKey<DropdownSearchState<City>>();
  City? selectedItem;

  Future<List<City>> _onFind(String filter, String languageCode) async {
    List<City> itemList = widget.province?.cityMap.values.toList() ?? [];
    return itemList.where((p) => p.getName(languageCode).toLowerCase().contains(filter.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final langCode = localeProvider.locale.languageCode;

    return FormField<City>(
      validator: widget.required ? (value) => value == null ? local.required : null : null,
      builder: (state) {
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
                DropdownSearch<City>(
                  key: dropDownKey,
                  selectedItem: selectedItem,
                  items: (query, _) => _onFind(query, langCode),
                  itemAsString: (item) => item.getName(langCode),
                  compareFn: (a, b) => a.en == b.en,
                  onChanged: (City? selected) {
                    setState(() {
                      selectedItem = selected;
                      state.didChange(selected); // ✅ mark field updated
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
