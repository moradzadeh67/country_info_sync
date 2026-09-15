import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:country_info_sync/models/heritage_site.dart';

void main() {
  test('Heritage Site JSON data is valid and parsable', () {
    final file = File('assets/data/heritage_sites.json');
    expect(file.existsSync(), true, reason: 'JSON asset file should exist');

    final jsonString = file.readAsStringSync();
    final List<dynamic> data = json.decode(jsonString);

    expect(data.isNotEmpty, true, reason: 'JSON should contain data');

    final sites = data.map((j) => HeritageSite.fromJson(j)).toList();
    expect(sites.length, greaterThan(0));

    final italySite = sites.firstWhere((s) => s.countryName == 'Italy');
    expect(italySite.name, 'Colosseum');
    expect(italySite.lat, 41.8902);
  });
}
