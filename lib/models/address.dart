class Address {
  final String province;
  final String? city;
  final String? provinceKo;
  final String? cityKo;
  final String? street;
  final String? streetNum;
  final String? unit;
  final String? zip;

  Address({
    required this.province,
    this.city,
    this.provinceKo,
    this.cityKo,
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
      provinceKo: "",
      cityKo: "",
      street: "",
    );
  }

  // Convert Address to JSON
  Map<String, dynamic> toJson() => {
        'province': province,
        'city': city,
        'provinceKo': provinceKo,
        'cityKo': cityKo,
        'street': street,
      };

  // Deserialize JSON back to Address
  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        province: json['province'] ?? "",
        city: json['city'] ?? "",
        provinceKo: json['provinceKo'] ?? "",
        cityKo: json['cityKo'] ?? "",
        street: json['street'] ?? "",
      );
    } catch (e) {
      return Address.defaultAddress(); // Fallback if parsing fails
    }
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
          return provinceKo!;
        default:
          return province;
      }
    } else {
      switch (languageCode) {
        case 'en':
          return city!;
        case 'ko':
          return cityKo!;
        default:
          return city!;
      }
    }
  }

  /// Returns a formatted address string based on the given language code.
  String getFullAddress(String langCode) {
    String name = langCode == "ko" ? provinceKo ?? province : province;

    if (city != null) {
      if (langCode == "ko") {
        name = "$provinceKo $cityKo";
      } else {
        name = "$city, $province";
      }
    }
    return name;
  }
}
