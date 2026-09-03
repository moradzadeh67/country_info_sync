import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:country_info_sync/presentation/screens/home_screen.dart';
import 'package:country_info_sync/presentation/screens/favorites_screen.dart';
import 'package:country_info_sync/presentation/screens/details_screen.dart';
import 'package:country_info_sync/services/service_locator.dart';
import 'package:country_info_sync/data/models/country_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapter for CountryModel
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CountryModelAdapter());
  }
  
  // Initialize service locator
  serviceLocator.init();
  runApp(const CountryInfoSyncApp());
}

class CountryInfoSyncApp extends StatelessWidget {
  const CountryInfoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CountryInfo Sync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        DetailsScreen.routeName: (context) => const DetailsScreen(),
        FavoritesScreen.routeName: (context) => const FavoritesScreen(),
      },
    );
  }
}
