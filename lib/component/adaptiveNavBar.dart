import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:jippin/constants.dart';
import 'package:jippin/locale_provider.dart';
import 'package:jippin/component/navBarItem.dart';
import 'package:jippin/component/countryDropdownTextField.dart';

class AdaptiveNavBar extends StatefulWidget implements PreferredSizeWidget {
  final double screenWidth;
  final Widget logo;
  final List<NavBarItem> navBarItems;
  final List<NavBarItem> popupMenuItems;
  final VoidCallback onSubmitReview;
  final ValueChanged<String> onSearch;

  const AdaptiveNavBar({
    Key? key,
    required this.screenWidth,
    required this.logo,
    required this.navBarItems,
    required this.popupMenuItems,
    required this.onSubmitReview,
    required this.onSearch,
  }) : super(key: key);

  @override
  _AdaptiveNavBarState createState() => _AdaptiveNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AdaptiveNavBarState extends State<AdaptiveNavBar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode(); // ✅ Added for better focus handling
  String selectedCountry = "Other"; // ✅ Default country

  @override
  void dispose() {
    searchController.dispose(); // ✅ Prevent memory leaks
    searchFocusNode.dispose(); // ✅ Properly dispose of the focus node
    super.dispose();
  }

  // pass search user input to parent widget
  void _handleSearch() {
    FocusScope.of(context).unfocus(); // ✅ Ensure keyboard closes
    widget.onSearch(searchController.text);
  }

  void _handleSearchDialog() {
    FocusScope.of(context).unfocus(); // ✅ Ensure keyboard closes
    widget.onSearch(searchController.text);
    Navigator.pop(context);
  }

  // 🔹 Popup Search (For Small Screens)
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Search"),
          content: _buildSearchDialogTextField(context),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    Locale currentLocale = localeProvider.locale;
    Color navbarBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return AppBar(
      backgroundColor: navbarBackgroundColor,
      elevation: 0,
      titleSpacing: 16.0,
      title: Row(
        children: [
          widget.logo,
          if (widget.screenWidth > largeScreenWidth) _buildMenuItems(),

          // Centered
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //if (widget.screenWidth > smallScreenWidth) _buildCountryDropdown(150),
                if (widget.screenWidth > smallScreenWidth)
                  CountryDropdownTextField(
                    width: 170,
                    initialValue: localeProvider.defaultCountry,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        localeProvider.setDefaultCountry(newValue);
                      }
                    },
                  ),
                if (widget.screenWidth > smallScreenWidth) _buildSearchBar(null),
                if (widget.screenWidth <= smallScreenWidth) _buildSearchBarButton(),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (widget.screenWidth > largeScreenWidth) _buildSubmitButton(),
        if (widget.screenWidth > largeScreenWidth) _buildLanguageDropdown(localeProvider, currentLocale, navbarBackgroundColor),
        if (widget.screenWidth <= largeScreenWidth) _buildPopupMenuButton(),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.navBarItems.map((item) {
          return TextButton(
            onPressed: item.onTap,
            child: Text(
              item.text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCountryDropdown(barWidth) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    // List of country options
    final List<Map<String, String>> countries = [
      {"code": "AU", "name": "Australia"},
      {"code": "CA", "name": "Canada"},
      {"code": "UK", "name": "Ireland"},
      {"code": "KR", "name": "South Korea"},
      {"code": "NZ", "name": "New Zealand"},
      {"code": "UK", "name": "United Kingdom"},
      {"code": "US", "name": "United States"},
      {"code": "Other", "name": "Other"},
    ];

    return SizedBox(
      height: 32, // Match the height of other menu items
      width: barWidth,
      child: DropdownButtonHideUnderline(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Background color of the dropdown
            borderRadius: BorderRadius.circular(24.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DropdownButton<String>(
              value: localeProvider.defaultCountry,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  localeProvider.setDefaultCountry(newValue);
                }
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
              // Dropdown arrow
              items: countries
                  .map(
                    (country) => DropdownMenuItem(
                      value: country["code"],
                      child: SizedBox(
                        width: barWidth - 32, // Ensure text doesn't exceed the dropdown width
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.black87),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Tooltip(
                                message: country["name"], // Tooltip displays full name
                                waitDuration: Duration(milliseconds: 500), // Optional: delay before showing
                                child: Text(
                                  country["name"]!,
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  overflow: TextOverflow.ellipsis, // Truncate text with ellipsis
                                  maxLines: 1, // Ensure text stays in one line
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              dropdownColor: Colors.white,
              // Background color for dropdown menu
              borderRadius: BorderRadius.circular(12.0),
              // Rounded corners for dropdown
              style: TextStyle(fontSize: 14, color: Colors.black), // Style for dropdown items
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(barWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 32, // Match the height of other menu items
        width: barWidth ?? widget.screenWidth * 0.25,
        child: TextField(
          style: TextStyle(
            fontSize: 14, // Reduced text size
            color: Colors.black87, // Text color
          ),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.search,
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.grey, size: 18),
              onPressed: _handleSearch, // 🔥 Trigger search on icon click
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
          onSubmitted: (value) => _handleSearch(),
          controller: searchController,
        ),
      ),
    );
  }

  // 🔹 Popup Search (For Small Screens) Text field widget
  Widget _buildSearchDialogTextField(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.search,
        // Replace with localization if needed
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: Colors.grey),
          onPressed: _handleSearchDialog, // 🔥 Trigger search on icon click
        ),
        //Icon(Icons.search, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
      ),
      onSubmitted: (value) => _handleSearchDialog(),
      controller: searchController,
    );
  }

  Widget _buildSearchBarButton() {
    return IconButton(
      icon: Icon(Icons.search, color: Colors.grey),
      onPressed: () {
        _showSearchDialog(context);
      },
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: widget.onSubmitReview,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0), // Reduce internal padding
          backgroundColor: Colors.teal, //Colors.grey[200], // Light gray background
          elevation: 0, // Remove button shadow for a flat look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0), // More rounded corners
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensure button size adjusts to content
          children: [
            Icon(Icons.add, color: Colors.white), // Black icon
            const SizedBox(width: 2), // Space between icon and text
            Text(
              AppLocalizations.of(context)!.submitReview, // Use your desired text
              style: const TextStyle(color: Colors.white), // Black text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(localeProvider, currentLocale, navbarBackgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonHideUnderline(
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
                borderRadius: BorderRadius.circular(16.0),
                style: TextStyle(fontSize: 14, color: Colors.black87),
                isDense: true, // Compact dropdown
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: PopupMenuButton<NavBarItem>(
        onSelected: (item) => item.onTap(),
        itemBuilder: (context) {
          return widget.popupMenuItems.map((item) {
            return PopupMenuItem(
              value: item,
              child: Text(item.text),
            );
          }).toList();
        },
      ),
    );
  }
}
