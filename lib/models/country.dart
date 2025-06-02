/// CountryCode Key value pair
final Map<String, Country> countries = {
  "CA": Country("CA", "Canada", "캐나다", "\$", "달러"),
  "KR": Country("KR", "South Korea", "대한민국", "₩", "원"),
  // "US": Country("US", "United States", "미국"),
  // "AU": Country("AU", "Australia", "호주"),
  // "NZ": Country("NZ", "New Zealand", "뉴질랜드"),
  // "GB": Country("GB", "United Kingdom", "영국"),
  // "IE": Country("IE", "Ireland", "아일랜드"),
  // "JP": Country("JP", "Japan", "일본"),
  // "CN": Country("CN", "China", "중국"),
};

class Country {
  final String code;
  final String nameEn;
  final String nameKo;
  final String currencyEn;
  final String currencyKo;

  Country(this.code, this.nameEn, this.nameKo, this.currencyEn, this.currencyKo);

  String getCountryName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return nameEn;
      case 'ko':
        return nameKo;
      case 'fr':
        return nameEn;
      default:
        return nameEn;
    }
  }

  String getCountryCurrency(String languageCode) {
    switch (languageCode) {
      case 'en':
        return currencyEn;
      case 'ko':
        return currencyKo;
      case 'fr':
        return currencyEn;
      default:
        return currencyEn;
    }
  }
}

Country getCountry(String countryName) {
  return countries.values.firstWhere((country) => country.nameEn == countryName || country.nameKo == countryName);
}

List<Country> searchCountries(String keyword) {
  return countries.values.where((country) => country.nameEn.toLowerCase().contains(keyword.toLowerCase()) || country.nameKo.contains(keyword)).toList();
}
