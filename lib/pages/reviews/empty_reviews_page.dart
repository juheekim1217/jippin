import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:jippin/pages/reviews/build_address_link.dart';
import 'package:go_router/go_router.dart';
import 'package:jippin/models/address.dart';

class EmptyReviewsPage extends StatelessWidget {
  final String defaultCountryName;
  final String qLandlord;
  final Address qAddress;

  const EmptyReviewsPage({
    super.key,
    required this.defaultCountryName,
    required this.qLandlord,
    required this.qAddress,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildAddressLink(context, defaultCountryName, qLandlord, qAddress),
          const SizedBox(height: 12),
          const Icon(Icons.rate_review, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            local.empty_reviews_no_reviews,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            local.empty_reviews_be_first,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/submit');
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(local.empty_reviews_write_review),
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
}
