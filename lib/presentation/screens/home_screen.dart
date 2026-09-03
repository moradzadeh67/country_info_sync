
import 'package:flutter/material.dart';
import 'package:country_info_sync/presentation/widgets/country_card.dart';
import 'package:country_info_sync/services/service_locator.dart';
import 'package:country_info_sync/domain/repositories/country_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CountryRepository _repository;
  List<dynamic> _countries = []; // We'll use dynamic for simplicity, but ideally List<CountryModel>
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _repository = serviceLocator.repository;
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final countries = await _repository.getAllCountries();
      setState(() {
        _countries = countries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredCountries {
    if (_searchQuery.isEmpty) return _countries;
    return _countries.where((c) {
      final name = (c as dynamic).name ?? '';
      return name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search country...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _filteredCountries.isEmpty
                  ? const Center(child: Text('No countries found.'))
                  : ListView.builder(
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        return CountryCard(
                          country: country,
                          onTap: () {
                            // Navigate to details screen
                            Navigator.of(context).pushNamed(
                              '/details',
                              arguments: country,
                            );
                          },
                        );
                      },
                    ),
    );
  }
}
