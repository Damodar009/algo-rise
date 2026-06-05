import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/blinking_cursor.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Page 7: Who's Waking Up ──────────────────────────────────────────────────
class WhoIsWakingUpPage extends StatefulWidget {
  /// Called when user taps "Let's go" — should navigate to Home.
  final VoidCallback? onFinish;

  const WhoIsWakingUpPage({super.key, this.onFinish});

  @override
  State<WhoIsWakingUpPage> createState() => _WhoIsWakingUpPageState();
}

class _WhoIsWakingUpPageState extends State<WhoIsWakingUpPage>
    with SingleTickerProviderStateMixin {
  int _selectedAvatar = 4;
  String _username = '';
  late AnimationController _cursor;
  final _textCtrl = TextEditingController();
  final _focus = FocusNode();

  static const _seeds = [
    'Felix', 'Aneka', 'Casper', 'Bella', 'Midnight', 'Oliver',
    'Luna', 'Shadow', 'Spark', 'Ghost', 'Circuit', 'Neon',
  ];

  String _url(String seed) =>
      'https://api.dicebear.com/7.x/pixel-art/svg?seed=$seed&backgroundColor=0d1117';

  String get _preview {
    final t = _username.trim();
    if (t.isEmpty) return '@your_username';
    return t.startsWith('@') ? t : '@$t';
  }

  @override
  void initState() {
    super.initState();
    _cursor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    _textCtrl.addListener(() => setState(() => _username = _textCtrl.text));
  }

  @override
  void dispose() {
    _cursor.dispose();
    _textCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(
        step: 7,
        total: 7,
        center: Opacity(
          opacity: 0.6,
          child: Text(
            'STEP 07 / 07',
            style: AppText.labelCaps.copyWith(color: AppColors.primaryFixed),
          ),
        ),
      ),
      body: OnboardingPageBody(
        maxWidth: 448,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Who's waking up?", style: AppText.displayMobile),
            const SizedBox(height: 8),
            Text(
              'Your name appears on streak cards and leaderboards.',
              style: AppText.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Avatar section label
            Text(
              'SELECT AVATAR',
              style: AppText.labelCaps.copyWith(
                color: AppColors.primaryFixedDim,
              ),
            ),
            const SizedBox(height: 8),

            // 3-col avatar grid
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _seeds.length,
              itemBuilder: (_, i) => _AvatarCell(
                url: _url(_seeds[i]),
                isSelected: _selectedAvatar == i,
                onTap: () => setState(() => _selectedAvatar = i),
              ),
            ),
            const SizedBox(height: 24),

            // Identifier input
            Text(
              'IDENTIFIER',
              style: AppText.labelCaps.copyWith(
                color: AppColors.primaryFixedDim,
              ),
            ),
            const SizedBox(height: 8),
            _UsernameInput(controller: _textCtrl, focus: _focus),
            const SizedBox(height: 24),

            // Card preview
            Opacity(
              opacity: 0.5,
              child: Text('CARD PREVIEW', style: AppText.labelCaps),
            ),
            const SizedBox(height: 8),
            _PreviewCard(
              avatarUrl: _url(_seeds[_selectedAvatar]),
              previewText: _preview,
              cursor: _cursor,
            ),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: "Let's go",
          color: AppColors.primaryContainer,
          onTap: widget.onFinish,
        ),
      ),
    );
  }
}

// ── Avatar Cell ────────────────────────────────────────────────────────────────
class _AvatarCell extends StatelessWidget {
  final String url;
  final bool isSelected;
  final VoidCallback onTap;
  const _AvatarCell({
    required this.url,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onTap,
        scaleDown: 0.95,
        child: GlassCard(
          isActive: isSelected,
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.hardEdge,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
              loadingBuilder: (_, child, p) => p == null
                  ? child
                  : Container(
                      color: AppColors.surfaceContainerHigh,
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.primaryFixedDim
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceContainerHigh,
                child: const Icon(
                  Icons.person,
                  color: AppColors.onSurfaceVariant,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      );
}

// ── Username Input ─────────────────────────────────────────────────────────────
class _UsernameInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focus;
  const _UsernameInput({required this.controller, required this.focus});
  @override
  State<_UsernameInput> createState() => _UsernameInputState();
}

class _UsernameInputState extends State<_UsernameInput> {
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    widget.focus.addListener(
      () => setState(() => _focused = widget.focus.hasFocus),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _focused ? AppColors.primaryFixed : AppColors.outlineVariant,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focus,
          style: AppText.labelCode.copyWith(color: AppColors.primaryFixedDim),
          cursorColor: AppColors.primaryFixedDim,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          decoration: InputDecoration(
            hintText: '@your_username',
            hintStyle: AppText.labelCode.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      );
}

// ── Preview Card ───────────────────────────────────────────────────────────────
class _PreviewCard extends StatelessWidget {
  final String avatarUrl;
  final String previewText;
  final AnimationController cursor;
  const _PreviewCard({
    required this.avatarUrl,
    required this.previewText,
    required this.cursor,
  });

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          previewText,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.headlineMd.copyWith(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      BlinkingCursor(controller: cursor),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: AppColors.tertiaryFixed,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '0 STREAK',
                        style: AppText.labelCaps.copyWith(
                          color: AppColors.tertiaryFixed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
