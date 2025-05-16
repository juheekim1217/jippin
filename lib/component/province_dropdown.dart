import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jippin/models/province.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/services/country_data_service.dart';

class ProvinceDropdown extends StatefulWidget {
  final String label;

  const ProvinceDropdown({super.key, required this.label});

  @override
  State<ProvinceDropdown> createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  final dropDownKey = GlobalKey<DropdownSearchState>();

  List<Province> itemList = CountryDataService().provinceMap.values.toList();
  Province? selectedItem;

  Future<List<Province>> _onFind(String filter, String languageCode) async {
    return itemList.where((p) => p.getName(languageCode).toLowerCase().contains(filter.toLowerCase())).toList();
  }

  void _onChanged(Province? data, String name) {
    if (data != null) {
      //widget.onChanged(data.code, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
      child: Tooltip(
        message: selectedItem?.getName(localeProvider.locale.languageCode) ?? '',
        waitDuration: const Duration(milliseconds: 500), // Optional: Delay before showing
        child: DropdownSearch<Province>(
          suffixProps: DropdownSuffixProps(dropdownButtonProps: DropdownButtonProps(iconClosed: Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54), iconOpened: Icon(Icons.arrow_drop_up, size: 18, color: Colors.black54))),
          key: dropDownKey,
          //selectedItem: getCountry(initialCountryName),
          items: (query, infiniteScrollProps) => _onFind(query, localeProvider.locale.languageCode),
          itemAsString: (Province item) => item.getName(localeProvider.locale.languageCode),
          compareFn: (a, b) => a.en == b.en,
          onChanged: (Province? selected) {
            if (selected != null) {
              setState(() {
                selectedItem = selected;
              });
              String selectedName = selected.getName(localeProvider.locale.languageCode);
              _onChanged(selected, selectedName);
            }
          },
          decoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                suffixIcon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                labelText: widget.label,
                labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                hoverColor: Colors.transparent,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide(color: Colors.blue, width: 1.0))),
          ),
          popupProps: PopupProps.dialog(showSearchBox: true, showSelectedItems: true, searchFieldProps: TextFieldProps(decoration: InputDecoration(hintText: widget.label))),
        ),
      ),
    );
  }
}
