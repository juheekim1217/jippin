import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewsPage extends StatelessWidget {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchAllReviews() async {
    final response = await supabase
        .from('review')
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('Error fetching reviews');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final reviews = snapshot.data ?? [];

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

  // Build the overall rating section
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
            _buildRatingCategory('Check-in', 5.0),
            _buildRatingCategory('Communication', 5.0),
            _buildRatingCategory('Location', 5.0),
            _buildRatingCategory('Value', 4.7),
          ],
        ),
      ),
    );
  }

  // Build individual rating categories
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

  // Build the reviews section
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

  // Build individual review cards
  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            review['user_avatar'] ?? 'https://via.placeholder.com/50',
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review['user_name'] ?? 'Anonymous',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(
                5,
                    (index) => Icon(
                  Icons.star,
                  size: 16,
                  color: index < (review['rating'] ?? 0)
                      ? Colors.amber
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              review['review_date'] ?? '1 week ago',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(review['comment'] ?? 'No comment provided.'),
          ],
        ),
      ),
    );
  }
}
