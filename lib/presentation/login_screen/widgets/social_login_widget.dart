import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Social login options widget with Google and Apple authentication
class SocialLoginWidget extends StatelessWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    this.onGoogleLogin,
    this.onAppleLogin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider with "OU" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OU',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social login buttons
        Column(
          children: [
            // Google login button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                  onGoogleLogin?.call();
                  _showComingSoonMessage(context, 'Google');
                },
                icon: CustomImageWidget(
                  imageUrl:
                  'https://developers.google.com/identity/images/g-logo.png',
                  width: 5.w,
                  height: 5.w,
                  fit: BoxFit.contain,
                  semanticLabel: 'Google logo icon for social authentication',
                ),
                label: Text(
                  'Continuer avec Google',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.onSurface,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Apple login button (iOS style)
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                  onAppleLogin?.call();
                  _showComingSoonMessage(context, 'Apple');
                },
                icon: CustomIconWidget(
                  iconName: 'apple',
                  color: theme.colorScheme.onSurface,
                  size: 5.w,
                ),
                label: Text(
                  'Continuer avec Apple',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showComingSoonMessage(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connexion $provider bientôt disponible'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
