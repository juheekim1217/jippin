import 'package:flutter/material.dart';
import 'package:jippin/style/GlobalScaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:jippin/locale_provider.dart';
import 'package:jippin/style/constants.dart';

class ReviewsPage extends StatelessWidget {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchAllReviews() async {
    final response = await supabase
        .from('review') // Using the 'review' table
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('Error fetching reviews');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return Center(
              child: Text('No reviews available'),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Check if the width is large enough for two columns
              bool isWide = constraints.maxWidth > 800;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column 1: Overall Rating
                          Expanded(
                            flex: 2,
                            child: _buildOverallRatingSection(context),
                          ),
                          const SizedBox(width: 24), // Spacing between columns

                          // Column 2: Reviews
                          Expanded(
                            flex: 3,
                            child: _buildReviewsSection(context, reviews),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column 1: Overall Rating
                          _buildOverallRatingSection(context),

                          const SizedBox(height: 24), // Spacing

                          // Column 2: Reviews
                          _buildReviewsSection(context, reviews),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOverallRatingSection(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Rating
            Row(
              children: const [
                Icon(Icons.star, size: 40, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  '4.67',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.overallrating,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Histogram for star ratings
            ...List.generate(5, (index) {
              return Row(
                children: [
                  Text('${5 - index}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (5 - index) / 5, // Example data
                      color: Colors.amber,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${5 - index}', style: const TextStyle(fontSize: 14)),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Categories Ratings
            _buildRatingCategory(AppLocalizations.of(context)!.trustworthiness, 4.8),
            _buildRatingCategory(AppLocalizations.of(context)!.price, 5.0),
            _buildRatingCategory(AppLocalizations.of(context)!.location, 5.0),
            _buildRatingCategory(AppLocalizations.of(context)!.condition, 5.0),
            _buildRatingCategory(AppLocalizations.of(context)!.safety, 4.7),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCategory(String category, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(category, style: const TextStyle(fontSize: 14)),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, List<Map<String, dynamic>> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reviews Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${reviews.length} reviews',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              items: const [
                DropdownMenuItem(
                  value: 'most_recent',
                  child: Text('Most recent'),
                ),
                DropdownMenuItem(
                  value: 'highest_rating',
                  child: Text('Highest rating'),
                ),
                DropdownMenuItem(
                  value: 'lowest_rating',
                  child: Text('Lowest rating'),
                ),
              ],
              onChanged: (value) {
                // Handle sorting logic here
              },
              hint: const Text('Most recent'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Search Bar
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search reviews',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Reviews List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return _buildReviewCard(context, review);
          },
        ),
      ],
    );
  }

  // Helper to build individual review cards
  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < smallScreenWidth;

    // Calculate the overall rating as the average of the five categories
    final ratings = [
      review['rating_trust'] ?? 0,
      review['rating_price'] ?? 0,
      review['rating_location'] ?? 0,
      review['rating_condition'] ?? 0,
      review['rating_safety'] ?? 0,
    ];
    final overallRating = ratings.where((rating) => rating > 0).isNotEmpty // Handle missing ratings
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0.0;

    final String country = review['country'];
    final String currency = country == 'CANADA' ? '\$' : '만원';
    final String address = '${review['country']}, ${review['state']}, ${review['city']}, ${review['district']}, ${review['street']}, ${review['postal_code']}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Landlord section
            Row(
              children: [
                Text(
                  '${review['landlord'] ?? 'Unknown'}',
                  // Title text
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                if (review['fraud'] != null && review['fraud'])
                  Tooltip(
                    message: "This landlord has been reported for fraud or deception by the reviewer.",
                    child: Icon(Icons.gavel, size: 30, color: Colors.red),
                  ),
              ],
            ),

            // Address section
            const SizedBox(height: 4),
            Row(
              children: [
                Tooltip(
                  message: "Address",
                  child: Icon(Icons.location_on, size: 20, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                Flexible(
                  // Allows the text to wrap instead of overflowing
                  child: Text(
                    address ?? "Unknown",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
                    softWrap: true, // Enables wrapping
                  ),
                ),
              ],
            ),

            // Realtor section
            if (review['realtor'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                // Adds a top margin of 16 pixels
                child: Row(
                  children: [
                    Tooltip(
                      message: "Realtor",
                      child: Icon(Icons.real_estate_agent, size: 20, color: Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${review['realtor'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),

            // Ratings section
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSmallScreen)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: overallRating > 4
                          ? Colors.greenAccent
                          : overallRating > 3
                              ? Colors.amberAccent
                              : overallRating > 2
                                  ? Colors.redAccent
                                  : Colors.red, // Assign color based on rating
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      overallRating.toStringAsFixed(1), // Display 1 decimal place
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                SizedBox(width: 16),
                // Ratings
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ratings Section
                      _buildRatingRow(AppLocalizations.of(context)!.trustworthiness, review['rating_trust']),
                      _buildRatingRow(AppLocalizations.of(context)!.price, review['rating_price']),
                      _buildRatingRow(AppLocalizations.of(context)!.location, review['rating_location']),
                      _buildRatingRow(AppLocalizations.of(context)!.condition, review['rating_condition']),
                      _buildRatingRow(AppLocalizations.of(context)!.safety, review['rating_safety']),
                    ],
                  ),
                ),
              ],
            ),

            // Rent Details section
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            if (review['occupied_year'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.occupiedYear, review['occupied_year'].toString(), country, currency),
            if (review['rental_type'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.type, review['rental_type'], country, currency),
            if (review['rent'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.rent, '${review['rent'].toString()}', country, currency),
            if (review['deposit'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.deposit, '${review['deposit'].toString()}', country, currency),
            if (review['other_fees'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.otherFees, '${review['other_fees'].toString()}', country, currency),

            // Title and Written Review section
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              review['title'] ?? 'No Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              review['review'] ?? 'No review provided.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build rating rows
  Widget _buildRatingRow(String category, int? rating) {
    final stars = List.generate(
      rating ?? 0,
      (index) => Icon(Icons.star, color: Colors.amber, size: 12),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              category,
              style: TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(width: 8),
          Row(children: stars),
        ],
      ),
    );
  }

  // Helper to build Rent Details rows
  Widget _buildRentDetailRow(String category, String value, String country, String currency) {
    String formattedValue = country == 'CANADA' ? '$currency $value' : value;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Adds a top margin of 16 pixels
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Column
          SizedBox(
            width: 100, // Fixed width for the label column
            child: Text(
              category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          // Value Column
          Expanded(
            child: Text(
              value ?? 'Unknown',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
