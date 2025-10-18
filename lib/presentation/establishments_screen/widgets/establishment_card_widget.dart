import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual establishment card widget displaying institution information
/// with interactive elements for favorites, ratings, and navigation
class EstablishmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> establishment;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  const EstablishmentCardWidget({
    super.key,
    required this.establishment,
    this.onTap,
    this.onBookmark,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showQuickActions(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, colorScheme),
                SizedBox(height: 2.h),
                _buildContent(context, theme),
                SizedBox(height: 2.h),
                _buildFooter(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Institution logo
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: establishment["logo"] as String? ?? "",
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
              semanticLabel: establishment["logoSemanticLabel"] as String? ??
                  "Institution logo",
            ),
          ),
        ),
        SizedBox(width: 3.w),
        // Institution name and type
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                establishment["name"] as String? ?? "",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  establishment["type"] as String? ?? "",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bookmark button
        IconButton(
          onPressed: onBookmark,
          icon: CustomIconWidget(
            iconName: (establishment["isBookmarked"] as bool? ?? false)
                ? 'bookmark'
                : 'bookmark_border',
            color: (establishment["isBookmarked"] as bool? ?? false)
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          constraints: BoxConstraints(
            minWidth: 8.w,
            minHeight: 8.w,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                establishment["location"] as String? ?? "",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        // Student count
        Row(
          children: [
            CustomIconWidget(
              iconName: 'people',
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              "${establishment["studentCount"] ?? 0} étudiants",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Rating
        Row(
          children: [
            CustomIconWidget(
              iconName: 'star',
              color: Colors.amber,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              "${establishment["rating"] ?? 0.0}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              "(${establishment["reviewCount"] ?? 0})",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const Spacer(),
        // Quick action buttons
        Row(
          children: [
            _buildActionButton(
              context,
              icon: 'phone',
              onTap: () => _callEstablishment(context),
            ),
            SizedBox(width: 2.w),
            _buildActionButton(
              context,
              icon: 'directions',
              onTap: () => _getDirections(context),
            ),
            SizedBox(width: 2.w),
            _buildActionButton(
              context,
              icon: 'share',
              onTap: onShare,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required String icon,
        required VoidCallback? onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(1.5.w),
          child: CustomIconWidget(
            iconName: icon,
            color: colorScheme.primary,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              establishment["name"] as String? ?? "",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              context,
              icon: 'share',
              title: 'Partager l\'établissement',
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'school',
              title: 'Voir les programmes',
              onTap: () {
                Navigator.pop(context);
                _viewPrograms(context);
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'directions',
              title: 'Obtenir l\'itinéraire',
              onTap: () {
                Navigator.pop(context);
                _getDirections(context);
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'phone',
              title: 'Appeler',
              onTap: () {
                Navigator.pop(context);
                _callEstablishment(context);
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'email',
              title: 'Envoyer un email',
              onTap: () {
                Navigator.pop(context);
                _emailEstablishment(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
      BuildContext context, {
        required String icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _callEstablishment(BuildContext context) {
    // Implementation for calling establishment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction d\'appel à implémenter')),
    );
  }

  void _getDirections(BuildContext context) {
    // Implementation for getting directions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction d\'itinéraire à implémenter')),
    );
  }

  void _viewPrograms(BuildContext context) {
    // Navigate to programs screen with establishment filter
    Navigator.pushNamed(context, '/programs-screen');
  }

  void _emailEstablishment(BuildContext context) {
    // Implementation for emailing establishment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction d\'email à implémenter')),
    );
  }
}
