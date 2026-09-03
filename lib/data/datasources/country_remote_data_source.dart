import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/country_model.dart';

class CountryRemoteDataSource {
  static const String _url = 'https://countries.dev/countries';

  Future<List<CountryModel>> fetchAll() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
    final List<dynamic> raw = json.decode(response.body);
    return raw
        .where((e) => e is Map)
        .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
