import 'package:flutter/material.dart';
import 'package:jippin/component/layout/global_page_layout_scaffold.dart';
import 'package:jippin/pages/reviews/reviews_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:jippin/pages/reviews/build_overall_rating_card.dart';

class ReviewsPage extends StatefulWidget {
  final String defaultCountryCode;
  final String defaultCountryName;
  final String qDetails;
  final String qLandlord;
  final String qProperty;
  final String qRealtor;
  final Address qAddress;

  const ReviewsPage({
    super.key,
    required this.defaultCountryCode,
    required this.defaultCountryName,
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
    if (widget.qAddress.fullName != oldWidget.qAddress.fullName) {
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
      debugPrint("_applySearchFilter ${widget.qAddress.fullName}");

      // Filtering Address
      final String state = widget.qAddress.state ?? "";
      final String city = widget.qAddress.city ?? "";
      final String district = widget.qAddress.district ?? "";
      final String street = widget.qAddress.street ?? "";
      filteredReviews = allReviews.where((review) {
        // Extract values safely (avoid null issues)
        String reviewState = review["state"]?.toString() ?? "";
        String reviewCity = review["city"]?.toString() ?? "";
        String reviewDistrict = review["district"]?.toString() ?? "";
        String reviewStreet = review["street"]?.toString() ?? "";
        // Apply exact match filtering (if the search field is not empty, it must match exactly)
        return (state.isEmpty || equalsIgnoreCase(reviewState, state)) && (city.isEmpty || equalsIgnoreCase(reviewCity, city)) && (district.isEmpty || equalsIgnoreCase(reviewDistrict, district)) && (street.isEmpty || equalsIgnoreCase(reviewStreet, street));
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
        bool matchesLandlord = qLandlord.isEmpty || equalsIgnoreCase(landlord, qLandlord);
        bool matchesProperty = qProperty.isEmpty || equalsIgnoreCase(property, qProperty);
        bool matchesRealtor = qRealtor.isEmpty || equalsIgnoreCase(realtor, qRealtor);
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
                                  child: buildOverallRatingCard(context, filteredReviews, widget.defaultCountryName, widget.qLandlord, widget.qAddress),
                                ),
                                const SizedBox(width: 24), // Spacing between columns

                                // Column 2: Reviews
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      //_buildReviewsSection(context, filteredReviews),
                                      ReviewsSection(
                                        reviews: filteredReviews,
                                        onSortSelected: _applySortingReviews,
                                        // Ensure this method is defined in ReviewsPage
                                        defaultCountryName: widget.defaultCountryName,
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
                                buildOverallRatingCard(context, filteredReviews, widget.defaultCountryName, widget.qLandlord, widget.qAddress),
                                const SizedBox(height: 24), // Spacing

                                // Column 2: Reviews
                                //_buildReviewsSection(context, filteredReviews),
                                ReviewsSection(
                                  reviews: filteredReviews,
                                  onSortSelected: _applySortingReviews,
                                  // Ensure this method is defined in ReviewsPage
                                  defaultCountryName: widget.defaultCountryName,
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

// Widget _buildReviewsSection(BuildContext context, List<Map<String, dynamic>> reviews) {
//   final Map<String, String> sortOptions = {
//     'most_recent': AppLocalizations.of(context).sort_most_recent,
//     'highest_rating': AppLocalizations.of(context).sort_highest_rating,
//     'lowest_rating': AppLocalizations.of(context).sort_lowest_rating,
//   };
//
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // 📌 **Reviews Section Header**
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           children: [
//             if (reviews.isNotEmpty)
//               Expanded(
//                 child: Row(
//                   children: [
//                     const Icon(Icons.reviews, size: 22, color: Colors.blueAccent), // ✅ Add an icon for visibility
//                     const SizedBox(width: 6),
//                     Text(
//                       '${reviews.length} ${AppLocalizations.of(context).reviews}',
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             if (reviews.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // ✅ Reduced padding
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: selectedSort,
//                     focusColor: Colors.transparent,
//                     dropdownColor: Colors.white,
//                     isDense: true,
//                     // ✅ Reduces default height
//                     style: const TextStyle(fontSize: 14, color: Colors.black),
//
//                     // ✅ Reduced Dropdown height using buttonHeight
//                     iconSize: 18,
//                     // Reduce dropdown arrow size
//                     padding: EdgeInsets.zero,
//                     // ✅ Remove extra padding
//
//                     hint: Text(
//                       selectedSort != null ? sortOptions[selectedSort]! : AppLocalizations.of(context).sortBy,
//                       style: const TextStyle(color: Colors.black54),
//                     ),
//
//                     items: sortOptions.entries.map((entry) {
//                       return DropdownMenuItem(
//                         value: entry.key,
//                         child: Text(entry.value, style: const TextStyle(fontSize: 14)),
//                       );
//                     }).toList(),
//
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedSort = newValue;
//                       });
//                       _applySortingReviews(newValue!);
//                     },
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//
//       const SizedBox(height: 16),
//
//       // 📌 **Handle Empty Reviews**
//       if (reviews.isEmpty) buildEmptyReviewsPage(context, widget.defaultCountryName, widget.qLandlord, widget.qAddress),
//
//       // 📌 **Reviews List**
//       if (reviews.isNotEmpty)
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: reviews.length,
//           itemBuilder: (context, index) {
//             final review = reviews[index];
//             return _buildReviewCard(context, review);
//           },
//         ),
//     ],
//   );
// }

// Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
//   double screenWidth = MediaQuery.of(context).size.width;
//   bool isSmallScreen = screenWidth < smallScreenWidth;
//
//   // Calculate the overall rating as the average of the five categories
//   final ratings = [
//     review['rating_trust'] ?? 0,
//     review['rating_price'] ?? 0,
//     review['rating_location'] ?? 0,
//     review['rating_condition'] ?? 0,
//     review['rating_safety'] ?? 0,
//   ];
//   final overallRating = ratings.where((rating) => rating > 0).isNotEmpty // Handle missing ratings
//       ? ratings.reduce((a, b) => a + b) / ratings.length
//       : 0.0;
//
//   String currency = '\$';
//   String rent = '';
//   String deposit = '';
//   String otherFees = '';
//
//   if (review['country_code'] == 'KR') {
//     currency = '만원';
//     rent = '${review['rent'].toString()} $currency';
//     deposit = '${review['deposit'].toString()} $currency';
//     otherFees = '${review['other_fees'].toString()} $currency';
//   } else {
//     rent = '$currency ${review['rent'].toString()} ';
//     deposit = '$currency ${review['deposit'].toString()}';
//     otherFees = '$currency ${review['other_fees'].toString()}';
//   }
//
//   String formatDateTime(String dateTimeString) {
//     DateTime dateTime = DateTime.parse(dateTimeString); // Convert string to DateTime
//     return DateFormat('yyyy-MM-dd HH:mm').format(dateTime); // Format to readable string
//   }
//
//   return Card(
//     margin: const EdgeInsets.only(bottom: 16.0),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, // Aligns everything to the top
//         children: [
//           // Landlord name && Created_at section
//           Row(
//             children: [
//               // 📌 Column 1: Landlord Info (Left-Aligned)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (review['landlord'] != null && review['landlord'] != "")
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.person,
//                             size: 30,
//                             color: Colors.blueAccent,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SelectionContainer.disabled(
//                                   child: MouseRegion(
//                                     cursor: SystemMouseCursors.click,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         context.go('/reviews?qL=${review['landlord']}');
//                                       },
//                                       child: Text(
//                                         review['landlord'] ?? '',
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 0),
//                                 Text(
//                                   AppLocalizations.of(context).landlord,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//               // 📌 Column 2: Created At (Right-Aligned & Top)
//               Column(
//                 mainAxisSize: MainAxisSize.min, // Prevents unnecessary vertical stretching
//                 crossAxisAlignment: CrossAxisAlignment.end, // Ensures right alignment
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min, // Ensures only takes necessary space
//                     children: [
//                       Icon(Icons.edit_calendar_outlined, size: 12, color: Colors.black54),
//                       const SizedBox(width: 4), // Space between text and icon
//                       Text(
//                         DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(review['created_at'])),
//                         style: const TextStyle(fontSize: 12, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             ],
//           ),
//           const SizedBox(height: 8), // Spacing between icon and text
//
//           // Property name and alerts section
//           if (review['property'] != null || (review['fraud'] != null && review['fraud']))
//             Row(
//               children: [
//                 Expanded(
//                   child: Row(
//                     // Use Row instead of Column to keep elements in one line
//                     crossAxisAlignment: CrossAxisAlignment.center, // Ensures proper alignment
//                     children: [
//                       // 📌 Property Icon with Tooltip
//                       if (review['property'] != null && review['property'] != "")
//                         Tooltip(
//                           message: AppLocalizations.of(context).property,
//                           child: Icon(Icons.apartment_outlined, size: 20, color: Colors.black87),
//                         ),
//                       const SizedBox(width: 8), // Spacing between icon and text
//                       // 📌 Property Text (Ensures it stays in one line)
//                       if (review['property'] != null && review['property'] != "")
//                         Expanded(
//                           child: SelectionContainer.disabled(
//                             child: MouseRegion(
//                               cursor: SystemMouseCursors.click,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   context.go('/reviews?qP=${review['property']}');
//                                 },
//                                 child: Text(
//                                   review['property'],
//                                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
//                                   overflow: TextOverflow.ellipsis, // Ensures text truncates instead of wrapping
//                                   maxLines: 1, // Restricts text to a single line
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 // 📌 Column 2: Alerts (Right-Aligned)
//                 if (review['fraud'] != null && review['fraud'])
//                   Column(
//                     mainAxisSize: MainAxisSize.min, // Prevents stretching
//                     crossAxisAlignment: CrossAxisAlignment.end, // Ensures full right alignment
//                     children: [
//                       Tooltip(
//                         message: AppLocalizations.of(context).landlord_fraud,
//                         child: Icon(Icons.gavel, size: 20, color: Colors.red),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//
//           // Address section
//           Padding(
//             padding: const EdgeInsets.only(top: 4.0),
//             // Adds a top margin of 16 pixels
//             child: Row(
//               children: [
//                 Tooltip(
//                   message: AppLocalizations.of(context).address,
//                   child: Icon(Icons.location_on, size: 20, color: Colors.black87),
//                 ),
//                 const SizedBox(width: 8),
//                 Wrap(
//                   spacing: 8.0, // Space between links
//                   children: [
//                     if (review['state'] != null && review['state'].toString().isNotEmpty)
//                       SelectionContainer.disabled(
//                         child: MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: GestureDetector(
//                             onTap: () {
//                               Address address = Address(name: review['state'], latitude: 0.0, longitude: 0.0, fullName: review['state'], stateCode: '', state: review['state']);
//                               final encodedAddress = encodeAddressUri(address);
//                               context.go('/reviews?qA=$encodedAddress');
//                             },
//                             child: Text(
//                               review['state'],
//                               style: TextStyle(fontSize: 14, decoration: TextDecoration.underline),
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (review['city'] != null && review['city'].toString().isNotEmpty)
//                       SelectionContainer.disabled(
//                         child: MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: GestureDetector(
//                             onTap: () {
//                               Address address = Address(name: review['state'], latitude: 0.0, longitude: 0.0, fullName: review['state'], stateCode: '', state: review['state'], city: review['city']);
//                               final encodedAddress = encodeAddressUri(address);
//                               context.go('/reviews?qA=$encodedAddress');
//                             },
//                             child: Text(
//                               review['city'],
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (review['district'] != null && review['district'].toString().isNotEmpty)
//                       SelectionContainer.disabled(
//                         child: MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: GestureDetector(
//                             onTap: () {
//                               Address address = Address(name: review['state'], latitude: 0.0, longitude: 0.0, fullName: review['state'], stateCode: '', state: review['state'], city: review['city'], district: review['district']);
//                               final encodedAddress = encodeAddressUri(address);
//                               context.go('/reviews?qA=$encodedAddress');
//                             },
//                             child: Text(
//                               review['district'],
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (review['street'] != null && review['street'].toString().isNotEmpty)
//                       SelectionContainer.disabled(
//                         child: MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: GestureDetector(
//                             onTap: () {
//                               Address address = Address(name: review['state'], latitude: 0.0, longitude: 0.0, fullName: review['state'], stateCode: '', state: review['state'], city: review['city'], district: review['district'], street: review['street']);
//                               final encodedAddress = encodeAddressUri(address);
//                               context.go('/reviews?qA=$encodedAddress');
//                             },
//                             child: Text(
//                               review['street'],
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (review['street_number'] != null && review['street_number'].toString().isNotEmpty)
//                       Text(
//                         review['street_number'],
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//                       ),
//                     if (review['postal_code'] != null && review['postal_code'].toString().isNotEmpty)
//                       Text(
//                         review['postal_code'],
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//                       ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//
//           // Realtor section
//           if (review['realtor'] != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               // Adds a top margin of 16 pixels
//               child: Row(
//                 children: [
//                   Tooltip(
//                     message: AppLocalizations.of(context).realtor,
//                     child: Icon(Icons.supervised_user_circle_outlined, size: 20, color: Colors.black87),
//                   ),
//                   const SizedBox(width: 8),
//                   SelectionContainer.disabled(
//                     child: MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                       child: GestureDetector(
//                         onTap: () {
//                           context.go('/reviews?qR=${review['realtor']}');
//                         },
//                         child: Text(
//                           '${review['realtor']}',
//                           style: TextStyle(fontSize: 14, color: Colors.black87),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//
//           // Ratings section
//           const SizedBox(height: 8),
//           Divider(color: Colors.grey.shade300),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (!isSmallScreen)
//                 Container(
//                   padding: EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     color: overallRating > 4
//                         ? Colors.greenAccent
//                         : overallRating > 3
//                             ? Colors.amberAccent
//                             : overallRating > 2
//                                 ? Colors.redAccent
//                                 : Colors.red, // Assign color based on rating
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Text(
//                     overallRating.toStringAsFixed(1), // Display 1 decimal place
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               SizedBox(width: 16),
//               // Ratings
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Ratings Section
//                     _buildRatingRow(AppLocalizations.of(context).trustworthiness, review['rating_trust']),
//                     _buildRatingRow(AppLocalizations.of(context).price, review['rating_price']),
//                     _buildRatingRow(AppLocalizations.of(context).location, review['rating_location']),
//                     _buildRatingRow(AppLocalizations.of(context).condition, review['rating_condition']),
//                     _buildRatingRow(AppLocalizations.of(context).safety, review['rating_safety']),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           // Rent Details section
//           const SizedBox(height: 8),
//           Divider(color: Colors.grey.shade300),
//           const SizedBox(height: 8),
//           if (review['occupied_year'] != null) _buildRentDetailRow(AppLocalizations.of(context).occupiedYear, review['occupied_year'].toString()),
//           if (review['rental_type'] != null) _buildRentDetailRow(AppLocalizations.of(context).type, review['rental_type']),
//           if (review['deposit'] != null) _buildRentDetailRow(AppLocalizations.of(context).deposit, deposit),
//           if (review['rent'] != null) _buildRentDetailRow(AppLocalizations.of(context).rent, rent),
//           if (review['other_fees'] != null) _buildRentDetailRow(AppLocalizations.of(context).otherFees, otherFees),
//
//           // Title and Written Review section
//           const SizedBox(height: 8),
//           Divider(color: Colors.grey.shade300),
//           const SizedBox(height: 8),
//           if (review['title'] != null)
//             Text(
//               review['title'],
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           const SizedBox(height: 8),
//           if (review['review'] != null)
//             Text(
//               review['review'],
//               style: TextStyle(fontSize: 16),
//             ),
//         ],
//       ),
//     ),
//   );
// }
}
