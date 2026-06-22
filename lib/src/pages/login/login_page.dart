import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:algo_rise/src/widgets/atmosphere_painter.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/pressable.dart';

// ─── LOGIN SCREEN WIDGET ──────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  // Login states: 'idle', 'authenticating', 'authorized'
  String _loginState = 'idle';

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() => _isEmailFocused = _emailFocusNode.hasFocus);
    });
    _passwordFocusNode.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_loginState != 'idle') return;

    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _loginState = 'authenticating');

      // Stage 1: Authenticate for 1.5s
      Timer(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() => _loginState = 'authorized');

        // Stage 2: Show success state for 1.0s and redirect
        Timer(const Duration(milliseconds: 1000), () async {
          if (!mounted) return;
          await PreferencesService.instance.setLoggedIn(true);
          if (mounted) {
            context.go('/main');
          }
        });
      });
    }
  }

  void _handleSocialLogin(String provider) {
    if (_loginState != 'idle') return;
    FocusScope.of(context).unfocus();
    setState(() => _loginState = 'authenticating');

    // Stage 1: Authenticate for 1.5s
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _loginState = 'authorized');

      // Stage 2: Show success state for 1.0s and redirect
      Timer(const Duration(milliseconds: 1000), () async {
        if (!mounted) return;
        await PreferencesService.instance.setLoggedIn(true);
        if (mounted) {
          context.go('/main');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly = _loginState != 'idle';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Atmospheric Glow Background
            Positioned.fill(
              child: CustomPaint(
                painter: AtmospherePainter(),
              ),
            ),
            // Floating Particles Layer
            const Positioned.fill(
              child: ParticleBackground(),
            ),
            // Form & Logo Container
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Brand Header
                      _buildLogoHeader(),
                      const SizedBox(height: 32),

                      // Login Card
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Email Field
                                _buildFieldLabel('ID_EMAIL'),
                                const SizedBox(height: 8),
                                _buildEmailField(isReadOnly),
                                const SizedBox(height: 24),

                                // Password Field
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildFieldLabel('ACCESS_KEY'),
                                    GestureDetector(
                                      onTap: isReadOnly ? null : () {},
                                      child: Text(
                                        'FORGOT?',
                                        style: AppText.labelCaps.copyWith(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildPasswordField(isReadOnly),
                                const SizedBox(height: 32),

                                // Action Button
                                _buildActionButton(),
                                const SizedBox(height: 32),

                                // Divider
                                _buildDivider(),
                                const SizedBox(height: 24),

                                // Social Login Providers
                                Row(
                                  children: [
                                    Expanded(
                                      child: _SocialButton(
                                        icon: CustomPaint(
                                          size: const Size(20, 20),
                                          painter: GithubIconPainter(),
                                        ),
                                        label: 'GITHUB',
                                        onTap: isReadOnly ? () {} : () => _handleSocialLogin('GITHUB'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _SocialButton(
                                        icon: CustomPaint(
                                          size: const Size(20, 20),
                                          painter: GoogleIconPainter(),
                                        ),
                                        label: 'GOOGLE',
                                        onTap: isReadOnly ? () {} : () => _handleSocialLogin('GOOGLE'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer Navigation links
                      _buildFooterLinks(isReadOnly),
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

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 136,
              height: 136,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.12),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
            Image.network(
              'https://lh3.googleusercontent.com/aida/AP1WRLtNmhF_YOxz2-sY789_P1z_6JtKj8AeeOYQZXWxm9sBwNJdnOkD3i9u2GgeAcC8DxmjwGxathO6aApFPnO9--lvCThqUPanRKQg0mlHmsyKEK5baG7fGbBGFC6_9f7YDNzJXwku4SVtEdqz0jXXWqSXyMUwkGOLFKSNobFhJVOO0ZjiDnUVUY4axVhQgUMXSqe2kI2g_eDw_HYzBCFlB3GJteRb_H_5qXgk3itVL_MXloOTOPYYaW7_hbez',
              width: 128,
              height: 128,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.primaryContainer.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.developer_board,
                  size: 48,
                  color: AppColors.primaryFixedDim,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'AlgoRise',
          style: AppText.displayMobile.copyWith(
            fontSize: 28,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'PERFORMANCE PROTOCOL v1.0',
          style: AppText.labelCode.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppText.labelCaps.copyWith(
        fontSize: 12,
        color: AppColors.primaryFixedDim,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildEmailField(bool isReadOnly) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isEmailFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.12),
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
        cursorColor: AppColors.primaryContainer,
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
          prefixIcon: Icon(
            Icons.alternate_email,
            size: 20,
            color: _isEmailFocused
                ? AppColors.primaryContainer
                : AppColors.onSurfaceVariant.withOpacity(0.4),
          ),
          hintText: 'dev@algorise.io',
          hintStyle: AppText.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          filled: true,
          fillColor: const Color(0xFF0B0E17),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryContainer,
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
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isPasswordFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.12),
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
        cursorColor: AppColors.primaryContainer,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Access key verification required';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            size: 20,
            color: _isPasswordFocused
                ? AppColors.primaryContainer
                : AppColors.onSurfaceVariant.withOpacity(0.4),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: AppColors.onSurfaceVariant.withOpacity(0.4),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryContainer,
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

  Widget _buildActionButton() {
    Color bg = AppColors.primaryContainer;
    Color fg = AppColors.onPrimaryFixed;
    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'INITIALIZE_LOGIN',
          style: AppText.headlineMd.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.login, color: fg, size: 20),
      ],
    );

    if (_loginState == 'authenticating') {
      bg = AppColors.primaryContainer.withOpacity(0.8);
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
            'AUTHENTICATING...',
            style: AppText.headlineMd.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      );
    } else if (_loginState == 'authorized') {
      bg = const Color(0xFF00FE87); // tertiary container green
      fg = const Color(0xFF007138); // on-tertiary container dark green
      buttonContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: fg, size: 20),
          const SizedBox(width: 8),
          Text(
            'AUTHORIZED',
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
      onTap: _handleLogin,
      scaleDown: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 56,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _loginState != 'authorized'
              ? [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.25),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF00FE87).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
        ),
        child: Center(child: buttonContent),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR PROVIDER',
            style: AppText.labelCode.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant.withOpacity(0.4),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinks(bool isReadOnly) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: AppText.bodyMd.copyWith(
                fontSize: 14,
                color: AppColors.onSurfaceVariant.withOpacity(0.8),
              ),
            ),
            GestureDetector(
              onTap: isReadOnly ? null : () => context.go('/signup'),
              child: Text(
                'Sign Up',
                style: AppText.bodyMd.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryFixedDim,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Opacity(
          opacity: 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLinkItem('Legal', isReadOnly),
              _buildFooterDivider(),
              _buildFooterLinkItem('Security', isReadOnly),
              _buildFooterDivider(),
              _buildFooterLinkItem('Terminal_v1.0', isReadOnly),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinkItem(String text, bool isReadOnly) {
    return GestureDetector(
      onTap: isReadOnly ? null : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          text,
          style: AppText.labelCode.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: AppColors.onSurfaceVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─── PARTICLE BACKGROUND EFFECT ───────────────────────────────────────────────
class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double fadeSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.fadeSpeed,
  });
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Particle> _particles = [];
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateParticles)..repeat();
  }

  void _updateParticles() {
    if (!mounted) return;

    // Maintain around 20-30 particles
    if (_particles.length < 25 && _rng.nextDouble() < 0.15) {
      _particles.add(Particle(
        x: _rng.nextDouble(),
        y: 1.0, // starts at bottom
        size: _rng.nextDouble() * 3.5 + 1.0,
        speed: _rng.nextDouble() * 0.0015 + 0.0005,
        opacity: 0.0,
        fadeSpeed: _rng.nextDouble() * 0.02 + 0.008,
      ));
    }

    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        final p = _particles[i];
        p.y -= p.speed; // move up

        // Fade in when starting, fade out towards the top
        if (p.y > 0.85) {
          p.opacity = math.min(0.3, p.opacity + p.fadeSpeed);
        } else if (p.y < 0.25) {
          p.opacity = math.max(0.0, p.opacity - p.fadeSpeed);
        } else {
          p.opacity = math.min(0.3, p.opacity);
        }

        // Remove if off screen or fully faded
        if (p.y < 0.05 || (p.y < 0.25 && p.opacity <= 0.0)) {
          _particles.removeAt(i);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlesPainter(particles: _particles),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  _ParticlesPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      paint.color = AppColors.primaryContainer.withOpacity(p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
}

// ─── SOCIAL PROVIDER BUTTON ──────────────────────────────────────────────────
class _SocialButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Pressable(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.04) : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? AppColors.primaryContainer.withOpacity(0.3)
                  : Colors.white.withOpacity(0.08),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: AppText.labelCaps.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SVG PATH PARSER & GRAPHIC PAINTERS ───────────────────────────────────────
class SvgPathParser {
  static Path parse(String d) {
    final Path path = Path();
    final RegExp commandRegExp = RegExp(r'([A-Za-z])|(-?\d*\.?\d+(?:[eE][-+]?\d+)?)');
    final matches = commandRegExp.allMatches(d).toList();

    int index = 0;
    double currentX = 0.0;
    double currentY = 0.0;

    while (index < matches.length) {
      String token = matches[index].group(0)!;
      if (RegExp(r'[A-Za-z]').hasMatch(token)) {
        String cmd = token;
        index++;

        List<double> params = [];
        while (index < matches.length && !RegExp(r'[A-Za-z]').hasMatch(matches[index].group(0)!)) {
          params.add(double.parse(matches[index].group(0)!));
          index++;
        }

        _applyCommand(path, cmd, params, (x, y) {
          currentX = x;
          currentY = y;
        }, currentX, currentY);
      } else {
        index++;
      }
    }
    return path;
  }

  static void _applyCommand(Path path, String cmd, List<double> p, Function(double, double) updateCoords, double curX, double curY) {
    int i = 0;
    double x = curX;
    double y = curY;

    switch (cmd) {
      case 'M':
        while (i < p.length - 1) {
          x = p[i];
          y = p[i + 1];
          path.moveTo(x, y);
          i += 2;
        }
        break;
      case 'm':
        while (i < p.length - 1) {
          x += p[i];
          y += p[i + 1];
          path.moveTo(x, y);
          i += 2;
        }
        break;
      case 'L':
        while (i < p.length - 1) {
          x = p[i];
          y = p[i + 1];
          path.lineTo(x, y);
          i += 2;
        }
        break;
      case 'l':
        while (i < p.length - 1) {
          x += p[i];
          y += p[i + 1];
          path.lineTo(x, y);
          i += 2;
        }
        break;
      case 'H':
        while (i < p.length) {
          x = p[i];
          path.lineTo(x, y);
          i++;
        }
        break;
      case 'h':
        while (i < p.length) {
          x += p[i];
          path.lineTo(x, y);
          i++;
        }
        break;
      case 'V':
        while (i < p.length) {
          y = p[i];
          path.lineTo(x, y);
          i++;
        }
        break;
      case 'v':
        while (i < p.length) {
          y += p[i];
          path.lineTo(x, y);
          i++;
        }
        break;
      case 'C':
        while (i < p.length - 5) {
          path.cubicTo(p[i], p[i + 1], p[i + 2], p[i + 3], p[i + 4], p[i + 5]);
          x = p[i + 4];
          y = p[i + 5];
          i += 6;
        }
        break;
      case 'c':
        while (i < p.length - 5) {
          path.cubicTo(x + p[i], y + p[i + 1], x + p[i + 2], y + p[i + 3], x + p[i + 4], y + p[i + 5]);
          x += p[i + 4];
          y += p[i + 5];
          i += 6;
        }
        break;
      case 'Z':
      case 'z':
        path.close();
        break;
    }
    updateCoords(x, y);
  }
}

class GithubIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final path = SvgPathParser.parse(
        'M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.43.372.823 1.102.823 2.222 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12');
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    final greenPaint = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.fill;
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.fill;
    final redPaint = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.fill;

    canvas.drawPath(SvgPathParser.parse('M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z'), bluePaint);
    canvas.drawPath(SvgPathParser.parse('M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z'), greenPaint);
    canvas.drawPath(SvgPathParser.parse('M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z'), yellowPaint);
    canvas.drawPath(SvgPathParser.parse('M12 5.38c1.62 0 3.06.56 4.21 1.66l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z'), redPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
