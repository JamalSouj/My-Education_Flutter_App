import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for when no establishments are found
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;
  final String? illustrationUrl;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionTap,
    this.illustrationUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          if (illustrationUrl != null)
            Container(
              width: 60.w,
              height: 30.h,
              margin: EdgeInsets.only(bottom: 4.h),
              child: CustomImageWidget(
                imageUrl: illustrationUrl!,
                width: 60.w,
                height: 30.h,
                fit: BoxFit.contain,
                semanticLabel:
                "Empty state illustration showing a person looking through a magnifying glass at educational buildings",
              ),
            )
          else
            Container(
              width: 40.w,
              height: 20.h,
              margin: EdgeInsets.only(bottom: 4.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: colorScheme.primary.withValues(alpha: 0.6),
                  size: 60,
                ),
              ),
            ),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Subtitle
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Action button
          if (actionText != null && onActionTap != null) ...[
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onActionTap,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(actionText!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
