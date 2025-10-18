import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/featured_content_carousel.dart';
import './widgets/home_header.dart';
import './widgets/quick_access_grid.dart';
import './widgets/recent_programs_section.dart';
import './widgets/recommended_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchPressed() {
    Navigator.pushNamed(context, '/programs-screen');
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: HomeHeader(),
          ),

          // Main content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),

                // Featured Content Carousel
                const FeaturedContentCarousel(),

                SizedBox(height: 4.h),

                // Quick Access Grid
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accès Rapide",
                        style:
                        AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      const QuickAccessGrid(),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Recent Programs Section
                const RecentProgramsSection(),

                SizedBox(height: 4.h),

                // Recommended Section
                const RecommendedSection(),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _isRefreshing
          ? Stack(
        children: [
          // Main content (dimmed)
          Opacity(
            opacity: 0.5,
            child: _buildMainContent(),
          ),

          // Loading indicator
          Center(
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.shadowColor
                        .withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Mise à jour en cours...",
                    style: AppTheme.lightTheme.textTheme.bodyMedium
                        ?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : _buildMainContent(),

      // Floating Action Button for Search
      floatingActionButton: FloatingActionButton(
        onPressed: _onSearchPressed,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
        elevation: 4,
        child: CustomIconWidget(
          iconName: 'search',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 24,
        ),
      ),
    );
  }
}
