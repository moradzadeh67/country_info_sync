import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../models/country.dart';
import '../services/country_service.dart';
import '../services/favorites_service.dart';
import '../main.dart';
import '../theme/app_spacing.dart';
import '../widgets/country_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/empty_state_view.dart';
import 'details_screen.dart';
import 'compare_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CountryService _service = CountryService();
  final FavoritesService _favService = FavoritesService();
  final TextEditingController _controller = TextEditingController();
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  List<String> _favorites = [];
  bool _showFavoritesOnly = false;
  List<String> selectedForCompare = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final countries = await _service.getCountries();
      final favorites = await _favService.getFavorites();
      setState(() {
        _allCountries = countries;
        _filteredCountries = countries;
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load countries: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(String name) async {
    if (_favorites.contains(name)) {
      await _favService.removeFavorite(name);
    } else {
      await _favService.addFavorite(name);
    }
    final updatedFavs = await _favService.getFavorites();
    if (!mounted) return;
    _favorites = updatedFavs;
    _applyFilters();
  }

  void _toggleFavoritesFilter() {
    HapticFeedback.lightImpact();
    _showFavoritesOnly = !_showFavoritesOnly;
    _applyFilters();
  }

  void _toggleTheme() {
    HapticFeedback.mediumImpact();
    final newMode = themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    themeNotifier.value = newMode;
    Hive.box('settings_box').put('theme_mode', newMode == ThemeMode.dark ? 'dark' : 'light');
  }

  void _toggleSelectForCompare(String name) {
    if (selectedForCompare.contains(name)) {
      selectedForCompare.remove(name);
    } else if (selectedForCompare.length < 2) {
      selectedForCompare.add(name);
    } else {
      if (!mounted) return;
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only 2 countries can be compared'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (mounted) setState(() {});
  }

  void _applyFilters() {
    final lowerQuery = _controller.text.toLowerCase().trim();
    setState(() {
      var result = _allCountries
          .where((c) => !_showFavoritesOnly || _favorites.contains(c.name))
          .toList();

      if (lowerQuery.isNotEmpty) {
        result = result.where((c) {
          final name = c.name.toLowerCase();
          final capital = c.capital?.toLowerCase() ?? '';
          return name.contains(lowerQuery) || capital.contains(lowerQuery);
        }).toList();

        result.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();
          final aStarts = aName.startsWith(lowerQuery);
          final bStarts = bName.startsWith(lowerQuery);
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          return aName.compareTo(bName);
        });
      }

      _filteredCountries = result;
    });
  }

  List<Country> _selectedCountries() {
    return _allCountries.where((c) => selectedForCompare.contains(c.name)).toList();
  }

  Future<void> _navigateToCompare() async {
    HapticFeedback.mediumImpact();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompareScreen(countries: _selectedCountries())),
    );
    if (mounted) {
      setState(() {
        selectedForCompare.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.surface : const Color(0xFFDAE0EA),
      appBar: AppBar(
        title: Text(
          'Explorer',
          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF6373BF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : Colors.white,
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
            tooltip: 'Favorites only',
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: _showFavoritesOnly ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavoritesFilter,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: const Color(0xFF6373BF),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg(context),
              vertical: AppSpacing.xs(context),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: Colors.white24, width: 1) : null,
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: (_) => _applyFilters(),
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.amber : const Color(0xFF6373BF),
                  ),
                  filled: isDark,
                  fillColor: const Color(0xFF1A1A2E),
                  border: isDark
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white24),
                        )
                      : InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.md(context)),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: selectedForCompare.length == 2
          ? FloatingActionButton.extended(
              onPressed: _navigateToCompare,
              label: Text('Compare (${selectedForCompare.length})'),
              icon: const Icon(Icons.swap_horiz),
            )
          : null,
      body: _isLoading
          ? const ShimmerLoading()
          : _error.isNotEmpty
          ? EmptyStateView(
              icon: Icons.error_outline,
              title: 'Error',
              message: _error,
              onRetry: _loadData,
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _filteredCountries.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: AppSpacing.emptyStateGap(context)),
                        EmptyStateView(
                          icon: _showFavoritesOnly && _controller.text.trim().isEmpty
                              ? Icons.favorite_border
                              : Icons.search_off,
                          title: _showFavoritesOnly && _controller.text.trim().isEmpty
                              ? 'No favorites yet'
                              : 'No countries found',
                          message: _showFavoritesOnly && _controller.text.trim().isEmpty
                              ? 'Explore countries and mark them as favorites'
                              : 'Try adjusting your search query',
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(AppSpacing.lg(context)),
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        return CountryCard(
                          country: country,
                          isFavorite: _favorites.contains(country.name),
                          isSelected: selectedForCompare.contains(country.name),
                          onToggleFavorite: () => _toggleFavorite(country.name),
                          onLongPress: () => _toggleSelectForCompare(country.name),
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(country: country),
                              ),
                            );
                            // Refresh favorites when returning from details screen
                            final updatedFavs = await _favService.getFavorites();
                            if (mounted) {
                              setState(() {
                                _favorites = updatedFavs;
                              });
                            }
                          },
                        );
                      },
                    ),
            ),
    );
  }
}
