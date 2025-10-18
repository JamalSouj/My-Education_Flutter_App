import 'package:flutter/material.dart';

/// Custom bottom navigation bar widget implementing Contemporary Academic Minimalism
/// with adaptive tab persistence and contextual navigation for educational applications.
class CustomBottomBar extends StatelessWidget {
  /// The currently selected index
  final int currentIndex;

  /// Callback when a tab is selected
  final ValueChanged<int> onTap;

  /// Whether to show labels on navigation items
  final bool showLabels;

  /// Navigation bar type variant
  final CustomBottomBarType type;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
    this.type = CustomBottomBarType.fixed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Navigation items with hardcoded routes for educational app
    final List<_NavigationItem> items = [
      _NavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Accueil',
        route: '/home-screen',
      ),
      _NavigationItem(
        icon: Icons.school_outlined,
        activeIcon: Icons.school,
        label: 'Programmes',
        route: '/programs-screen',
      ),
      _NavigationItem(
        icon: Icons.business_outlined,
        activeIcon: Icons.business,
        label: 'Établissements',
        route: '/establishments-screen',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return _NavigationItemWidget(
                item: item,
                isSelected: isSelected,
                showLabel: showLabels,
                onTap: () {
                  onTap(index);
                  // Navigate to the corresponding route
                  Navigator.pushNamed(context, item.route);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Navigation item widget with gesture-enhanced feedback
class _NavigationItemWidget extends StatelessWidget {
  final _NavigationItem item;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  const _NavigationItemWidget({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color iconColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.6);

    final Color labelColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with subtle elevation change on selection
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(4),
                  decoration: isSelected
                      ? BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  )
                      : null,
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),

                // Label with progressive disclosure
                if (showLabel) ...[
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: labelColor,
                      fontWeight:
                      isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigation item data model
class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom bar type variants
enum CustomBottomBarType {
  /// Fixed type with all items always visible
  fixed,

  /// Shifting type with animated transitions
  shifting,
}
