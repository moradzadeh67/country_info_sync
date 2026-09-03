import 'dart:convert';

import 'package:country_info_sync/data/models/country_model.dart';
import 'package:http/http.dart' as http;

class CountryRemoteDataSource {
  final http.Client client;

  CountryRemoteDataSource({required this.client});

  Future<List<CountryModel>> getAllCountries() async {
    final response = await client.get(
      Uri.parse('https://restcountries.com/v3.1/all'),
    );

    // اول از همه متن پاسخ را دیکد می‌کنیم؛ هر نوعی ممکن است باشد.
    final dynamic decoded;
    try {
      decoded = json.decode(response.body);
    } catch (e) {
      throw Exception('پاسخ سرور JSON معتبر نبود: $e');
    }

    // اگر پاسخ لیست نبود (مثلاً پیام خطا به شکل Map)، پیام واضح بده.
    if (decoded is! List) {
      throw Exception(
        'پاسخ غیرمنتظره از سرور (لیست نیست): $decoded',
      );
    }

    // حالا هر آیتم را به‌صورت امن به مدل تبدیل کن.
    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw Exception('آیتم کشور شکل درستی ندارد.');
      }
      return CountryModel.fromJson(item);
    }).toList();
  }
}