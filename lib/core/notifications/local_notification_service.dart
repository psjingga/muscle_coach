import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
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

/// Bunyi khusus per kategori (nama file tanpa ekstensi). File ada di
/// `android/app/src/main/res/raw/` dan `assets/sounds/` (disalin ke
/// `Library/Sounds` di iOS saat init).
const _channelSounds = {'workout': 'workout_reminder'};

/// Bunyi kanal Android tidak bisa diubah setelah kanal dibuat, jadi kanal
/// berbunyi khusus memakai ID baru; kanal lama dihapus saat init.
const _androidChannelIds = {'workout': 'workout_bell'};

String _androidChannelId(String channel) => _androidChannelIds[channel] ?? channel;

AndroidNotificationSound? _androidSound(String channel) => switch (_channelSounds[channel]) {
  final name? => RawResourceAndroidNotificationSound(name),
  null => null,
};

String? _iosSound(String channel) => switch (_channelSounds[channel]) {
  final name? => '$name.wav',
  null => null,
};

/// iOS hanya memutar bunyi notifikasi dari bundel aplikasi atau
/// `Library/Sounds`; aset Flutter disalin ke sana.
Future<void> _installIosSounds() async {
  try {
    final dir = Directory('${(await getLibraryDirectory()).path}/Sounds');
    await dir.create(recursive: true);
    for (final name in _channelSounds.values) {
      final file = File('${dir.path}/$name.wav');
      final data = await rootBundle.load('assets/sounds/$name.wav');
      if (await file.exists() && await file.length() == data.lengthInBytes) continue;
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    }
  } catch (e) {
    appLogger.w('Bunyi notifikasi iOS gagal dipasang: ${e.runtimeType}');
  }
}

const _snoozeAction = 'snooze';
const _doneAction = 'done';
const _snoozeMinutes = 10;

/// Kanal yang punya aksi "Tandai selesai".
const _doneChannels = {'check_in'};

AndroidNotificationDetails _android(String channel, {bool snooze = true}) {
  final actions = [
    if (snooze) const AndroidNotificationAction(_snoozeAction, 'Tunda $_snoozeMinutes menit'),
    if (_doneChannels.contains(channel))
      const AndroidNotificationAction(_doneAction, 'Tandai selesai'),
  ];
  return AndroidNotificationDetails(
    _androidChannelId(channel),
    notificationChannels[channel] ?? channel,
    sound: _androidSound(channel),
    importance: Importance.high,
    priority: Priority.high,
    category: AndroidNotificationCategory.reminder,
    actions: actions.isEmpty ? null : actions,
  );
}

NotificationDetails _details(String channel, {bool snooze = true}) => NotificationDetails(
  android: _android(channel, snooze: snooze),
  iOS: DarwinNotificationDetails(sound: _iosSound(channel)),
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

/// Tanggal check-in (`YYYY-MM-DD`) dari payload notifikasi check-in.
String? checkInDateOf(String? payload) {
  final route = _decode(payload)?['route'] as String?;
  final m = RegExp(r'^/check-in/(\d{4}-\d{2}-\d{2})$').firstMatch(route ?? '');
  return m?.group(1);
}

/// Dipanggil saat "Tandai selesai" pada notifikasi check-in ditekan.
typedef CheckInDoneHandler = Future<void> Function(String date);

/// "Tandai selesai": batalkan tunda yang mungkin menyusul, lalu catat.
Future<void> _done(
  FlutterLocalNotificationsPlugin plugin,
  NotificationResponse r,
  CheckInDoneHandler? onCheckInDone,
) async {
  if (r.id != null) await plugin.cancel(id: snoozeIdFor(r.id!));
  final date = checkInDateOf(r.payload);
  if (date != null) await onCheckInDone?.call(date);
}

/// Aksi notifikasi saat aplikasi tertutup (isolate latar belakang, Android).
/// Fitur membungkus fungsi ini dalam handler `@pragma('vm:entry-point')`
/// sendiri untuk menyediakan [onCheckInDone].
Future<void> handleNotificationActionInBackground(
  NotificationResponse response, {
  CheckInDoneHandler? onCheckInDone,
}) async {
  if (response.actionId != _snoozeAction && response.actionId != _doneAction) return;
  tzdata.initializeTimeZones();
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(),
    ),
  );
  if (response.actionId == _snoozeAction) {
    await _snooze(plugin, response);
  } else {
    await _done(plugin, response, onCheckInDone);
  }
}

/// Handler latar belakang bawaan (hanya "Tunda").
@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(NotificationResponse response) =>
    handleNotificationActionInBackground(response);

class LocalNotificationService implements NotificationService {
  LocalNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    this.backgroundHandler = notificationBackgroundHandler,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// Harus fungsi top-level ber-`@pragma('vm:entry-point')`.
  final DidReceiveBackgroundNotificationResponseCallback backgroundHandler;
  bool _initialized = false;

  AndroidFlutterLocalNotificationsPlugin? get _androidImpl =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _iosImpl =>
      _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  @override
  Future<void> init({
    required void Function(String route) onOpenRoute,
    CheckInDoneHandler? onCheckInDone,
  }) async {
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
        if (r.actionId == _doneAction) {
          await _done(_plugin, r, onCheckInDone);
          return;
        }
        final route = _decode(r.payload)?['route'] as String?;
        if (route != null) onOpenRoute(route);
      },
      onDidReceiveBackgroundNotificationResponse: backgroundHandler,
    );
    final android = _androidImpl;
    if (android != null) {
      for (final entry in notificationChannels.entries) {
        await android.createNotificationChannel(
          AndroidNotificationChannel(
            _androidChannelId(entry.key),
            entry.value,
            importance: Importance.high,
            sound: _androidSound(entry.key),
            playSound: true,
          ),
        );
      }
      // Kanal lama tanpa bunyi khusus.
      for (final old in _androidChannelIds.keys) {
        await android.deleteNotificationChannel(channelId: old);
      }
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) await _installIosSounds();
    _initialized = true;
  }

  @override
  Future<String?> launchRoute() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (!(details?.didNotificationLaunchApp ?? false)) return null;
    final response = details!.notificationResponse;
    if (response?.actionId == _snoozeAction || response?.actionId == _doneAction) return null;
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
