import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FeaturedContentCarousel extends StatefulWidget {
  const FeaturedContentCarousel({super.key});

  @override
  State<FeaturedContentCarousel> createState() =>
      _FeaturedContentCarouselState();
}

class _FeaturedContentCarouselState extends State<FeaturedContentCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _featuredContent = [
    {
      "id": 1,
      "title": "Programmes d'Ingénierie 2024",
      "description":
      "Découvrez les derniers programmes d'ingénierie disponibles",
      "image":
      "https://images.unsplash.com/photo-1682663947104-aafbaaa719f3",
      "semanticLabel":
      "Modern engineering laboratory with computers and technical equipment on white desks",
      "sector": "AIG",
      "institution": "École Polytechnique"
    },
    {
      "id": 2,
      "title": "Arts et Design Créatif",
      "description":
      "Explorez votre créativité avec nos programmes artistiques",
      "image":
      "https://images.unsplash.com/photo-1717416700182-56f263f333ab",
      "semanticLabel":
      "Artist's workspace with colorful paint brushes, palette, and canvas in natural lighting",
      "sector": "ART",
      "institution": "École des Beaux-Arts"
    },
    {
      "id": 3,
      "title": "Agriculture Moderne",
      "description": "Technologies agricoles et développement durable",
      "image":
      "https://images.unsplash.com/photo-1501536689435-45c1e0bf5d92",
      "semanticLabel":
      "Green agricultural field with modern farming equipment under blue sky with mountains in background",
      "sector": "AGRI",
      "institution": "Institut Agronomique"
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _featuredContent.length,
            itemBuilder: (context, index) {
              final content = _featuredContent[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.shadowColor
                          .withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomImageWidget(
                        imageUrl: content["image"] as String,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        semanticLabel: content["semanticLabel"] as String,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            content["sector"] as String,
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
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content["title"] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              content["description"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              content["institution"] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
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
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _featuredContent.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: _currentPage == index ? 8.w : 2.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
