import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget implementing Contemporary Academic Minimalism
/// with contextual actions and bilingual support for educational applications.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title widget to display in the app bar
  final Widget? title;

  /// The title text to display (alternative to title widget)
  final String? titleText;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// List of action widgets
  final List<Widget>? actions;

  /// Whether to show the back button automatically
  final bool automaticallyImplyLeading;

  /// Background color of the app bar
  final Color? backgroundColor;

  /// Foreground color for text and icons
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether to show a bottom border
  final bool showBottomBorder;

  /// App bar variant type
  final CustomAppBarVariant variant;

  /// Whether the app bar is pinned (for slivers)
  final bool pinned;

  /// Custom height for the app bar
  final double? height;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showBottomBorder = true,
    this.variant = CustomAppBarVariant.standard,
    this.pinned = false,
    this.height,
  }) : assert(title == null || titleText == null,
  'Cannot provide both title widget and titleText');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color effectiveBackgroundColor = backgroundColor ??
        (variant == CustomAppBarVariant.transparent
            ? Colors.transparent
            : colorScheme.surface);

    final Color effectiveForegroundColor =
        foregroundColor ?? colorScheme.onSurface;

    // Build title widget
    Widget? effectiveTitle;
    if (title != null) {
      effectiveTitle = title;
    } else if (titleText != null) {
      effectiveTitle = Text(
        titleText!,
        style: theme.textTheme.titleLarge?.copyWith(
          color: effectiveForegroundColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: showBottomBorder && variant != CustomAppBarVariant.transparent
            ? Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        )
            : null,
        boxShadow: elevation > 0
            ? [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ]
            : null,
      ),
      child: AppBar(
        title: effectiveTitle,
        leading: _buildLeading(context, effectiveForegroundColor),
        actions: _buildActions(context, effectiveForegroundColor),
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        foregroundColor: effectiveForegroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle:
        _getSystemOverlayStyle(context, effectiveBackgroundColor),
        toolbarHeight: height,
        centerTitle: variant == CustomAppBarVariant.centered,
      ),
    );
  }

  /// Build leading widget with contextual navigation
  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    if (!automaticallyImplyLeading) return null;

    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    if (canPop) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: foregroundColor,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Retour',
      );
    }

    return null;
  }

  /// Build actions with consistent styling
  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: action.onPressed,
          tooltip: action.tooltip,
          color: foregroundColor,
        );
      }
      return action;
    }).toList();
  }

  /// Get system overlay style based on background color
  SystemUiOverlayStyle _getSystemOverlayStyle(
      BuildContext context, Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      brightness == Brightness.light ? Brightness.dark : Brightness.light,
      statusBarBrightness: brightness,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

/// Custom app bar variant types
enum CustomAppBarVariant {
  /// Standard app bar with surface background
  standard,

  /// Transparent app bar for overlay scenarios
  transparent,

  /// Centered title variant
  centered,

  /// Large title variant for main screens
  large,
}

/// Specialized app bar for search functionality
class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Hint text for the search field
  final String hintText;

  /// Callback when search text changes
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Initial search text
  final String? initialText;

  /// Whether to show the search field initially
  final bool autoFocus;

  /// Leading widget
  final Widget? leading;

  /// Actions to show when not searching
  final List<Widget>? actions;

  const CustomSearchAppBar({
    super.key,
    this.hintText = 'Rechercher...',
    this.onChanged,
    this.onSubmitted,
    this.initialText,
    this.autoFocus = false,
    this.leading,
    this.actions,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startSearch();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    _focusNode.requestFocus();
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
    });
    _controller.clear();
    _focusNode.unfocus();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomAppBar(
      backgroundColor: colorScheme.surface,
      showBottomBorder: true,
      title: _isSearching
          ? TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      )
          : null,
      leading: _isSearching
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _stopSearch,
      )
          : widget.leading,
      actions: _isSearching
          ? [
        if (_controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onChanged?.call('');
            },
          ),
      ]
          : [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
        if (widget.actions != null) ...widget.actions!,
      ],
    );
  }
}
