import 'package:flutter/material.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:jippin/utilities/constants.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/models/nav_bar_item.dart';
import 'package:jippin/component/country_dropdown_search.dart';
import 'package:jippin/component/address_autocomplete_search.dart';
import 'package:jippin/models/language.dart';
import 'package:jippin/models/address.dart';

import 'package:go_router/go_router.dart';

class AdaptiveNavBar extends StatefulWidget implements PreferredSizeWidget {
  final double screenWidth;
  final Widget logo;
  final List<NavBarItem> navBarItems;
  final List<NavBarItem> popupMenuItems;
  final VoidCallback onSubmitReview;
  final ValueChanged<Address> onSearch;

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
  // final TextEditingController searchController = TextEditingController();
  // final FocusNode searchFocusNode = FocusNode(); // ✅ Added for better focus handling

  // @override
  // void dispose() {
  //   searchController.dispose(); // ✅ Prevent memory leaks
  //   searchFocusNode.dispose(); // ✅ Properly dispose of the focus node
  //   super.dispose();
  // }

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
                if (widget.screenWidth > smallScreenWidth) _buildCountryDropdown(localeProvider, initialCountryName),
                if (widget.screenWidth > smallScreenWidth) _buildSearchBar(localeProvider),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (widget.screenWidth <= smallScreenWidth) _buildCountryDropdownButton(localeProvider, currentLocale, navbarBackgroundColor, initialCountryName),
        if (widget.screenWidth <= smallScreenWidth) _buildSearchBarButton(localeProvider),
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

  Widget _buildCountryDropdown(localeProvider, String initialCountryName) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 120), // ✅ Set minimum width
      child: SizedBox(
        height: 32,
        width: widget.screenWidth * 0.12, // ✅ Dynamic max width
        child: _buildCountryDropdownSearch(localeProvider, initialCountryName),
      ),
    );
  }

  Widget _buildCountryDropdownButton(localeProvider, Locale currentLocale, Color navbarBackgroundColor, String initialCountryName) {
    return IconButton(
      padding: EdgeInsets.zero, // ✅ Removes default padding
      constraints: BoxConstraints(), // ✅ Prevents extra space
      icon: Icon(Icons.location_on, color: Colors.grey),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).selectCountry),
              content: _buildCountryDropdownSearch(localeProvider, initialCountryName),
              actions: [
                TextButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pop(context); // ✅ Safely closes the dialog
                    }
                  },
                  child: Text(AppLocalizations.of(context).close),
                ),
              ],
            );
          },
        );
        //_showCountryDialog(context, localeProvider, currentLocale, navbarBackgroundColor);
      },
    );
  }

  Widget _buildCountryDropdownSearch(localeProvider, String initialCountryName) {
    return CountryDropdownSearch(
      localeProvider: localeProvider,
      initialCountryName: initialCountryName,
      onChanged: (String? newValue, String? countryName) {
        if (newValue != null && countryName != null) {
          String currentRoute = GoRouter.of(context).state.path ?? '/';
          localeProvider.setCountry(newValue, countryName, currentRoute);
        }
      },
    );
  }

  // AutoComplete searchbar
  Widget _buildSearchBar(localeProvider) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 220), // ✅ Set minimum width
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: 32, // Match the height of other menu items
          width: widget.screenWidth * 0.25,
          child: AddressAutocompleteField(
            localeProvider: localeProvider,
            onChangedAddress: (Address address) {
              //FocusScope.of(context).unfocus(); // ✅ Ensure keyboard closes
              widget.onSearch(address);
            },
          ), // Only the address search field
        ),
      ),
    );
  }

  Widget _buildSearchBarButton(localeProvider) {
    return IconButton(
      icon: Icon(Icons.search, color: Colors.grey),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).search),
              content: AddressAutocompleteField(
                localeProvider: localeProvider,
                onChangedAddress: (Address address) {
                  FocusScope.of(context).unfocus(); // ✅ Ensure keyboard closes
                  widget.onSearch(address);
                  if (mounted) {
                    Navigator.pop(context); // ✅ Safely closes the dialog
                  }
                },
              ), // Only the address search field,
              actions: [
                TextButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pop(context); // ✅ Safely closes the dialog
                    }
                  },
                  child: Text(AppLocalizations.of(context).close),
                ),
              ],
            );
          },
        );
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
          backgroundColor: Colors.blueGrey, //Colors.grey[200], // Light gray background
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
                    String currentRoute = GoRouter.of(context).state.path ?? '/';
                    localeProvider.setLocaleLanguage(newLanguage, currentRoute); // Update locale
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
