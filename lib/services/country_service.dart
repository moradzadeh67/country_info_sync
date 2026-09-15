import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../models/country.dart';

class CountryService {
  static const String _apiUrl = 'https://countries.dev/countries';
  static const String _boxName = 'countries_cache_v4'; // Incremented to v4 for alpha2Code schema

  Future<List<Country>> getCountries() async {
    final box = await Hive.openBox<Country>(_boxName);

    try {
      final response = await http.get(Uri.parse(_apiUrl)).timeout(const Duration(seconds: 5));
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

      // Fallback to local asset if both network and cache fail
      try {
        final String assetData = await rootBundle.loadString('assets/data/countries.json');
        final List<dynamic> data = json.decode(assetData);
        final countries = data.map((json) => Country.fromJson(json)).toList();

        await box.clear();
        await box.addAll(countries);
        return countries;
      } catch (assetError) {
        throw Exception('Failed to load country data: $e');
      }
    }

    return box.values.toList();
  }
}
