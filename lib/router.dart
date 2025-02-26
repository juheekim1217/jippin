import 'package:jippin/pages/about_page.dart';
import 'package:jippin/pages/home_page.dart';
import 'package:jippin/pages/reviews_page.dart';
import 'package:jippin/pages/submit_review_page.dart';
import 'package:jippin/pages/terms_and_conditions_page.dart';
import 'package:jippin/pages/privacy_policy.dart';
import 'package:jippin/models/address.dart';

import 'package:go_router/go_router.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/component/main_navigation.dart';
import 'dart:convert';

GoRouter createRouter(LocaleProvider localeProvider) {
  return GoRouter(
    initialLocation: localeProvider.currentRoute, // ✅ Start from the stored route
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(localeProvider: localeProvider, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomePage(
              defaultCountryCode: localeProvider.country.code,
              defaultCountryName: localeProvider.country.getCountryName(localeProvider.locale.languageCode),
              onSearchLandlord: (String query) {
                // Navigate to the reviews page with searchQueryLandlord as a query parameter
                context.go('/reviews?searchQueryLandlord=$query');
              }, // Empty callback
            ),
          ),
          GoRoute(
            path: '/reviews',
            builder: (context, state) {
              final String searchQueryLandlord = state.uri.queryParameters['searchQueryLandlord'] ?? "";
              final String? searchQueryAddressStr = state.uri.queryParameters['searchQueryAddress'];
              // Decode JSON from URL-safe format & parse into Address object
              final Address searchQueryAddress = (searchQueryAddressStr != null && searchQueryAddressStr.isNotEmpty) ? Address.fromJson(jsonDecode(Uri.decodeComponent(searchQueryAddressStr))) : Address.defaultAddress();

              return ReviewsPage(
                searchQueryLandlord: searchQueryLandlord,
                searchQueryAddress: searchQueryAddress,
                defaultCountryCode: localeProvider.country.code,
                defaultCountryName: localeProvider.country.getCountryName(localeProvider.locale.languageCode),
              );
            },
          ),
          GoRoute(
            path: '/submit',
            builder: (context, state) => const SubmitReviewPage(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: '/terms',
            builder: (context, state) => const TermsAndConditionsPage(),
          ),
          GoRoute(
            path: '/privacy',
            builder: (context, state) => const PrivacyPolicyPage(),
          ),
        ],
      ),
    ],
  );
}
