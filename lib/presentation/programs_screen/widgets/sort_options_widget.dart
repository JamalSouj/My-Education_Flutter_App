import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortOptionsWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.only(bottom: 3.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Trier par',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSortOption(theme, 'relevance', 'Pertinence', 'trending_up'),
          _buildSortOption(
              theme, 'alphabetical', 'Alphabétique', 'sort_by_alpha'),
          _buildSortOption(theme, 'duration', 'Durée', 'schedule'),
          _buildSortOption(theme, 'recent', 'Récemment ajouté', 'new_releases'),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildSortOption(
      ThemeData theme, String value, String title, String iconName) {
    final isSelected = currentSort == value;

    return Builder(
      builder: (context) => ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 24,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: isSelected
            ? CustomIconWidget(
          iconName: 'check',
          color: theme.colorScheme.primary,
          size: 20,
        )
            : null,
        onTap: () {
          onSortChanged(value);
          Navigator.pop(context);
        },
      ),
    );
  }
}
