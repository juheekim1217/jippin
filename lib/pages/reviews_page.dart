import 'package:flutter/material.dart';
import 'package:jippin/utility/global_page_layout_scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/utility/utils.dart';

class ReviewsPage extends StatefulWidget {
  final String searchQuery;
  final String defaultCountry;

  const ReviewsPage({super.key, required this.searchQuery, required this.defaultCountry});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final supabase = Supabase.instance.client;
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allReviews = [];
  List<Map<String, dynamic>> filteredReviews = [];
  bool isLoading = true;
  String errorMessage = '';
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    searchController.text = widget.searchQuery; // Set initial search query
    _fetchAllReviews();
  }

  @override
  void didUpdateWidget(covariant ReviewsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultCountry != oldWidget.defaultCountry) {
      _fetchAllReviews();
    }
    if (widget.searchQuery != oldWidget.searchQuery) {
      searchController.text = widget.searchQuery;
      _applySearchFilter(widget.searchQuery);
    }
  }

  // Fetch reviews from Supabase
  Future<void> _fetchAllReviews() async {
    try {
      final response = await supabase
          .from('review')
          .select('*') // ✅ Fetch all columns, or specify only required ones
          .eq('country_code', widget.defaultCountry)
          .order('created_at', ascending: false);
      debugPrint("_fetchAllReviews ${response.length}");
      if (response.isEmpty) {
        setState(() {
          isLoading = false;
          _buildEmptyReviewsPage();
        });
        return;
      }

      setState(() {
        allReviews = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });

      // Apply search filtering after fetching
      _applySearchFilter(widget.searchQuery);
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching reviews: $error';
      });
    }
  }

  // Search filtering logic
  void _applySearchFilter(String query) {
    setState(() {
      debugPrint("_applySearchFilter$query");
      if (query.isEmpty) {
        filteredReviews = List.from(allReviews);
      } else {
        //filteredReviews = allReviews.where((review) => review["city"].toLowerCase().contains(query.toLowerCase()) || review["address"].toLowerCase().contains(query.toLowerCase()) || review["postal_code"].toString().toLowerCase().contains(query.toLowerCase())).toList();
        filteredReviews = allReviews.where((review) => review["city"].toLowerCase().contains(query.toLowerCase())).toList();
      }
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
          ? const Center(child: CircularProgressIndicator())
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
                                  child: _buildOverallRatingSection(context, filteredReviews),
                                ),
                                const SizedBox(width: 24), // Spacing between columns

                                // Column 2: Reviews
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      _buildReviewsSection(context, filteredReviews),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Column 1: Overall Rating
                                _buildOverallRatingSection(context, filteredReviews),
                                const SizedBox(height: 24), // Spacing

                                // Column 2: Reviews
                                _buildReviewsSection(context, filteredReviews),
                              ],
                            ),
                    );
                  },
                ),
    );
  }

  Widget _buildOverallRatingSection(BuildContext context, List<Map<String, dynamic>> reviews) {
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

    String? countryName = getCountryName(widget.defaultCountry);
    String? searchQuery = widget.searchQuery.isEmpty ? "" : "- ${widget.searchQuery}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🌍 **Header Section Above the Card**
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$countryName $searchQuery",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
                    AppLocalizations.of(context)!.overallrating,
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
                _buildRatingCategory(AppLocalizations.of(context)!.trustworthiness, avgTrust, Icons.check_circle_outline),
                _buildRatingCategory(AppLocalizations.of(context)!.price, avgPrice, Icons.sell_outlined),
                _buildRatingCategory(AppLocalizations.of(context)!.location, avgLocation, Icons.map_outlined),
                _buildRatingCategory(AppLocalizations.of(context)!.condition, avgCondition, Icons.other_houses_outlined),
                _buildRatingCategory(AppLocalizations.of(context)!.safety, avgSafety, Icons.shield_outlined),
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

  Widget _buildReviewsSection(BuildContext context, List<Map<String, dynamic>> reviews) {
    String? countryName = getCountryName(widget.defaultCountry);
    String? searchQuery = widget.searchQuery.isEmpty ? "" : "- ${widget.searchQuery}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📌 **Reviews Section Header**
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              if (reviews.isNotEmpty)
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.reviews, size: 22, color: Colors.blueAccent), // ✅ Add an icon for visibility
                      const SizedBox(width: 6),
                      Text(
                        '${reviews.length} Reviews',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              if (reviews.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // ✅ Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSort,
                      focusColor: Colors.transparent,
                      dropdownColor: Colors.white,
                      isDense: true,
                      // ✅ Reduces default height
                      style: const TextStyle(fontSize: 14, color: Colors.black),

                      // ✅ Reduced Dropdown height using buttonHeight
                      iconSize: 18,
                      // Reduce dropdown arrow size
                      padding: EdgeInsets.zero,
                      // ✅ Remove extra padding

                      hint: Text(
                        selectedSort != null ? sortOptions[selectedSort]! : 'Sort by',
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
                        _applySortingReviews(newValue!);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 📌 **Handle Empty Reviews**
        if (reviews.isEmpty) _buildEmptyReviewsPage(),

        // 📌 **Reviews List**
        if (reviews.isNotEmpty)
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

  Widget _buildEmptyReviewsPage() {
    String? countryName = getCountryName(widget.defaultCountry);
    String? searchQuery = widget.searchQuery.isEmpty ? "" : "- ${widget.searchQuery}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$countryName $searchQuery",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Icon(Icons.rate_review, size: 64, color: Colors.grey), // ✅ Larger icon
          const SizedBox(height: 12),
          const Text(
            'No reviews yet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          const Text(
            'Be the first to share your experience!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/submit'); // ✅ Use your route name
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Write a Review"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
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

    String currency = '\$';
    String rent = '';
    String deposit = '';
    String otherFees = '';
    String address = '';
    if (review['country_code'] == 'KR') {
      currency = '만원';
      address = address = '${review['postal_code']} ${review['country']} ' '${review['province'] != null ? '${review['province']} ' : ''}' '${review['city']} ${review['district']} ${review['street']}';
      rent = '${review['rent'].toString()} $currency';
      deposit = '${review['deposit'].toString()} $currency';
      otherFees = '${review['other_fees'].toString()} $currency';
    } else {
      address = '${review['street']}, ${review['city']}, '
          '${review['province'] == null ? '' : '${review['province']}, '}'
          '${review['postal_code']}, ${review['country']}';
      rent = '$currency ${review['rent'].toString()} ';
      deposit = '$currency ${review['deposit'].toString()}';
      otherFees = '$currency ${review['other_fees'].toString()}';
    }

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
                  message: AppLocalizations.of(context)!.address,
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
                      message: AppLocalizations.of(context)!.realtor,
                      child: Icon(Icons.supervised_user_circle_outlined, size: 20, color: Colors.black87),
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
            if (review['occupied_year'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.occupiedYear, review['occupied_year'].toString()),
            if (review['rental_type'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.type, review['rental_type']),
            if (review['deposit'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.deposit, deposit),
            if (review['rent'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.rent, rent),
            if (review['other_fees'] != null) _buildRentDetailRow(AppLocalizations.of(context)!.otherFees, otherFees),

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
  Widget _buildRentDetailRow(String category, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0), // Adds a top margin of 16 pixels
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
