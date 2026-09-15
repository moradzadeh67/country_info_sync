import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/heritage_site.dart';
import '../models/country_insight.dart';
import '../theme/app_spacing.dart';

class HeritageCard extends StatelessWidget {
  final HeritageSite site;
  final ThemeData theme;

  const HeritageCard({super.key, required this.site, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.sm(context)),
      padding: EdgeInsets.all(AppSpacing.lg(context)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
          Row(
            children: [
              Icon(Icons.account_balance, size: 18, color: isDark ? Colors.white : Colors.black),
              SizedBox(width: AppSpacing.xxs(context)),
              Expanded(
                child: Text(
                  site.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxs(context)),
          Text(
            site.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : const Color(0xFF344535),
            ),
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatefulWidget {
  final CountryInsight insight;
  final ThemeData theme;
  final String countryName;

  const InsightCard({
    super.key,
    required this.insight,
    required this.theme,
    required this.countryName,
  });

  @override
  State<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard> {
  bool _isInsightExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md(context)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
          Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: isDark ? Colors.white : Colors.black),
              SizedBox(width: AppSpacing.xxs(context)),
              Text(
                'About ${widget.countryName}',
                style: widget.theme.textTheme.titleSmall?.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxs(context)),
          GestureDetector(
            onTap: () => setState(() => _isInsightExpanded = !_isInsightExpanded),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.insight.extract,
                  style: widget.theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : const Color(0xFF344535),
                  ),
                  maxLines: _isInsightExpanded ? null : 4,
                  overflow: _isInsightExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.hair(context)),
                Text(
                  _isInsightExpanded ? 'Show Less' : 'Read More...',
                  style: widget.theme.textTheme.labelMedium?.copyWith(
                    color: isDark ? Colors.lightGreenAccent : const Color(0xFF344535),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (widget.insight.sourceUrl.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm(context)),
            const Divider(height: 1),
            SizedBox(height: AppSpacing.xxs(context)),
            InkWell(
              onTap: () async {
                final url = Uri.parse(widget.insight.sourceUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Source: Wikipedia',
                    style: widget.theme.textTheme.labelSmall?.copyWith(
                      color: isDark ? Colors.white38 : Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: AppSpacing.hair(context)),
                  Icon(Icons.open_in_new, size: 10, color: isDark ? Colors.white38 : Colors.grey),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm(context)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xxs(context)),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black),
          ),
          SizedBox(width: AppSpacing.sm(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF344535),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
