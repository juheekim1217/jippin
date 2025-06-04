import 'package:jippin/models/city.dart';

class Province {
  final String en;
  final String ko;
  final String type;
  final Map<String, dynamic> cities;
  final Map<String, City> cityMap;

  Province({
    required this.en,
    required this.ko,
    required this.type,
    required this.cities,
  }) : cityMap = {
          for (var entry in cities.entries)
            entry.key: City(
              en: entry.value['en'] ?? '',
              ko: entry.value['ko'] ?? '',
            )
        };

  String getName(String langCode) => langCode == 'ko' ? ko : en;

  @override
  String toString() => en;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Province && runtimeType == other.runtimeType && en == other.en;

  @override
  int get hashCode => en.hashCode;
}
