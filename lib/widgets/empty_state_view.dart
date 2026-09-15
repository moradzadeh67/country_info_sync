import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message = '',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.scale(context) * 64,
              color: isDark ? Colors.white24 : Colors.grey[300],
            ),
            SizedBox(height: AppSpacing.md(context)),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message.isNotEmpty) ...[
              SizedBox(height: AppSpacing.xxs(context)),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white38 : Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.md(context)),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
