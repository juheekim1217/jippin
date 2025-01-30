import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jippin/style/constants.dart';
import 'package:provider/provider.dart';
import 'package:jippin/locale_provider.dart';

class AdaptiveNavBar extends StatelessWidget implements PreferredSizeWidget {
  final double screenWidth;
  final Widget logo;
  final List<NavBarItem> navBarItems;
  final VoidCallback onSubmitReview;

  const AdaptiveNavBar({
    required this.screenWidth,
    required this.logo,
    required this.navBarItems,
    required this.onSubmitReview,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    // Ensure locale is initialized and valid
    Locale currentLocale = localeProvider.locale;

    Color navbarBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return AppBar(
      backgroundColor: navbarBackgroundColor,
      elevation: 0,
      titleSpacing: 16.0,
      title: Row(
        children: [
          // Logo
          logo,

          const SizedBox(width: 32),

          // Navigation items (only visible on larger screens)
          if (screenWidth > mediumScreenWidth)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: navBarItems.map((item) {
                  return TextButton(
                    onPressed: item.onTap,
                    child: Text(
                      item.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Country dropdown
          if (screenWidth > largeScreenWidth)
            SizedBox(
              height: 32, // Match the height of other menu items
              width: 150,
              child: DropdownButtonHideUnderline(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Background color of the dropdown
                    borderRadius: BorderRadius.circular(24.0), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      value: "Canada",
                      // Default value
                      onChanged: (String? newValue) {
                        // Handle selection
                      },
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
                      // Dropdown arrow
                      items: [
                        DropdownMenuItem(
                          value: "Canada",
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.black87), // Location icon
                              const SizedBox(width: 8),
                              Text(
                                "Canada",
                                style: TextStyle(fontSize: 14, color: Colors.black), // Text style
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Other",
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.black87), // Location icon
                              const SizedBox(width: 8),
                              Text(
                                "Other",
                                style: TextStyle(fontSize: 14, color: Colors.black), // Text style
                              ),
                            ],
                          ),
                        ),
                      ],
                      dropdownColor: Colors.white,
                      // Background color for dropdown menu
                      borderRadius: BorderRadius.circular(12.0),
                      // Rounded corners for dropdown
                      style: TextStyle(fontSize: 14, color: Colors.black), // Style for dropdown items
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(width: 16),

          // Search Bar
          if (screenWidth > largeScreenWidth)
            SizedBox(
              height: 32, // Match the height of other menu items
              width: 250,
              child: TextField(
                style: TextStyle(
                  fontSize: 14, // Reduced text size
                  color: Colors.black87, // Text color
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0), // Light grey border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0), // Light grey border for non-focused state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5), // Slightly thicker blue border on focus
                  ),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),
            ),
        ],
      ),
      actions: [
        if (screenWidth > mediumScreenWidth)
          // Submit a Review Button
          ElevatedButton(
            onPressed: onSubmitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], // Light gray background
              elevation: 0, // Remove button shadow for a flat look
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0), // More rounded corners
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ensure button size adjusts to content
              children: [
                Icon(Icons.add, color: Colors.black), // Black icon
                const SizedBox(width: 8), // Space between icon and text
                Text(
                  AppLocalizations.of(context)!.submitReview, // Use your desired text
                  style: const TextStyle(color: Colors.black), // Black text
                ),
              ],
            ),
          ),

        const SizedBox(width: 16),

        // Language Dropdown
        DropdownButtonHideUnderline(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: navbarBackgroundColor, // Dropdown background color
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              border: Border.all(color: Colors.grey, width: 1), // Border styling
            ),
            child: SizedBox(
              height: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0), // Inner padding
                child: DropdownButton<Locale>(
                  focusColor: Colors.transparent,
                  // Disable default focus highlight
                  value: currentLocale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      localeProvider.setLocale(newLocale); // Update locale
                    }
                  },
                  icon: Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                  // Customize dropdown icon
                  items: [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text(
                        'English',
                        style: TextStyle(fontSize: 14), // Smaller text size
                      ),
                    ),
                    DropdownMenuItem(
                      value: Locale('ko'),
                      child: Text(
                        '한국어',
                        style: TextStyle(fontSize: 14), // Smaller text size
                      ),
                    ),
                  ],
                  dropdownColor: Colors.white,
                  // Dropdown menu background
                  borderRadius: BorderRadius.circular(16.0),
                  // Rounded dropdown corners
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  // Text style
                  isDense: true, // Compact dropdown
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // small screen more icon
        if (screenWidth <= mediumScreenWidth)
          PopupMenuButton<NavBarItem>(
            onSelected: (item) => item.onTap(),
            itemBuilder: (context) {
              return navBarItems.map((item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(item.text),
                );
              }).toList();
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NavBarItem {
  final String text;
  final VoidCallback onTap;

  const NavBarItem({required this.text, required this.onTap});
}
