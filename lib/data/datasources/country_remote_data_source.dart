
import 'package:http/http.dart' as http;
import 'package:country_info_sync/data/models/country_model.dart';
import 'dart:convert';

class CountryRemoteDataSource {
  final http.Client client;

  CountryRemoteDataSource({required this.client});

  Future<List<CountryModel>> getAllCountries() async {
    final response = await client.get(
      Uri.parse('https://restcountries.com/v3.1/all'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }
}
