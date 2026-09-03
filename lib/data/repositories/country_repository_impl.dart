
import 'package:country_info_sync/data/datasources/country_remote_data_source.dart';
import 'package:country_info_sync/data/datasources/country_local_data_source.dart';
import 'package:country_info_sync/data/models/country_model.dart';
import 'package:country_info_sync/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CountryModel>> getAllCountries() async {
    return await remoteDataSource.getAllCountries();
  }

  @override
  Future<List<CountryModel>> getFavorites() async {
    await localDataSource.init();
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(CountryModel country) async {
    await localDataSource.init();
    await localDataSource.addFavorite(country);
  }

  @override
  Future<void> removeFavorite(String countryName) async {
    await localDataSource.init();
    await localDataSource.removeFavorite(countryName);
  }

  @override
  Future<bool> isFavorite(String countryName) async {
    await localDataSource.init();
    return await localDataSource.isFavorite(countryName);
  }
}
