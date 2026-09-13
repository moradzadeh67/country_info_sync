import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../models/country.dart';

class CountryService {
  static const String _apiUrl = 'https://countries.dev/countries';
  static const String _boxName = 'countries_cache_v3'; // Incremented to v3 for new schema

  Future<List<Country>> getCountries() async {
    final box = await Hive.openBox<Country>(_boxName);

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final countries = data.map((json) => Country.fromJson(json)).toList();

        await box.clear();
        await box.addAll(countries);
        return countries;
      }
    } catch (e) {
      if (box.isNotEmpty) {
        return box.values.toList();
      }
      rethrow;
    }

    return box.values.toList();
  }
}
