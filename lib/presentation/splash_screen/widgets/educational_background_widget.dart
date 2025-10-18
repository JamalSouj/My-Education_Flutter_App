import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

/// Educational background widget with professional gradient and geometric patterns
class EducationalBackgroundWidget extends StatefulWidget {
  const EducationalBackgroundWidget({super.key});

  @override
  State<EducationalBackgroundWidget> createState() =>
      _EducationalBackgroundWidgetState();
}

class _EducationalBackgroundWidgetState
    extends State<EducationalBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeBackgroundAnimation();
  }

  void _initializeBackgroundAnimation() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.colorScheme.primaryContainer,
            AppTheme.lightTheme.colorScheme.surface,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Floating geometric shapes
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 15.h + (_floatingAnimation.value * 5.h),
                right: 10.w,
                child: Transform.rotate(
                  angle: _floatingAnimation.value * 0.5,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'menu_book',
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.3),
                      size: 8.w,
                    ),
                  ),
                ),
              );
            },
          ),
          // Second floating element
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 20.h + (_floatingAnimation.value * -3.h),
                left: 8.w,
                child: Transform.rotate(
                  angle: -_floatingAnimation.value * 0.3,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.4),
                      size: 6.w,
                    ),
                  ),
                ),
              );
            },
          ),
          // Third floating element
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 35.h + (_floatingAnimation.value * 2.h),
                left: 15.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
          // Overlay gradient for better content visibility
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
