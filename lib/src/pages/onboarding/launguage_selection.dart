import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/code_atmosphere_card.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/launguage_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:flutter/material.dart';

// ─── Page 3: Language Selection ───────────────────────────────────────────────
class LanguageSelectionPage extends StatefulWidget {
  final VoidCallback? onNext;

  const LanguageSelectionPage({super.key, this.onNext});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selected = 'python'; // Python pre-selected by default

  static const _languages = [
    _Language(
      id: 'python',
      title: 'Python 3',
      version: 'v3.11',
      icon: Icons.terminal,
    ),
    _Language(
      id: 'js',
      title: 'JavaScript',
      version: 'ES2023',
      icon: Icons.javascript,
    ),
    _Language(
        id: 'java', title: 'Java', version: 'JDK 17', icon: Icons.coffee),
    _Language(
      id: 'cpp',
      title: 'C++',
      version: 'C++20',
      icon: Icons.settings_ethernet,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(step: 3, total: 11),
      body: OnboardingPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Headline ───────────────────────────────────────────────
            Text(
              'What language do you think in?',
              style: AppText.headlineMd.copyWith(
                shadows: [
                  Shadow(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can change this per alarm later.',
              style: AppText.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 40),

            // ── 2×2 Language grid ──────────────────────────────────────
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.92,
              children: _languages.map((lang) {
                return LanguageCard(
                  icon: lang.icon,
                  title: lang.title,
                  version: lang.version,
                  isSelected: _selected == lang.id,
                  onTap: () => setState(() => _selected = lang.id),
                );
              }).toList(),
            ),

            const SizedBox(height: 48),

            // ── Atmospheric code card ──────────────────────────────────
            const CodeAtmosphereCard(),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(label: 'Continue', onTap: widget.onNext),
      ),
    );
  }
}

// ─── Language data model ──────────────────────────────────────────────────────
class _Language {
  final String id;
  final String title;
  final String version;
  final IconData icon;

  const _Language({
    required this.id,
    required this.title,
    required this.version,
    required this.icon,
  });
}
