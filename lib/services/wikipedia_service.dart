import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../models/country_insight.dart';

class WikipediaService {
  static const String _baseUrl = 'https://en.wikipedia.org/api/rest_v1/page/summary/';
  static const String _boxName = 'insight_cache';

  /// Explicit mappings for country names in the dataset that differ from
  /// their official Wikipedia page titles. These are verified, not guessed.
  static const Map<String, String> _titleOverrides = {
    'iran (islamic republic of)': 'Iran',
    'korea (republic of)': 'South Korea',
    'korea (democratic people\'s republic of)': 'North Korea',
    'united states of america': 'United States',
    'russian federation': 'Russia',
    'viet nam': 'Vietnam',
    'syrian arab republic': 'Syria',
    'bolivia (plurinational state of)': 'Bolivia',
    'venezuela (bolivarian republic of)': 'Venezuela',
    'tanzania, united republic of': 'Tanzania',
    'moldova (republic of)': 'Moldova',
    'lao people\'s democratic republic': 'Laos',
    'brunei darussalam': 'Brunei',
    'czechia': 'Czech Republic',
    'côte d\'ivoire': 'Ivory Coast',
    'congo (republic of the)': 'Republic of the Congo',
    'congo (democratic republic of the)': 'Democratic Republic of the Congo',
    'türkiye': 'Turkey',
    'north macedonia': 'North Macedonia',
    'eswatini': 'Eswatini',
    'cabo verde': 'Cape Verde',
    'timor-leste': 'East Timor',
    'vatican city': 'Vatican City',
    'palestine, state of': 'State of Palestine',
    'hong kong': 'Hong Kong',
    'macao': 'Macau',
  };

  /// Builds the ordered list of candidate page titles to try.
  static List<String> _candidateTitles(String countryName) {
    final candidates = <String>[];
    final lower = countryName.toLowerCase().trim();

    // 1. Explicit override (highest confidence).
    if (_titleOverrides.containsKey(lower)) {
      candidates.add(_titleOverrides[lower]!);
    }

    // 2. Raw name as-is.
    candidates.add(countryName.trim());

    // 3. Name with any parenthetical suffix removed: "Iran (Islamic...)" -> "Iran".
    final withoutParen = countryName.replaceAll(RegExp(r'\s*\(.*\)'), '').trim();
    if (withoutParen.isNotEmpty && withoutParen.toLowerCase() != lower) {
      candidates.add(withoutParen);
    }

    // 4. Deduplicate while preserving order.
    final seen = <String>{};
    return candidates.where((c) => seen.add(c.toLowerCase())).toList();
  }

  static Future<CountryInsight?> getInsight(String countryName) async {
    final box = Hive.box(_boxName);
    final cacheKey = countryName.toLowerCase().trim();

    // 1. Check Cache first (offline-first behavior).
    final cachedData = box.get(cacheKey);
    if (cachedData is Map) {
      return CountryInsight.fromMap(cachedData);
    }

    // 2. Fetch from Wikipedia API, trying each candidate title.
    final candidates = _candidateTitles(countryName);

    for (final candidate in candidates) {
      try {
        final encodedName = Uri.encodeComponent(candidate);
        final response = await http
            .get(Uri.parse('$_baseUrl$encodedName'))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final extract = data['extract']?.toString() ?? '';
          if (extract.isEmpty) continue;

          final insight = CountryInsight(
            countryName: countryName,
            extract: extract,
            sourceUrl: data['content_urls']?['desktop']?['page']?.toString() ?? '',
          );

          // Save to Cache under the original dataset name for future offline use.
          await box.put(cacheKey, insight.toMap());
          return insight;
        }
      } catch (e) {
        // Network failure: if cache is empty, return null so UI stays hidden.
        return null;
      }
    }

    return null;
  }
}
