import 'package:flutter/material.dart';
import 'package:jippin/pages/reviews/review_card.dart';
import 'package:jippin/pages/reviews/empty_reviews_page.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/models/address.dart';

class ReviewsSection extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final Function(String) onSortSelected;
  final String qCountry;
  final String qLandlord;
  final Address qAddress;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.onSortSelected,
    required this.qCountry,
    required this.qLandlord,
    required this.qAddress,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  String? selectedSort;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> sortOptions = {
      'most_recent': AppLocalizations.of(context).sort_most_recent,
      'highest_rating': AppLocalizations.of(context).sort_highest_rating,
      'lowest_rating': AppLocalizations.of(context).sort_lowest_rating,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // **Reviews Section Header**
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              if (widget.reviews.isNotEmpty)
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.reviews, size: 22, color: Colors.blueAccent),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.reviews.length} ${AppLocalizations.of(context).reviews}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              if (widget.reviews.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSort,
                      isDense: true,
                      iconSize: 18,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      hint: Text(
                        selectedSort != null ? sortOptions[selectedSort]! : AppLocalizations.of(context).sortBy,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      items: sortOptions.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSort = newValue;
                        });
                        widget.onSortSelected(newValue!);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // **Handle Empty Reviews**
        if (widget.reviews.isEmpty)
          EmptyReviewsPage(
            qCountry: widget.qCountry,
            qLandlord: widget.qLandlord,
            qAddress: widget.qAddress,
          ), //buildEmptyReviewsPage(context),

        // **Reviews List**
        if (widget.reviews.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              return ReviewCard(review: review);
            },
          ),
      ],
    );
  }
}
