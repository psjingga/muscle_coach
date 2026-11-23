import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// Gaya pil ramping untuk aksi di judul kartu ("Catat berat", dll.).
ButtonStyle sectionActionStyle() => FilledButton.styleFrom(
  minimumSize: const Size(48, 40),
  padding: const EdgeInsets.symmetric(horizontal: 14),
  shape: const StadiumBorder(),
  textStyle: const TextStyle(
    fontFamily: AppTheme.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  ),
);

/// Kartu bagian di tab Progres: judul, aksi opsional, isi.
class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key, required this.title, required this.children, this.trailing});

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
              ?trailing,
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    ),
  );
}

Widget mutedText(BuildContext context, String text) {
  final theme = Theme.of(context);
  return Text(
    text,
    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
  );
}
