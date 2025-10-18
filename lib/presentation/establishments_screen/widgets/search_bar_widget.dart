import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Custom search bar widget with voice search capability and recent searches
class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onFilterTap;
  final List<String> recentSearches;
  final bool showRecentSearches;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Rechercher un établissement...',
    this.onChanged,
    this.onSubmitted,
    this.onVoiceSearch,
    this.onFilterTap,
    this.recentSearches = const [],
    this.showRecentSearches = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showRecentSearches = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _showRecentSearches = _focusNode.hasFocus &&
            widget.recentSearches.isNotEmpty &&
            _controller.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search icon
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 2.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
              // Search input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    setState(() {
                      _showRecentSearches = _focusNode.hasFocus &&
                          widget.recentSearches.isNotEmpty &&
                          value.isEmpty;
                    });
                  },
                  onSubmitted: widget.onSubmitted,
                ),
              ),
              // Clear button
              if (_controller.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                    setState(() {
                      _showRecentSearches = _focusNode.hasFocus &&
                          widget.recentSearches.isNotEmpty;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
              // Voice search button
              if (widget.onVoiceSearch != null)
                IconButton(
                  onPressed: widget.onVoiceSearch,
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
              // Filter button
              if (widget.onFilterTap != null)
                Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: IconButton(
                    onPressed: widget.onFilterTap,
                    icon: CustomIconWidget(
                      iconName: 'tune',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Recent searches dropdown
        if (_showRecentSearches) _buildRecentSearches(context, colorScheme),
      ],
    );
  }

  Widget _buildRecentSearches(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Recherches récentes',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ...widget.recentSearches
              .take(5)
              .map((search) =>
              _buildRecentSearchItem(context, search, colorScheme))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(
      BuildContext context,
      String search,
      ColorScheme colorScheme,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.text = search;
          widget.onChanged?.call(search);
          widget.onSubmitted?.call(search);
          _focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              SizedBox(width: 6.w), // Align with header icon
              Expanded(
                child: Text(
                  search,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomIconWidget(
                iconName: 'north_west',
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
