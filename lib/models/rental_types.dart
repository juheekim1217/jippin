class RentalType {
  final String key;
  final Map<String, String> localizedLabels;

  const RentalType({required this.key, required this.localizedLabels});

  String getLabel(String locale) {
    return localizedLabels[locale] ?? key;
  }
}

String? getRentalTypeLabel(String key, String languageCode) {
  return rentalTypes
      .firstWhere(
        (type) => type.key == key,
        orElse: () => RentalType(key: key, localizedLabels: {}),
      )
      .localizedLabels[languageCode];
}

const List<RentalType> rentalTypes = [
  RentalType(
    key: 'long_term',
    localizedLabels: {
      'en': 'Long-Term Rental',
      'ko': '월세 (장기 임대)',
    },
  ),
  RentalType(
    key: 'short_term',
    localizedLabels: {
      'en': 'Short-Term Rental',
      'ko': '단기 임대',
    },
  ),
  RentalType(
    key: 'vacation',
    localizedLabels: {
      'en': 'Vacation Rental',
      'ko': '휴가용 임대',
    },
  ),
  RentalType(
    key: 'jeonse',
    localizedLabels: {
      'en': 'Lump-sum Lease',
      'ko': '전세',
    },
  ),
  RentalType(
    key: 'daily',
    localizedLabels: {
      'en': 'Daily Rental',
      'ko': '일일 임대',
    },
  ),
  RentalType(
    key: 'other',
    localizedLabels: {
      'en': 'Other',
      'ko': '기타',
    },
  ),
];

const List<RentalType> placeTypes = [
  RentalType(
    key: 'apartment',
    localizedLabels: {
      'en': 'Apartment',
      'ko': '아파트',
    },
  ),
  RentalType(
    key: 'condo',
    localizedLabels: {
      'en': 'Condo',
      'ko': '콘도',
    },
  ),
  RentalType(
    key: 'house',
    localizedLabels: {
      'en': 'House',
      'ko': '단독주택',
    },
  ),
  RentalType(
    key: 'studio',
    localizedLabels: {
      'en': 'Studio',
      'ko': '원룸',
    },
  ),
  RentalType(
    key: 'room',
    localizedLabels: {
      'en': 'Room',
      'ko': '방',
    },
  ),
  RentalType(
    key: 'goshiwon',
    localizedLabels: {
      'en': 'Micro studio',
      'ko': '고시원',
    },
  ),
  RentalType(
    key: 'officetel',
    localizedLabels: {
      'en': 'Live-work apartment',
      'ko': '오피스텔',
    },
  ),
  RentalType(
    key: 'shared_house',
    localizedLabels: {
      'en': 'Shared House',
      'ko': '쉐어하우스',
    },
  ),
  RentalType(
    key: 'other',
    localizedLabels: {
      'en': 'Other',
      'ko': '기타',
    },
  ),
];
