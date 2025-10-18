import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const RegistrationFormWidget({
    super.key,
    required this.onFormChanged,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  String? _selectedEducationLevel;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  // Password strength indicators
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  final List<Map<String, String>> _educationLevels = [
    {'value': 'high_school', 'label': 'Lycée'},
    {'value': 'bachelor', 'label': 'Licence'},
    {'value': 'master', 'label': 'Master'},
    {'value': 'phd', 'label': 'Doctorat'},
    {'value': 'other', 'label': 'Autre'},
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
    _fullNameController.addListener(_updateFormData);
    _emailController.addListener(_updateFormData);
    _passwordController.addListener(_updateFormData);
    _confirmPasswordController.addListener(_updateFormData);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _updateFormData() {
    final formData = {
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'confirmPassword': _confirmPasswordController.text,
      'educationLevel': _selectedEducationLevel,
      'acceptTerms': _acceptTerms,
      'isValid': _isFormValid(),
    };
    widget.onFormChanged(formData);
  }

  bool _isFormValid() {
    return _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _isValidEmail(_emailController.text) &&
        _passwordController.text.isNotEmpty &&
        _isPasswordStrong() &&
        _passwordController.text == _confirmPasswordController.text &&
        _selectedEducationLevel != null &&
        _acceptTerms;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isPasswordStrong() {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSpecialChar;
  }

  double _getPasswordStrength() {
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasUppercase) score++;
    if (_hasLowercase) score++;
    if (_hasNumber) score++;
    if (_hasSpecialChar) score++;
    return score / 5.0;
  }

  Color _getPasswordStrengthColor() {
    final strength = _getPasswordStrength();
    if (strength < 0.3) return AppTheme.lightTheme.colorScheme.error;
    if (strength < 0.6) return AppTheme.warningLight;
    if (strength < 0.8) return AppTheme.secondaryLight;
    return AppTheme.successLight;
  }

  String _getPasswordStrengthText() {
    final strength = _getPasswordStrength();
    if (strength < 0.3) return 'Faible';
    if (strength < 0.6) return 'Moyen';
    if (strength < 0.8) return 'Bon';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          _buildInputField(
            controller: _fullNameController,
            focusNode: _fullNameFocus,
            nextFocusNode: _emailFocus,
            label: 'Nom complet',
            hint: 'Entrez votre nom complet',
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le nom complet est requis';
              }
              if (value.length < 2) {
                return 'Le nom doit contenir au moins 2 caractères';
              }
              return null;
            },
          ),

          SizedBox(height: 3.h),

          // Email Field
          _buildInputField(
            controller: _emailController,
            focusNode: _emailFocus,
            nextFocusNode: _passwordFocus,
            label: 'Adresse e-mail',
            hint: 'exemple@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'L\'adresse e-mail est requise';
              }
              if (!_isValidEmail(value)) {
                return 'Veuillez entrer une adresse e-mail valide';
              }
              return null;
            },
          ),

          SizedBox(height: 3.h),

          // Password Field
          _buildPasswordField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            nextFocusNode: _confirmPasswordFocus,
            label: 'Mot de passe',
            hint: 'Créez un mot de passe sécurisé',
            obscureText: _obscurePassword,
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le mot de passe est requis';
              }
              if (!_isPasswordStrong()) {
                return 'Le mot de passe ne respecte pas tous les critères';
              }
              return null;
            },
          ),

          SizedBox(height: 2.h),

          // Password Strength Indicator
          if (_passwordController.text.isNotEmpty) ...[
            _buildPasswordStrengthIndicator(),
            SizedBox(height: 1.h),
            _buildPasswordRequirements(),
            SizedBox(height: 3.h),
          ] else
            SizedBox(height: 3.h),

          // Confirm Password Field
          _buildPasswordField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocus,
            label: 'Confirmer le mot de passe',
            hint: 'Ressaisissez votre mot de passe',
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La confirmation du mot de passe est requise';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),

          SizedBox(height: 3.h),

          // Education Level Dropdown
          _buildEducationLevelDropdown(),

          SizedBox(height: 4.h),

          // Terms and Conditions
          _buildTermsCheckbox(),

          SizedBox(height: 4.h),

          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: _getFieldIcon(keyboardType),
            errorMaxLines: 2,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: CustomIconWidget(
              iconName: 'lock_outline',
              color: AppTheme.textSecondaryLight,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: CustomIconWidget(
                iconName: obscureText ? 'visibility_off' : 'visibility',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            errorMaxLines: 2,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _getPasswordStrength();
    final color = _getPasswordStrengthColor();
    final text = _getPasswordStrengthText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Force du mot de passe: ',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: strength,
          backgroundColor: AppTheme.dividerLight,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Critères du mot de passe:',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          _buildRequirementItem('Au moins 8 caractères', _hasMinLength),
          _buildRequirementItem('Une lettre majuscule', _hasUppercase),
          _buildRequirementItem('Une lettre minuscule', _hasLowercase),
          _buildRequirementItem('Un chiffre', _hasNumber),
          _buildRequirementItem('Un caractère spécial', _hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
            color: isMet ? AppTheme.successLight : AppTheme.textDisabledLight,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isMet
                    ? AppTheme.textPrimaryLight
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Niveau d\'éducation',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _selectedEducationLevel,
          decoration: InputDecoration(
            hintText: 'Sélectionnez votre niveau',
            prefixIcon: CustomIconWidget(
              iconName: 'school',
              color: AppTheme.textSecondaryLight,
              size: 20,
            ),
          ),
          items: _educationLevels.map((level) {
            return DropdownMenuItem<String>(
              value: level['value'],
              child: Text(level['label']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEducationLevel = value;
            });
            _updateFormData();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner votre niveau d\'éducation';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
            _updateFormData();
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
              _updateFormData();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 3.w),
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                  children: [
                    const TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'Conditions d\'utilisation',
                      style: TextStyle(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'Politique de confidentialité',
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
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isFormValid = _isFormValid();

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isFormValid && !widget.isLoading ? widget.onSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isFormValid ? AppTheme.primaryLight : AppTheme.textDisabledLight,
          foregroundColor: Colors.white,
          elevation: isFormValid ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: widget.isLoading
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.onPrimaryLight,
            ),
          ),
        )
            : Text(
          'Créer un compte',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _getFieldIcon(TextInputType keyboardType) {
    String iconName;
    switch (keyboardType) {
      case TextInputType.name:
        iconName = 'person_outline';
        break;
      case TextInputType.emailAddress:
        iconName = 'email_outlined';
        break;
      default:
        iconName = 'text_fields';
        break;
    }

    return CustomIconWidget(
      iconName: iconName,
      color: AppTheme.textSecondaryLight,
      size: 20,
    );
  }
}
