import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Comprehensive filter bottom sheet for establishments
class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context, colorScheme),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstitutionTypeFilter(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildLocationFilter(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildProgramsFilter(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildAccreditationFilter(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildLanguageFilter(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildRatingFilter(context, colorScheme),
                  SizedBox(height: 10.h), // Bottom padding for buttons
                ],
              ),
            ),
          ),
          // Action buttons
          _buildActionButtons(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          // Title and close button
          Row(
            children: [
              Text(
                'Filtres',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionTypeFilter(
      BuildContext context, ColorScheme colorScheme) {
    final List<String> types = [
      'Université',
      'Institut',
      'École',
      'Centre de formation',
      'École supérieure',
    ];

    return _buildFilterSection(
      context,
      title: 'Type d\'établissement',
      icon: 'school',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: types
            .map((type) => _buildFilterChip(
          context,
          label: type,
          isSelected:
          (_filters["institutionTypes"] as List<String>? ?? [])
              .contains(type),
          onTap: () => _toggleListFilter("institutionTypes", type),
          colorScheme: colorScheme,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildLocationFilter(BuildContext context, ColorScheme colorScheme) {
    final List<String> locations = [
      'Casablanca',
      'Rabat',
      'Marrakech',
      'Fès',
      'Tanger',
      'Agadir',
      'Oujda',
      'Kenitra',
    ];

    return _buildFilterSection(
      context,
      title: 'Localisation',
      icon: 'location_on',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: locations
            .map((location) => _buildFilterChip(
          context,
          label: location,
          isSelected: (_filters["locations"] as List<String>? ?? [])
              .contains(location),
          onTap: () => _toggleListFilter("locations", location),
          colorScheme: colorScheme,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildProgramsFilter(BuildContext context, ColorScheme colorScheme) {
    final List<String> programs = [
      'Ingénierie',
      'Commerce',
      'Médecine',
      'Droit',
      'Arts',
      'Sciences',
      'Informatique',
      'Architecture',
    ];

    return _buildFilterSection(
      context,
      title: 'Programmes offerts',
      icon: 'menu_book',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: programs
            .map((program) => _buildFilterChip(
          context,
          label: program,
          isSelected: (_filters["programs"] as List<String>? ?? [])
              .contains(program),
          onTap: () => _toggleListFilter("programs", program),
          colorScheme: colorScheme,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildAccreditationFilter(
      BuildContext context, ColorScheme colorScheme) {
    final List<String> accreditations = [
      'Accrédité par l\'État',
      'Certification internationale',
      'Partenariat étranger',
      'Label qualité',
    ];

    return _buildFilterSection(
      context,
      title: 'Statut d\'accréditation',
      icon: 'verified',
      child: Column(
        children: accreditations
            .map((accreditation) => CheckboxListTile(
          title: Text(
            accreditation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          value: (_filters["accreditations"] as List<String>? ?? [])
              .contains(accreditation),
          onChanged: (value) =>
              _toggleListFilter("accreditations", accreditation),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildLanguageFilter(BuildContext context, ColorScheme colorScheme) {
    final List<String> languages = [
      'Français',
      'Arabe',
      'Anglais',
      'Bilingue',
    ];

    return _buildFilterSection(
      context,
      title: 'Langue d\'instruction',
      icon: 'language',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: languages
            .map((language) => _buildFilterChip(
          context,
          label: language,
          isSelected: (_filters["languages"] as List<String>? ?? [])
              .contains(language),
          onTap: () => _toggleListFilter("languages", language),
          colorScheme: colorScheme,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildRatingFilter(BuildContext context, ColorScheme colorScheme) {
    return _buildFilterSection(
      context,
      title: 'Note minimale',
      icon: 'star',
      child: Column(
        children: [
          Slider(
            value: (_filters["minRating"] as double? ?? 0.0),
            min: 0.0,
            max: 5.0,
            divisions: 10,
            label:
            '${(_filters["minRating"] as double? ?? 0.0).toStringAsFixed(1)} étoiles',
            onChanged: (value) {
              setState(() {
                _filters["minRating"] = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 étoile',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                '5 étoiles',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context, {
        required String title,
        required String icon,
        required Widget child,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildFilterChip(
      BuildContext context, {
        required String label,
        required bool isSelected,
        required VoidCallback onTap,
        required ColorScheme colorScheme,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color:
              isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Clear filters button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                  });
                },
                child: const Text('Effacer'),
              ),
            ),
            SizedBox(width: 4.w),
            // Apply filters button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFiltersChanged?.call(_filters);
                  Navigator.pop(context);
                },
                child: const Text('Appliquer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleListFilter(String key, String value) {
    setState(() {
      final List<String> currentList = (_filters[key] as List<String>?) ?? [];
      if (currentList.contains(value)) {
        currentList.remove(value);
      } else {
        currentList.add(value);
      }
      _filters[key] = currentList;
    });
  }
}
