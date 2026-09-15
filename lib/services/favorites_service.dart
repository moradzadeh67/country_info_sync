import 'package:hive/hive.dart';

class FavoritesService {
  static const String _boxName = 'favorites_box';
  static const String _key = 'names';

  Future<List<String>> getFavorites() async {
    final box = Hive.box<List>(_boxName);
    final List? favorites = box.get(_key);
    return List<String>.from(favorites ?? []);
  }

  Future<void> addFavorite(String name) async {
    final favorites = await getFavorites();
    if (!favorites.contains(name)) {
      favorites.add(name);
      final box = Hive.box<List>(_boxName);
      await box.put(_key, favorites);
    }
  }

  Future<void> removeFavorite(String name) async {
    final favorites = await getFavorites();
    if (favorites.contains(name)) {
      favorites.remove(name);
      final box = Hive.box<List>(_boxName);
      await box.put(_key, favorites);
    }
  }

  Future<bool> isFavorite(String name) async {
    final favorites = await getFavorites();
    return favorites.contains(name);
  }
}
