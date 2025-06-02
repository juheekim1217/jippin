import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
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
import 'package:jippin/models/rental_types.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';

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
  String _province = '';
  String _city = '';

  String? _postalCode;
  String? _countryCode;
  String? _street;

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

  //int? _occupiedYear;
  //bool _fraud = false;

  Country? _selectedCountry;
  Province? _selectedProvince;

  // Future<void> _submitReview(AppLocalizations local) async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     try {
  //       await ReviewService.createReview({
  //         'review': _content,
  //         'landlord': _landlord,
  //         'realtor': _realtor,
  //         'rating_trust': _ratingTrust,
  //         'rating_price': _ratingPrice,
  //         'rating_location': _ratingLocation,
  //         'rating_condition': _ratingCondition,
  //         'overall_rating': (_ratingTrust + _ratingPrice + _ratingLocation + _ratingCondition) / 4,
  //         'rental_type': _rentalType,
  //         'rent': _rent,
  //         'deposit': _deposit,
  //         //'occupied_year': _occupiedYear,
  //         //'fraud': _fraud,
  //         'country': _country,
  //         'province': _province,
  //         'city': _city,
  //         'postal_code': _postalCode,
  //         'country_code': _countryCode,
  //         'street': _street,
  //       });
  //
  //       if (!mounted) return;
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(local.submit_review_success)),
  //       );
  //       _formKey.currentState!.reset();
  //     } catch (e) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('${local.submit_review_error}: $e')),
  //       );
  //     }
  //   }
  // }

  Future<void> _submitReview(AppLocalizations local) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Step 1: Run reCAPTCHA
        final token = await GRecaptchaV3.execute('submit_review');

        if (token == null || token.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(local.submit_review_error)),
          );
          return;
        }

        // Step 2: Optionally send `token` to your backend to verify it with Google

        // Step 3: Submit review
        await ReviewService.createReview({
          'review': _content,
          'landlord': _landlord,
          'realtor': _realtor,
          'rating_trust': _ratingTrust,
          'rating_price': _ratingPrice,
          'rating_location': _ratingLocation,
          'rating_condition': _ratingCondition,
          'overall_rating': (_ratingTrust + _ratingPrice + _ratingLocation + _ratingCondition) / 4,
          'rental_type': _rentalType,
          'rent': _rent,
          'deposit': _deposit,
          'country': _country,
          'province': _province,
          'city': _city,
          'postal_code': _postalCode,
          'country_code': _countryCode,
          'street': _street,
          'captcha_token': token, // Optional: store for audit
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
    final localeProvider = Provider.of<LocaleProvider>(context);
    _country = localeProvider.country.nameEn;
    _countryCode = localeProvider.country.code;

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
                                  children: _buildPropertyFormFields(local, localeProvider),
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
                            children: _buildPropertyFormFields(local, localeProvider) + _buildReviewFormFields(local),
                          ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () => _submitReview(local),
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
      // CheckboxListTile(
      //   title: const Text('Was this rental a scam or fraud?'),
      //   value: _fraud,
      //   onChanged: (val) => setState(() => _fraud = val ?? false),
      // ),
      //const SizedBox(height: 16),
      _buildTextField(local.submit_review_review_content_label, local, true, (val) => _content = val!, maxLines: 5),
      _buildRatingField(local.trustworthiness, _ratingTrust, (val) => _ratingTrust = val),
      _buildRatingField(local.price, _ratingPrice, (val) => _ratingPrice = val),
      _buildRatingField(local.location, _ratingLocation, (val) => _ratingLocation = val),
      _buildRatingField(local.condition, _ratingCondition, (val) => _ratingCondition = val),
    ];
  }

  List<Widget> _buildPropertyFormFields(AppLocalizations local, LocaleProvider localeProvider) {
    return [
      _buildSearchDropdown(local.country, "Country", local, true, (val) => _country = val!),
      _buildSearchDropdown(local.state, "Province", local, true, (val) => _province = val!),
      _buildSearchDropdown(local.city, "City", local, true, (val) => _city = val!),
      _buildTextField(local.street, local, true, (val) => _street = val),
      _buildTextField(local.zip, local, true, (val) => _postalCode = val),
      _buildTextField(local.submit_review_landlord_label, local, true, (val) => _landlord = val!),
      _buildTextField(local.submit_review_realtor_label, local, false, (val) => _realtor = val!),
      _buildRentalTypeDropdown(local.rental_type, local, true, (val) => _rentalType = val),
      _buildIntField('${local.rent} (${localeProvider.country.getCountryCurrency(localeProvider.language.code)})', local, true, (val) => _rent = val),
      _buildIntField('${local.deposit} (${localeProvider.country.getCountryCurrency(localeProvider.language.code)})', local, true, (val) => _deposit = val),
    ];
  }

  Widget _buildSearchDropdown(String label, String type, AppLocalizations local, bool required, FormFieldSetter<String?> onSaved) {
    if (type == "Province") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ProvinceDropdown(
          label: label,
          country: _selectedCountry, // 👈 Pass selected province
          onChanged: (province) {
            setState(() {
              _selectedProvince = province;
              _province = province!.en;
            });
          },
          required: required,
        ),
      );
    } else if (type == "City") {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CityDropdown(
          label: label,
          province: _selectedProvince, // 👈 Pass selected province
          onChanged: (city) {
            setState(() {
              _city = city!.en;
            });
          },
          required: required,
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
            _country = selected!.nameEn;
            _countryCode = selected.code;
          });
        },
        required: required,
      ),
    );
  }

  Widget _buildTextField(String label, AppLocalizations local, bool required, FormFieldSetter<String?> onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        maxLines: maxLines,
        validator: required ? (val) => (val == null || val.isEmpty) ? local.required : null : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildIntField(
    String label,
    AppLocalizations local,
    bool required,
    void Function(int?) onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: TextInputType.number,
        validator: (val) {
          if (required && (val == null || val.trim().isEmpty)) {
            return local.required;
          }
          if (val != null && val.trim().isNotEmpty && int.tryParse(val.trim()) == null) {
            return local.invalid_number; // Add this key to your localization ARB files
          }
          return null;
        },
        onSaved: (val) => onSaved(int.tryParse(val?.trim() ?? '')),
      ),
    );
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

  Widget _buildRentalTypeDropdown(
    String label,
    AppLocalizations local,
    bool required,
    void Function(String?) onSaved,
  ) {
    final localeCode = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: _rentalType,
        items: rentalTypes
            .map((type) => DropdownMenuItem<String>(
                  value: type.key,
                  child: Text(type.getLabel(localeCode)),
                ))
            .toList(),
        onChanged: (value) => setState(() => _rentalType = value),
        validator: required ? (val) => (val == null || val.isEmpty) ? local.required : null : null,
        onSaved: onSaved,
      ),
    );
  }
}
