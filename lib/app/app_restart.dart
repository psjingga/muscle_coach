import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_logger.dart';
import 'theme/app_theme.dart';

/// Membungkus [ProviderScope] agar aplikasi bisa "dimuat ulang" tanpa
/// menutup proses: semua provider (termasuk basis data) dibuat ulang.
/// Dipakai setelah memulihkan cadangan.
class AppRestartScope extends StatefulWidget {
  const AppRestartScope({super.key, required this.child});

  final Widget child;

  /// Buat ulang seluruh provider & widget di bawah scope ini.
  static void restart(BuildContext context) =>
      context.findAncestorStateOfType<_AppRestartScopeState>()?._restart();

  /// Lepas seluruh aplikasi (semua provider & pendengar data berhenti),
  /// jalankan [whileStopped] (mis. tutup basis data & ganti berkasnya),
  /// lalu bangun ulang aplikasi. Selama itu hanya layar progres yang tampil.
  static Future<void> restartWith(BuildContext context, Future<void> Function() whileStopped) =>
      context.findAncestorStateOfType<_AppRestartScopeState>()?._restartWith(whileStopped) ??
      Future.value();

  @override
  State<AppRestartScope> createState() => _AppRestartScopeState();
}

class _AppRestartScopeState extends State<AppRestartScope> {
  Key _key = UniqueKey();
  bool _stopped = false;

  void _restart() => setState(() => _key = UniqueKey());

  Future<void> _restartWith(Future<void> Function() whileStopped) async {
    setState(() => _stopped = true);
    // Tunggu pohon lama dilepas (ProviderScope lama di-dispose).
    await WidgetsBinding.instance.endOfFrame;
    try {
      await whileStopped();
    } catch (e) {
      appLogger.w('Proses saat aplikasi dihentikan gagal: ${e.runtimeType}');
    } finally {
      if (mounted) {
        setState(() {
          _stopped = false;
          _key = UniqueKey();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => _stopped
      ? MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(),
          home: const Scaffold(body: Center(child: CircularProgressIndicator())),
        )
      : ProviderScope(key: _key, child: widget.child);
}
