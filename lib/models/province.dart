class Province {
  final String nameEn;
  final String nameKo;
  final String type;
  final Map<String, dynamic> cities;

  Province({
    required this.nameEn,
    required this.nameKo,
    required this.type,
    required this.cities,
  });

  String getName(String langCode) => langCode == 'ko' ? nameKo : nameEn;

  @override
  String toString() => nameEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Province && runtimeType == other.runtimeType && nameEn == other.nameEn;

  @override
  int get hashCode => nameEn.hashCode;
}
