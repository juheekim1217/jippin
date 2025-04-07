import 'package:flutter/cupertino.dart';
import 'package:jippin/models/address.dart';

class ReviewQueryProvider with ChangeNotifier {
  String qDetail = '';
  String qLandlord = '';
  String qProperty = '';
  String qRealtor = '';
  Address qAddress = Address.defaultAddress();
  String defaultCountryName = '';

  void updateQuery({
    String? qDetail,
    String? qLandlord,
    String? qProperty,
    String? qRealtor,
    Address? qAddress,
    String? defaultCountryName,
  }) {
    this.qDetail = qDetail ?? this.qDetail;
    this.qLandlord = qLandlord ?? this.qLandlord;
    this.qProperty = qProperty ?? this.qProperty;
    this.qRealtor = qRealtor ?? this.qRealtor;
    this.qAddress = qAddress ?? this.qAddress;
    this.defaultCountryName = defaultCountryName ?? this.defaultCountryName;
    notifyListeners();
  }
}
