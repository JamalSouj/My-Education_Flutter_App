import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final String? illustrationUrl;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.illustrationUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (illustrationUrl != null) ...[
            CustomImageWidget(
              imageUrl: illustrationUrl!,
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
              semanticLabel:
              "Illustration showing empty search results with a magnifying glass and document icons",
            ),
            SizedBox(height: 4.h),
          ] else ...[
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'search_off',
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
                size: 40,
              ),
            ),
            SizedBox(height: 4.h),
          ],
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          if (primaryButtonText != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPrimaryPressed,
                child: Text(primaryButtonText!),
              ),
            ),
            SizedBox(height: 2.h),
          ],
          if (secondaryButtonText != null) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onSecondaryPressed,
                child: Text(secondaryButtonText!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
