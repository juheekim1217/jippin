import 'package:flutter/material.dart';
import 'package:jippin/models/address.dart';
import 'package:go_router/go_router.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/providers/review_query_provider.dart';

class AddressLink extends StatefulWidget {
  const AddressLink({super.key});

  @override
  State<AddressLink> createState() => _AddressLinkState();
}

class _AddressLinkState extends State<AddressLink> {
  String? selectedSort;

  @override
  Widget build(BuildContext context) {
    final query = context.watch<ReviewQueryProvider>();
    final localeProvider = Provider.of<LocaleProvider>(context);
    final langCode = localeProvider.language.code;
    return RichText(
      text: TextSpan(
        children: [
          // Country search query
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
            baseline: TextBaseline.alphabetic,
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Convert Address object to JSON string and encode it for the URL
                    final address = Address.defaultAddress(); // empty address
                    final encodedAddress = encodeAddressUri(address);
                    context.go('/reviews?qA=$encodedAddress');
                  },
                  child: Text(
                    query.qCountry,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // State search query
          if (query.qAddress.province.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // ✅ Aligns with text
              baseline: TextBaseline.alphabetic,
              child: Text(
                " / ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),

          if (query.qAddress.province.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Convert Address object to JSON string and encode it for the URL
                      final encodedAddress = encodeAddressUri(query.qAddress.getCurrentAddress(langCode, true, false, false));
                      context.go('/reviews?qA=$encodedAddress');
                    },
                    child: Text(
                      query.qProvince,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // City search query
          if (query.qAddress.city != null && query.qAddress.city!.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // ✅ Aligns with text
              baseline: TextBaseline.alphabetic,
              child: Text(
                ", ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),

          if (query.qAddress.city != null && query.qAddress.city!.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final encodedAddress = encodeAddressUri(query.qAddress.getCurrentAddress(langCode, true, true, false));
                      context.go('/reviews?qA=$encodedAddress');
                    },
                    child: Text(
                      query.qAddress.city!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // street search query
          if (query.qAddress.street != null && query.qAddress.street!.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // ✅ Aligns with text
              baseline: TextBaseline.alphabetic,
              child: Text(
                ", ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),

          if (query.qAddress.street != null && query.qAddress.street!.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final encodedAddress = encodeAddressUri(query.qAddress.getCurrentAddress(langCode, true, true, true));
                      context.go('/reviews?qA=$encodedAddress');
                    },
                    child: Text(
                      query.qAddress.street!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Landlord search query
          if (query.qLandlord.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/reviews?qL=${query.qLandlord}');
                    },
                    child: Text(
                      ' [${query.qLandlord}]',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Property
          if (query.qProperty.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/reviews?qP=${query.qProperty}');
                    },
                    child: Text(
                      ' [${query.qProperty}]',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Realtor
          if (query.qRealtor.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/reviews?qR=${query.qRealtor}');
                    },
                    child: Text(
                      ' [${query.qRealtor}]',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Detail search query
          if (query.qDetail.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
              baseline: TextBaseline.alphabetic,
              child: SelectionContainer.disabled(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/reviews?qD=${query.qDetail}');
                    },
                    child: Text(
                      ' [${query.qDetail}]',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
