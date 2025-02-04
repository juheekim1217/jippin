import 'package:flutter/material.dart';
import 'package:jippin/style/GlobalScaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubmitReviewPage extends StatefulWidget {
  const SubmitReviewPage({super.key});

  @override
  _SubmitReviewPageState createState() => _SubmitReviewPageState();
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

  // Function to handle form submission and save review to Supabase
  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form values

      try {
        final response = await Supabase.instance.client.from('review').insert({
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

        if (response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review Submitted: $_title')),
          );
          _formKey.currentState!.reset(); // Reset form after submission
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error!.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      body: SingleChildScrollView(
        // Make the entire body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title input field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Review Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16),

              // Content input field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Review Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5, // Allow multiline content
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content for your review';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              SizedBox(height: 16),

              // Landlord input field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Landlord or Building Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the landlord or building name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _landlord = value!;
                },
              ),
              SizedBox(height: 16),

              // Address input field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address or Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address or location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              SizedBox(height: 16),

              // Ratings (for Trust, Price, Location, Condition, and Safety)
              _buildRatingField('Trustworthiness', (value) {
                setState(() {
                  _ratingTrust = value!;
                });
              }),
              _buildRatingField('Price', (value) {
                setState(() {
                  _ratingPrice = value!;
                });
              }),
              _buildRatingField('Location', (value) {
                setState(() {
                  _ratingLocation = value!;
                });
              }),
              _buildRatingField('Condition', (value) {
                setState(() {
                  _ratingCondition = value!;
                });
              }),
              _buildRatingField('Safety', (value) {
                setState(() {
                  _ratingSafety = value!;
                });
              }),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the rating input fields
  Widget _buildRatingField(String label, Function(int?) onSaved) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Expanded(
          child: Slider(
            value: (label == 'Trustworthiness'
                    ? _ratingTrust
                    : label == 'Price'
                        ? _ratingPrice
                        : label == 'Location'
                            ? _ratingLocation
                            : label == 'Condition'
                                ? _ratingCondition
                                : _ratingSafety)
                .toDouble(),
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
        Text(
            '${(label == 'Trustworthiness' ? _ratingTrust : label == 'Price' ? _ratingPrice : label == 'Location' ? _ratingLocation : label == 'Condition' ? _ratingCondition : _ratingSafety)}',
            style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
