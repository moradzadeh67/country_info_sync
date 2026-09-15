import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/country.dart';
import '../theme/app_spacing.dart';

class CompareScreen extends StatelessWidget {
  final List<Country> countries;

  const CompareScreen({super.key, required this.countries});

  String _formatNumber(num number) {
    if (number > 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number > 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (countries.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? theme.colorScheme.surface : const Color(0xFFDAE0EA),
        appBar: AppBar(title: const Text('Compare')),
        body: const Center(child: Text('No countries selected')),
      );
    }

    if (countries.length == 1) {
      return Scaffold(
        backgroundColor: isDark ? theme.colorScheme.surface : const Color(0xFFDAE0EA),
        appBar: AppBar(title: const Text('Compare')),
        body: const Center(child: Text('Select at least 2 countries to compare')),
      );
    }

    final c1 = countries[0];
    final c2 = countries[1];

    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.surface : const Color(0xFFDAE0EA),
      appBar: AppBar(
        title: Text(
          'Compare Countries',
          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6373BF),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md(context)),
        child: Column(
          children: [
            // Flags Header Row
            Row(
              children: [
                Expanded(child: _buildCountryHeaderCard(context, c1, theme)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs(context)),
                  child: Icon(
                    Icons.swap_horiz,
                    color: isDark ? theme.colorScheme.primary : Colors.indigo,
                    size: 28,
                  ),
                ),
                Expanded(child: _buildCountryHeaderCard(context, c2, theme)),
              ],
            ),
            SizedBox(height: AppSpacing.xl(context)),

            // Comparison Details List
            _buildComparisonCard(
              title: 'Capital',
              icon: Icons.location_city,
              val1: c1.capital != null && c1.capital!.isNotEmpty ? c1.capital! : '—',
              val2: c2.capital != null && c2.capital!.isNotEmpty ? c2.capital! : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Population',
              icon: Icons.people,
              val1: _formatNumber(c1.population),
              val2: _formatNumber(c2.population),
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Area',
              icon: Icons.square_foot,
              val1: c1.area != null ? '${_formatNumber(c1.area!)} km²' : '—',
              val2: c2.area != null ? '${_formatNumber(c2.area!)} km²' : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Continent',
              icon: Icons.map,
              val1: c1.continent.isNotEmpty ? c1.continent : '—',
              val2: c2.continent.isNotEmpty ? c2.continent : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Subregion',
              icon: Icons.public,
              val1: c1.subregion.isNotEmpty ? c1.subregion : '—',
              val2: c2.subregion.isNotEmpty ? c2.subregion : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Calling Code',
              icon: Icons.call,
              val1: c1.callingCode.isNotEmpty ? '+${c1.callingCode}' : '—',
              val2: c2.callingCode.isNotEmpty ? '+${c2.callingCode}' : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Languages',
              icon: Icons.language,
              val1: c1.languages.isNotEmpty ? c1.languages.join(', ') : '—',
              val2: c2.languages.isNotEmpty ? c2.languages.join(', ') : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Currencies',
              icon: Icons.currency_exchange,
              val1: c1.currencies.isNotEmpty
                  ? c1.currencies.map((e) => e.split('(')[0].trim()).join(', ')
                  : '—',
              val2: c2.currencies.isNotEmpty
                  ? c2.currencies.map((e) => e.split('(')[0].trim()).join(', ')
                  : '—',
              context: context,
              theme: theme,
            ),
            _buildComparisonCard(
              title: 'Timezones',
              icon: Icons.access_time,
              val1: c1.timezones.isNotEmpty ? c1.timezones.join(', ') : '—',
              val2: c2.timezones.isNotEmpty ? c2.timezones.join(', ') : '—',
              context: context,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryHeaderCard(BuildContext context, Country country, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm(context)),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainer : const Color(0xFFF2F6FD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            height: AppSpacing.flagBannerHeight(context),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFE9F0FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : const Color(0xFFC5D2E8),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: country.flag.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: country.flag,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(country.emojiFlag, style: const TextStyle(fontSize: 64)),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(country.emojiFlag, style: const TextStyle(fontSize: 64)),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: AppSpacing.sm(context)),
          Text(
            country.name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String val1,
    required String val2,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm(context)),
      padding: EdgeInsets.all(AppSpacing.md(context)),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.black),
              SizedBox(width: AppSpacing.tiny(context)),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs(context)),
          Row(
            children: [
              Expanded(
                child: Text(
                  val1,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF344535),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 1,
                height: AppSpacing.xl(context),
                color: isDark ? Colors.white12 : Colors.grey[300],
              ),
              Expanded(
                child: Text(
                  val2,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF344535),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
