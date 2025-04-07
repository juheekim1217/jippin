import 'package:flutter/material.dart';
import 'package:jippin/pages/reviews/address_link.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/models/address.dart';

class OverallRatingCard extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;

  const OverallRatingCard({
    super.key,
    required this.reviews,
  });

  @override
  State<OverallRatingCard> createState() => _OverallRatingCardState();
}

class _OverallRatingCardState extends State<OverallRatingCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    final starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalTrust = 0, totalPrice = 0, totalLocation = 0, totalCondition = 0, totalSafety = 0;
    int count = 0;

    for (var review in widget.reviews) {
      if (review.values.every((value) => value != null)) {
        double reviewAvg = (review['rating_trust'] + review['rating_price'] + review['rating_location'] + review['rating_condition'] + review['rating_safety']) / 5;
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

    double avgTrust = count > 0 ? totalTrust / count : 0.0;
    double avgPrice = count > 0 ? totalPrice / count : 0.0;
    double avgLocation = count > 0 ? totalLocation / count : 0.0;
    double avgCondition = count > 0 ? totalCondition / count : 0.0;
    double avgSafety = count > 0 ? totalSafety / count : 0.0;
    double overallRating = count > 0 ? (avgTrust + avgPrice + avgLocation + avgCondition + avgSafety) / 5 : 0.0;
    int totalReviews = starCounts.values.reduce((a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressLink(),
        const SizedBox(height: 28),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallRatingDisplay(overallRating),
                const SizedBox(height: 16),
                _buildStarHistogram(starCounts, totalReviews),
                const SizedBox(height: 20),
                _buildCategoryRatings(context, avgTrust, avgPrice, avgLocation, avgCondition, avgSafety),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallRatingDisplay(double rating) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 44, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              rating.toStringAsFixed(2),
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
      ],
    );
  }

  Widget _buildStarHistogram(Map<int, int> starCounts, int totalReviews) {
    return Column(
      children: List.generate(5, (index) {
        int starValue = 5 - index;
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
    );
  }

  Widget _buildCategoryRatings(BuildContext context, double avgTrust, double avgPrice, double avgLocation, double avgCondition, double avgSafety) {
    return Column(
      children: [
        _buildRatingCategory(AppLocalizations.of(context).trustworthiness, avgTrust, Icons.check_circle_outline),
        _buildRatingCategory(AppLocalizations.of(context).price, avgPrice, Icons.sell_outlined),
        _buildRatingCategory(AppLocalizations.of(context).location, avgLocation, Icons.map_outlined),
        _buildRatingCategory(AppLocalizations.of(context).condition, avgCondition, Icons.other_houses_outlined),
        _buildRatingCategory(AppLocalizations.of(context).safety, avgSafety, Icons.shield_outlined),
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
}
