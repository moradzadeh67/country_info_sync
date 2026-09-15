import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/country.dart';
import '../models/heritage_site.dart';
import '../models/country_insight.dart';
import '../services/favorites_service.dart';
import '../services/heritage_service.dart';
import '../services/wikipedia_service.dart';
import '../theme/app_spacing.dart';
import '../widgets/details_widgets.dart';

class DetailsScreen extends StatefulWidget {
  final Country country;
  const DetailsScreen({super.key, required this.country});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final FavoritesService _favService = FavoritesService();
  bool _isFavorite = false;
  List<HeritageSite> _heritageSites = [];
  CountryInsight? _countryInsight;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _loadHeritageSites();
    _loadCountryInsight();
  }

  Future<void> _loadCountryInsight() async {
    final insight = await WikipediaService.getInsight(widget.country.name);
    if (mounted) {
      setState(() {
        _countryInsight = insight;
      });
    }
  }

  Future<void> _loadHeritageSites() async {
    final sites = await HeritageService.getSitesForCountry(widget.country.name);
    if (mounted) {
      setState(() {
        _heritageSites = sites;
      });
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await _favService.isFavorite(widget.country.name);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.selectionClick();
    if (_isFavorite) {
      await _favService.removeFavorite(widget.country.name);
    } else {
      await _favService.addFavorite(widget.country.name);
    }
    _checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.surface : const Color(0xFFDAE0EA),
      appBar: AppBar(
        title: Text(
          'Country Details',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFF6373BF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Flag and Identity
            Center(
              child: Hero(
                tag: 'flag-${widget.country.name}',
                child: Container(
                  height: AppSpacing.heroFlagHeight(context),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : const Color(0xFFE9F0FA),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? Colors.white24 : const Color(0xFFC5D2E8),
                      width: 1,
                    ),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: widget.country.flag.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.country.flag,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.flag, size: 100),
                          )
                        : const Icon(Icons.flag, size: 100),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl(context)),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.country.name,
                style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onSurface),
                maxLines: 1,
              ),
            ),
            if (widget.country.nativeName.isNotEmpty)
              Text(
                widget.country.nativeName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
            SizedBox(height: AppSpacing.xl(context)),

            // Section 2: Core Info
            _buildSectionHeader(context, 'General Information', theme),
            if (_countryInsight != null) ...[
              InsightCard(
                insight: _countryInsight!,
                theme: theme,
                countryName: widget.country.name,
              ),
              SizedBox(height: AppSpacing.md(context)),
            ],
            _buildInfoGrid(context, [
              _InfoItem(Icons.location_city, 'Capital', widget.country.capital ?? '—'),
              _InfoItem(Icons.people, 'Population', _formatNumber(widget.country.population)),
              _InfoItem(
                Icons.public,
                'Subregion',
                widget.country.subregion.isNotEmpty ? widget.country.subregion : '—',
              ),
              _InfoItem(
                Icons.square_foot,
                'Area',
                widget.country.area != null
                    ? '${_formatNumber(widget.country.area!.toInt())} km²'
                    : '—',
              ),
            ], theme),

            SizedBox(height: AppSpacing.xl(context)),

            // Section 3: Identity & Communication
            _buildSectionHeader(context, 'Communication', theme),
            _buildInfoGrid(context, [
              _InfoItem(
                Icons.call,
                'Calling Code',
                widget.country.callingCode.isNotEmpty ? '+${widget.country.callingCode}' : '—',
              ),
              _InfoItem(
                Icons.language,
                'Languages',
                widget.country.languages.isNotEmpty ? widget.country.languages.first : '—',
              ),
              _InfoItem(
                Icons.access_time,
                'Timezones',
                widget.country.timezones.isNotEmpty ? widget.country.timezones.first : '—',
              ),
              _InfoItem(
                Icons.currency_exchange,
                'Currencies',
                widget.country.currencies.isNotEmpty
                    ? widget.country.currencies.first.split('(')[0].trim()
                    : '—',
              ),
            ], theme),

            SizedBox(height: AppSpacing.xl(context)),

            // Section 4: Full Lists
            _buildSectionHeader(context, 'Detailed Records', theme),
            _buildDetailedTile(
              context,
              'All Languages',
              widget.country.languages.join(', '),
              theme,
            ),
            _buildDetailedTile(
              context,
              'All Currencies',
              widget.country.currencies.join(', '),
              theme,
            ),
            if (widget.country.borders.isNotEmpty)
              _buildDetailedTile(
                context,
                'Border Countries',
                widget.country.borders.join(', '),
                theme,
              ),

            if (_heritageSites.isNotEmpty) ...[
              SizedBox(height: AppSpacing.xl(context)),
              _buildSectionHeader(context, 'UNESCO Heritage Sites', theme),
              ..._heritageSites.map((site) => HeritageCard(site: site, theme: theme)),
            ],

            SizedBox(height: AppSpacing.xxl(context)),
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

  Widget _buildSectionHeader(BuildContext context, String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm(context)),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, List<_InfoItem> items, ThemeData theme) {
    final double spacing = AppSpacing.md(context);
    final double cellWidth =
        (MediaQuery.sizeOf(context).width - AppSpacing.lg(context) * 2 - spacing) / 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: cellWidth / AppSpacing.infoCellHeight(context),
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InfoTile(icon: item.icon, label: item.label, value: item.value, theme: theme);
      },
    );
  }

  Widget _buildDetailedTile(BuildContext context, String title, String content, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.sm(context)),
      padding: EdgeInsets.all(AppSpacing.lg(context)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xxs(context)),
          Text(
            content.isEmpty ? '—' : content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : const Color(0xFF344535),
              fontWeight: FontWeight.w500,
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
