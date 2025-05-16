import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jippin/utilities/constants.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/models/address.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/services/country_data_service.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < smallScreenWidth;

    final ratings = [
      review['rating_trust'] ?? 0,
      review['rating_price'] ?? 0,
      review['rating_location'] ?? 0,
      review['rating_condition'] ?? 0,
    ];
    final overallRating = ratings.where((rating) => rating > 0).isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0.0;

    String currency = review['country_code'] == 'KR' ? '만원' : '\$';
    String rent = '${review['rent'] ?? ''} $currency';
    String deposit = '${review['deposit'] ?? ''} $currency';

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Landlord name && Created_at section
            _buildReviewHeader(context),

            const SizedBox(height: 8),
            _buildReviewDetails(context),

            // Ratings section
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            _buildRatingsSection(context, overallRating, isSmallScreen),

            // Rent Details section
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            if (review['occupied_year'] != null) _buildRentDetailRow(AppLocalizations.of(context).occupiedYear, review['occupied_year'].toString()),
            if (review['rental_type'] != null) _buildRentDetailRow(AppLocalizations.of(context).rental_type, review['rental_type']),
            if (review['deposit'] != null) _buildRentDetailRow(AppLocalizations.of(context).deposit, deposit),
            if (review['rent'] != null) _buildRentDetailRow(AppLocalizations.of(context).rent, rent),

            // Review section
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            if (review['review'] != null)
              Text(
                review['review'],
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  /// Landlord name && Created_at section
  Widget _buildReviewHeader(BuildContext context) {
    return Row(
      children: [
        // Column 1: Landlord Info (Left-Aligned)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (review['landlord'] != null && review['landlord'] != "")
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectionContainer.disabled(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  context.go('/reviews?qL=${review['landlord']}');
                                },
                                child: Text(
                                  review['landlord'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            AppLocalizations.of(context).landlord,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        // Column 2: Created At (Right-Aligned & Top)
        Column(
          mainAxisSize: MainAxisSize.min, // Prevents unnecessary vertical stretching
          crossAxisAlignment: CrossAxisAlignment.end, // Ensures right alignment
          children: [
            Row(
              mainAxisSize: MainAxisSize.min, // Ensures only takes necessary space
              children: [
                Icon(Icons.edit_calendar_outlined, size: 12, color: Colors.black54),
                const SizedBox(width: 4), // Space between text and icon
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(review['created_at'])),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  /// Address
  /// Realtor and Alerts
  Widget _buildReviewDetails(BuildContext context) {
    final langCode = Provider.of<LocaleProvider>(context).language.code;
    String provinceName = CountryDataService().findProvinceNameByKey(langCode, review['province']);
    String cityName = CountryDataService().findCityNameByKey(langCode, review['province'], review['city']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address section
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          // Adds a top margin of 16 pixels
          child: Row(
            children: [
              Tooltip(
                message: AppLocalizations.of(context).address,
                child: Icon(Icons.location_on, size: 20, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              if (langCode == 'ko') _buildAddressRowKo(context, provinceName, cityName),
              if (langCode != 'ko') _buildAddressRow(context, provinceName, cityName),
            ],
          ),
        ),

        // Realtor name and alerts section
        Row(
          children: [
            Expanded(
              child: Row(
                // Use Row instead of Column to keep elements in one line
                crossAxisAlignment: CrossAxisAlignment.center, // Ensures proper alignment
                children: [
                  if (review['realtor'] != null)
                    Tooltip(
                      message: AppLocalizations.of(context).realtor,
                      child: Icon(Icons.supervised_user_circle_outlined, size: 20, color: Colors.black87),
                    ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  if (review['realtor'] != null)
                    Expanded(
                      child: SelectionContainer.disabled(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              context.go('/reviews?qR=${review['realtor']}');
                            },
                            child: Text(
                              review['realtor'],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
                              overflow: TextOverflow.ellipsis, // Ensures text truncates instead of wrapping
                              maxLines: 1, // Restricts text to a single line
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Column 2: Alerts (Right-Aligned)
            // if (review['fraud'] != null && review['fraud'])
            //   Column(
            //     mainAxisSize: MainAxisSize.min, // Prevents stretching
            //     crossAxisAlignment: CrossAxisAlignment.end, // Ensures full right alignment
            //     children: [
            //       Tooltip(
            //         message: AppLocalizations.of(context).landlord_fraud,
            //         child: Icon(Icons.gavel, size: 20, color: Colors.red),
            //       ),
            //     ],
            //   ),
          ],
        ),

        // Realtor section
        // if (review['realtor'] != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 4.0),
        //     // Adds a top margin of 16 pixels
        //     child: Row(
        //       children: [
        //         Tooltip(
        //           message: AppLocalizations.of(context).realtor,
        //           child: Icon(Icons.supervised_user_circle_outlined, size: 20, color: Colors.black87),
        //         ),
        //         const SizedBox(width: 8),
        //         SelectionContainer.disabled(
        //           child: MouseRegion(
        //             cursor: SystemMouseCursors.click,
        //             child: GestureDetector(
        //               onTap: () {
        //                 context.go('/reviews?qR=${review['realtor']}');
        //               },
        //               child: Text(
        //                 '${review['realtor']}',
        //                 style: TextStyle(fontSize: 14, color: Colors.black87),
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildAddressRow(BuildContext context, String provinceName, String cityName) {
    return Wrap(
      spacing: 8.0, // Space between links
      children: [
        if (review['street_number'] != null && review['street_number'].toString().isNotEmpty)
          Text(
            review['street_number'],
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        if (review['street'] != null && review['street'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province'], city: review['city'], street: review['street']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  '${review['street']},',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['district'] != null && review['district'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province'], city: review['city']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  '${review['district']},',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['city'] != null && review['city'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province'], city: review['city']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  '$cityName,',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['province'] != null && review['province'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  provinceName,
                  style: TextStyle(fontSize: 14, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddressRowKo(BuildContext context, String provinceName, String cityName) {
    return Wrap(
      spacing: 8.0, // Space between links
      children: [
        if (review['province'] != null && review['province'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  provinceName,
                  style: TextStyle(fontSize: 14, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['city'] != null && review['city'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province'], city: review['city']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  cityName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['district'] != null && review['district'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province'], city: review['city']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  review['district'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['street'] != null && review['street'].toString().isNotEmpty)
          SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Address address = Address(province: review['province'], city: review['city'], street: review['street']);
                  final encodedAddress = encodeAddressUri(address);
                  context.go('/reviews?qA=$encodedAddress');
                },
                child: Text(
                  review['street'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
        if (review['street_number'] != null && review['street_number'].toString().isNotEmpty)
          Text(
            review['street_number'],
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
      ],
    );
  }

  Widget _buildRatingsSection(BuildContext context, double overallRating, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSmallScreen)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: overallRating > 4
                  ? Colors.greenAccent
                  : overallRating > 3
                      ? Colors.amberAccent
                      : Colors.redAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              overallRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingRow(AppLocalizations.of(context).trustworthiness, review['rating_trust']),
              _buildRatingRow(AppLocalizations.of(context).price, review['rating_price']),
              _buildRatingRow(AppLocalizations.of(context).location, review['rating_location']),
              _buildRatingRow(AppLocalizations.of(context).condition, review['rating_condition']),
            ],
          ),
        ),
      ],
    );
  }

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
              value,
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
