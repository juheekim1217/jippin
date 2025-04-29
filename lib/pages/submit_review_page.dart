import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/services/review_service.dart';

class SubmitReviewPage extends StatefulWidget {
  const SubmitReviewPage({super.key});

  @override
  State<SubmitReviewPage> createState() => _SubmitReviewPageState();
}

class _SubmitReviewPageState extends State<SubmitReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _landlord = '';
  String _address = '';
  int _ratingTrust = 0;
  int _ratingPrice = 0;
  int _ratingLocation = 0;
  int _ratingCondition = 0;
  int _ratingSafety = 0;

  // Function to handle form submission and save review
  Future<void> _submitReview() async {
    final AppLocalizations local = AppLocalizations.of(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form values

      try {
        await ReviewService.createReview({
          'title': _title,
          'review': _content,
          'landlord': _landlord,
          'address': _address,
          'rating_trust': _ratingTrust,
          'rating_price': _ratingPrice,
          'rating_location': _ratingLocation,
          'rating_condition': _ratingCondition,
          'rating_safety': _ratingSafety,
        });

        if (!mounted) return; // Ensure widget is still in the tree

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${local.submit_review_success}: $_title')),
        );
        _formKey.currentState!.reset(); // Reset form after success
      } catch (e) {
        if (!mounted) return; // Prevent calling context if widget is disposed

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${local.submit_review_error}:  $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context);

    return GlobalPageLayoutScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: local.submit_review_review_title_label,
                errorMessage: local.submit_review_review_title_error,
                onSaved: (value) => _title = value!,
              ),
              _buildTextField(
                label: local.submit_review_review_content_label,
                errorMessage: local.submit_review_review_content_error,
                onSaved: (value) => _content = value!,
                maxLines: 5,
              ),
              _buildTextField(
                label: local.submit_review_landlord_label,
                errorMessage: local.submit_review_landlord_error,
                onSaved: (value) => _landlord = value!,
              ),
              _buildTextField(
                label: local.submit_review_address_label,
                errorMessage: local.submit_review_address_error,
                onSaved: (value) => _address = value!,
              ),
              _buildRatingField(local.submit_review_trustworthiness, (value) => _ratingTrust = value!),
              _buildRatingField(local.submit_review_price, (value) => _ratingPrice = value!),
              _buildRatingField(local.submit_review_location, (value) => _ratingLocation = value!),
              _buildRatingField(local.submit_review_condition, (value) => _ratingCondition = value!),
              _buildRatingField(local.submit_review_safety, (value) => _ratingSafety = value!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text(local.submit_review_submit_button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String errorMessage,
    required Function(String?) onSaved,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) => value == null || value.isEmpty ? errorMessage : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildRatingField(String label, Function(int?) onSaved) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Expanded(
          child: Slider(
            value: _getRating(label).toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (value) {
              setState(() {
                onSaved(value.toInt());
              });
            },
          ),
        ),
        Text('${_getRating(label)}', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  int _getRating(String label) {
    return label == "Trustworthiness"
        ? _ratingTrust
        : label == "Price"
            ? _ratingPrice
            : label == "Location"
                ? _ratingLocation
                : label == "Condition"
                    ? _ratingCondition
                    : _ratingSafety;
  }
}
