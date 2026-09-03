
import 'package:country_info_sync/data/models/country_model.dart';

abstract class CountryRepository {
  Future<List<CountryModel>> getAllCountries();
  Future<List<CountryModel>> getFavorites();
  Future<void> addFavorite(CountryModel country);
  Future<void> removeFavorite(String countryName);
  Future<bool> isFavorite(String countryName);
}
