import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/applied_filters_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/program_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sector_chip_widget.dart';
import './widgets/sort_options_widget.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedSector = 'Tous';
  String _searchQuery = '';
  String _currentSort = 'relevance';
  Map<String, dynamic> _appliedFilters = {};
  Set<String> _bookmarkedPrograms = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  late TabController _tabController;

  // Mock data for educational programs
  final List<Map<String, dynamic>> _allPrograms = [
    {
      "id": "1",
      "title": "Licence en Informatique",
      "description":
      "Formation complète en développement logiciel, bases de données et systèmes d'information avec une approche pratique et théorique.",
      "duration": 3,
      "degreeType": "Licence",
      "sector": "TECH",
      "language": "Français",
      "institution": {
        "name": "Université des Sciences et Technologies",
        "logo":
        "https://images.unsplash.com/photo-1707464779415-8e511b9a2843",
        "logoSemanticLabel":
        "Modern university building with glass facade and contemporary architecture against blue sky"
      },
      "location": "Alger",
      "institutionType": "Publique",
      "educationalLevel": "Licence"
    },
    {
      "id": "2",
      "title": "Master en Arts Visuels",
      "description":
      "Programme avancé en création artistique contemporaine, design graphique et médias numériques avec ateliers pratiques.",
      "duration": 2,
      "degreeType": "Master",
      "sector": "ART",
      "language": "Bilingue",
      "institution": {
        "name": "École Supérieure des Beaux-Arts",
        "logo":
        "https://images.unsplash.com/photo-1728574986896-99248c170c1d",
        "logoSemanticLabel":
        "Classical art school building with ornate stone architecture and arched windows"
      },
      "location": "Oran",
      "institutionType": "Publique",
      "educationalLevel": "Master"
    },
    {
      "id": "3",
      "title": "Diplôme en Agriculture Moderne",
      "description":
      "Formation spécialisée en techniques agricoles durables, gestion des ressources et innovation technologique agricole.",
      "duration": 4,
      "degreeType": "Diplôme",
      "sector": "AGRI",
      "language": "Français",
      "institution": {
        "name": "Institut National d'Agriculture",
        "logo":
        "https://images.unsplash.com/photo-1668301980329-2aea41efeb88",
        "logoSemanticLabel":
        "Agricultural research facility with greenhouses and modern farming equipment in rural setting"
      },
      "location": "Constantine",
      "institutionType": "Publique",
      "educationalLevel": "Diplôme"
    },
    {
      "id": "4",
      "title": "Master en Intelligence Artificielle",
      "description":
      "Programme de pointe en apprentissage automatique, réseaux de neurones et applications d'IA dans l'industrie.",
      "duration": 2,
      "degreeType": "Master",
      "sector": "AIG",
      "language": "Anglais",
      "institution": {
        "name": "Centre d'Excellence Technologique",
        "logo":
        "https://images.unsplash.com/photo-1633530410483-335548086a84",
        "logoSemanticLabel":
        "Futuristic technology center with glass and steel architecture featuring LED lighting"
      },
      "location": "Alger",
      "institutionType": "Privée",
      "educationalLevel": "Master"
    },
    {
      "id": "5",
      "title": "Licence en Médecine Générale",
      "description":
      "Formation médicale complète avec stages cliniques, anatomie, physiologie et pratique médicale supervisée.",
      "duration": 6,
      "degreeType": "Licence",
      "sector": "MED",
      "language": "Français",
      "institution": {
        "name": "Faculté de Médecine d'Alger",
        "logo":
        "https://images.unsplash.com/photo-1655722931748-0a56017d39ef",
        "logoSemanticLabel":
        "Modern medical school building with white facade and red cross symbol"
      },
      "location": "Alger",
      "institutionType": "Publique",
      "educationalLevel": "Licence"
    },
    {
      "id": "6",
      "title": "Master en Économie Internationale",
      "description":
      "Analyse économique globale, commerce international et politiques économiques avec focus sur les marchés émergents.",
      "duration": 2,
      "degreeType": "Master",
      "sector": "ECO",
      "language": "Bilingue",
      "institution": {
        "name": "École de Commerce International",
        "logo":
        "https://images.unsplash.com/photo-1707109462231-ad2b9dd1597b",
        "logoSemanticLabel":
        "Contemporary business school with glass towers and corporate architecture"
      },
      "location": "Oran",
      "institutionType": "Privée",
      "educationalLevel": "Master"
    },
    {
      "id": "7",
      "title": "Doctorat en Biotechnologies",
      "description":
      "Recherche avancée en génie génétique, biologie moléculaire et applications biotechnologiques industrielles.",
      "duration": 3,
      "degreeType": "Doctorat",
      "sector": "TECH",
      "language": "Anglais",
      "institution": {
        "name": "Institut de Recherche Biotechnologique",
        "logo":
        "https://images.unsplash.com/photo-1706075683012-699360267e77",
        "logoSemanticLabel":
        "State-of-the-art research laboratory with modern equipment and sterile environment"
      },
      "location": "Annaba",
      "institutionType": "Publique",
      "educationalLevel": "Doctorat"
    },
    {
      "id": "8",
      "title": "Licence en Design Graphique",
      "description":
      "Formation créative en communication visuelle, typographie, branding et design numérique avec projets clients réels.",
      "duration": 3,
      "degreeType": "Licence",
      "sector": "ART",
      "language": "Français",
      "institution": {
        "name": "École de Design et Communication",
        "logo":
        "https://images.unsplash.com/photo-1580746988097-aebeea7b2731",
        "logoSemanticLabel":
        "Creative design studio with colorful artwork displays and modern workspace"
      },
      "location": "Sétif",
      "institutionType": "Privée",
      "educationalLevel": "Licence"
    }
  ];

  final Map<String, String> _sectorDisplayNames = {
    'Tous': 'Tous',
    'ART': 'Arts',
    'AIG': 'IA & Tech',
    'AGRI': 'Agriculture',
    'TECH': 'Technologie',
    'MED': 'Médecine',
    'ECO': 'Économie',
  };

  List<Map<String, dynamic>> _filteredPrograms = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _filteredPrograms = List.from(_allPrograms);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePrograms();
    }
  }

  Future<void> _loadMorePrograms() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _currentPage++;
      // In real app, this would load more data from API
      if (_currentPage > 3) {
        _hasMoreData = false;
      }
    });
  }

  Future<void> _refreshPrograms() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });

    // Simulate API refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredPrograms = List.from(_allPrograms);
    });

    _applyFiltersAndSearch();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSearch();
  }

  void _onSectorSelected(String sector) {
    setState(() {
      _selectedSector = sector;
    });
    _applyFiltersAndSearch();
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _appliedFilters = filters;
    });
    _applyFiltersAndSearch();
  }

  void _onRemoveFilter(String filterKey, String value) {
    setState(() {
      if (_appliedFilters[filterKey] != null) {
        (_appliedFilters[filterKey] as List<String>).remove(value);
        if ((_appliedFilters[filterKey] as List<String>).isEmpty) {
          _appliedFilters.remove(filterKey);
        }
      }
    });
    _applyFiltersAndSearch();
  }

  void _clearAllFilters() {
    setState(() {
      _appliedFilters.clear();
      _selectedSector = 'Tous';
      _searchQuery = '';
      _searchController.clear();
    });
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_allPrograms);

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((program) {
        final title = (program['title'] as String).toLowerCase();
        final description = (program['description'] as String).toLowerCase();
        final institution =
        ((program['institution'] as Map<String, dynamic>)['name'] as String)
            .toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            institution.contains(query);
      }).toList();
    }

    // Apply sector filter
    if (_selectedSector != 'Tous') {
      filtered = filtered
          .where((program) => program['sector'] == _selectedSector)
          .toList();
    }

    // Apply other filters
    _appliedFilters.forEach((filterKey, filterValues) {
      if (filterValues is List<String> && filterValues.isNotEmpty) {
        filtered = filtered.where((program) {
          final programValue = program[filterKey]?.toString() ?? '';
          return filterValues.any((value) => programValue.contains(value));
        }).toList();
      }
    });

    // Apply sorting
    _applySorting(filtered);

    setState(() {
      _filteredPrograms = filtered;
    });
  }

  void _applySorting(List<Map<String, dynamic>> programs) {
    switch (_currentSort) {
      case 'alphabetical':
        programs.sort(
                (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'duration':
        programs.sort(
                (a, b) => (a['duration'] as int).compareTo(b['duration'] as int));
        break;
      case 'recent':
      // In real app, would sort by creation date
        programs.shuffle();
        break;
      case 'relevance':
      default:
      // Keep current order for relevance
        break;
    }
  }

  void _toggleBookmark(String programId) {
    setState(() {
      if (_bookmarkedPrograms.contains(programId)) {
        _bookmarkedPrograms.remove(programId);
      } else {
        _bookmarkedPrograms.add(programId);
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _appliedFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsWidget(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  Map<String, int> _getSectorCounts() {
    final Map<String, int> counts = {};

    for (final sector in _sectorDisplayNames.keys) {
      if (sector == 'Tous') {
        counts[sector] = _allPrograms.length;
      } else {
        counts[sector] =
            _allPrograms.where((program) => program['sector'] == sector).length;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectorCounts = _getSectorCounts();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filter
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Title and sort button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Text(
                          'Programmes',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _showSortOptions,
                          icon: CustomIconWidget(
                            iconName: 'sort',
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  SearchBarWidget(
                    hintText: 'Rechercher des programmes...',
                    onChanged: _onSearchChanged,
                    onFilterTap: _showFilterBottomSheet,
                    initialValue: _searchQuery,
                  ),
                ],
              ),
            ),

            // Applied filters
            if (_appliedFilters.isNotEmpty || _selectedSector != 'Tous')
              AppliedFiltersWidget(
                appliedFilters: _appliedFilters,
                onRemoveFilter: _onRemoveFilter,
                onClearAll: _clearAllFilters,
              ),

            // Sector chips
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _sectorDisplayNames.length,
                itemBuilder: (context, index) {
                  final sector = _sectorDisplayNames.keys.elementAt(index);
                  final displayName = _sectorDisplayNames[sector]!;
                  final count = sectorCounts[sector] ?? 0;

                  return SectorChipWidget(
                    sector: sector,
                    displayName: displayName,
                    count: count,
                    isSelected: _selectedSector == sector,
                    onTap: () => _onSectorSelected(sector),
                  );
                },
              ),
            ),

            // Programs list
            Expanded(
              child: _filteredPrograms.isEmpty
                  ? EmptyStateWidget(
                title: 'Aucun programme trouvé',
                subtitle:
                'Essayez de modifier vos critères de recherche ou explorez d\'autres catégories.',
                primaryButtonText: 'Effacer les filtres',
                secondaryButtonText: 'Parcourir tous les programmes',
                onPrimaryPressed: _clearAllFilters,
                onSecondaryPressed: () {
                  _clearAllFilters();
                  _onSectorSelected('Tous');
                },
                illustrationUrl:
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              )
                  : RefreshIndicator(
                onRefresh: _refreshPrograms,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(bottom: 2.h),
                  itemCount:
                  _filteredPrograms.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _filteredPrograms.length) {
                      return Container(
                        padding: EdgeInsets.all(4.w),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final program = _filteredPrograms[index];
                    final programId = program['id'] as String;

                    return ProgramCardWidget(
                      program: program,
                      isBookmarked:
                      _bookmarkedPrograms.contains(programId),
                      onTap: () {
                        // Navigate to program details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('Ouverture de ${program['title']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      onBookmark: () => _toggleBookmark(programId),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating action button for quick actions
      floatingActionButton: FloatingActionButton(
        onPressed: _showSortOptions,
        child: CustomIconWidget(
          iconName: 'sort',
          color: theme.colorScheme.onSecondary,
          size: 24,
        ),
      ),
    );
  }
}
