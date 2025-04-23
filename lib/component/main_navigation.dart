import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jippin/models/nav_bar_item.dart';
import 'package:jippin/component/adaptive_nav_bar.dart';
import 'package:jippin/utilities/constants.dart';
import 'package:jippin/models/address.dart';

import 'package:go_router/go_router.dart';
import 'dart:convert'; // Required for router JSON encoding

class MainNavigation extends StatefulWidget {
  //final int currentIndex;
  final dynamic localeProvider;

  final Widget child;

  //const MainNavigation({super.key, required this.currentIndex, required this.localeProvider});
  const MainNavigation({super.key, required this.localeProvider, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  void _filterReviews(Address address) {
    // Convert Address object to JSON string and encode it for the URL
    final encodedAddress = base64Url.encode(utf8.encode(jsonEncode(address)));
    context.go('/reviews?qA=$encodedAddress');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context);
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: isAndroid
          ? AppBar(
              title: Text(local.appTitle),
              actions: [
                IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        debugPrint('Settings selected');
                        break;
                      case 'about':
                        context.go('/about');
                        break;
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(value: 'settings', child: Text(local.popup_settings)),
                      PopupMenuItem(value: 'about', child: Text(local.popup_about)),
                    ];
                  },
                ),
              ],
            )
          : AdaptiveNavBar(
              screenWidth: screenWidth,
              logo: Row(
                children: [
                  const Icon(Icons.home_filled, size: 24, color: Colors.black87),
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.go('/'),
                      child: Text(
                        local.appTitle,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              navBarItems: [
                NavBarItem(
                  text: local.reviews,
                  onTap: () => context.go('/reviews'),
                ),
                if (screenWidth <= smallScreenWidth) NavBarItem(text: local.writeReview, onTap: () => context.go('/submit')),
                NavBarItem(text: local.about, onTap: () => context.go('/about')),
              ],
              popupMenuItems: [
                NavBarItem(text: local.home, onTap: () => context.go('/')),
                NavBarItem(text: local.reviews, onTap: () => context.go('/reviews')),
                NavBarItem(text: local.writeReview, onTap: () => context.go('/submit')),
                NavBarItem(text: local.about, onTap: () => context.go('/about')),
              ],
              onSubmitReview: () => context.go('/submit'),
              onSearch: (query) => _filterReviews(query),
            ),
      body: widget.child, //_pages[_currentIndex],
      bottomNavigationBar: isAndroid
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              //onTap: _navigateTo,
              onTap: (index) {
                if (index == 0) context.go('/');
                if (index == 1) context.go('/reviews');
                if (index == 2) context.go('/submit');
              },
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.home), label: local.home),
                BottomNavigationBarItem(icon: const Icon(Icons.list), label: local.reviews),
                BottomNavigationBarItem(icon: const Icon(Icons.add), label: local.writeReview),
              ],
            )
          : null,
    );
  }
}
