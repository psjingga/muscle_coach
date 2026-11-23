import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/database/app_database.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/notifications/local_notification_service.dart';
import '../../progress/data/progress_repository.dart';

/// Aksi notifikasi saat aplikasi tertutup (isolate latar belakang, Android):
/// "Tunda" dan "Tandai selesai" untuk check-in. Membuka koneksi basis data
/// sendiri sebentar; tanpa data kesehatan di log.
@pragma('vm:entry-point')
Future<void> reminderBackgroundHandler(NotificationResponse response) =>
    handleNotificationActionInBackground(response, onCheckInDone: markCheckInDoneInBackground);

Future<void> markCheckInDoneInBackground(String date) async {
  final db = AppDatabase();
  try {
    await LocalProgressRepository(db, DateTime.now).markCheckInDone(date);
  } catch (e) {
    appLogger.w('Tandai check-in selesai gagal: ${e.runtimeType}');
  } finally {
    await db.close();
  }
}
