import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/educational_background_widget.dart';
import './widgets/loading_indicator_widget.dart';

/// Splash Screen providing branded app launch experience while initializing core educational services
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _loadingProgress = 0.0;
  String _loadingText = 'Initialisation...';
  bool _isInitialized = false;

  // Animation controllers for smooth transitions
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  /// Initialize core educational services and determine navigation path
  Future<void> _startInitialization() async {
    try {
      // Step 1: Check authentication status
      await _updateProgress(0.2, 'Vérification de l\'authentification...');
      final bool isAuthenticated = await _checkAuthenticationStatus();

      // Step 2: Load language preferences
      await _updateProgress(0.4, 'Chargement des préférences linguistiques...');
      final String? languageCode = await _loadLanguagePreferences();

      // Step 3: Fetch educational content cache
      await _updateProgress(0.6, 'Préparation du contenu éducatif...');
      await _fetchEducationalContentCache();

      // Step 4: Prepare RTL/LTR layout configuration
      await _updateProgress(0.8, 'Configuration de l\'interface...');
      await _prepareLayoutConfiguration(languageCode);

      // Step 5: Complete initialization
      await _updateProgress(1.0, 'Finalisation...');

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
      });

      // Navigate based on authentication status
      await _navigateToNextScreen(isAuthenticated, languageCode);
    } catch (error) {
      // Handle initialization errors gracefully
      await _handleInitializationError(error);
    }
  }

  /// Update loading progress with smooth animation
  Future<void> _updateProgress(double progress, String text) async {
    setState(() {
      _loadingProgress = progress;
      _loadingText = text;
    });

    // Simulate realistic loading time
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Check user authentication status from secure storage
  Future<bool> _checkAuthenticationStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');
      final int? tokenExpiry = prefs.getInt('token_expiry');

      if (authToken != null && tokenExpiry != null) {
        final DateTime expiryDate =
        DateTime.fromMillisecondsSinceEpoch(tokenExpiry);
        return DateTime.now().isBefore(expiryDate);
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Load user language preferences (Arabic/French)
  Future<String?> _loadLanguagePreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('language_code') ?? 'fr'; // Default to French
    } catch (e) {
      return 'fr';
    }
  }

  /// Fetch and cache educational content for offline access
  Future<void> _fetchEducationalContentCache() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Simulate fetching educational sectors data
      final List<String> educationalSectors = [
        'ART',
        'AIG',
        'AGRI',
        'TECH',
        'MED',
        'ENG',
        'BUS',
        'SCI'
      ];

      await prefs.setStringList('cached_sectors', educationalSectors);

      // Cache last update timestamp
      await prefs.setInt(
          'cache_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silent fail - app can work without cache
    }
  }

  /// Prepare RTL/LTR layout configuration based on language
  Future<void> _prepareLayoutConfiguration(String? languageCode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Set text direction based on language
      final bool isRTL = languageCode == 'ar';
      await prefs.setBool('is_rtl_layout', isRTL);

      // Configure system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    } catch (e) {
      // Use default LTR configuration
    }
  }

  /// Navigate to appropriate screen based on authentication and setup status
  Future<void> _navigateToNextScreen(
      bool isAuthenticated, String? languageCode) async {
    // Start fade out animation
    await _fadeController.forward();

    if (!mounted) return;

    try {
      if (isAuthenticated) {
        // Authenticated users go to dashboard
        Navigator.pushReplacementNamed(context, '/home-screen');
      } else {
        // Check if user has completed language selection
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool hasCompletedOnboarding =
            prefs.getBool('completed_onboarding') ?? false;

        if (hasCompletedOnboarding) {
          // Returning users go to login
          Navigator.pushReplacementNamed(context, '/login-screen');
        } else {
          // New users need onboarding (for now, redirect to login)
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      }
    } catch (e) {
      // Fallback to login screen
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  /// Handle initialization errors with user-friendly retry option
  Future<void> _handleInitializationError(dynamic error) async {
    setState(() {
      _loadingText = 'Erreur de connexion';
      _loadingProgress = 0.0;
    });

    // Wait 5 seconds then show retry option
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // Show retry dialog
    final bool? shouldRetry = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Erreur de connexion',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Impossible de charger l\'application. Vérifiez votre connexion internet et réessayez.',
            style: GoogleFonts.inter(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Quitter',
                style: GoogleFonts.inter(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Réessayer',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldRetry == true) {
      // Restart initialization
      _startInitialization();
    } else {
      // Exit app or go to offline mode
      SystemNavigator.pop();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _isInitialized ? _fadeAnimation.value : 1.0,
            child: Stack(
              children: [
                // Educational background with gradient
                const EducationalBackgroundWidget(),

                // Safe area content
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Spacer to push content to center
                        const Spacer(flex: 2),

                        // Animated logo with educational branding
                        const AnimatedLogoWidget(),

                        // Spacer between logo and loading indicator
                        const Spacer(flex: 1),

                        // Loading indicator with progress
                        LoadingIndicatorWidget(
                          progress: _loadingProgress,
                          loadingText: _loadingText,
                        ),

                        // Bottom spacer
                        const Spacer(flex: 2),

                        // Copyright and version info
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Column(
                            children: [
                              Text(
                                '© 2024 MyWay Education',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Version 1.0.0',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
