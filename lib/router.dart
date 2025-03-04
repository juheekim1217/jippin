import 'package:flutter/cupertino.dart';
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
              onSearchDetails: (String query) {
                context.go('/reviews?qD=$query');
              }, // Empty callback
            ),
          ),
          GoRoute(
            path: '/reviews',
            builder: (context, state) {
              final String qDetails = state.uri.queryParameters['qD'] ?? "";
              final String qLandlord = state.uri.queryParameters['qL'] ?? "";
              final String qProperty = state.uri.queryParameters['qP'] ?? "";
              final String qRealtor = state.uri.queryParameters['qR'] ?? "";

              final String qAddressStr = state.uri.queryParameters['qA'] ?? "";
              // Decode JSON from URL-safe format & parse into Address object
              //final Address qAddress = qAddressStr.isNotEmpty ? Address.fromJson(jsonDecode(Uri.decodeComponent(qAddressStr))) : Address.defaultAddress();
              final Address qAddress = qAddressStr.isNotEmpty ? Address.fromJson(jsonDecode(utf8.decode(base64Url.decode(qAddressStr)))) : Address.defaultAddress();

              return ReviewsPage(
                key: ValueKey(Object.hash(qDetails, qLandlord, qProperty, qRealtor, qAddressStr, localeProvider.country.code, localeProvider.country.getCountryName(localeProvider.locale.languageCode).hashCode)),
                // 👈 Includes all params to force rebuild. Generates a unique but shorter key
                defaultCountryCode: localeProvider.country.code,
                defaultCountryName: localeProvider.country.getCountryName(localeProvider.locale.languageCode),
                qDetails: qDetails,
                qLandlord: qLandlord,
                qProperty: qProperty,
                qRealtor: qRealtor,
                qAddress: qAddress,
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
