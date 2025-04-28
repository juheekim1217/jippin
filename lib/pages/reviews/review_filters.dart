import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/models/province.dart';
import 'package:jippin/models/city.dart';
import 'package:go_router/go_router.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/review_query_provider.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';

class ReviewFilters extends StatefulWidget {
  final dynamic localeProvider;
  final List<Map<String, dynamic>> reviews;

  const ReviewFilters({
    super.key,
    required this.localeProvider,
    required this.reviews,
  });

  @override
  State<ReviewFilters> createState() => _ReviewFiltersState();
}

class _ReviewFiltersState extends State<ReviewFilters> {
  String? selectedSort;
  Province? selectedProvince;
  City? selectedCity;
  String? selectedStreet;
  String? selectedLandlord;
  String? selectedProperty;
  String? selectedRealtor;

  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];
  List<Province> stateList = [];
  List<City> cityList = [];

  late final TextEditingController streetController;
  late final TextEditingController landlordController;
  late final TextEditingController propertyController;
  late final TextEditingController realtorController;

  List<String> getDistinctValues(String key) {
    return widget.reviews.map((review) => review[key]).whereType<String>().toSet().toList()..sort();
  }

  @override
  void initState() {
    super.initState();

    streetController = TextEditingController();
    landlordController = TextEditingController();
    propertyController = TextEditingController();
    realtorController = TextEditingController();
    _loadStateCities(widget.localeProvider.country.code).then((_) {
      final query = context.read<ReviewQueryProvider>();
      final address = query.qAddress;

      setState(() {
        selectedStreet = address.street;
        selectedLandlord = query.qLandlord;
        selectedProperty = query.qProperty;
        selectedRealtor = query.qRealtor;

        // Set controller values
        streetController.text = selectedStreet ?? '';
        landlordController.text = selectedLandlord ?? '';
        propertyController.text = selectedProperty ?? '';
        realtorController.text = selectedRealtor ?? '';

        if (selectedProvince != null) {
          final langCode = widget.localeProvider.language.code;
          final stateData = states.firstWhere(
            (state) => state[langCode] == selectedProvince,
            orElse: () => {},
          );
          //final filteredCities = List<Map<String, dynamic>>.from(stateData["cities"] ?? []);
          final Map<String, dynamic> citiesMap = stateData["cities"];
          final filteredCities = citiesMap.values.map((s) => s as Map<String, dynamic>).toList();
          //cityList = filteredCities.map((city) => city[langCode] as String).toList();
          // Convert city entries to a list of City objects
          cityList = citiesMap.entries
              .where((entry) => entry.value["s_$langCode"] == selectedProvince)
              .map((entry) => City(
                    nameEn: entry.value["en"] ?? '',
                    nameKo: entry.value["ko"] ?? '',
                    stateEn: entry.value["s_en"] ?? '',
                    stateKo: entry.value["s_ko"] ?? '',
                  ))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    streetController.dispose();
    landlordController.dispose();
    propertyController.dispose();
    realtorController.dispose();
    super.dispose();
  }

  /// Loads state and city data based on localeProvider
  Future<void> _loadStateCities(String countryCode) async {
    try {
      debugPrint("loadcities $countryCode");
      final String jsonString = await rootBundle.loadString('assets/json/country/$countryCode.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      //final Map<String, dynamic> statesMap = jsonData["states"];
      // setState(() {
      //   states = statesMap.values.map((s) => s as Map<String, dynamic>).toList();
      //   final langCode = widget.localeProvider.language.code;
      //   stateList = states.map((state) => state[langCode] as String).toList();
      // });

      final statesMap = jsonData["states"] as Map<String, dynamic>;
      stateList = statesMap.entries.map((entry) {
        final data = entry.value;
        return Province(
          nameEn: data["en"] ?? '',
          nameKo: data["ko"] ?? '',
          type: data["type"] ?? '',
          cities: data["cities"] ?? {},
        );
      }).toList();
    } catch (e) {
      debugPrint("Error loading cities: $e");
    }
  }

  void _onSearch() {
    final query = context.read<ReviewQueryProvider>();

    final address = Address(
      province: selectedProvince!.nameEn,
      city: selectedCity?.nameEn,
      province_ko: selectedProvince?.nameKo,
      city_ko: selectedCity?.nameKo,
      street: selectedStreet,
    );

    query.setQuery(
      landlord: selectedLandlord,
      property: selectedProperty,
      realtor: selectedRealtor,
      address: address,
    );

    final encodedAddress = encodeAddressUri(address);
    context.go('/reviews?qA=$encodedAddress'
        '&qL=${selectedLandlord ?? ''}'
        '&qP=${selectedProperty ?? ''}'
        '&qR=${selectedRealtor ?? ''}');
  }

  @override
  Widget build(BuildContext context) {
    //final query = context.watch<ReviewQueryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // _buildFilterDropdown(AppLocalizations.of(context).state, selectedState, stateList, (val) {
            //   setState(() {
            //     final langCode = widget.localeProvider.language.code;
            //     selectedState = val;
            //     selectedCity = null;
            //
            //     if (val != null) {
            //       // Find the state object
            //       final stateData = states.firstWhere(
            //         (state) => state[langCode] == val,
            //         orElse: () => {},
            //       );
            //       final Map<String, dynamic> citiesMap = stateData["cities"];
            //       final filteredCities = citiesMap.values.map((s) => s as Map<String, dynamic>).toList();
            //       //cityList = filteredCities.map((city) => city[langCode] as String).toList();
            //
            //       cityList = citiesMap.entries
            //           .where((entry) => entry.value["s_$langCode"] == selectedState)
            //           .map((entry) => City(
            //                 nameEn: entry.value["en"] ?? '',
            //                 nameKo: entry.value["ko"] ?? '',
            //                 stateEn: entry.value["s_en"] ?? '',
            //                 stateKo: entry.value["s_ko"] ?? '',
            //               ))
            //           .toList();
            //     } else {
            //       cityList.clear();
            //     }
            //   });
            // }),
            //_buildFilterDropdown(AppLocalizations.of(context).city, selectedCity as String?, cityList.cast<String>(), (val) => setState(() => selectedCity = val as City?)),
            _buildStateDropdown(AppLocalizations.of(context).state),
            _buildCityDropdown(AppLocalizations.of(context).city),
            _buildTextInput(AppLocalizations.of(context).street, streetController, (val) => setState(() => selectedStreet = val)),

            // Now text inputs
            _buildTextInput(AppLocalizations.of(context).landlord, landlordController, (val) => setState(() => selectedLandlord = val)),
            _buildTextInput(AppLocalizations.of(context).property, propertyController, (val) => setState(() => selectedProperty = val)),
            _buildTextInput(AppLocalizations.of(context).realtor, realtorController, (val) => setState(() => selectedRealtor = val)),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _onSearch,
          icon: const Icon(Icons.search),
          label: Text(AppLocalizations.of(context).search),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    //final safeValue = items.contains(selectedValue) ? selectedValue : null;

    return SizedBox(
        width: 160,
        // child: DropdownButtonFormField<String>(
        //   isExpanded: true,
        //   value: safeValue,
        //   decoration: InputDecoration(
        //     labelText: label,
        //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //   ),
        //   items: [null, ...items].map((val) {
        //     return DropdownMenuItem(
        //       value: val,
        //       child: Text(val ?? AppLocalizations.of(context).all, overflow: TextOverflow.ellipsis),
        //     );
        //   }).toList(),
        //   onChanged: onChanged,
        // ),
        child: DropdownButtonFormField<City>(
          isExpanded: true,
          value: selectedCity,
          decoration: InputDecoration(
            labelText: label,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [null, ...cityList].map((city) {
            return DropdownMenuItem<City>(
              value: city,
              child: Text(
                city?.getName(widget.localeProvider.language.code) ?? AppLocalizations.of(context).all,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (City? newCity) {
            setState(() {
              selectedCity = newCity;
            });
          },
        ));
  }

  Widget _buildStateDropdown(String label) {
    final langCode = widget.localeProvider.language.code;

    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<Province>(
        isExpanded: true,
        value: selectedProvince,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [null, ...stateList].map((state) {
          return DropdownMenuItem<Province>(
            value: state,
            child: Text(
              state?.getName(langCode) ?? AppLocalizations.of(context).all,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (Province? selected) {
          setState(() {
            selectedProvince = selected;
            selectedCity = null;

            final citiesMap = selected?.cities ?? {};
            cityList = citiesMap.entries
                .map((entry) => City(
                      nameEn: entry.value["en"] ?? '',
                      nameKo: entry.value["ko"] ?? '',
                      stateEn: selected?.nameEn ?? '',
                      stateKo: selected?.nameKo ?? '',
                    ))
                .toList();
          });
        },
      ),
    );
  }

  Widget _buildCityDropdown(String label) {
    final langCode = widget.localeProvider.language.code;

    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<City>(
        isExpanded: true,
        value: selectedCity,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [null, ...cityList].map((city) {
          return DropdownMenuItem<City>(
            value: city,
            child: Text(
              city?.getName(langCode) ?? AppLocalizations.of(context).all,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (City? selected) {
          setState(() {
            selectedCity = selected;
          });
        },
      ),
    );
  }

  Widget _buildTextInput(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return SizedBox(
      width: 160,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: (_) => _onSearch(), // 👈 triggers search on Enter
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
