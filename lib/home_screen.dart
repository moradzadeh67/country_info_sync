import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'country.dart';
import 'country_service.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CountryService _service = CountryService();
  final TextEditingController _controller = TextEditingController();
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final countries = await _service.getCountries();
      setState(() {
        _allCountries = countries;
        _filteredCountries = countries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load countries: $e';
        _isLoading = false;
      });
    }
  }

  void _filter(String query) {
    final lowerQuery = query.toLowerCase().trim();
    setState(() {
      if (lowerQuery.isEmpty) {
        _filteredCountries = List.from(_allCountries);
      } else {
        _filteredCountries = _allCountries.where((c) {
          final name = c.name.toLowerCase();
          final capital = c.capital?.toLowerCase() ?? '';
          return name.contains(lowerQuery) || capital.contains(lowerQuery);
        }).toList();

        _filteredCountries.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();
          final aStarts = aName.startsWith(lowerQuery);
          final bStarts = bName.startsWith(lowerQuery);
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          return aName.compareTo(bName);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          'Explorer',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: _filter,
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error, style: GoogleFonts.poppins()))
          : RefreshIndicator(
              onRefresh: _loadCountries,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  return CountryCard(country: country);
                },
              ),
            ),
    );
  }
}

class CountryCard extends StatelessWidget {
  final Country country;
  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsScreen(country: country)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'flag-${country.name}',
                  child: Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: country.flag.isNotEmpty
                          ? Image.network(
                              country.flag,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 30),
                            )
                          : const Icon(Icons.flag, size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          country.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: const Color(0xFF1E2432),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_city, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              country.capital ?? 'No Capital',
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
