import 'package:flutter/cupertino.dart';
import 'package:jippin/models/address.dart';

class ReviewQueryProvider with ChangeNotifier {
  String qDetail = '';
  String qLandlord = '';
  String qRealtor = '';
  Address qAddress = Address.defaultAddress();

  String qCountry = '';

  void setQuery({String? landlord, String? realtor, Address? address}) {
    qLandlord = landlord ?? '';
    qRealtor = realtor ?? '';
    qAddress = address ?? Address.defaultAddress();
    notifyListeners();
  }

  void updateQuery({
    String? qDetail,
    String? qLandlord,
    String? qRealtor,
    Address? qAddress,
    String? qCountry,
  }) {
    this.qDetail = qDetail ?? this.qDetail;
    this.qLandlord = qLandlord ?? this.qLandlord;
    this.qRealtor = qRealtor ?? this.qRealtor;
    this.qAddress = qAddress ?? this.qAddress;
    this.qCountry = qCountry ?? this.qCountry;
    notifyListeners();
  }
}
