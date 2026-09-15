import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/country.dart';
import 'screens/home_screen.dart';
import 'theme/app_typography.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CountryAdapter());

  await Hive.openBox<List>('favorites_box');
  await Hive.openBox('insight_cache');
  final settingsBox = await Hive.openBox('settings_box');

  // Load saved theme preference
  final savedTheme = settingsBox.get('theme_mode', defaultValue: 'light');
  themeNotifier.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Country Info Sync',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            textTheme: AppTypography.build(ThemeData.light().textTheme),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
            useMaterial3: true,
            textTheme: AppTypography.build(ThemeData.dark().textTheme),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
