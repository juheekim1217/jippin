import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:jippin/utility/constants.dart';
import 'package:jippin/locale_provider.dart';
import 'package:jippin/utility/nav_bar_item.dart';
import 'package:jippin/component/test/country_autocomplete_field.dart';
import 'package:jippin/component/country_dropdown_search.dart';
import 'package:jippin/utility/language.dart';

class AdaptiveNavBar extends StatefulWidget implements PreferredSizeWidget {
  final double screenWidth;
  final Widget logo;
  final List<NavBarItem> navBarItems;
  final List<NavBarItem> popupMenuItems;
  final VoidCallback onSubmitReview;
  final ValueChanged<String> onSearch;

  const AdaptiveNavBar({
    super.key,
    required this.screenWidth,
    required this.logo,
    required this.navBarItems,
    required this.popupMenuItems,
    required this.onSubmitReview,
    required this.onSearch,
  });

  @override
  State<AdaptiveNavBar> createState() => _AdaptiveNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AdaptiveNavBarState extends State<AdaptiveNavBar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode(); // ✅ Added for better focus handling

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
          title: Text(AppLocalizations.of(context).search),
          content: _buildSearchDialogTextField(context),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).close),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Popup Search (For Small Screens)
  void _showCountryDialog(BuildContext context, localeProvider, Locale currentLocale, Color navbarBackgroundColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).selectCountry),
          content: _buildCountryDialogTextField(context, localeProvider, currentLocale, navbarBackgroundColor),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).close),
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
    String initialCountryName = localeProvider.country.getCountryName(localeProvider.locale.languageCode);

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
                if (widget.screenWidth > smallScreenWidth)
                  SizedBox(
                    height: 32, // Match the height of other menu items
                    width: widget.screenWidth * 0.1,
                    child: CountryDropdownSearch(
                      localeProvider: localeProvider,
                      initialCountryName: initialCountryName,
                      onChanged: (String? newValue, String? countryName) {
                        if (newValue != null) {
                          localeProvider.setCountry(newValue, countryName!);
                        }
                      },
                    ),
                  ),
                if (widget.screenWidth > smallScreenWidth) _buildSearchBar(null),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (widget.screenWidth <= smallScreenWidth) _buildCountryButton(localeProvider, currentLocale, navbarBackgroundColor),
        if (widget.screenWidth <= smallScreenWidth) _buildSearchBarButton(),
        if (widget.screenWidth > mediumScreenWidth) _buildSubmitButton(),
        _buildLanguageDropdown(localeProvider, currentLocale, navbarBackgroundColor),
        if (widget.screenWidth <= mediumScreenWidth) _buildPopupMenuButton(),
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

  Widget _buildSearchBar(barWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 32, // Match the height of other menu items
        width: barWidth ?? widget.screenWidth * 0.25,
        child: TextField(
          autofocus: false,
          // Prevents unnecessary refocus
          style: TextStyle(
            fontSize: 14, // Reduced text size
            color: Colors.black87, // Text color
          ),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).search_location,
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
            //fillColor: Colors.grey.shade100,
            //filled: true,
          ),
          onSubmitted: (value) => _handleSearch(),
          controller: searchController,
        ),
      ),
    );
  }

  // Widget _buildSearchBar(barWidth) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //     child: SizedBox(
  //       //height: 20, // Increased height for better usability
  //       width: 200,
  //       child: AddressAutocompleteField(), // Only the address search field
  //     ),
  //   );
  // }

  // 🔹 Popup Search (For Small Screens) Text field widget
  Widget _buildSearchDialogTextField(BuildContext context) {
    return TextField(
      autofocus: false,
      // Prevents unnecessary refocus
      style: TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).search_location,
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

  // 🔹 Popup Country (For Small Screens) Text field widget
  Widget _buildCountryDialogTextField(BuildContext context, localeProvider, Locale currentLocale, Color navbarBackgroundColor) {
    String initialCountryName = localeProvider.defaultCountry.getCountryName(localeProvider.defaultLanguage.code);
    return CountryAutoCompleteField(
      width: 150,
      initialCountryName: initialCountryName,
      onChanged: (String? newValue, String? countryName) {
        if (newValue != null) {
          localeProvider.setDefaultCountry(newValue, countryName!);
        }
      },
    );
  }

  Widget _buildCountryButton(localeProvider, Locale currentLocale, Color navbarBackgroundColor) {
    return IconButton(
      padding: EdgeInsets.zero, // ✅ Removes default padding
      constraints: BoxConstraints(), // ✅ Prevents extra space
      icon: Icon(Icons.location_on, color: Colors.grey),
      onPressed: () {
        _showCountryDialog(context, localeProvider, currentLocale, navbarBackgroundColor);
      },
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
              AppLocalizations.of(context).writeReview, // Use your desired text
              style: const TextStyle(color: Colors.white), // Black text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(localeProvider, Locale currentLocale, Color navbarBackgroundColor) {
    double paddingRight = 24.0;
    double paddingInner = 8.0;
    if (widget.screenWidth <= mediumScreenWidth) {
      paddingRight = 0.0;
      paddingInner = 4.0;
    }

    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: paddingRight),
      child: DropdownButtonHideUnderline(
        child: DecoratedBox(
          decoration: BoxDecoration(
            //color: navbarBackgroundColor, // Dropdown background color
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
            //border: Border.all(color: Colors.grey, width: 1), // Border styling
          ),
          child: SizedBox(
            height: 32,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingInner), // Inner padding
              child: DropdownButton<Language>(
                focusColor: Colors.transparent,
                value: localeProvider.language,
                onChanged: (Language? newLanguage) {
                  if (newLanguage != null) {
                    localeProvider.setLanguage(newLanguage); // Update locale
                  }
                },
                icon: const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                // Customize dropdown icon
                items: languages.values.map((language) {
                  return DropdownMenuItem(
                    value: language, // Corrected: Directly use the locale property
                    child: Text(language.label, style: const TextStyle(fontSize: 14)), // Corrected: Use language.label
                  );
                }).toList(),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
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
