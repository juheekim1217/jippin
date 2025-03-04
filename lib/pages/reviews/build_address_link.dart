import 'package:flutter/material.dart';
import 'package:jippin/models/address.dart';
import 'package:go_router/go_router.dart';
import 'package:jippin/utilities/common_helper.dart';

Widget buildAddressLink(BuildContext context, String defaultCountryName, String qLandlord, Address qAddress) {
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
                  defaultCountryName,
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
        if (qAddress.state!.isNotEmpty)
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

        if (qAddress.state!.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
            baseline: TextBaseline.alphabetic,
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Convert Address object to JSON string and encode it for the URL
                    final encodedAddress = encodeAddressUri(qAddress.getCurrentAddress(true, false, false, false));
                    context.go('/reviews?qA=$encodedAddress');
                  },
                  child: Text(
                    qAddress.state!,
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
        if (qAddress.city!.isNotEmpty)
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

        if (qAddress.city!.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
            baseline: TextBaseline.alphabetic,
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final encodedAddress = encodeAddressUri(qAddress.getCurrentAddress(true, true, false, false));
                    context.go('/reviews?qA=$encodedAddress');
                  },
                  child: Text(
                    qAddress.city!,
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

        // district search query
        if (qAddress.district != null && qAddress.district!.isNotEmpty)
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

        if (qAddress.district != null && qAddress.district!.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
            baseline: TextBaseline.alphabetic,
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final encodedAddress = encodeAddressUri(qAddress.getCurrentAddress(true, true, true, false));
                    context.go('/reviews?qA=$encodedAddress');
                  },
                  child: Text(
                    qAddress.district!,
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
        if (qAddress.street != null && qAddress.street!.isNotEmpty)
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

        if (qAddress.street != null && qAddress.street!.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
            baseline: TextBaseline.alphabetic,
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final encodedAddress = encodeAddressUri(qAddress.getCurrentAddress(true, true, true, true));
                    context.go('/reviews?qA=$encodedAddress');
                  },
                  child: Text(
                    qAddress.street!,
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
        if (qLandlord.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline, // Ensures proper alignment
            baseline: TextBaseline.alphabetic,
            child: SelectionContainer.disabled(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    context.go('/reviews?qL=$qLandlord');
                  },
                  child: Text(
                    ' [$qLandlord]',
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
