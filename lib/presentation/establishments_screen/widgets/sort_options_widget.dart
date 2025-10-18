import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Sort options widget for establishments list
class SortOptionsWidget extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String>? onSortChanged;

  const SortOptionsWidget({
    super.key,
    required this.selectedSort,
    this.onSortChanged,
  });

  static const List<Map<String, dynamic>> sortOptions = [
    {
      "key": "alphabetical",
      "label": "Alphabétique",
      "icon": "sort_by_alpha",
    },
    {
      "key": "rating",
      "label": "Note",
      "icon": "star",
    },
    {
      "key": "student_count",
      "label": "Nombre d'étudiants",
      "icon": "people",
    },
    {
      "key": "distance",
      "label": "Distance",
      "icon": "location_on",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Title
          Text(
            'Trier par',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          // Sort options
          ...sortOptions
              .map((option) => _buildSortOption(
            context,
            option,
            colorScheme,
          ))
              .toList(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildSortOption(
      BuildContext context,
      Map<String, dynamic> option,
      ColorScheme colorScheme,
      ) {
    final String optionKey = option["key"] as String? ?? "";
    final String optionLabel = option["label"] as String? ?? "";
    final String optionIcon = option["icon"] as String? ?? "";
    final bool isSelected = selectedSort == optionKey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSortChanged?.call(optionKey);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child: Row(
            children: [
              // Option icon
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: optionIcon,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              // Option label
              Expanded(
                child: Text(
                  optionLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              // Selection indicator
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
