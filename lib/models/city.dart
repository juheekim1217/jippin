class City {
  final String nameEn;
  final String nameKo;
  final String stateEn;
  final String stateKo;

  City({
    required this.nameEn,
    required this.nameKo,
    required this.stateEn,
    required this.stateKo,
  });

  String getName(String langCode) => langCode == 'ko' ? nameKo : nameEn;

  @override
  String toString() => nameEn; // For debugging or default printing

  @override
  bool operator ==(Object other) => identical(this, other) || other is City && runtimeType == other.runtimeType && nameEn == other.nameEn && stateEn == other.stateEn;

  @override
  int get hashCode => nameEn.hashCode ^ stateEn.hashCode;
}
