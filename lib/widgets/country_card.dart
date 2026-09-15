import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../models/country.dart';
import '../theme/app_spacing.dart';

class CountryCard extends StatefulWidget {
  final Country country;
  final bool isFavorite;
  final bool isSelected;
  final VoidCallback onToggleFavorite;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  const CountryCard({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.isSelected,
    required this.onToggleFavorite,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) => _controller.reverse();
  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: EdgeInsets.only(bottom: AppSpacing.md(context)),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: isDark ? 0.3 : 0.1)
                : (isDark ? theme.colorScheme.surfaceContainer : const Color(0xFFF2F6FD)),
            borderRadius: BorderRadius.circular(20),
            border: widget.isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : (isDark ? Border.all(color: Colors.white10, width: 1) : null),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              onLongPress: () {
                HapticFeedback.mediumImpact();
                widget.onLongPress();
              },
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md(context)),
                child: Row(
                  children: [
                    Hero(
                      tag: 'flag-${widget.country.name}',
                      child: Container(
                        width: AppSpacing.flagWidth(context),
                        height: AppSpacing.flagWidth(context) / AppSpacing.flagAspectRatio,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : const Color(0xFFE9F0FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white24 : const Color(0xFFC5D2E8),
                            width: 1,
                          ),
                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: widget.country.flag.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.country.flag,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDark ? Colors.white10 : Colors.grey[200],
                                    child: const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          widget.country.emojiFlag,
                                          style: const TextStyle(fontSize: 100),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        widget.country.emojiFlag,
                                        style: const TextStyle(fontSize: 100),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.country.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: AppSpacing.hair(context)),
                          Row(
                            children: [
                              Icon(Icons.location_city, size: 14, color: Colors.black),
                              SizedBox(width: AppSpacing.hair(context)),
                              Expanded(
                                child: Text(
                                  widget.country.capital ?? 'No Capital',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF344535),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.isFavorite
                            ? Colors.red
                            : (isDark ? Colors.white38 : Colors.grey),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        widget.onToggleFavorite();
                      },
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDark ? theme.colorScheme.primary : Colors.indigo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
