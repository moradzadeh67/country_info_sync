import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/country.dart';

class DetailsScreen extends StatelessWidget {
  final Country country;
  const DetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Country Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Flag and Identity
            Center(
              child: Hero(
                tag: 'flag-${country.name}',
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: country.flag.isNotEmpty
                        ? Image.network(country.flag, fit: BoxFit.cover)
                        : const Icon(Icons.flag, size: 100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                country.name,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E2432),
                ),
                maxLines: 1,
              ),
            ),
            if (country.nativeName.isNotEmpty)
              Text(
                country.nativeName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 24),

            // Section 2: Core Info
            _buildSectionHeader('General Information'),
            _buildInfoGrid([
              _InfoItem(Icons.location_city, 'Capital', country.capital ?? 'N/A'),
              _InfoItem(Icons.people, 'Population', _formatNumber(country.population)),
              _InfoItem(Icons.public, 'Subregion', country.subregion),
              _InfoItem(
                Icons.square_foot,
                'Area',
                '${_formatNumber(country.area?.toInt() ?? 0)} km²',
              ),
            ]),

            const SizedBox(height: 24),

            // Section 3: Identity & Communication
            _buildSectionHeader('Communication'),
            _buildInfoGrid([
              _InfoItem(Icons.call, 'Calling Code', '+${country.callingCode}'),
              _InfoItem(
                Icons.language,
                'Languages',
                country.languages.isNotEmpty ? country.languages.first : 'N/A',
              ),
              _InfoItem(
                Icons.access_time,
                'Timezones',
                country.timezones.isNotEmpty ? country.timezones.first : 'N/A',
              ),
              _InfoItem(
                Icons.currency_exchange,
                'Currencies',
                country.currencies.isNotEmpty ? country.currencies.first.split('(')[0] : 'N/A',
              ),
            ]),

            const SizedBox(height: 24),

            // Section 4: Full Lists
            _buildSectionHeader('Detailed Records'),
            _buildDetailedTile('All Languages', country.languages.join(', ')),
            _buildDetailedTile('All Currencies', country.currencies.join(', ')),
            if (country.borders.isNotEmpty)
              _buildDetailedTile('Border Countries', country.borders.join(', ')),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number > 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number > 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.indigo),
      ),
    );
  }

  Widget _buildInfoGrid(List<_InfoItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 20, color: Colors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      item.value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2432),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailedTile(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content.isEmpty ? 'N/A' : content,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xFF1E2432),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  _InfoItem(this.icon, this.label, this.value);
}
