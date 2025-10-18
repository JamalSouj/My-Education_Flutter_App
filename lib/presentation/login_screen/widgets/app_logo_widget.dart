import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Educational app logo widget with brand recognition
class AppLogoWidget extends StatelessWidget {
  final bool showTitle;
  final double? logoSize;

  const AppLogoWidget({
    super.key,
    this.showTitle = true,
    this.logoSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLogoSize = logoSize ?? 20.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo container with educational styling
        Container(
          width: effectiveLogoSize,
          height: effectiveLogoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(effectiveLogoSize * 0.2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Education icon
                CustomIconWidget(
                  iconName: 'school',
                  color: theme.colorScheme.onPrimary,
                  size: effectiveLogoSize * 0.4,
                ),

                SizedBox(height: effectiveLogoSize * 0.05),

                // App initial
                Text(
                  'MW',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: effectiveLogoSize * 0.15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (showTitle) ...[
          SizedBox(height: 3.h),

          // App title
          Text(
            'MyWay Education',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // App subtitle
          Text(
            'Votre parcours éducatif commence ici',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
