
import 'package:hive/hive.dart';

class CountryModel extends HiveObject {
  final String name;
  final String flag;
  final int population;
  final List<String> capital;
  final String continent;
  final Map<String, String> languages;
  final Map<String, dynamic> currencies;
  final double? area;
  final List<String> timezones;
  final String callingCode;

  CountryModel({
    required this.name,
    required this.flag,
    required this.population,
    required this.capital,
    required this.continent,
    required this.languages,
    required this.currencies,
    this.area,
    required this.timezones,
    required this.callingCode,
  });

    factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']['common'] ?? '',
      flag: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      capital: _parseStringList(json['capital']),
      continent: (json['continents'] != null && (json['continents'] as List).isNotEmpty)
          ? (json['continents'] as List).first.toString()
          : '',
      languages: json['languages'] != null
          ? Map<String, String>.from(json['languages'])
          : {},
      currencies: json['currencies'] != null
          ? Map<String, dynamic>.from(json['currencies'])
          : {},
      area: (json['area'] as num?)?.toDouble(),
      timezones: _parseStringList(json['timezones']),
      callingCode: _extractCallingCode(json),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value];
    }
    return [];
  }

  static String _extractCallingCode(Map<String, dynamic> json) {
    final idd = json['idd'] as Map<String, dynamic>?;
    if (idd == null) return '';
    final root = idd['root'] as String? ?? '';
    final suffixes = idd['suffixes'] as List<dynamic>?;
    if (suffixes == null || suffixes.isEmpty) return root;
    final first = suffixes.first as String?;
    return first != null ? '$root$first' : root;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flag},
      'population': population,
      'capital': capital,
      'continents': [continent],
      'languages': languages,
      'currencies': currencies,
      'area': area,
      'timezones': timezones,
      'callingCode': callingCode,
    };
  }
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
      languages: Map<String, String>.from(reader.read()),
      currencies: Map<String, dynamic>.from(reader.read()),
      area: reader.read(),
      timezones: reader.read(),
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
