import 'package:flutter/material.dart';

/// AppBar tab utama: judul besar rata kiri (desain "volt").
class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => AppBar(
    toolbarHeight: 64,
    titleSpacing: 16,
    title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    actions: actions,
  );
}
