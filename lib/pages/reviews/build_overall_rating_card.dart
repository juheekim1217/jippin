import 'package:flutter/material.dart';
import 'package:jippin/pages/reviews/build_address_link.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/models/address.dart';

Widget buildOverallRatingCard(BuildContext context, List<Map<String, dynamic>> reviews, String defaultCountryName, String qLandlord, Address qAddress) {
  if (reviews.isEmpty) {
    return const Text("");
  }

  // Star rating counts (1-5)
  Map<int, int> starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  // Initialize category rating sums and counts
  double totalTrust = 0, totalPrice = 0, totalLocation = 0, totalCondition = 0, totalSafety = 0;
  int count = 0;

  // Loop through reviews to sum up ratings and count stars
  for (var review in reviews) {
    if (review['rating_trust'] != null && review['rating_price'] != null && review['rating_location'] != null && review['rating_condition'] != null && review['rating_safety'] != null) {
      // Calculate average rating per review
      double reviewAvg = (review['rating_trust'] + review['rating_price'] + review['rating_location'] + review['rating_condition'] + review['rating_safety']) / 5;

      // Round to nearest star (1-5) and count
      int roundedStar = reviewAvg.round().clamp(1, 5);
      starCounts[roundedStar] = starCounts[roundedStar]! + 1;

      totalTrust += review['rating_trust'];
      totalPrice += review['rating_price'];
      totalLocation += review['rating_location'];
      totalCondition += review['rating_condition'];
      totalSafety += review['rating_safety'];
      count++;
    }
  }

  // Calculate the average ratings for each category
  double avgTrust = count > 0 ? totalTrust / count : 0.0;
  double avgPrice = count > 0 ? totalPrice / count : 0.0;
  double avgLocation = count > 0 ? totalLocation / count : 0.0;
  double avgCondition = count > 0 ? totalCondition / count : 0.0;
  double avgSafety = count > 0 ? totalSafety / count : 0.0;

  // Calculate the overall rating as the average of the category averages
  double overallRating = count > 0 ? (avgTrust + avgPrice + avgLocation + avgCondition + avgSafety) / 5 : 0.0;

  // Total reviews for histogram
  int totalReviews = starCounts.values.reduce((a, b) => a + b);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🌍 **Header Section Above the Card**
      buildAddressLink(context, defaultCountryName, qLandlord, qAddress),

      const SizedBox(height: 28),

      // ⭐ **The Rating Card**
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ **Overall Rating Display**
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 44, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    overallRating.toStringAsFixed(2), // Display with 2 decimal places
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  AppLocalizations.of(context).overallrating,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // 📊 **Histogram for Star Ratings**
              ...List.generate(5, (index) {
                int starValue = 5 - index; // 5-star at the top, 1-star at the bottom
                double percentage = totalReviews > 0 ? starCounts[starValue]! / totalReviews : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text('$starValue ★', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 8,
                            color: Colors.amber,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${starCounts[starValue]}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // 📌 **Categories Ratings**
              _buildRatingCategory(AppLocalizations.of(context).trustworthiness, avgTrust, Icons.check_circle_outline),
              _buildRatingCategory(AppLocalizations.of(context).price, avgPrice, Icons.sell_outlined),
              _buildRatingCategory(AppLocalizations.of(context).location, avgLocation, Icons.map_outlined),
              _buildRatingCategory(AppLocalizations.of(context).condition, avgCondition, Icons.other_houses_outlined),
              _buildRatingCategory(AppLocalizations.of(context).safety, avgSafety, Icons.shield_outlined),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildRatingCategory(String label, double rating, IconData icon) {
  return Row(
    children: [
      Icon(icon),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 16)),
      const Spacer(),
      Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}
