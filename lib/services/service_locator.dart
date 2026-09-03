
import 'package:http/http.dart' as http;
import 'package:country_info_sync/data/datasources/country_remote_data_source.dart';
import 'package:country_info_sync/data/datasources/country_local_data_source.dart';
import 'package:country_info_sync/data/repositories/country_repository_impl.dart';
import 'package:country_info_sync/domain/repositories/country_repository.dart';

class ServiceLocator {
  ServiceLocator._internal();
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;

  late final http.Client httpClient;
  late final CountryRemoteDataSource remoteDataSource;
  late final CountryLocalDataSource localDataSource;
  late final CountryRepository repository;

  void init() {
    httpClient = http.Client();
    remoteDataSource = CountryRemoteDataSource(); // countries.dev no param
    localDataSource = CountryLocalDataSource();
    repository = CountryRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }
}

final serviceLocator = ServiceLocator();
