import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  final Set<int> _bookmarkedPrograms = <int>{};

  final List<Map<String, dynamic>> _recommendedPrograms = [
    {
      "id": 1,
      "title": "Intelligence Artificielle et Data Science",
      "institution": "Université Mohammed V",
      "image":
      "https://images.unsplash.com/photo-1472696599328-db2570cd2021",
      "semanticLabel":
      "Modern data center with servers and blue LED lights showing artificial intelligence infrastructure",
      "sector": "AIG",
      "description":
      "Programme avancé en IA et science des données avec focus sur l'apprentissage automatique",
      "duration": "2 ans",
      "level": "Master",
      "rating": 4.8,
      "studentsCount": 150
    },
    {
      "id": 2,
      "title": "Arts Numériques et Multimédia",
      "institution": "École des Arts Visuels",
      "image":
      "https://images.unsplash.com/photo-1715678077681-e4163401e7a3",
      "semanticLabel":
      "Digital artist working on tablet with stylus creating colorful digital artwork on large monitor",
      "sector": "ART",
      "description":
      "Formation complète en création numérique, animation 3D et design interactif",
      "duration": "3 ans",
      "level": "Licence",
      "rating": 4.6,
      "studentsCount": 85
    },
    {
      "id": 3,
      "title": "Agriculture Biologique et Durable",
      "institution": "Institut National d'Agriculture",
      "image":
      "https://images.unsplash.com/photo-1594633834252-18f92511bd9c",
      "semanticLabel":
      "Organic vegetable garden with fresh green lettuce and tomatoes growing in sustainable farming setup",
      "sector": "AGRI",
      "description":
      "Spécialisation en techniques agricoles durables et agriculture biologique moderne",
      "duration": "4 ans",
      "level": "Ingénieur",
      "rating": 4.7,
      "studentsCount": 120
    },
    {
      "id": 4,
      "title": "Biotechnologie Médicale",
      "institution": "Faculté de Médecine",
      "image":
      "https://images.unsplash.com/photo-1630959302878-a30de73cdbb5",
      "semanticLabel":
      "Medical laboratory with scientist in white coat examining samples under microscope with modern equipment",
      "sector": "AIG",
      "description":
      "Programme interdisciplinaire combinant biologie, technologie et médecine",
      "duration": "5 ans",
      "level": "Ingénieur",
      "rating": 4.9,
      "studentsCount": 95
    },
  ];

  void _toggleBookmark(int programId) {
    setState(() {
      if (_bookmarkedPrograms.contains(programId)) {
        _bookmarkedPrograms.remove(programId);
      } else {
        _bookmarkedPrograms.add(programId);
      }
    });
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> program) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              program["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              context,
              'share',
              'Partager',
                  () {
                Navigator.pop(context);
                // Share functionality would be implemented here
              },
            ),
            _buildQuickActionItem(
              context,
              'bookmark',
              _bookmarkedPrograms.contains(program["id"])
                  ? 'Retirer des favoris'
                  : 'Ajouter aux favoris',
                  () {
                Navigator.pop(context);
                _toggleBookmark(program["id"] as int);
              },
            ),
            _buildQuickActionItem(
              context,
              'search',
              'Programmes similaires',
                  () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/programs-screen');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
      BuildContext context, String iconName, String title, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "Recommandé pour vous",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: _recommendedPrograms.length,
          itemBuilder: (context, index) {
            final program = _recommendedPrograms[index];
            final isBookmarked = _bookmarkedPrograms.contains(program["id"]);

            return GestureDetector(
              onLongPress: () => _showQuickActions(context, program),
              child: Container(
                margin: EdgeInsets.only(bottom: 3.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.shadowColor
                          .withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: CustomImageWidget(
                            imageUrl: program["image"] as String,
                            width: double.infinity,
                            height: 20.h,
                            fit: BoxFit.cover,
                            semanticLabel: program["semanticLabel"] as String,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              program["sector"] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color:
                                AppTheme.lightTheme.colorScheme.onSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _toggleBookmark(program["id"] as int),
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomIconWidget(
                                iconName: isBookmarked
                                    ? 'bookmark'
                                    : 'bookmark_border',
                                color: isBookmarked
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'business',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  program["institution"] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            program["description"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  program["level"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color:
                                    AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                program["duration"] as String,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'star',
                                    color: AppTheme.warningLight,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    (program["rating"] as double).toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "(${program["studentsCount"]} étudiants)",
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
