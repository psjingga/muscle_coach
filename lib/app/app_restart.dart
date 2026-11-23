import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Membungkus [ProviderScope] agar aplikasi bisa "dimuat ulang" tanpa
/// menutup proses: semua provider (termasuk basis data) dibuat ulang.
/// Dipakai setelah memulihkan cadangan.
class AppRestartScope extends StatefulWidget {
  const AppRestartScope({super.key, required this.child});

  final Widget child;

  /// Buat ulang seluruh provider & widget di bawah scope ini.
  static void restart(BuildContext context) =>
      context.findAncestorStateOfType<_AppRestartScopeState>()?._restart();

  @override
  State<AppRestartScope> createState() => _AppRestartScopeState();
}

class _AppRestartScopeState extends State<AppRestartScope> {
  Key _key = UniqueKey();

  void _restart() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) => ProviderScope(key: _key, child: widget.child);
}
