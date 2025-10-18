import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Filter chips widget for location and category filtering
class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
  final List<String> selectedFilters;
  final ValueChanged<String>? onFilterSelected;
  final VoidCallback? onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.filters,
    required this.selectedFilters,
    this.onFilterSelected,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (filters.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with clear all button
          if (selectedFilters.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  Text(
                    'Filtres actifs',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onClearAll,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Tout effacer',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Filter chips
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: filters
                .map((filter) => _buildFilterChip(
              context,
              filter,
              colorScheme,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context,
      Map<String, dynamic> filter,
      ColorScheme colorScheme,
      ) {
    final String filterKey = filter["key"] as String? ?? "";
    final String filterLabel = filter["label"] as String? ?? "";
    final int filterCount = filter["count"] as int? ?? 0;
    final bool isSelected = selectedFilters.contains(filterKey);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onFilterSelected?.call(filterKey),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter icon (if selected)
              if (isSelected) ...[
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
              ],
              // Filter label
              Text(
                filterLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              // Filter count
              if (filterCount > 0) ...[
                SizedBox(width: 1.w),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    filterCount.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
