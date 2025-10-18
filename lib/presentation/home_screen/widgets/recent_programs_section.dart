import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RecentProgramsSection extends StatelessWidget {
  const RecentProgramsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentPrograms = [
      {
        "id": 1,
        "title": "Génie Informatique",
        "institution": "ENSIAS Rabat",
        "image":
        "https://images.unsplash.com/photo-1597239451127-914cc6d50a1d",
        "semanticLabel":
        "Modern computer science classroom with students working on laptops and large monitors displaying code",
        "sector": "AIG",
        "duration": "5 ans",
        "level": "Ingénieur"
      },
      {
        "id": 2,
        "title": "Design Graphique",
        "institution": "École Supérieure d'Art",
        "image":
        "https://images.unsplash.com/photo-1561070791-2526d30994b5",
        "semanticLabel":
        "Creative design workspace with graphic tablet, color swatches, and design sketches on wooden desk",
        "sector": "ART",
        "duration": "3 ans",
        "level": "Licence"
      },
      {
        "id": 3,
        "title": "Agronomie",
        "institution": "IAV Hassan II",
        "image":
        "https://images.unsplash.com/photo-1681208759396-94058908d796",
        "semanticLabel":
        "Golden wheat field under bright sunlight with agricultural research equipment in the background",
        "sector": "AGRI",
        "duration": "5 ans",
        "level": "Ingénieur"
      },
      {
        "id": 4,
        "title": "Architecture",
        "institution": "ENA Rabat",
        "image":
        "https://images.unsplash.com/photo-1603901622056-0a5bee231395",
        "semanticLabel":
        "Architectural blueprints and drafting tools spread on white table with modern building model",
        "sector": "ART",
        "duration": "6 ans",
        "level": "Architecte"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Programmes Récents",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/programs-screen');
                },
                child: Text(
                  "Voir tout",
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: recentPrograms.length,
            itemBuilder: (context, index) {
              final program = recentPrograms[index];
              return Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 4.w),
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
                            height: 16.h,
                            fit: BoxFit.cover,
                            semanticLabel: program["semanticLabel"] as String,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
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
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
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
                            SizedBox(height: 0.5.h),
                            Text(
                              program["institution"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  program["duration"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    program["level"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
