import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:jippin/models/address.dart';
import 'package:jippin/models/province.dart';
import 'package:jippin/models/city.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:jippin/providers/review_query_provider.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/services/country_data_service.dart';

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

  List<Province> provinceList = CountryDataService().provinceMap.values.toList();
  List<City> cityList = [];

  late final TextEditingController streetController;
  late final TextEditingController landlordController;
  late final TextEditingController propertyController;
  late final TextEditingController realtorController;

  @override
  void initState() {
    super.initState();

    streetController = TextEditingController();
    landlordController = TextEditingController();
    propertyController = TextEditingController();
    realtorController = TextEditingController();

    _initializeFilters();
  }

  @override
  void dispose() {
    streetController.dispose();
    landlordController.dispose();
    propertyController.dispose();
    realtorController.dispose();
    super.dispose();
  }

  // set selected values to each filters after search
  Future<void> _initializeFilters() async {
    if (!mounted) return;

    final query = context.read<ReviewQueryProvider>();
    final address = query.qAddress;

    setState(() {
      selectedStreet = address.street;
      selectedLandlord = query.qLandlord;
      selectedProperty = query.qProperty;
      selectedRealtor = query.qRealtor;

      streetController.text = selectedStreet ?? '';
      landlordController.text = selectedLandlord ?? '';
      propertyController.text = selectedProperty ?? '';
      realtorController.text = selectedRealtor ?? '';

      // ✅ Set selectedProvince
      if (address.province.isNotEmpty) {
        selectedProvince = provinceList.firstWhere(
          (p) => p.en == address.province,
          //orElse: () => provinceList.first,
        );
        cityList = selectedProvince?.cityMap.values.toList() ?? [];
      }

      // ✅ Set selectedCity
      if (address.city!.isNotEmpty) {
        selectedCity = cityList.firstWhere(
          (c) => c.en == address.city,
          //orElse: () => null,
        );
      }
    });
  }

  void _onSearch() {
    final query = context.read<ReviewQueryProvider>();

    final address = Address(
      province: selectedProvince?.en ?? '',
      city: selectedCity?.en,
      provinceKo: selectedProvince?.ko,
      cityKo: selectedCity?.ko,
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
    final local = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStateDropdown(local.state),
            _buildCityDropdown(local.city),
            _buildTextInput(local.street, streetController, (val) => setState(() => selectedStreet = val)),
            _buildTextInput(local.landlord, landlordController, (val) => setState(() => selectedLandlord = val)),
            _buildTextInput(local.property, propertyController, (val) => setState(() => selectedProperty = val)),
            _buildTextInput(local.realtor, realtorController, (val) => setState(() => selectedRealtor = val)),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _onSearch,
          icon: const Icon(Icons.search),
          label: Text(local.search),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
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
        items: [null, ...provinceList].map((province) {
          return DropdownMenuItem<Province>(
            value: province,
            child: Text(
              province?.getName(langCode) ?? AppLocalizations.of(context).all,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (Province? selected) {
          setState(() {
            selectedProvince = selected;
            selectedCity = null;

            cityList = selected!.cityMap.values.toList();
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
        onFieldSubmitted: (_) => _onSearch(),
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
