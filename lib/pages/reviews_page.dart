import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/pages/reviews/reviews_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:jippin/pages/reviews/overall_rating_card.dart';

class ReviewsPage extends StatefulWidget {
  final String defaultCountryCode;
  final String qCountry;
  final String qDetails;
  final String qLandlord;
  final String qProperty;
  final String qRealtor;
  final Address qAddress;

  const ReviewsPage({
    super.key,
    required this.defaultCountryCode,
    required this.qCountry,
    required this.qDetails,
    required this.qLandlord,
    required this.qProperty,
    required this.qRealtor,
    required this.qAddress,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allReviews = [];
  List<Map<String, dynamic>> filteredReviews = [];
  bool isLoading = true;
  String errorMessage = '';
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    _fetchAllReviews();
  }

  @override
  void didUpdateWidget(covariant ReviewsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Default Country is changed
    if (widget.defaultCountryCode.isNotEmpty && widget.defaultCountryCode != oldWidget.defaultCountryCode) {
      _fetchAllReviews();
    }
    if (widget.qAddress.city != oldWidget.qAddress.city || widget.qAddress.province != oldWidget.qAddress.province) {
      _applySearchFilter();
    }
  }

  // Fetch reviews from Supabase by Selected Country
  Future<void> _fetchAllReviews() async {
    try {
      final response = await supabase
          .from('review')
          .select('*') // ✅ Fetch all columns, or specify only required ones
          .eq('country_code', widget.defaultCountryCode)
          .order('created_at', ascending: false);
      debugPrint("_fetchAllReviews ${response.length}");

      if (response.isEmpty) {
        setState(() {
          isLoading = false;
          filteredReviews = List.empty();
        });
        return;
      }

      setState(() {
        allReviews = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });

      // Apply search filtering after fetching
      _applySearchFilter();
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching reviews: $error';
      });
    }
  }

  // Search filtering logic
  void _applySearchFilter() {
    setState(() {
      // Filtering Address
      final String province = widget.qAddress.province ?? "";
      final String city = widget.qAddress.city ?? "";
      final String street = widget.qAddress.street ?? "";
      filteredReviews = allReviews.where((review) {
        // Extract values safely (avoid null issues)
        String reviewProvince = review["province"]?.toString() ?? "";
        String reviewCity = review["city"]?.toString() ?? "";
        String reviewStreet = review["street"]?.toString() ?? "";
        // Apply exact match filtering (if the search field is not empty, it must match exactly)
        return (province.isEmpty || equalsIgnoreCase(reviewProvince, province)) && (city.isEmpty || equalsIgnoreCase(reviewCity, city)) && (street.isEmpty || containsIgnoreCase(reviewStreet, street));
      }).toList();

      // Filtering Landlord, Property, Realtor
      final String qDetails = widget.qDetails;
      final String qLandlord = widget.qLandlord;
      final String qProperty = widget.qProperty;
      final String qRealtor = widget.qRealtor;
      filteredReviews = filteredReviews.where((review) {
        String landlord = review["landlord"]?.toString() ?? "";
        String property = review["property"]?.toString() ?? "";
        String realtor = review["realtor"]?.toString() ?? "";
        // contains match: Apply filtering dynamically
        bool matchesDetails = qDetails.isEmpty || landlord.contains(qDetails) || property.contains(qDetails) || realtor.contains(qDetails);
        // exact match
        bool matchesLandlord = qLandlord.isEmpty || equalsIgnoreCase(landlord, qLandlord) || landlord.contains(qLandlord);
        bool matchesProperty = qProperty.isEmpty || equalsIgnoreCase(property, qProperty) || property.contains(qProperty);
        bool matchesRealtor = qRealtor.isEmpty || equalsIgnoreCase(realtor, qRealtor) || realtor.contains(qRealtor);
        return matchesDetails && matchesLandlord && matchesProperty && matchesRealtor;
      }).toList();
    });
  }

  void _applySortingReviews(String order) {
    setState(() {
      if (order == 'most_recent') {
        filteredReviews.sort((a, b) => DateTime.parse(b["created_at"]).compareTo(DateTime.parse(a["created_at"])));
      } else if (order == 'highest_rating') {
        filteredReviews.sort((a, b) => b["overall_rating"].compareTo(a["overall_rating"]));
      } else if (order == 'lowest_rating') {
        filteredReviews.sort((a, b) => a["overall_rating"].compareTo(b["overall_rating"]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPageLayoutScaffold(
      body: isLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: const CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
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
                                  child: OverallRatingCard(
                                    reviews: filteredReviews,
                                  ),
                                ),
                                const SizedBox(width: 24), // Spacing between columns

                                // Column 2: Reviews
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      ReviewsSection(
                                        reviews: filteredReviews,
                                        onSortSelected: _applySortingReviews,
                                        // Ensure this method is defined in ReviewsPage
                                        qCountry: widget.qCountry,
                                        qLandlord: widget.qLandlord,
                                        qAddress: widget.qAddress,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Column 1: Overall Rating
                                OverallRatingCard(
                                  reviews: filteredReviews,
                                ),
                                const SizedBox(height: 24), // Spacing

                                // Column 2: Reviews
                                //_buildReviewsSection(context, filteredReviews),
                                ReviewsSection(
                                  reviews: filteredReviews,
                                  onSortSelected: _applySortingReviews,
                                  // Ensure this method is defined in ReviewsPage
                                  qCountry: widget.qCountry,
                                  qLandlord: widget.qLandlord,
                                  qAddress: widget.qAddress,
                                ),
                              ],
                            ),
                    );
                  },
                ),
    );
  }
}
