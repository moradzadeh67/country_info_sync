
import 'package:flutter/material.dart';
import 'package:country_info_sync/data/models/country_model.dart';
import 'package:country_info_sync/services/service_locator.dart';
import 'package:country_info_sync/domain/repositories/country_repository.dart';

class FavoritesScreen extends StatefulWidget {
  static const String routeName = '/favorites';

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final CountryRepository _repository;
  List<CountryModel> _favorites = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = serviceLocator.repository;
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final favs = await _repository.getFavorites();
      setState(() {
        _favorites = favs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(String countryName) async {
    try {
      await _repository.removeFavorite(countryName);
      _loadFavorites(); // Refresh
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                // Clear all favorites
                try {
                  for (var fav in _favorites) {
                    await _repository.removeFavorite(fav.name);
                  }
                  _loadFavorites();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error clearing: $e')),
                  );
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _favorites.isEmpty
                  ? const Center(child: Text('No favorites yet.'))
                  : ListView.builder(
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        final country = _favorites[index];
                        return ListTile(
                          leading: country.flag.isNotEmpty
                              ? Image.network(
                                  country.flag,
                                  width: 48,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.flag, size: 32),
                                )
                              : const Icon(Icons.flag, size: 32),
                          title: Text(country.name),
                          subtitle: Text(
                            country.capital.isNotEmpty ? country.capital.first : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFavorite(country.name),
                          ),
                        );
                      },
                    ),
    );
  }
}
