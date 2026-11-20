import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../logging/app_logger.dart';
import 'notification_service.dart';

/// Kanal Android per kategori (dapat diatur pengguna di pengaturan sistem).
const notificationChannels = {
  'workout': 'Pengingat latihan',
  'meals': 'Pengingat makan',
  'weigh_in': 'Pengingat timbang',
  'check_in': 'Check-in harian',
  'test': 'Uji notifikasi',
};

const _snoozeAction = 'snooze';
const _snoozeMinutes = 10;

AndroidNotificationDetails _android(String channel, {bool snooze = true}) =>
    AndroidNotificationDetails(
      channel,
      notificationChannels[channel] ?? channel,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: snooze
          ? const [AndroidNotificationAction(_snoozeAction, 'Tunda $_snoozeMinutes menit')]
          : null,
    );

NotificationDetails _details(String channel, {bool snooze = true}) => NotificationDetails(
  android: _android(channel, snooze: snooze),
  iOS: const DarwinNotificationDetails(),
);

/// Payload notifikasi: rute + teks (agar "Tunda" bisa menjadwalkan ulang).
String _payload(String route, String channel, String title, String body) =>
    jsonEncode({'route': route, 'channel': channel, 'title': title, 'body': body});

Map<String, dynamic>? _decode(String? payload) {
  if (payload == null || payload.isEmpty) return null;
  try {
    return jsonDecode(payload) as Map<String, dynamic>;
  } catch (_) {
    return {'route': payload};
  }
}

/// ID notifikasi tunda (tidak bentrok dengan ID jadwal 31-bit dari planner
/// karena sumber hash berbeda; satu tunda aktif per notifikasi asal).
int snoozeIdFor(int originalId) => (originalId ^ 0x5a5a5a5) & 0x7fffffff;

Future<void> _snooze(FlutterLocalNotificationsPlugin plugin, NotificationResponse r) async {
  final data = _decode(r.payload);
  if (data == null || r.id == null) return;
  final channel = (data['channel'] as String?) ?? 'workout';
  await plugin.zonedSchedule(
    id: snoozeIdFor(r.id!),
    scheduledDate: tz.TZDateTime.now(tz.UTC).add(const Duration(minutes: _snoozeMinutes)),
    notificationDetails: _details(channel, snooze: false),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: data['title'] as String?,
    body: data['body'] as String?,
    payload: r.payload,
  );
}

/// Aksi "Tunda" saat aplikasi tertutup (isolate latar belakang, Android).
@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(NotificationResponse response) async {
  if (response.actionId != _snoozeAction) return;
  tzdata.initializeTimeZones();
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(),
    ),
  );
  await _snooze(plugin, response);
}

class LocalNotificationService implements NotificationService {
  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  AndroidFlutterLocalNotificationsPlugin? get _androidImpl =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _iosImpl =>
      _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  @override
  Future<void> init({required void Function(String route) onOpenRoute}) async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
        // Izin TIDAK diminta saat start — hanya dari layar pengaturan, dengan penjelasan.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) async {
        if (r.actionId == _snoozeAction) {
          await _snooze(_plugin, r);
          return;
        }
        final route = _decode(r.payload)?['route'] as String?;
        if (route != null) onOpenRoute(route);
      },
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );
    for (final entry in notificationChannels.entries) {
      await _androidImpl?.createNotificationChannel(
        AndroidNotificationChannel(entry.key, entry.value, importance: Importance.high),
      );
    }
    _initialized = true;
  }

  @override
  Future<String?> launchRoute() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (!(details?.didNotificationLaunchApp ?? false)) return null;
    final response = details!.notificationResponse;
    if (response?.actionId == _snoozeAction) return null;
    return _decode(response?.payload)?['route'] as String?;
  }

  @override
  Future<NotificationPermission> permission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final enabled = await _androidImpl?.areNotificationsEnabled();
      return enabled == null
          ? NotificationPermission.unknown
          : (enabled ? NotificationPermission.granted : NotificationPermission.denied);
    }
    final ios = await _iosImpl?.checkPermissions();
    if (ios == null) return NotificationPermission.unknown;
    return ios.isEnabled ? NotificationPermission.granted : NotificationPermission.denied;
  }

  @override
  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _androidImpl?.requestNotificationsPermission() ?? false;
    }
    return await _iosImpl?.requestPermissions(alert: true, badge: false, sound: true) ?? false;
  }

  @override
  Future<tz.Location> localLocation() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      return tz.getLocation(info.identifier);
    } catch (e) {
      appLogger.w('Zona waktu perangkat tidak dikenali, memakai Asia/Jakarta: $e');
      return tz.getLocation('Asia/Jakarta');
    }
  }

  @override
  Future<Set<int>> pendingIds() async =>
      (await _plugin.pendingNotificationRequests()).map((p) => p.id).toSet();

  @override
  Future<void> schedule(ScheduledNotification n) => _plugin.zonedSchedule(
    id: n.id,
    scheduledDate: n.when,
    notificationDetails: _details(n.channel),
    // Jadwal tidak presisi: tanpa izin exact alarm (OS boleh menunda sedikit).
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: n.title,
    body: n.body,
    payload: _payload(n.route, n.channel, n.title, n.body),
  );

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<void> openSystemSettings() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _androidImpl?.openAppNotificationSettings();
    } else {
      await _iosImpl?.openAppNotificationSettings();
    }
  }

  @override
  Future<void> showTest({required String title, required String body}) => _plugin.show(
    id: 1,
    title: title,
    body: body,
    notificationDetails: _details('test', snooze: false),
    payload: _payload('/home', 'test', title, body),
  );
}
