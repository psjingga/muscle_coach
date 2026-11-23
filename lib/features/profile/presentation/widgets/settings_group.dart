import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';

/// Label seksi kecil huruf kapital (desain "volt").
class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: context.palette.muted,
      ),
    ),
  );
}

/// Satu kartu berisi baris-baris pengaturan, dipisah garis 1px.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          children[i],
        ],
      ],
    ),
  );
}

/// Ikon bulat 40px: surface2 (biasa) atau accentSoft + aksen.
class SettingsIcon extends StatelessWidget {
  const SettingsIcon(this.icon, {super.key, this.accent = false});

  final IconData icon;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: accent ? palette.accentSoft : palette.surface2,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: accent
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Pill status: aktif = accentSoft + aksen, nonaktif = surface2 + muted.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.text, required this.on});

  final String text;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: on ? palette.accentSoft : palette.surface2,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: on ? Theme.of(context).colorScheme.primary : palette.muted,
        ),
      ),
    );
  }
}

/// Baris pengaturan: ikon bulat · judul (+subjudul) · pill opsional · chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.accentIcon = false,
    this.pill,
    this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool accentIcon;
  final Widget? pill;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SettingsIcon(icon, accent: accentIcon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: TextStyle(fontSize: 12, color: palette.muted)),
                    ],
                  ],
                ),
              ),
              if (pill != null) ...[const SizedBox(width: 8), pill!],
              if (showChevron && onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 22, color: palette.muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
