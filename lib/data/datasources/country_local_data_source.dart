
import 'package:hive/hive.dart';
import 'package:country_info_sync/data/models/country_model.dart';

class CountryLocalDataSource {
  static const String _boxName = 'favorites';
  late Box<CountryModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<CountryModel>(_boxName);
  }

  Future<List<CountryModel>> getFavorites() async {
    return _box.values.toList();
  }

  Future<void> addFavorite(CountryModel country) async {
    await _box.put(country.name, country);
  }

  Future<void> removeFavorite(String countryName) async {
    await _box.delete(countryName);
  }

  Future<bool> isFavorite(String countryName) async {
    return _box.containsKey(countryName);
  }

  Future<void> clearFavorites() async {
    await _box.clear();
  }
}
