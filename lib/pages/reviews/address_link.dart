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
  WidgetSpan _linkSpan(String label, VoidCallback onTap) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: SelectionContainer.disabled(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) => onTap()),
            child: Text(
              label,
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
    );
  }

  WidgetSpan _separatorSpan(String symbol) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Text(
        symbol,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  String _safe(String? value) => Uri.encodeComponent(value ?? '');

  @override
  Widget build(BuildContext context) {
    final query = context.watch<ReviewQueryProvider>();
    final localeProvider = Provider.of<LocaleProvider>(context);
    final langCode = localeProvider.language.code;
    final address = query.qAddress;

    final List<InlineSpan> spans = [];

    // Country
    spans.add(_linkSpan(query.qCountry, () {
      final encoded = encodeAddressUri(Address.defaultAddress());
      context.go('/reviews?qA=$encoded');
    }));

    // Province
    if (address.province.isNotEmpty) {
      spans.add(_separatorSpan(" / "));
      spans.add(_linkSpan(address.province, () {
        final encoded = encodeAddressUri(address.getCurrentAddress(langCode, true, false, false));
        context.go('/reviews?qA=$encoded');
      }));
    }

    // City
    if (address.city?.isNotEmpty == true) {
      spans.add(_separatorSpan(", "));
      spans.add(_linkSpan(address.city!, () {
        final encoded = encodeAddressUri(address.getCurrentAddress(langCode, true, true, false));
        context.go('/reviews?qA=$encoded');
      }));
    }

    // Street
    if (address.street?.isNotEmpty == true) {
      spans.add(_separatorSpan(", "));
      spans.add(_linkSpan(address.street!, () {
        final encoded = encodeAddressUri(address.getCurrentAddress(langCode, true, true, true));
        context.go('/reviews?qA=$encoded');
      }));
    }

    // Landlord
    if (query.qLandlord.isNotEmpty) {
      spans.add(_linkSpan(' [${query.qLandlord}]', () {
        context.go('/reviews?qL=${_safe(query.qLandlord)}');
      }));
    }

    // Property
    if (query.qProperty.isNotEmpty) {
      spans.add(_linkSpan(' [${query.qProperty}]', () {
        context.go('/reviews?qP=${_safe(query.qProperty)}');
      }));
    }

    // Realtor
    if (query.qRealtor.isNotEmpty) {
      spans.add(_linkSpan(' [${query.qRealtor}]', () {
        context.go('/reviews?qR=${_safe(query.qRealtor)}');
      }));
    }

    // Detail
    if (query.qDetail.isNotEmpty) {
      spans.add(_linkSpan(' [${query.qDetail}]', () {
        context.go('/reviews?qD=${_safe(query.qDetail)}');
      }));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
