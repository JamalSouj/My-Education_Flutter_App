import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickAccessItems = [
      {
        "title": "Programmes",
        "icon": "school",
        "color": AppTheme.lightTheme.colorScheme.primary,
        "route": "/programs-screen",
      },
      {
        "title": "Établissements",
        "icon": "business",
        "color": AppTheme.lightTheme.colorScheme.secondary,
        "route": "/establishments-screen",
      },
      {
        "title": "Favoris",
        "icon": "bookmark",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
        "route": "/programs-screen",
      },
      {
        "title": "Recherches",
        "icon": "history",
        "color": AppTheme.warningLight,
        "route": "/programs-screen",
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.2,
      ),
      itemCount: quickAccessItems.length,
      itemBuilder: (context, index) {
        final item = quickAccessItems[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, item["route"] as String);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                  AppTheme.lightTheme.shadowColor.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: (item["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: item["icon"] as String,
                      color: item["color"] as Color,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  item["title"] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
