import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:jippin/constants.dart';
import 'package:jippin/locale_provider.dart';
import 'package:jippin/component/navBarItem.dart';

class AdaptiveNavBar extends StatefulWidget implements PreferredSizeWidget {
  final double screenWidth;
  final Widget logo;
  final List<NavBarItem> navBarItems;
  final VoidCallback onSubmitReview;
  final ValueChanged<String> onSearch;

  const AdaptiveNavBar({
    Key? key,
    required this.screenWidth,
    required this.logo,
    required this.navBarItems,
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
        ],
      ),
      actions: [
        if (widget.screenWidth > smallScreenWidth) _buildCountryDropdown(),
        //if (widget.screenWidth <= smallScreenWidth) _buildCountryDropdownButton(),
        if (widget.screenWidth > mediumScreenWidth) _buildSearchBar(250),
        if (widget.screenWidth > smallScreenWidth && widget.screenWidth <= mediumScreenWidth) _buildSearchBar(200),
        if (widget.screenWidth <= smallScreenWidth) _buildSearchBarButton(),
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

  Widget _buildCountryDropdown() {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return SizedBox(
      height: 32, // Match the height of other menu items
      width: 120,
      child: DropdownButtonHideUnderline(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Background color of the dropdown
            borderRadius: BorderRadius.circular(24.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: localeProvider.defaultCountry,
              // ✅ Uses dynamically set default country
              onChanged: (String? newValue) {
                if (newValue != null) {
                  localeProvider.setDefaultCountry(newValue);
                }
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
              // Dropdown arrow
              items: [
                DropdownMenuItem(
                  value: "CA",
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black87), // Location icon
                      const SizedBox(width: 4),
                      Text(
                        "Canada",
                        style: TextStyle(fontSize: 14, color: Colors.black), // Text style
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "KR",
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black87), // Location icon
                      const SizedBox(width: 4),
                      Text(
                        "Korea",
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
                      const SizedBox(width: 4),
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
    );
  }

  Widget _buildSearchBar(barWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 32, // Match the height of other menu items
        width: barWidth,
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
            const SizedBox(width: 2), // Space between icon and text
            Text(
              AppLocalizations.of(context)!.submitReview, // Use your desired text
              style: const TextStyle(color: Colors.black), // Black text
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
                style: TextStyle(fontSize: 14, color: Colors.black),
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
          return widget.navBarItems.map((item) {
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
