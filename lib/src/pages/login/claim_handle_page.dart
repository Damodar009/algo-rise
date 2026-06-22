import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:algo_rise/src/pages/login/login_page.dart';

class ClaimHandlePage extends StatefulWidget {
  const ClaimHandlePage({super.key});

  @override
  State<ClaimHandlePage> createState() => _ClaimHandlePageState();
}

class _ClaimHandlePageState extends State<ClaimHandlePage> with SingleTickerProviderStateMixin {
  final _handleController = TextEditingController();
  final _focusNode = FocusNode();
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  bool _isFocused = false;
  String _btnState = 'idle'; // 'idle', 'verifying', 'success'

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _handleController.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_btnState != 'idle') return;
    if (_handleController.text.length < 3) return;

    FocusScope.of(context).unfocus();
    setState(() => _btnState = 'verifying');

    // Verification timing (0.8s)
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _btnState = 'success');

      // Successful redirect delay (0.8s)
      Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        context.go('/main');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String val = _handleController.text;
    final bool isAvailable = val.length >= 3;
    final bool isReadOnly = _btnState != 'idle';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Floating Particles Layer
            const Positioned.fill(
              child: ParticleBackground(),
            ),
            // Page contents
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // pulsating sleepy pixel robot section
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: _buildRobotSection(),
                      ),
                      const SizedBox(height: 32),

                      // Headlines
                      Text(
                        'Claim your @handle',
                        style: AppText.displayMobile.copyWith(
                          fontSize: 28,
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your unique identity in the AlgoRise ecosystem.',
                        textAlign: TextAlign.center,
                        style: AppText.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Input section
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'IDENTITY_SETTING',
                              style: AppText.labelCode.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryFixedDim,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInputBox(isReadOnly, isAvailable),
                            const SizedBox(height: 24),

                            // Profile Preview Card
                            _buildPreviewCard(val),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Actions and step count footer
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: _buildFooterSection(isAvailable, isReadOnly),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 192,
          height: 192,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        Image.network(
          'https://lh3.googleusercontent.com/aida/AP1WRLtBlzvYkW-OvGQFbl_jhUz4cn_kAIwFhWZjyviTE-8_9IzAaI9-f6v2lahqZTKvyXxNO705VQEdub5gwD-Cc4woEjChVPEDymosalNFwJwrvSilX-XaV7phW3O7WTxSGb9LLgZMFTs3n5kgee8Lj08B4gxBf9GSQcKeWU1wa_E73dLPuZZD9rfP2SdnHtJlZwcnp3_eRpcPq-OUuIHpNkmcEt-BtTjsCUiyBObhFXMj5DR_MD6yUSfp5yP4',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.primaryFixedDim.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 64,
              color: AppColors.primaryFixedDim,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBox(bool isReadOnly, bool isAvailable) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: Matrix4.identity()..scale(_isFocused ? 1.01 : 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isFocused
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
        controller: _handleController,
        focusNode: _focusNode,
        readOnly: isReadOnly,
        style: AppText.headlineMd.copyWith(
          color: AppColors.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        cursorColor: AppColors.primaryFixedDim,
        onChanged: (value) {
          final lowercaseValue = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
          if (lowercaseValue != value) {
            _handleController.value = TextEditingValue(
              text: lowercaseValue,
              selection: TextSelection.collapsed(offset: lowercaseValue.length),
            );
          }
          setState(() {});
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Text(
              '@',
              style: AppText.headlineMd.copyWith(
                color: AppColors.primaryFixedDim,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: isAvailable
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryFixedDim,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AVAILABLE',
                        style: AppText.labelCaps.copyWith(
                          fontSize: 10,
                          color: AppColors.primaryFixedDim,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          hintText: 'username',
          hintStyle: AppText.headlineMd.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: const Color(0xFF0B0E17),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
        ),
      ),
    );
  }

  Widget _buildPreviewCard(String handleText) {
    final displayHandle = handleText.isEmpty ? 'username' : handleText;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Circular Avatar with gradient
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF641fac), // secondary-container (purple)
                  Color(0xFF00f5ff), // primary-container (cyan)
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF460084), // on-secondary is 460084
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Handle details & block cursor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mock placeholder box
                Container(
                  height: 14,
                  width: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '@',
                      style: AppText.labelCode.copyWith(
                        color: AppColors.primaryFixedDim,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayHandle,
                      style: AppText.labelCode.copyWith(
                        color: AppColors.primaryFixedDim,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const BlinkingCursor(),
                  ],
                ),
              ],
            ),
          ),

          // Streak chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00FE87).withValues(alpha: 0.1),
              border: Border.all(color: const Color(0xFF00E479).withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.tertiaryFixedDim,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '0',
                  style: AppText.labelCode.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiaryFixedDim,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(bool isAvailable, bool isReadOnly) {
    Color bg = AppColors.primaryFixedDim;
    Color fg = AppColors.onPrimaryFixed;
    double opacity = 1.0;
    bool clickable = isAvailable && !isReadOnly;

    Widget btnContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Continue',
          style: AppText.headlineMd.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: fg, size: 20),
      ],
    );

    if (!isAvailable) {
      opacity = 0.5;
    }

    if (_btnState == 'verifying') {
      btnContent = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    } else if (_btnState == 'success') {
      bg = const Color(0xFF60FF99); // AppColors.tertiaryFixed
      fg = const Color(0xFF00210C); // AppColors.onTertiaryFixed
      btnContent = Icon(Icons.check, color: fg, size: 20);
    }

    return Column(
      children: [
        Opacity(
          opacity: opacity,
          child: Pressable(
            onTap: clickable ? _handleContinue : () {},
            scaleDown: clickable ? 0.95 : 1.0,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                boxShadow: clickable && _btnState != 'success'
                    ? [
                        BoxShadow(
                          color: AppColors.primaryFixedDim.withValues(alpha: 0.35),
                          blurRadius: 15,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Center(child: btnContent),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'STEP 1 OF 4',
          style: AppText.labelCaps.copyWith(
            fontSize: 11,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
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
