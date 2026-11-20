import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_logo.dart';
import '../../../../core/utils/context_x.dart';

/// Pembuka sebelum assessment: apa yang ditanyakan, prinsip, dan disclaimer.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final points = [
      (Icons.calculate_outlined, l.onboardingPoint1),
      (Icons.fact_check_outlined, l.onboardingPoint2),
      (Icons.lock_outline, l.onboardingPoint3),
    ];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                const Align(alignment: Alignment.centerLeft, child: AppLogo(size: 64)),
                const SizedBox(height: 16),
                Text(l.onboardingTitle, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(l.onboardingMessage, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                for (final (icon, text) in points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  l.disclaimerShort,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => context.push(Routes.assessment),
                  child: Text(l.startAssessment),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
