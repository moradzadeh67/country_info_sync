import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/heritage_site.dart';

class HeritageService {
  static List<HeritageSite>? _cachedSites;

  static Future<List<HeritageSite>> _getAllSites() async {
    if (_cachedSites != null) return _cachedSites!;

    try {
      final String response = await rootBundle.loadString('assets/data/heritage_sites.json');
      final List<dynamic> data = json.decode(response);
      _cachedSites = data.map((json) => HeritageSite.fromJson(json)).toList();
      return _cachedSites!;
    } catch (e) {
      // Return empty list instead of crashing on malformed JSON or missing asset
      return [];
    }
  }

  static Future<List<HeritageSite>> getSitesForCountry(String countryName) async {
    final allSites = await _getAllSites();
    return allSites
        .where((site) => site.countryName.toLowerCase() == countryName.toLowerCase())
        .toList();
  }
}
