import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/services/review_service.dart';
import 'package:jippin/component/footer.dart';
import 'package:jippin/component/country_dropdown.dart';
import 'package:jippin/models/province.dart';
import 'package:jippin/services/country_data_service.dart';
import 'package:jippin/component/province_dropdown.dart';
import 'package:jippin/component/city_dropdown.dart';

import 'package:jippin/models/country.dart';

class SubmitReviewPage extends StatefulWidget {
  const SubmitReviewPage({super.key});

  @override
  State<SubmitReviewPage> createState() => _SubmitReviewPageState();
}

class _SubmitReviewPageState extends State<SubmitReviewPage> {
  final _formKey = GlobalKey<FormState>();
  List<Province> provinceList = CountryDataService().provinceMap.values.toList();

  // Required fields
  String _content = '';
  String _landlord = '';
  String _country = '';
  String _city = '';
  String _address = '';

  // Ratings
  int _ratingTrust = 0;
  int _ratingPrice = 0;
  int _ratingLocation = 0;
  int _ratingCondition = 0;

  // Optional fields
  String? _realtor;
  String? _rentalType;
  int? _rent;
  int? _deposit;
  int? _occupiedYear;
  bool _fraud = false;
  String? _province;
  String? _postalCode;
  String? _countryCode;
  String? _street;

  Country? _selectedCountry;
  Province? _selectedProvince;

  Future<void> _submitReview() async {
    final local = AppLocalizations.of(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await ReviewService.createReview({
          'review': _content,
          'landlord': _landlord,
          'realtor': _realtor,
          'rating_trust': _ratingTrust,
          'rating_price': _ratingPrice,
          'rating_location': _ratingLocation,
          'rating_condition': _ratingCondition,
          'overall_rating': (_ratingTrust + _ratingPrice + _ratingLocation + _ratingCondition) / 5,
          'rental_type': _rentalType,
          'rent': _rent,
          'deposit': _deposit,
          'occupied_year': _occupiedYear,
          'fraud': _fraud,
          'country': _country,
          'province': _province,
          'city': _city,
          'postal_code': _postalCode,
          'country_code': _countryCode,
          'street': _address,
          'street_number': _street,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(local.submit_review_success)),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${local.submit_review_error}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 800;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column: Address & Basic Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildPropertyFormFields(local),
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Right Column: Ratings, Cost, Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildReviewFormFields(local),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildPropertyFormFields(local) + _buildReviewFormFields(local),
                          ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                child: Text(local.submit_review_submit_button),
              ),
            ),

            const SizedBox(height: 48),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReviewFormFields(AppLocalizations local) {
    return [
      CheckboxListTile(
        title: const Text('Was this rental a scam or fraud?'),
        value: _fraud,
        onChanged: (val) => setState(() => _fraud = val ?? false),
      ),
      _buildTextField(local.submit_review_review_content_label, true, (val) => _content = val!, maxLines: 5),
      _buildRatingField("Trustworthiness", _ratingTrust, (val) => _ratingTrust = val),
      _buildRatingField("Price", _ratingPrice, (val) => _ratingPrice = val),
      _buildRatingField("Location", _ratingLocation, (val) => _ratingLocation = val),
      _buildRatingField("Condition", _ratingCondition, (val) => _ratingCondition = val),
    ];
  }

  List<Widget> _buildPropertyFormFields(AppLocalizations local) {
    return [
      _buildSearchDropdown(AppLocalizations.of(context).country, "Country", local, true, (val) => _country = val!),
      _buildSearchDropdown(AppLocalizations.of(context).state, "Province", local, false, (val) => _province = val),
      _buildSearchDropdown(AppLocalizations.of(context).city, "City", local, true, (val) => _city = val!),
      _buildTextField('Street', false, (val) => _street = val),
      _buildTextField('Postal Code', false, (val) => _postalCode = val),
      _buildTextField(local.submit_review_landlord_label, true, (val) => _landlord = val!),
      _buildTextField(local.submit_review_realtor_label, true, (val) => _address = val!),
      _buildTextField('Rental Type', false, (val) => _rentalType = val),
      _buildIntField('Rent', (val) => _rent = val),
      _buildIntField('Deposit', (val) => _deposit = val),
      _buildIntField('Occupied Year', (val) => _occupiedYear = val),
    ];
  }

  Widget _buildSearchDropdown(String label, String type, AppLocalizations local, bool required, FormFieldSetter<String?> onSaved, {int maxLines = 1}) {
    if (type == "Province") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ProvinceDropdown(
          label: label,
          country: _selectedCountry, // 👈 Pass selected province
          onChanged: (province) {
            setState(() {
              _selectedProvince = province;
            });
          },
        ),
      );
    } else if (type == "City") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CityDropdown(
          label: label,
          province: _selectedProvince, // 👈 Pass selected province
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CountryDropdown(
        label: label,
        onChanged: (selected) {
          setState(() {
            _selectedCountry = selected;
          });
        },
      ),
    );
  }

  Widget _buildTextField(String label, bool required, FormFieldSetter<String?> onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        maxLines: maxLines,
        validator: required ? (val) => (val == null || val.isEmpty) ? 'Required' : null : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildIntField(String label, void Function(int?) onSaved) {
    return _buildTextField(label, false, (val) => onSaved(int.tryParse(val ?? '')));
  }

  Widget _buildRatingField(String label, int rating, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: rating.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: rating.toString(),
                  onChanged: (value) => setState(() => onChanged(value.toInt())),
                ),
              ),
              Text('$rating'),
            ],
          ),
        ],
      ),
    );
  }
}
