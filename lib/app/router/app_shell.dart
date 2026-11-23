import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/context_x.dart';
import '../../features/dashboard/presentation/quick_actions.dart';
import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// Kerangka tab utama dengan bottom bar "pil melayang + aksi cepat"
/// (opsi B): 4 tab di pil (Beranda, Latihan, Nutrisi, Progres) dan tombol
/// volt "+" terpisah untuk aksi harian. Profil dibuka dari header Beranda.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tabs = [
      (Icons.home_outlined, Icons.home_rounded, l.tabHome),
      (Icons.fitness_center_outlined, Icons.fitness_center_rounded, l.tabWorkout),
      (Icons.restaurant_outlined, Icons.restaurant_rounded, l.tabNutrition),
      (Icons.insights_outlined, Icons.insights_rounded, l.tabProgress),
    ];
    void go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);
    return Scaffold(
      body: shell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            key: const Key('app-nav'),
            children: [
              Expanded(
                child: _NavPill(tabs: tabs, current: shell.currentIndex, onSelected: go),
              ),
              const SizedBox(width: 12),
              _QuickAddButton(onPressed: () => showQuickActions(context, ref)),
            ],
          ),
        ),
      ),
    );
  }
}

const _barHeight = 64.0;
const _shadow = [BoxShadow(color: Color(0x80000000), blurRadius: 24, offset: Offset(0, 8))];

class _NavPill extends StatelessWidget {
  const _NavPill({required this.tabs, required this.current, required this.onSelected});

  final List<(IconData, IconData, String)> tabs;
  final int current;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Container(
      height: _barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          for (final (i, (icon, selectedIcon, label)) in tabs.indexed)
            Expanded(
              child: Semantics(
                selected: i == current,
                button: true,
                label: label,
                excludeSemantics: true,
                child: InkResponse(
                  key: Key('nav-$i'),
                  onTap: () => onSelected(i),
                  radius: 32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        width: 52,
                        height: 30,
                        decoration: BoxDecoration(
                          color: i == current ? palette.accentSoft : Colors.transparent,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Icon(
                          i == current ? selectedIcon : icon,
                          size: 22,
                          color: i == current ? theme.colorScheme.primary : palette.muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 11,
                          fontWeight: i == current ? FontWeight.w600 : FontWeight.w500,
                          color: i == current ? theme.colorScheme.onSurface : palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: _barHeight,
      height: _barHeight,
      decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: _shadow),
      child: Material(
        color: scheme.primary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const Key('quick-add'),
          onTap: onPressed,
          child: Tooltip(
            message: context.l10n.quickActions,
            child: Icon(Icons.add_rounded, size: 32, color: scheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
