import 'package:flutter/material.dart';
import 'package:jippin/style/GlobalScaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                      child: _buildOverallRatingSection(),
                    ),
                    const SizedBox(width: 24), // Spacing between columns

                    // Column 2: Reviews
                    Expanded(
                      flex: 3,
                      child: _buildReviewsSection(reviews),
                    ),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1: Overall Rating
                    _buildOverallRatingSection(),

                    const SizedBox(height: 24), // Spacing

                    // Column 2: Reviews
                    _buildReviewsSection(reviews),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOverallRatingSection() {
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
            const Text(
              'Overall rating',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
            _buildRatingCategory('Cleanliness', 4.8),
            _buildRatingCategory('Accuracy', 5.0),
            _buildRatingCategory('Communication', 5.0),
            _buildRatingCategory('Location', 5.0),
            _buildRatingCategory('Value', 4.7),
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

  Widget _buildReviewsSection(List<Map<String, dynamic>> reviews) {
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
            return _buildReviewCard(review);
          },
        ),
      ],
    );
  }

  // Helper to build individual review cards
  Widget _buildReviewCard(Map<String, dynamic> review) {
    // Calculate the overall rating as the average of the five categories
    final ratings = [
      review['rating_trust'] ?? 0,
      review['rating_price'] ?? 0,
      review['rating_location'] ?? 0,
      review['rating_condition'] ?? 0,
      review['rating_safety'] ?? 0,
    ];
    final overallRating = ratings
        .where((rating) => rating > 0)
        .isNotEmpty // Handle missing ratings
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Rating
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
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

                // Ratings and Additional Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ratings Section
                      _buildRatingRow(
                          'Trustworthiness', review['rating_trust']),
                      _buildRatingRow('Price', review['rating_price']),
                      _buildRatingRow('Location', review['rating_location']),
                      _buildRatingRow('Condition', review['rating_condition']),
                      _buildRatingRow('Safety', review['rating_safety']),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Landlord, Realtor, and Address Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Landlord: ${review['landlord'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Realtor: ${review['realtor'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Address: ${review['address'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            // Title and Written Review
            Text(
              review['title'] ?? 'No Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
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
}
