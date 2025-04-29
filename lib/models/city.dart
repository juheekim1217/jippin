class City {
  final String en;
  final String ko;
  final String? stateEn;
  final String? stateKo;

  City({
    required this.en,
    required this.ko,
    this.stateEn,
    this.stateKo,
  });

  String getName(String langCode) => langCode == 'ko' ? ko : en;

  @override
  bool operator ==(Object other) => identical(this, other) || other is City && runtimeType == other.runtimeType && en == other.en && stateEn == other.stateEn;

  @override
  int get hashCode => en.hashCode ^ stateEn.hashCode;
}
