import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with progress percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                      AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getProgressColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: _getProgressColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.dividerLight,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(_getProgressColor()),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getProgressText(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  Text(
                    'Complet',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress steps
          _buildProgressSteps(),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    final steps = [
      {'label': 'Informations personnelles', 'completed': progress >= 0.2},
      {'label': 'Adresse e-mail', 'completed': progress >= 0.4},
      {'label': 'Mot de passe sécurisé', 'completed': progress >= 0.6},
      {'label': 'Niveau d\'éducation', 'completed': progress >= 0.8},
      {'label': 'Conditions d\'utilisation', 'completed': progress >= 1.0},
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = step['completed'] as bool;
        final isLast = index == steps.length - 1;

        return Row(
          children: [
            // Step indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color:
                isCompleted ? _getProgressColor() : AppTheme.dividerLight,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 12,
              )
                  : Container(),
            ),

            SizedBox(width: 3.w),

            // Step label
            Expanded(
              child: Text(
                step['label'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isCompleted
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textSecondaryLight,
                  fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),

            // Vertical line (except for last item)
            if (!isLast)
              Container(
                margin: EdgeInsets.only(left: 10, top: 1.h),
                width: 2,
                height: 2.h,
                color: isCompleted
                    ? _getProgressColor().withValues(alpha: 0.3)
                    : AppTheme.dividerLight,
              ),
          ],
        );
      }).toList(),
    );
  }

  Color _getProgressColor() {
    if (progress < 0.3) return AppTheme.errorLight;
    if (progress < 0.6) return AppTheme.warningLight;
    if (progress < 0.9) return AppTheme.secondaryLight;
    return AppTheme.successLight;
  }

  String _getProgressText() {
    if (progress < 0.2) return 'Commencé';
    if (progress < 0.5) return 'En cours';
    if (progress < 0.8) return 'Presque fini';
    if (progress < 1.0) return 'Finalisation';
    return 'Terminé';
  }
}
