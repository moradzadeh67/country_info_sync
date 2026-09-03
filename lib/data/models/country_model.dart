import 'package:hive/hive.dart';

class CountryModel extends HiveObject {
  final String name;
  final String flag;
  final int population;
  final String? capital;      // countries.dev: String (not List); 5 countries null
  final String continent;     // from 'region' field
  final List<String> languages; // countries.dev: array of {name, ...}; we keep names
  final List<String> currencies; // countries.dev: array of {code, name, symbol}
  final double? area;
  final List<String> timezones;
  final String callingCode;   // first of callingCodes[]

  CountryModel({
    required this.name,
    required this.flag,
    required this.population,
    this.capital,
    required this.continent,
    required this.languages,
    required this.currencies,
    this.area,
    required this.timezones,
    required this.callingCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // countries.dev structure: https://countries.dev/countries
    final languagesRaw = json['languages'] as List<dynamic>? ?? [];
    final languages = languagesRaw
        .map((e) => (e as Map)['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    final currenciesRaw = json['currencies'] as List<dynamic>? ?? [];
    final currencies = currenciesRaw
        .map((e) {
          final m = e as Map<dynamic, dynamic>;
          final code = m['code']?.toString() ?? '';
          final name = m['name']?.toString() ?? '';
          return '$code ($name)';
        })
        .where((s) => s.isNotEmpty && s != ' ()')
        .toList();

    return CountryModel(
      name: json['name'] ?? '',
      flag: json['flags']?['png'] ?? '',
      population: (json['population'] as num?)?.toInt() ?? 0,
      capital: json['capital']?.toString(), // null allowed for 5 countries
      continent: json['region'] ?? '',
      languages: languages,
      currencies: currencies,
      area: (json['area'] as num?)?.toDouble(),
      timezones: (json['timezones'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      callingCode: (json['callingCodes'] as List<dynamic>?)?.isNotEmpty == true
          ? json['callingCodes'].first.toString()
          : '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'flags': {'png': flag},
    'population': population,
    'capital': capital,
    'region': continent,
    'languages': languages,
    'currencies': currencies,
    'area': area,
    'timezones': timezones,
    'callingCodes': [callingCode],
  };
}

class CountryModelAdapter extends TypeAdapter<CountryModel> {
  @override
  final int typeId = 0;

  @override
  CountryModel read(BinaryReader reader) {
    return CountryModel(
      name: reader.read(),
      flag: reader.read(),
      population: reader.read(),
      capital: reader.read(),
      continent: reader.read(),
      languages: (reader.read() as List?)?.map((e) => e.toString()).toList() ?? [],
      currencies: (reader.read() as List?)?.map((e) => e.toString()).toList() ?? [],
      area: reader.read(),
      timezones: (reader.read() as List?)?.map((e) => e.toString()).toList() ?? [],
      callingCode: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CountryModel obj) {
    writer.write(obj.name);
    writer.write(obj.flag);
    writer.write(obj.population);
    writer.write(obj.capital);
    writer.write(obj.continent);
    writer.write(obj.languages);
    writer.write(obj.currencies);
    writer.write(obj.area);
    writer.write(obj.timezones);
    writer.write(obj.callingCode);
  }
}
