import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _currentLanguage = 'french';
  bool _isLoading = false;
  bool _showSuccessMessage = false;
  int _resendCountdown = 0;

  Map<String, dynamic> _formData = {
    'fullName': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
    'educationLevel': null,
    'acceptTerms': false,
    'isValid': false,
  };

  // Mock user data for demonstration
  final List<Map<String, String>> _existingUsers = [
    {'email': 'test@example.com', 'name': 'Test User'},
    {'email': 'admin@myway.edu', 'name': 'Admin User'},
    {'email': 'student@university.fr', 'name': 'Student User'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _playEntryAnimation();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _playEntryAnimation() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onFormChanged(Map<String, dynamic> formData) {
    setState(() {
      _formData = formData;
    });
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _currentLanguage = language;
    });

    // Haptic feedback for language change
    HapticFeedback.selectionClick();

    // Update text direction based on language
    if (language == 'arabic') {
      // In a real app, you would update the app's locale and text direction
      // For now, we'll just show a visual indication
    }
  }

  double _calculateProgress() {
    double progress = 0.0;

    if (_formData['fullName']?.isNotEmpty == true) progress += 0.2;
    if (_formData['email']?.isNotEmpty == true &&
        _isValidEmail(_formData['email'])) progress += 0.2;
    if (_formData['password']?.isNotEmpty == true &&
        _isPasswordStrong(_formData['password'])) progress += 0.2;
    if (_formData['confirmPassword'] == _formData['password'] &&
        _formData['password']?.isNotEmpty == true) progress += 0.2;
    if (_formData['educationLevel'] != null) progress += 0.1;
    if (_formData['acceptTerms'] == true) progress += 0.1;

    return progress;
  }

  bool _isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isPasswordStrong(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Future<void> _handleRegistration() async {
    if (!_formData['isValid']) return;

    setState(() {
      _isLoading = true;
    });

    // Haptic feedback for button press
    HapticFeedback.mediumImpact();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email already exists
      final emailExists = _existingUsers.any(
            (user) =>
        user['email']?.toLowerCase() == _formData['email']?.toLowerCase(),
      );

      if (emailExists) {
        _showErrorDialog(
          'Adresse e-mail déjà utilisée',
          'Cette adresse e-mail est déjà associée à un compte. Veuillez utiliser une autre adresse ou vous connecter.',
        );
        return;
      }

      // Simulate successful registration
      setState(() {
        _showSuccessMessage = true;
      });

      _startResendCountdown();

      // Success haptic feedback
      HapticFeedback.lightImpact();
    } catch (e) {
      _showErrorDialog(
        'Erreur de création de compte',
        'Une erreur s\'est produite lors de la création de votre compte. Veuillez réessayer.',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.errorLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Compris',
              style: TextStyle(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_formData['fullName']?.isNotEmpty == true ||
        _formData['email']?.isNotEmpty == true ||
        _formData['password']?.isNotEmpty == true) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Quitter l\'inscription ?',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Vos informations saisies seront perdues. Êtes-vous sûr de vouloir quitter ?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Quitter',
                style: TextStyle(
                  color: AppTheme.errorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      return shouldPop ?? false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _showSuccessMessage
                  ? _buildSuccessView()
                  : _buildRegistrationView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationView() {
    return Column(
      children: [
        // Header with back button and language toggle
        _buildHeader(),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Progress indicator
                ProgressIndicatorWidget(
                  progress: _calculateProgress(),
                  title: 'Créer votre compte',
                  subtitle: 'Complétez les informations ci-dessous',
                ),

                SizedBox(height: 4.h),

                // Registration form
                RegistrationFormWidget(
                  onFormChanged: _onFormChanged,
                  onSubmit: _handleRegistration,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 4.h),

                // Login link
                _buildLoginLink(),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: AppTheme.textPrimaryLight,
              size: 20,
            ),
            tooltip: 'Retour',
          ),

          // Title
          Expanded(
            child: Text(
              'Inscription',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Language toggle
          LanguageToggleWidget(
            currentLanguage: _currentLanguage,
            onLanguageChanged: _onLanguageChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/login-screen'),
        child: RichText(
          text: TextSpan(
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            children: [
              const TextSpan(text: 'Vous avez déjà un compte ? '),
              TextSpan(
                text: 'Se connecter',
                style: TextStyle(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 60,
            ),
          ),

          SizedBox(height: 4.h),

          // Success title
          Text(
            'Compte créé avec succès !',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Success message
          Text(
            'Un e-mail de vérification a été envoyé à ${_formData['email']}. Veuillez vérifier votre boîte de réception et cliquer sur le lien pour activer votre compte.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Resend button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton(
              onPressed: _resendCountdown > 0
                  ? null
                  : () {
                _startResendCountdown();
                HapticFeedback.selectionClick();
              },
              child: Text(
                _resendCountdown > 0
                    ? 'Renvoyer dans ${_resendCountdown}s'
                    : 'Renvoyer l\'e-mail',
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login-screen'),
              child: const Text('Continuer vers la connexion'),
            ),
          ),
        ],
      ),
    );
  }
}