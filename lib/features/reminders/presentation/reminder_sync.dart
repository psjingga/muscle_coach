import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/logging/app_logger.dart';
import '../../progress/presentation/providers/progress_providers.dart';
import '../../profile/presentation/providers/profile_providers.dart';
import '../../workout/presentation/providers/workout_providers.dart';
import 'providers/reminder_providers.dart';

/// Menyinkronkan jadwal pengingat dengan data terbaru: saat aplikasi dibuka
/// & kembali aktif (zona waktu bisa berubah), preferensi berubah, program
/// aktif berubah, dan sesi selesai. Juga membuka rute dari notifikasi.
class ReminderSync extends ConsumerStatefulWidget {
  const ReminderSync({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderSync> createState() => _ReminderSyncState();
}

class _ReminderSyncState extends ConsumerState<ReminderSync> with WidgetsBindingObserver {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      final service = ref.read(notificationServiceProvider);
      void open(String route) => ref.read(appRouterProvider).push(route);
      await service.init(
        onOpenRoute: open,
        onCheckInDone: (date) => ref.read(progressRepositoryProvider).markCheckInDone(date),
      );
      final launch = await service.launchRoute();
      if (launch != null) WidgetsBinding.instance.addPostFrameCallback((_) => open(launch));
    } catch (e) {
      appLogger.w('Notifikasi tidak dapat diinisialisasi: $e');
    }
    _schedule();
  }

  /// Rekonsiliasi dengan jeda singkat agar perubahan beruntun digabung.
  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      unawaited(ref.read(reminderStatusProvider.notifier).refresh());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // "Tandai selesai" di latar belakang menulis lewat koneksi lain →
      // segarkan tampilan check-in.
      final db = ref.read(appDatabaseProvider);
      db.markTablesUpdated([db.dailyCheckIns]);
      _schedule();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationSettingsProvider, (_, _) => _schedule());
    ref.listen(
      userProfileProvider.select((p) => p.value?.activeWorkoutPlanId),
      (_, _) => _schedule(),
    );
    // Check-in diisi/ditandai selesai → pengingat hari itu dibatalkan.
    ref.listen(checkInsProvider.select((c) => c.value?.length), (_, _) => _schedule());
    // Sesi terbaru yang selesai berubah → batalkan pengingat sesi tersebut.
    ref.listen(
      workoutHistoryProvider.select((h) => h.value?.firstOrNull?.id),
      (_, _) => _schedule(),
    );
    return widget.child;
  }
}
