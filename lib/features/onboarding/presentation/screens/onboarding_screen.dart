import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/context_x.dart';
import '../../../assessment/presentation/widgets/form_fields.dart';

/// Pembuka sebelum assessment: apa yang ditanyakan, prinsip, dan disclaimer.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final accent = theme.colorScheme.primary;
    final points = [
      (Icons.calculate_outlined, l.onboardingPoint1),
      (Icons.fact_check_outlined, l.onboardingPoint2),
      (Icons.lock_outline_rounded, l.onboardingPoint3),
    ];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: palette.accentSoft,
                            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                          ),
                          child: Icon(Icons.assignment_outlined, size: 32, color: accent),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.onboardingTitle,
                        style: const TextStyle(
                          fontSize: 32,
                          height: 36 / 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l.onboardingMessage,
                        style: theme.textTheme.bodyLarge?.copyWith(color: palette.muted),
                      ),
                      const SizedBox(height: 24),
                      const StepSegments(current: 0, total: 7),
                      const SizedBox(height: 24),
                      for (final (icon, text) in points)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: palette.surface2,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, size: 20, color: accent),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l.disclaimerShort,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, height: 17 / 12, color: palette.muted),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.push(Routes.assessment),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: Text(l.startAssessment)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 22),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
