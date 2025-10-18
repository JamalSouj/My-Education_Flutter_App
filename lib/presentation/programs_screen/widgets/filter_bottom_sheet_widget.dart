import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _educationalLevels = [
    'Licence',
    'Master',
    'Doctorat',
    'Diplôme'
  ];
  final List<String> _durations = ['1 an', '2 ans', '3 ans', '4 ans', '5+ ans'];
  final List<String> _languages = ['Français', 'Arabe', 'Anglais', 'Bilingue'];
  final List<String> _institutionTypes = [
    'Publique',
    'Privée',
    'Internationale'
  ];
  final List<String> _locations = [
    'Alger',
    'Oran',
    'Constantine',
    'Annaba',
    'Sétif'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    theme,
                    'Niveau d\'éducation',
                    'educationalLevel',
                    _educationalLevels,
                  ),
                  _buildFilterSection(
                    theme,
                    'Durée',
                    'duration',
                    _durations,
                  ),
                  _buildFilterSection(
                    theme,
                    'Langue d\'instruction',
                    'language',
                    _languages,
                  ),
                  _buildFilterSection(
                    theme,
                    'Type d\'établissement',
                    'institutionType',
                    _institutionTypes,
                  ),
                  _buildFilterSection(
                    theme,
                    'Localisation',
                    'location',
                    _locations,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filtres',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Effacer tout',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      ThemeData theme,
      String title,
      String filterKey,
      List<String> options,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: ExpansionTile(
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        initiallyExpanded:
        (_filters[filterKey] as List<String>?)?.isNotEmpty ?? false,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: options.map((option) {
                final isSelected =
                    (_filters[filterKey] as List<String>?)?.contains(option) ??
                        false;

                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (_filters[filterKey] == null) {
                        _filters[filterKey] = <String>[];
                      }

                      final filterList = _filters[filterKey] as List<String>;
                      if (selected) {
                        filterList.add(option);
                      } else {
                        filterList.remove(option);
                      }
                    });
                  },
                  backgroundColor: theme.colorScheme.surface,
                  selectedColor:
                  theme.colorScheme.primary.withValues(alpha: 0.2),
                  checkmarkColor: theme.colorScheme.primary,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final activeFiltersCount = _getActiveFiltersCount();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _clearAllFilters,
                child: Text('Effacer ($activeFiltersCount)'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: Text('Appliquer les filtres'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getActiveFiltersCount() {
    int count = 0;
    _filters.forEach((key, value) {
      if (value is List<String> && value.isNotEmpty) {
        count += value.length;
      }
    });
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }
}
