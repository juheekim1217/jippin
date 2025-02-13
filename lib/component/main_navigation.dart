import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jippin/utility/nav_bar_item.dart';
import 'package:jippin/component/adaptive_nav_bar.dart';
import 'package:jippin/utility/constants.dart';
import 'package:jippin/pages/about_page.dart';
import 'package:jippin/pages/home_page.dart';
import 'package:jippin/pages/reviews_page.dart';
import 'package:jippin/pages/submit_review_page.dart';

class MainNavigation extends StatefulWidget {
  final int currentIndex;
  final dynamic localeProvider;

  const MainNavigation({super.key, required this.currentIndex, required this.localeProvider});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  String _searchQuery = "";

  //final List<BottomNavigationBarItem> _mobileBottomNavigationBarList = [];

  List<Widget> get _pages => [
        HomePage(),
        ReviewsPage(
          key: ValueKey(_searchQuery),
          searchQuery: _searchQuery,
          defaultCountryCode: widget.localeProvider.country.code,
          defaultCountryName: widget.localeProvider.country.getCountryName(widget.localeProvider.locale.languageCode),
        ),
        SubmitReviewPage(),
        AboutPage(),
      ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _filterReviews(String query) {
    setState(() {
      _currentIndex = 1;
      _searchQuery = query;
      debugPrint("_filterReviews $query");
    });
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
                      case 'help':
                        debugPrint('Help selected');
                        break;
                      case 'about':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutPage()),
                        );
                        break;
                      case 'logout':
                        debugPrint('Logout selected');
                        break;
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(value: 'settings', child: Text(local.popup_settings)),
                      PopupMenuItem(value: 'help', child: Text(local.popup_help)),
                      PopupMenuItem(value: 'about', child: Text(local.popup_about)),
                      PopupMenuItem(value: 'logout', child: Text(local.popup_logout)),
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
                      onTap: () => _navigateTo(0),
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
                NavBarItem(text: local.reviews, onTap: () => _navigateTo(1)),
                if (screenWidth <= smallScreenWidth) NavBarItem(text: local.writeReview, onTap: () => _navigateTo(2)),
                NavBarItem(text: local.about, onTap: () => _navigateTo(3)),
              ],
              popupMenuItems: [
                NavBarItem(text: local.home, onTap: () => _navigateTo(0)),
                NavBarItem(text: local.reviews, onTap: () => _navigateTo(1)),
                NavBarItem(text: local.writeReview, onTap: () => _navigateTo(2)),
                NavBarItem(text: local.about, onTap: () => _navigateTo(3)),
              ],
              onSubmitReview: () => _navigateTo(2),
              onSearch: (query) => _filterReviews(query),
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: isAndroid
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _navigateTo,
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
