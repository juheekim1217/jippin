import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdaptiveNavBar extends StatelessWidget implements PreferredSizeWidget {
  final double screenWidth;
  final Widget logo;
  final List<NavBarItem> navBarItems;
  final VoidCallback onSubmitReview;
  final ValueChanged<Locale?> onChangeLanguage;
  final Locale currentLocale;

  const AdaptiveNavBar({
    required this.screenWidth,
    required this.logo,
    required this.navBarItems,
    required this.onSubmitReview,
    required this.onChangeLanguage,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 16.0,
      title: Row(
        children: [
          // Logo
          logo,

          // Navigation items (only visible on larger screens)
          if (screenWidth > 600)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: navBarItems.map((item) {
                  return TextButton(
                    onPressed: item.onTap,
                    child: Text(
                      item.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
      actions: [
        // Language Dropdown
        DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
              focusColor: Colors.transparent,
              value: currentLocale,
              onChanged: onChangeLanguage,
              items: [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('ko'),
                  child: Text('한국어'),
                ),
              ],
              dropdownColor: Colors.white),
        ),

        const SizedBox(width: 16),

        if (screenWidth > 600)
          // Submit a Review Button
          ElevatedButton(
            onPressed: onSubmitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], // Light gray background
              elevation: 0, // Remove button shadow for a flat look
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24.0), // More rounded corners
              ),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Ensure button size adjusts to content
              children: [
                Icon(Icons.add, color: Colors.black), // Black icon
                const SizedBox(width: 8), // Space between icon and text
                Text(
                  AppLocalizations.of(context)!
                      .submitReview, // Use your desired text
                  style: const TextStyle(color: Colors.black), // Black text
                ),
              ],
            ),
          ),

        const SizedBox(width: 16),

        if (screenWidth <= 600)
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
