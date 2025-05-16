import 'package:flutter/material.dart';
import 'package:jippin/models/address.dart';
import 'package:go_router/go_router.dart';
import 'package:jippin/utilities/common_helper.dart';
import 'package:provider/provider.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/providers/review_query_provider.dart';
import 'package:jippin/services/country_data_service.dart';

class AddressLink extends StatefulWidget {
  const AddressLink({super.key});

  @override
  State<AddressLink> createState() => _AddressLinkState();
}

class _AddressLinkState extends State<AddressLink> {
  WidgetSpan _linkSpan(Address address, String label, String type, String langCode, VoidCallback onTap) {
    String displayLabel = label;
    if (langCode != 'en') {
      if (type == "Province") {
        displayLabel = CountryDataService().findProvinceNameByKey(langCode, label);
      } else if (type == "City") {
        displayLabel = CountryDataService().findCityNameByKey(langCode, address.province, label);
      }
    }

    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: SelectionContainer.disabled(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) => onTap()),
            child: Text(
              displayLabel,
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
    spans.add(_linkSpan(address, query.qCountry, "Country", langCode, () {
      final encoded = encodeAddressUri(Address.defaultAddress());
      context.go('/reviews?qA=$encoded');
    }));

    // Province
    if (address.province.isNotEmpty) {
      spans.add(_separatorSpan(" / "));
      spans.add(_linkSpan(address, address.province, "Province", langCode, () {
        final encoded = encodeAddressUri(address.getCurrentAddress(langCode, true, false, false));
        context.go('/reviews?qA=$encoded');
      }));
    }

    // City
    if (address.city?.isNotEmpty == true) {
      spans.add(_separatorSpan(", "));
      spans.add(_linkSpan(address, address.city!, "City", langCode, () {
        final encoded = encodeAddressUri(address.getCurrentAddress(langCode, true, true, false));
        context.go('/reviews?qA=$encoded');
      }));
    }

    // Street
    if (address.street?.isNotEmpty == true) {
      spans.add(_separatorSpan(", "));
      spans.add(_linkSpan(address, address.street!, "Street", langCode, () {
        final encoded = encodeAddressUri(address.getCurrentAddress(langCode, true, true, true));
        context.go('/reviews?qA=$encoded');
      }));
    }

    // Landlord
    if (query.qLandlord.isNotEmpty) {
      spans.add(_linkSpan(address, ' [${query.qLandlord}]', "Landlord", langCode, () {
        context.go('/reviews?qL=${_safe(query.qLandlord)}');
      }));
    }

    // Realtor
    if (query.qRealtor.isNotEmpty) {
      spans.add(_linkSpan(address, ' [${query.qRealtor}]', "Realtor", langCode, () {
        context.go('/reviews?qR=${_safe(query.qRealtor)}');
      }));
    }

    // Detail
    if (query.qDetail.isNotEmpty) {
      spans.add(_linkSpan(address, ' [${query.qDetail}]', "Detail", langCode, () {
        context.go('/reviews?qD=${_safe(query.qDetail)}');
      }));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
