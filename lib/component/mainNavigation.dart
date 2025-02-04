import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jippin/component/navBarItem.dart';
import 'package:jippin/component/adaptiveNavBar.dart';
import 'package:jippin/utils.dart';

import 'package:jippin/pages/about.dart';
import 'package:jippin/pages/home.dart';
import 'package:jippin/pages/reviews_page.dart';
import 'package:jippin/pages/submit_review.dart';

class MainNavigation extends StatefulWidget {
  final int currentIndex;
  final localeProvider;

  const MainNavigation({super.key, required this.currentIndex, required this.localeProvider});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  String searchQuery = "";

  // Android navigation
  final List<BottomNavigationBarItem> _bottomnav = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Reviews',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Submit',
    ),
  ];

  List<Widget> get _pages => [
        HomePage(),
        ReviewsPage(searchQuery: searchQuery, key: ValueKey(searchQuery), defaultCountry: widget.localeProvider.defaultCountry), // 🔥 Updates dynamically
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

  @override
  void dispose() {
    super.dispose();
  }

  void _filterReviews(String query) {
    setState(() {
      _currentIndex = 1; // move to Reviews page
      searchQuery = query; // Update search query
      print("_filterReviews $query");
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: isAndroid
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.appTitle),
              actions: [
                IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle menu item selection
                    switch (value) {
                      case 'Settings':
                        // Navigate to settings
                        print('Settings selected');
                        break;
                      case 'Help':
                        // Navigate to help
                        print('Help selected');
                        break;
                      case 'About':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                        break;
                      case 'Logout':
                        // Perform logout
                        print('Logout selected');
                        break;
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'Settings',
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem(
                        value: 'Help',
                        child: Text('Help'),
                      ),
                      const PopupMenuItem(
                        value: 'About',
                        child: Text('About'),
                      ),
                      const PopupMenuItem(
                        value: 'Logout',
                        child: Text('Logout'),
                      ),
                    ];
                  },
                ),
              ],
            )
          : AdaptiveNavBar(
              screenWidth: screenWidth,
              logo: Row(
                children: [
                  Icon(Icons.home_filled, size: 24, color: Colors.black87),
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click, // Change cursor to pointer
                    child: GestureDetector(
                      onTap: () {
                        _navigateTo(0);
                      }, // Action when the title is clicked
                      child: Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, // Correct syntax
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              navBarItems: [
                NavBarItem(text: AppLocalizations.of(context)!.reviews, onTap: () => _navigateTo(1)),
                if (screenWidth <= smallScreenWidth) NavBarItem(text: AppLocalizations.of(context)!.writeReview, onTap: () => _navigateTo(2)),
                NavBarItem(text: AppLocalizations.of(context)!.about, onTap: () => _navigateTo(3)),
              ],
              popupMenuItems: [
                NavBarItem(text: AppLocalizations.of(context)!.home, onTap: () => _navigateTo(0)),
                NavBarItem(text: AppLocalizations.of(context)!.reviews, onTap: () => _navigateTo(1)),
                NavBarItem(text: AppLocalizations.of(context)!.writeReview, onTap: () => _navigateTo(2)),
                NavBarItem(text: AppLocalizations.of(context)!.about, onTap: () => _navigateTo(3)),
              ],
              onSubmitReview: () => _navigateTo(2),
              onSearch: (query) => _filterReviews(query),
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: isAndroid
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _navigateTo,
              items: _bottomnav,
            )
          : null,
    );
  }
}
