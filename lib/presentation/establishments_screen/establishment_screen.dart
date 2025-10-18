import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/establishment_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_options_widget.dart';

/// Establishments screen providing searchable directory of educational institutions
/// with comprehensive filtering, sorting, and navigation capabilities
class EstablishmentsScreen extends StatefulWidget {
  const EstablishmentsScreen({super.key});

  @override
  State<EstablishmentsScreen> createState() => _EstablishmentsScreenState();
}

class _EstablishmentsScreenState extends State<EstablishmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State variables
  String _searchQuery = '';
  String _selectedSort = 'alphabetical';
  List<String> _selectedFilters = [];
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _isMapView = false;
  int _currentBottomNavIndex = 2; // Establishments tab active

  // Mock data
  final List<String> _recentSearches = [
    'Université Mohammed V',
    'ENSA Casablanca',
    'HEC Marrakech',
    'École Polytechnique',
  ];

  final List<Map<String, dynamic>> _locationFilters = [
    {"key": "casablanca", "label": "Casablanca", "count": 45},
    {"key": "rabat", "label": "Rabat", "count": 38},
    {"key": "marrakech", "label": "Marrakech", "count": 22},
    {"key": "fes", "label": "Fès", "count": 18},
    {"key": "tanger", "label": "Tanger", "count": 15},
  ];

  final List<Map<String, dynamic>> _mockEstablishments = [
    {
      "id": 1,
      "name": "Université Mohammed V - Agdal",
      "type": "Université",
      "location": "Rabat, Maroc",
      "studentCount": 85000,
      "rating": 4.2,
      "reviewCount": 1250,
      "logo":
      "https://images.unsplash.com/photo-1650415033070-72ea0fa47656",
      "logoSemanticLabel":
      "Modern university campus building with glass facade and students walking in courtyard",
      "isBookmarked": false,
      "programs": ["Ingénierie", "Médecine", "Droit", "Sciences"],
      "accreditation": "Accrédité par l'État",
      "language": "Français",
    },
    {
      "id": 2,
      "name": "École Nationale Supérieure d'Arts et Métiers",
      "type": "École",
      "location": "Casablanca, Maroc",
      "studentCount": 3500,
      "rating": 4.5,
      "reviewCount": 890,
      "logo":
      "https://images.unsplash.com/photo-1730023571578-b6ac17a314fb",
      "logoSemanticLabel":
      "Engineering school building with modern architecture and technical equipment visible through windows",
      "isBookmarked": true,
      "programs": ["Ingénierie", "Architecture"],
      "accreditation": "Certification internationale",
      "language": "Français",
    },
    {
      "id": 3,
      "name": "HEC Marrakech Business School",
      "type": "École supérieure",
      "location": "Marrakech, Maroc",
      "studentCount": 2800,
      "rating": 4.3,
      "reviewCount": 567,
      "logo":
      "https://images.unsplash.com/photo-1659275136863-6f27b069e1f7",
      "logoSemanticLabel":
      "Business school campus with modern glass buildings and students in business attire walking between classes",
      "isBookmarked": false,
      "programs": ["Commerce", "Management"],
      "accreditation": "Partenariat étranger",
      "language": "Bilingue",
    },
    {
      "id": 4,
      "name": "Institut National des Postes et Télécommunications",
      "type": "Institut",
      "location": "Rabat, Maroc",
      "studentCount": 1200,
      "rating": 4.1,
      "reviewCount": 345,
      "logo":
      "https://images.unsplash.com/photo-1509488604473-049e638697ab",
      "logoSemanticLabel":
      "Technology institute building with satellite dishes and telecommunications equipment on rooftop",
      "isBookmarked": false,
      "programs": ["Informatique", "Télécommunications"],
      "accreditation": "Accrédité par l'État",
      "language": "Français",
    },
    {
      "id": 5,
      "name": "École Supérieure de Technologie",
      "type": "École",
      "location": "Fès, Maroc",
      "studentCount": 4200,
      "rating": 3.9,
      "reviewCount": 678,
      "logo":
      "https://images.unsplash.com/photo-1624490678659-ac05bc90ef41",
      "logoSemanticLabel":
      "Technology school campus with laboratory buildings and students working on technical projects outdoors",
      "isBookmarked": true,
      "programs": ["Informatique", "Ingénierie"],
      "accreditation": "Label qualité",
      "language": "Français",
    },
    {
      "id": 6,
      "name": "Université Al Akhawayn",
      "type": "Université",
      "location": "Ifrane, Maroc",
      "studentCount": 2100,
      "rating": 4.6,
      "reviewCount": 423,
      "logo":
      "https://images.unsplash.com/photo-1613413640479-4843899b4716",
      "logoSemanticLabel":
      "Private university campus with Mediterranean architecture surrounded by mountains and green landscapes",
      "isBookmarked": false,
      "programs": ["Commerce", "Informatique", "Sciences"],
      "accreditation": "Certification internationale",
      "language": "Anglais",
    },
  ];

  List<Map<String, dynamic>> _filteredEstablishments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _filteredEstablishments = List.from(_mockEstablishments);
    _setupScrollListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Hide keyboard when scrolling
      if (_scrollController.position.userScrollDirection.index > 0) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      body: Column(
        children: [
          // Tab bar
          _buildTabBar(context, colorScheme),
          // Content
          Expanded(
            child:
            _isMapView ? _buildMapView(context) : _buildListView(context),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Établissements',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        // Map/List toggle
        IconButton(
          onPressed: () {
            setState(() {
              _isMapView = !_isMapView;
            });
          },
          icon: CustomIconWidget(
            iconName: _isMapView ? 'list' : 'map',
            color: colorScheme.primary,
            size: 24,
          ),
          tooltip: _isMapView ? 'Vue liste' : 'Vue carte',
        ),
        // Sort button
        IconButton(
          onPressed: _showSortOptions,
          icon: CustomIconWidget(
            iconName: 'sort',
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
          tooltip: 'Trier',
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Accueil'),
          Tab(text: 'Programmes'),
          Tab(text: 'Établissements'),
        ],
        onTap: (index) {
          if (index != 2) {
            // Navigate to other screens
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home-screen');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/programs-screen');
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshEstablishments,
      child: Column(
        children: [
          // Search bar
          SearchBarWidget(
            hintText: 'Rechercher un établissement...',
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            onVoiceSearch: _onVoiceSearch,
            onFilterTap: _showFilterBottomSheet,
            recentSearches: _recentSearches,
            showRecentSearches: _searchQuery.isEmpty,
          ),

          // Filter chips
          if (_selectedFilters.isNotEmpty)
            FilterChipsWidget(
              filters: _locationFilters,
              selectedFilters: _selectedFilters,
              onFilterSelected: _onFilterSelected,
              onClearAll: _clearAllFilters,
            ),

          // Results count
          if (_filteredEstablishments.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredEstablishments.length} établissement${_filteredEstablishments.length > 1 ? 's' : ''} trouvé${_filteredEstablishments.length > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),

          // Establishments list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEstablishments.isEmpty
                ? EmptyStateWidget(
              title: _searchQuery.isNotEmpty
                  ? 'Aucun établissement trouvé'
                  : 'Aucun établissement disponible',
              subtitle: _searchQuery.isNotEmpty
                  ? 'Essayez de modifier vos critères de recherche ou explorez tous les établissements.'
                  : 'Les établissements seront bientôt disponibles.',
              actionText: _searchQuery.isNotEmpty
                  ? 'Parcourir tous les établissements'
                  : null,
              onActionTap:
              _searchQuery.isNotEmpty ? _clearSearch : null,
              illustrationUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
            )
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 2.h),
              itemCount: _filteredEstablishments.length,
              itemBuilder: (context, index) {
                final establishment = _filteredEstablishments[index];
                return EstablishmentCardWidget(
                  establishment: establishment,
                  onTap: () => _onEstablishmentTap(establishment),
                  onBookmark: () => _onBookmarkTap(establishment),
                  onShare: () => _onShareTap(establishment),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'map',
              color: colorScheme.primary.withValues(alpha: 0.6),
              size: 80,
            ),
            SizedBox(height: 2.h),
            Text(
              'Vue carte',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'La vue carte sera bientôt disponible',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        if (index != _currentBottomNavIndex) {
          setState(() {
            _currentBottomNavIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-screen');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/programs-screen');
              break;
            case 2:
            // Current screen - do nothing
              break;
          }
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home_outlined',
            color: _currentBottomNavIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'home',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'school_outlined',
            color: _currentBottomNavIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'school',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Programmes',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'business_outlined',
            color: _currentBottomNavIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'business',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          label: 'Établissements',
        ),
      ],
    );
  }

  // Event handlers
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterEstablishments();
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
    FocusScope.of(context).unfocus();
  }

  void _onVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recherche vocale à implémenter')),
    );
  }

  void _onFilterSelected(String filterKey) {
    setState(() {
      if (_selectedFilters.contains(filterKey)) {
        _selectedFilters.remove(filterKey);
      } else {
        _selectedFilters.add(filterKey);
      }
    });
    _filterEstablishments();
  }

  void _clearAllFilters() {
    setState(() {
      _selectedFilters.clear();
      _activeFilters.clear();
    });
    _filterEstablishments();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
    _filterEstablishments();
  }

  void _onEstablishmentTap(Map<String, dynamic> establishment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture de ${establishment["name"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBookmarkTap(Map<String, dynamic> establishment) {
    setState(() {
      establishment["isBookmarked"] =
      !(establishment["isBookmarked"] as bool? ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          (establishment["isBookmarked"] as bool? ?? false)
              ? 'Ajouté aux favoris'
              : 'Retiré des favoris',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onShareTap(Map<String, dynamic> establishment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage de ${establishment["name"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SortOptionsWidget(
        selectedSort: _selectedSort,
        onSortChanged: (sortKey) {
          setState(() {
            _selectedSort = sortKey;
          });
          _sortEstablishments();
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _filterEstablishments();
        },
      ),
    );
  }

  Future<void> _refreshEstablishments() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredEstablishments = List.from(_mockEstablishments);
    });

    _filterEstablishments();
  }

  void _filterEstablishments() {
    List<Map<String, dynamic>> filtered = List.from(_mockEstablishments);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((establishment) {
        final name = (establishment["name"] as String? ?? "").toLowerCase();
        final type = (establishment["type"] as String? ?? "").toLowerCase();
        final location =
        (establishment["location"] as String? ?? "").toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            type.contains(query) ||
            location.contains(query);
      }).toList();
    }

    // Apply location filters
    if (_selectedFilters.isNotEmpty) {
      filtered = filtered.where((establishment) {
        final location =
        (establishment["location"] as String? ?? "").toLowerCase();
        return _selectedFilters
            .any((filter) => location.contains(filter.toLowerCase()));
      }).toList();
    }

    // Apply advanced filters
    if (_activeFilters.isNotEmpty) {
      // Institution type filter
      if (_activeFilters["institutionTypes"] != null &&
          (_activeFilters["institutionTypes"] as List).isNotEmpty) {
        filtered = filtered.where((establishment) {
          final type = establishment["type"] as String? ?? "";
          return (_activeFilters["institutionTypes"] as List).contains(type);
        }).toList();
      }

      // Rating filter
      if (_activeFilters["minRating"] != null) {
        final minRating = _activeFilters["minRating"] as double;
        filtered = filtered.where((establishment) {
          final rating = establishment["rating"] as double? ?? 0.0;
          return rating >= minRating;
        }).toList();
      }
    }

    setState(() {
      _filteredEstablishments = filtered;
    });

    _sortEstablishments();
  }

  void _sortEstablishments() {
    switch (_selectedSort) {
      case 'alphabetical':
        _filteredEstablishments.sort((a, b) =>
            (a["name"] as String? ?? "").compareTo(b["name"] as String? ?? ""));
        break;
      case 'rating':
        _filteredEstablishments.sort((a, b) => (b["rating"] as double? ?? 0.0)
            .compareTo(a["rating"] as double? ?? 0.0));
        break;
      case 'student_count':
        _filteredEstablishments.sort((a, b) => (b["studentCount"] as int? ?? 0)
            .compareTo(a["studentCount"] as int? ?? 0));
        break;
      case 'distance':
      // For now, keep original order (distance sorting would require location data)
        break;
    }

    setState(() {});
  }
}
