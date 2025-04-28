import 'package:jippin/utilities/common_helper.dart';

class Address {
  final String province;
  final String? city;
  final String? province_ko;
  final String? city_ko;
  final String? street;
  final String? streetNum;
  final String? unit;
  final String? zip;

  Address({
    required this.province,
    this.city,
    this.province_ko,
    this.city_ko,
    this.street,
    this.streetNum,
    this.unit,
    this.zip,
  });

  // Factory constructor for empty Address
  factory Address.defaultAddress() {
    return Address(
      province: "",
      city: "",
      province_ko: "",
      city_ko: "",
      street: "",
    );
  }

  // Convert Address to JSON
  Map<String, dynamic> toJson() => {
        'province': province,
        'city': city,
        'province_ko': province_ko,
        'city_ko': city_ko,
        'street': street,
      };

  // Deserialize JSON back to Address
  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        province: json['province'] ?? "",
        city: json['city'] ?? "",
        province_ko: json['province_ko'] ?? "",
        city_ko: json['city_ko'] ?? "",
        street: json['street'] ?? "",
      );
    } catch (e) {
      return Address.defaultAddress(); // Fallback if parsing fails
    }
  }

  // from top nav bar: deserialize City JSON into an Address object
  factory Address.fromMapCity(Map<String, dynamic> map, String langCode) {
    String pKey = "s_$langCode";
    final name = getFormattedAddress(langCode, map[pKey], map[langCode]);
    return Address(
      province: map["s_en"],
      city: map["en"],
      province_ko: map["s_ko"],
      city_ko: map["ko"],
    );
  }

  // from top nav bar: deserialize State JSON into an Address object
  factory Address.fromMapState(Map<String, dynamic> map, String languageName) {
    String provinceName = map[languageName];
    return Address(
      province: map["en"],
      city: "",
      province_ko: map["s_ko"],
      city_ko: "",
    );
  }

  Address getCurrentAddress(String langCode, bool isState, bool isCity, bool isStreet) {
    return Address(
      province: isState ? province : '',
      city: isCity ? city : '',
      street: isStreet ? street : '',
    );
  }

  String getName(String languageCode, String type) {
    if (type == "Province") {
      switch (languageCode) {
        case 'en':
          return province;
        case 'ko':
          return province_ko!;
        default:
          return province;
      }
    } else {
      switch (languageCode) {
        case 'en':
          return city!;
        case 'ko':
          return city_ko!;
        default:
          return city!;
      }
    }
  }
}
