
import 'package:flutter/material.dart';
import 'package:country_info_sync/data/models/country_model.dart';
import 'package:country_info_sync/services/service_locator.dart';
import 'package:country_info_sync/domain/repositories/country_repository.dart';

class DetailsScreen extends StatefulWidget {
  static const String routeName = '/details';
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final CountryRepository _repository;
  CountryModel? _country;
  bool _isLoading = false;
  bool _isFav = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is CountryModel && _country == null) {
      _country = args;
      _checkFavoriteStatus();
    }
  }

  @override
  void initState() {
    super.initState();
    _repository = serviceLocator.repository;
  }

  Future<void> _checkFavoriteStatus() async {
    if (_country == null) return;
    try {
      final fav = await _repository.isFavorite(_country!.name);
      if (mounted) setState(() => _isFav = fav);
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    if (_country == null) return;
    setState(() => _isLoading = true);
    try {
      if (_isFav) {
        await _repository.removeFavorite(_country!.name);
        setState(() => _isFav = false);
      } else {
        await _repository.addFavorite(_country!);
        setState(() => _isFav = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: \$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_country == null) {
      return const Scaffold(body: Center(child: Text('No country selected.')));
    }
    final c = _country!;
    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: _isLoading ? null : _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: c.flag.isNotEmpty
                        ? Image.network(c.flag, width: 200, height: 120, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 100))
                        : const Icon(Icons.flag, size: 100),
                  ),
                  const SizedBox(height: 16),
                  Text(c.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(label: Text('Continent: ${c.continent}')),
                      Chip(label: Text('Population: ${c.population}')),
                      Chip(label: Text('Capital: ${c.capital.isNotEmpty ? c.capital.first : 'N/A'}')),
                      Chip(label: Text('Area: ${c.area?.toStringAsFixed(0) ?? 'N/A'} km²')),
                      Chip(label: Text('Code: +${c.callingCode}')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (c.languages.isNotEmpty) ...[
                    const Text('Languages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: c.languages.map.map((e) => Chip(label: Text('${e.key}: ${e.value}'))).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (c.currencies.isNotEmpty) ...[
                    const Text('Currencies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: c.currencies.map.map((e) => Chip(label: Text('${e.key}'))).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (c.timezones.isNotEmpty) ...[
                    const Text('Timezones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: c.timezones.map((t) => Chip(label: Text(t))).toList(),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
