import 'package:supabase_flutter/supabase_flutter.dart';

class Address {
  final String name;
  final String fullName;
  final String? stateCode;
  final String? state;
  final String? city;
  final String? street;
  final String? streetNum;
  final String? unit;
  final String? zip;

  Address({
    required this.name,
    required this.fullName,
    this.stateCode,
    this.state,
    this.city,
    this.street,
    this.streetNum,
    this.unit,
    this.zip,
  });

  // Factory constructor for empty Address
  factory Address.defaultAddress() {
    return Address(
      name: "",
      fullName: "",
      stateCode: "",
      state: "",
      city: "",
      street: "",
    );
  }

  // Convert Address to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'fullName': fullName,
        'stateCode': stateCode,
        'state': state,
        'city': city,
        'street': street,
      };

  // Deserialize JSON back to Address
  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        name: json['name'] ?? "",
        fullName: json['fullName'] ?? "",
        stateCode: json['stateCode'] ?? "",
        state: json['state'] ?? "",
        city: json['city'] ?? "",
        street: json['street'] ?? "",
      );
    } catch (e) {
      return Address.defaultAddress(); // Fallback if parsing fails
    }
  }

  // from top nav bar: deserialize City JSON into an Address object
  factory Address.fromMapCity(Map<String, dynamic> map, String langCode) {
    String state = map["s_en"];
    String city = map[langCode];
    String fn = "$city, $state";
    if (langCode == "ko") {
      state = map["s_ko"];
      fn = "$state $city";
    }
    return Address(
      name: city,
      fullName: fn,
      city: city,
      state: state,
      stateCode: "",
    );
  }

  // from top nav bar: deserialize State JSON into an Address object
  factory Address.fromMapState(Map<String, dynamic> map, String languageName) {
    String state = map[languageName];
    return Address(
      name: state,
      fullName: state,
      city: "",
      state: state,
      stateCode: map["sc"] ?? "",
    );
  }

  Address getCurrentAddress(bool isState, bool isCity, bool isStreet) {
    return Address(
      name: state ?? '',
      fullName: state ?? '',
      stateCode: stateCode,
      state: isState ? state : '',
      city: isCity ? city : '',
      street: isStreet ? street : '',
    );
  }
}
