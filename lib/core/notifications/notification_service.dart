import 'package:timezone/timezone.dart' as tz;

/// Status izin notifikasi sistem.
enum NotificationPermission { granted, denied, unknown }

/// Notifikasi terjadwal yang siap dikirim ke OS (teks sudah dilokalkan).
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.channel,
    required this.when,
    required this.title,
    required this.body,
    required this.route,
  });

  final int id;

  /// ID channel Android (per kategori).
  final String channel;
  final tz.TZDateTime when;
  final String title;
  final String body;

  /// Rute yang dibuka saat diketuk.
  final String route;
}

/// Abstraksi notifikasi lokal. UI & use case tidak memanggil plugin langsung.
abstract interface class NotificationService {
  /// Inisialisasi plugin; [onOpenRoute] dipanggil saat notifikasi diketuk.
  Future<void> init({required void Function(String route) onOpenRoute});

  /// Rute dari notifikasi yang membuka aplikasi (cold start), bila ada.
  Future<String?> launchRoute();

  Future<NotificationPermission> permission();

  /// Minta izin sistem (Android 13+/iOS). `true` bila diberikan.
  Future<bool> requestPermission();

  /// Zona waktu perangkat (IANA) & lokasinya untuk penjadwalan.
  Future<tz.Location> localLocation();

  /// ID notifikasi yang masih tertunda (milik aplikasi ini).
  Future<Set<int>> pendingIds();

  /// Jadwalkan (ID sama → menimpa).
  Future<void> schedule(ScheduledNotification n);

  Future<void> cancel(int id);
  Future<void> cancelAll();

  /// Buka halaman pengaturan notifikasi aplikasi di sistem.
  Future<void> openSystemSettings();

  /// Tampilkan notifikasi uji sekarang.
  Future<void> showTest({required String title, required String body});
}
