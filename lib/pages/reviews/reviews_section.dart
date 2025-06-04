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

  // review card list pagination
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  List<Map<String, dynamic>> get _pagedReviews {
    final start = _currentPage * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, widget.reviews.length);
    return widget.reviews.sublist(start, end);
  }

  List<int> get _visiblePageNumbers {
    const windowSize = 5;
    final totalPages = (widget.reviews.length / _itemsPerPage).ceil();

    if (totalPages == 0) return [];

    final maxStart = (totalPages - windowSize).clamp(0, totalPages);
    int start = (_currentPage - (windowSize ~/ 2)).clamp(0, maxStart);
    int end = (start + windowSize).clamp(0, totalPages);

    return List.generate(end - start, (i) => start + i);
  }

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
          ),

        // **Reviews List**
        // if (widget.reviews.isNotEmpty)
        //   ListView.builder(
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: widget.reviews.length,
        //     itemBuilder: (context, index) {
        //       final review = widget.reviews[index];
        //       return ReviewCard(review: review);
        //     },
        //   ),
        // **Reviews List**
        if (widget.reviews.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pagedReviews.length,
            itemBuilder: (context, index) {
              final review = _pagedReviews[index];
              return ReviewCard(review: review);
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            children: [
              // First
              if (_currentPage > 0)
                TextButton(
                  onPressed: () => setState(() => _currentPage = 0),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    foregroundColor: Colors.black87,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Icon(Icons.first_page, size: 16), //const Text('«', style: TextStyle(fontSize: 14)),
                ),
              // Previous
              if (_currentPage > 0)
                TextButton(
                  onPressed: () => setState(() => _currentPage -= 1),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    foregroundColor: Colors.black87,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Icon(Icons.chevron_left, size: 16), //const Text('<', style: TextStyle(fontSize: 13)),
                ),

              // Page buttons
              ..._visiblePageNumbers.map(
                (i) => TextButton(
                  onPressed: () => setState(() => _currentPage = i),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: _currentPage == i ? Colors.blue : Colors.transparent,
                    foregroundColor: _currentPage == i ? Colors.white : Colors.black87,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   side: _currentPage == i ? BorderSide.none : const BorderSide(color: Colors.grey),
                    // ),
                  ),
                  child: Text('${i + 1}', style: const TextStyle(fontSize: 11)),
                ),
              ),

              // Next
              if (_currentPage < (widget.reviews.length / _itemsPerPage).ceil() - 1)
                TextButton(
                  onPressed: () => setState(() => _currentPage += 1),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    foregroundColor: Colors.black87,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Icon(Icons.chevron_right, size: 16), //const Text('>', style: TextStyle(fontSize: 13)),
                ),
              // Last
              if (_currentPage < (widget.reviews.length / _itemsPerPage).ceil() - 1)
                TextButton(
                  onPressed: () => setState(() => _currentPage = (widget.reviews.length / _itemsPerPage).ceil() - 1),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    foregroundColor: Colors.black87,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Icon(Icons.last_page, size: 16), //const Text('»', style: TextStyle(fontSize: 13)),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
