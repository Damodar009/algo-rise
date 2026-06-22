import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:algo_rise/src/pages/login/login_page.dart';

// ─── SIGN UP SCREEN ───────────────────────────────────────────────────────────
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _agreeToTerms = false;
  bool _termsError = false;

  // Account creation states: 'idle', 'creating'
  String _signUpState = 'idle';

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      setState(() => _isNameFocused = _nameFocusNode.hasFocus);
    });
    _emailFocusNode.addListener(() {
      setState(() => _isEmailFocused = _emailFocusNode.hasFocus);
    });
    _passwordFocusNode.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_signUpState != 'idle') return;

    setState(() {
      _termsError = !_agreeToTerms;
    });

    if (_formKey.currentState!.validate() && _agreeToTerms) {
      FocusScope.of(context).unfocus();
      setState(() => _signUpState = 'creating');

      // Simulate account creation protocol for 1.5s
      Timer(const Duration(milliseconds: 1500), () async {
        if (!mounted) return;
        await PreferencesService.instance.setLoggedIn(true);
        if (mounted) {
          context.go('/claim-handle');
        }
      });
    }
  }

  void _handleSocialSignUp(String provider) {
    if (_signUpState != 'idle') return;
    FocusScope.of(context).unfocus();
    setState(() => _signUpState = 'creating');

    // Simulate account creation protocol for 1.5s
    Timer(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      await PreferencesService.instance.setLoggedIn(true);
      if (mounted) {
        context.go('/claim-handle');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly = _signUpState != 'idle';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Cyber Ambient Glows (Streak shaders)
          Positioned.fill(
            child: CustomPaint(
              painter: SignupAtmospherePainter(),
            ),
          ),
          // Floating Particles
          const Positioned.fill(
            child: ParticleBackground(),
          ),
          // Blurred Header Navigation
          _buildHeaderBar(isReadOnly),
          // Scrollable Form Layout
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 64, // below header
                    bottom: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      // Title Section
                      _buildTitleSection(),
                      const SizedBox(height: 32),

                      // Form Box
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Full Name field
                                _buildFieldLabel('Full Name'),
                                const SizedBox(height: 8),
                                _buildNameField(isReadOnly),
                                const SizedBox(height: 24),

                                // Email field
                                _buildFieldLabel('Email Address'),
                                const SizedBox(height: 8),
                                _buildEmailField(isReadOnly),
                                const SizedBox(height: 24),

                                // Password field
                                _buildFieldLabel('Password'),
                                const SizedBox(height: 8),
                                _buildPasswordField(isReadOnly),
                                const SizedBox(height: 24),

                                // Terms & Conditions Checkbox
                                _buildTermsCheckbox(isReadOnly),
                                const SizedBox(height: 32),

                                // Action Button
                                _buildActionButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Social Section
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: _buildSocialSection(isReadOnly),
                      ),
                      const SizedBox(height: 32),

                      // Footer Navigation link
                      _buildFooter(isReadOnly),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar(bool isReadOnly) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.8),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: isReadOnly ? null : () => context.go('/login'),
            ),
            Text(
              'AlgoRise',
              style: AppText.headlineMd.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 48), // balance spacer
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Initialize Account',
              style: AppText.displayMobile.copyWith(
                fontSize: 32,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'System access protocol v2.4.0',
                  style: AppText.labelCode.copyWith(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 4),
                const BlinkingCursor(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: AppText.labelCaps.copyWith(
        fontSize: 11,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildNameField(bool isReadOnly) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: Matrix4.identity()..scale(_isNameFocused ? 1.01 : 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isNameFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.12),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: _nameController,
        focusNode: _nameFocusNode,
        readOnly: isReadOnly,
        style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
        cursorColor: AppColors.primaryFixedDim,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Full name required';
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.badge,
            size: 20,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          hintText: 'John Doe',
          hintStyle: AppText.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          filled: true,
          fillColor: const Color(0xFF0B0E17),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryFixedDim,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(bool isReadOnly) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: Matrix4.identity()..scale(_isEmailFocused ? 1.01 : 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isEmailFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.12),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        readOnly: isReadOnly,
        keyboardType: TextInputType.emailAddress,
        style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
        cursorColor: AppColors.primaryFixedDim,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email identifier required';
          }
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(value)) {
            return 'Invalid email format';
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.alternate_email,
            size: 20,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          hintText: 'dev@algorise.io',
          hintStyle: AppText.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          filled: true,
          fillColor: const Color(0xFF0B0E17),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryFixedDim,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isReadOnly) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: Matrix4.identity()..scale(_isPasswordFocused ? 1.01 : 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isPasswordFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.12),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        readOnly: isReadOnly,
        obscureText: !_isPasswordVisible,
        style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
        cursorColor: AppColors.primaryFixedDim,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Access key verification required';
          }
          if (value.length < 6) {
            return 'Security policy requires 6+ characters';
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            onPressed: isReadOnly
                ? null
                : () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
          ),
          hintText: '••••••••',
          hintStyle: AppText.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          filled: true,
          fillColor: const Color(0xFF0B0E17),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryFixedDim,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(bool isReadOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _agreeToTerms,
                onChanged: isReadOnly
                    ? null
                    : (val) {
                        setState(() {
                          _agreeToTerms = val ?? false;
                          _termsError = false;
                        });
                      },
                activeColor: AppColors.primaryFixedDim,
                checkColor: AppColors.onPrimaryFixed,
                side: BorderSide(
                  color: _termsError ? AppColors.error : Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'I agree to the ',
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                        color: AppColors.primaryFixedDim,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        color: AppColors.primaryFixedDim,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_termsError)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 4),
            child: Text(
              'Acceptance required to initialize protocol',
              style: AppText.bodyMd.copyWith(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton() {
    Color bg = AppColors.primaryFixedDim;
    Color fg = AppColors.onPrimaryFixed;
    Widget buttonContent = Text(
      'Create Account',
      style: AppText.headlineMd.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: fg,
      ),
    );

    if (_signUpState == 'creating') {
      bg = AppColors.primaryFixedDim.withValues(alpha: 0.8);
      buttonContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'CREATING ACCOUNT...',
            style: AppText.headlineMd.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      );
    }

    return Pressable(
      onTap: _handleSignUp,
      scaleDown: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 56,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryFixedDim.withValues(alpha: 0.25),
              blurRadius: 15,
              spreadRadius: 1,
            )
          ],
        ),
        child: Center(child: buttonContent),
      ),
    );
  }

  Widget _buildSocialSection(bool isReadOnly) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Pressable(
                onTap: isReadOnly ? () {} : () => _handleSocialSignUp('GITHUB'),
                scaleDown: 0.98,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(20, 20),
                        painter: GithubIconPainter(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'GITHUB',
                        style: AppText.labelCaps.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Pressable(
                onTap: isReadOnly ? () {} : () => _handleSocialSignUp('GOOGLE'),
                scaleDown: 0.98,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(20, 20),
                        painter: GoogleIconPainter(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'GOOGLE',
                        style: AppText.labelCaps.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(bool isReadOnly) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppText.bodyMd.copyWith(
            fontSize: 14,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
        GestureDetector(
          onTap: isReadOnly ? null : () => context.go('/login'),
          child: Text(
            'Login',
            style: AppText.bodyMd.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryFixedDim,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── BLINKING CURSOR EFFECT ───────────────────────────────────────────────────
class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value < 0.5 ? 1.0 : 0.0,
          child: child,
        );
      },
      child: Container(
        width: 8,
        height: 18,
        color: AppColors.primaryFixedDim,
      ),
    );
  }
}

// ─── SIGNUP AMBIENT GRADIENTS PAINTER ──────────────────────────────────────────
class SignupAtmospherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Purple glow (mid-right)
    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFDAB9FF).withValues(alpha: 0.05), // bg-secondary/10
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 1.1, size.height * 0.5),
          radius: size.width * 0.7,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 1.1, size.height * 0.5),
      size.width * 0.7,
      paint1,
    );

    // 2. Cyan glow (bottom-left)
    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryContainer.withValues(alpha: 0.07), // bg-primary-container/10
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(-size.width * 0.1, size.height * 0.95),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawCircle(
      Offset(-size.width * 0.1, size.height * 0.95),
      size.width * 0.6,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
