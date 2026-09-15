import 'package:hive/hive.dart';

class Country extends HiveObject {
  final String name;
  final String nativeName;
  final String subregion;
  final List<String> borders;
  final String flag;
  final int population;
  final String? capital;
  final String continent;
  final List<String> languages;
  final List<String> currencies;
  final double? area;
  final List<String> timezones;
  final String callingCode;
  final String alpha2Code;

  Country({
    required this.name,
    required this.nativeName,
    required this.subregion,
    required this.borders,
    required this.flag,
    required this.population,
    this.capital,
    required this.continent,
    required this.languages,
    required this.currencies,
    this.area,
    required this.timezones,
    required this.callingCode,
    required this.alpha2Code,
  });

  String get emojiFlag {
    if (alpha2Code.length != 2) return '';
    final int firstLetter = alpha2Code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = alpha2Code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    final languagesRaw = json['languages'] as List<dynamic>? ?? [];
    final languages = languagesRaw
        .map((e) => (e is Map) ? (e['name']?.toString() ?? '') : e.toString())
        .where((s) => s.isNotEmpty)
        .toList();

    final currenciesRaw = json['currencies'] as List<dynamic>? ?? [];
    final currencies = currenciesRaw
        .map((e) {
          if (e is Map) {
            final code = e['code']?.toString() ?? '';
            final name = e['name']?.toString() ?? '';
            return code.isNotEmpty ? '$code ($name)' : name;
          }
          return e.toString();
        })
        .where((s) => s.isNotEmpty)
        .toList();

    final flagUrl = json['flags']?['png']?.toString() ?? '';
    // The API returns a broken Wikimedia URL for Afghanistan; fall back to a
    // reliable source for the black-red-green tricolor instead.
    final flag = flagUrl.contains('Flag_of_the_Taliban')
        ? 'https://flagcdn.com/w320/af.png'
        : flagUrl;

    return Country(
      name: json['name']?.toString() ?? '',
      nativeName: json['nativeName']?.toString() ?? '',
      subregion: json['subregion']?.toString() ?? '',
      borders: List<String>.from(json['borders'] ?? []),
      flag: flag,
      population: (json['population'] as num?)?.toInt() ?? 0,
      capital: json['capital']?.toString(),
      continent: json['region']?.toString() ?? '',
      languages: languages,
      currencies: currencies,
      area: (json['area'] as num?)?.toDouble(),
      timezones: (json['timezones'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      callingCode: (json['callingCodes'] as List<dynamic>?)?.isNotEmpty == true
          ? json['callingCodes'].first.toString()
          : '',
      alpha2Code: json['alpha2Code']?.toString() ?? '',
    );
  }
}

class CountryAdapter extends TypeAdapter<Country> {
  @override
  final int typeId = 0;

  @override
  Country read(BinaryReader reader) {
    return Country(
      name: reader.read().toString(),
      nativeName: reader.read().toString(),
      subregion: reader.read().toString(),
      borders: List<String>.from(reader.read() as List? ?? []),
      flag: reader.read().toString(),
      population: int.tryParse(reader.read().toString()) ?? 0,
      capital: reader.read()?.toString(),
      continent: reader.read().toString(),
      languages: List<String>.from(reader.read() as List? ?? []),
      currencies: List<String>.from(reader.read() as List? ?? []),
      area: double.tryParse(reader.read().toString()),
      timezones: List<String>.from(reader.read() as List? ?? []),
      callingCode: reader.read().toString(),
      alpha2Code: reader.read().toString(),
    );
  }

  @override
  void write(BinaryWriter writer, Country obj) {
    writer.write(obj.name);
    writer.write(obj.nativeName);
    writer.write(obj.subregion);
    writer.write(obj.borders);
    writer.write(obj.flag);
    writer.write(obj.population);
    writer.write(obj.capital);
    writer.write(obj.continent);
    writer.write(obj.languages);
    writer.write(obj.currencies);
    writer.write(obj.area);
    writer.write(obj.timezones);
    writer.write(obj.callingCode);
    writer.write(obj.alpha2Code);
  }
}
