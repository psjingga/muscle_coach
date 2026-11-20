import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/notifications/notification_service.dart';
import 'package:musclecoach/features/reminders/application/reminder_scheduler.dart';
import 'package:musclecoach/features/reminders/data/notification_settings_repository.dart';
import 'package:musclecoach/features/reminders/domain/notification_settings.dart';
import 'package:musclecoach/features/reminders/domain/reminder_planner.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';
import 'package:musclecoach/features/workout/domain/entities/workout.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../fixtures/workout_fixtures.dart';

/// Layanan notifikasi palsu: menyimpan jadwal di memori.
class FakeNotificationService implements NotificationService {
  FakeNotificationService({this.location});

  tz.Location? location;
  NotificationPermission perm = NotificationPermission.granted;
  final scheduled = <int, ScheduledNotification>{};
  int scheduleCalls = 0;

  @override
  Future<void> init({required void Function(String route) onOpenRoute}) async {}
  @override
  Future<String?> launchRoute() async => null;
  @override
  Future<NotificationPermission> permission() async => perm;
  @override
  Future<bool> requestPermission() async => perm == NotificationPermission.granted;
  @override
  Future<tz.Location> localLocation() async => location ?? tz.getLocation('Asia/Jakarta');
  @override
  Future<Set<int>> pendingIds() async => scheduled.keys.toSet();
  @override
  Future<void> schedule(ScheduledNotification n) async {
    scheduleCalls++;
    scheduled[n.id] = n;
  }

  @override
  Future<void> cancel(int id) async => scheduled.remove(id);
  @override
  Future<void> cancelAll() async => scheduled.clear();
  int openedSettings = 0;

  @override
  Future<void> openSystemSettings() async => openedSettings++;

  @override
  Future<void> showTest({required String title, required String body}) async {}
}

void main() {
  tzdata.initializeTimeZones();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final jakarta = tz.getLocation('Asia/Jakarta');

  // Kamis 19 Nov 2026 10:00 WIB.
  final now = tz.TZDateTime(jakarta, 2026, 11, 19, 10);
  const on = NotificationSettings(enabled: true);
  const mondayDay = PlanDay(
    id: 'd1',
    order: 0,
    weekday: 1,
    focus: 'full_body_a',
    warmupMinutes: 8,
    estimatedMinutes: 40,
    exercises: [gobletSquat],
  );
  final days = [mondayDay, dayA]; // Senin & Kamis

  List<PlannedReminder> build({
    NotificationSettings settings = on,
    tz.TZDateTime? at,
    Set<String> completed = const {},
    String? planId = 'p1',
    List<PlanDay>? planDays,
    int max = ReminderPlanner.maxPending,
  }) => ReminderPlanner.build(
    settings: settings,
    now: at ?? now,
    planId: planId,
    planDays: planDays ?? days,
    completedWorkoutDates: completed,
    max: max,
  );

  group('ReminderPlanner', () {
    test('mati → tidak ada jadwal', () {
      expect(build(settings: const NotificationSettings()), isEmpty);
    });

    test('latihan hanya di hari program, jam pilihan, mulai hari ini bila belum lewat', () {
      final workouts = build().where((r) => r.category == ReminderCategory.workout).toList();
      expect(workouts.map((r) => r.when.weekday).toSet(), {1, 4});
      expect(workouts.first.when, tz.TZDateTime(jakarta, 2026, 11, 19, 17)); // hari ini 17:00
      expect(workouts.first.route, '/day/p1/d1');
      expect(workouts, hasLength(4)); // 14 hari → 2 Senin + 2 Kamis
      expect(workouts.every((r) => r.when.isAfter(now)), isTrue);
    });

    test('sesi hari ini sudah selesai → pengingat latihan hari ini tidak ada', () {
      final ws = build(completed: {'2026-11-19'})
          .where((r) => r.category == ReminderCategory.workout);
      expect(ws.any((r) => r.when.day == 19), isFalse);
      expect(ws, hasLength(3));
    });

    test('jam yang sudah lewat tidak dijadwalkan (sarapan 07:00 hari ini)', () {
      final breakfasts = build().where((r) => r.category == ReminderCategory.breakfast);
      expect(breakfasts.first.when, tz.TZDateTime(jakarta, 2026, 11, 20, 7));
    });

    test(
      'ID stabil: penjadwalan ulang menghasilkan ID sama, kategori/tanggal berbeda → ID beda',
      () {
        final a = build().map((r) => r.id).toList();
        final b = build().map((r) => r.id).toList();
        expect(a, b);
        expect(a.toSet().length, a.length);
        expect(ReminderPlanner.stableId('x'), ReminderPlanner.stableId('x'));
        expect(ReminderPlanner.stableId('x'), lessThanOrEqualTo(0x7fffffff));
      },
    );

    test('ganti program → ID pengingat latihan berubah (jadwal lama dibatalkan)', () {
      final old = build(planId: 'p1')
          .where((r) => r.category == ReminderCategory.workout)
          .map((r) => r.id);
      final next = build(planId: 'p2')
          .where((r) => r.category == ReminderCategory.workout)
          .map((r) => r.id);
      expect(old.toSet().intersection(next.toSet()), isEmpty);
    });

    test('jam tenang melewati tengah malam melewati pengingat di dalamnya', () {
      const q = QuietHours(enabled: true, start: '22:00', end: '06:00');
      expect(ReminderPlanner.inQuietHours(q, 23, 0), isTrue);
      expect(ReminderPlanner.inQuietHours(q, 5, 59), isTrue);
      expect(ReminderPlanner.inQuietHours(q, 6, 0), isFalse);
      expect(ReminderPlanner.inQuietHours(q, 21, 0), isFalse);
      const day = QuietHours(enabled: true, start: '12:00', end: '13:00');
      final s = on.copyWith(quietHours: day);
      expect(build(settings: s).any((r) => r.category == ReminderCategory.lunch), isFalse);
      expect(build(settings: s).any((r) => r.category == ReminderCategory.dinner), isTrue);
    });

    test('timbang hanya di hari terpilih; kategori nonaktif tidak dijadwalkan', () {
      final s = on.copyWith(
        weighIn: const WeeklyReminder(enabled: true, daysOfWeek: [1, 4], time: '07:00'),
        meals: on.meals.copyWith(snack: const TimedReminder(enabled: false, time: '15:00')),
      );
      final weigh = build(settings: s).where((r) => r.category == ReminderCategory.weighIn);
      expect(weigh.map((r) => r.when.weekday).toSet(), {1, 4});
      expect(build(settings: s).any((r) => r.category == ReminderCategory.snack), isFalse);
    });

    test('dibatasi maks. pending (iOS 64), prioritas yang terdekat', () {
      final limited = build(max: 10);
      final all = build();
      expect(limited, hasLength(10));
      expect(limited.map((r) => r.id), all.take(10).map((r) => r.id));
      expect(all.length, lessThanOrEqualTo(ReminderPlanner.maxPending));
    });

    test('DST: jam lokal tetap 17:00 walau zona berganti offset', () {
      final ams = tz.getLocation('Europe/Amsterdam');
      // 27 Mar 2027 (sebelum DST) → 1 Apr 2027 (setelah DST, 28 Mar).
      final at = tz.TZDateTime(ams, 2027, 3, 26, 9);
      final ws = ReminderPlanner.build(
        settings: on,
        now: at,
        planId: 'p1',
        planDays: [for (var d = 1; d <= 7; d++) mondayDay.copyWith(id: 'd$d', weekday: d)],
      ).where((r) => r.category == ReminderCategory.workout);
      expect(ws.every((r) => r.when.hour == 17 && r.when.minute == 0), isTrue);
      final offsets = ws.map((r) => r.when.timeZoneOffset).toSet();
      expect(offsets, hasLength(2)); // +1 dan +2
    });
  });

  group('NotificationSettings', () {
    test('default sesuai contoh brief & round-trip JSON', () {
      const s = NotificationSettings();
      expect(s.enabled, isFalse);
      expect(s.workout.time, '17:00');
      expect(s.weighIn.daysOfWeek, [1]);
      expect(NotificationSettings.fromJson(s.toJson()), s);
      expect(validateNotificationSettings(s), isEmpty);
    });

    test('validasi jam & hari', () {
      expect(TimeOfDayCodec.isValid('07:30'), isTrue);
      expect(TimeOfDayCodec.isValid('24:00'), isFalse);
      expect(TimeOfDayCodec.isValid('7:30'), isFalse);
      final bad = const NotificationSettings().copyWith(
        workout: const TimedReminder(enabled: true, time: '25:00'),
        weighIn: const WeeklyReminder(enabled: true, daysOfWeek: [8], time: '07:00'),
      );
      expect(validateNotificationSettings(bad), hasLength(2));
    });
  });

  group('ReminderScheduler.reconcile', () {
    late AppDatabase db;
    late NotificationSettingsRepository repo;
    late LocalWorkoutRepository workouts;
    late FakeNotificationService service;
    String? activePlan;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      DateTime clock() => now;
      repo = NotificationSettingsRepository(db, clock);
      workouts = LocalWorkoutRepository(db, clock, () async => {});
      service = FakeNotificationService();
      activePlan = null;
    });

    tearDown(() => db.close());

    ReminderScheduler scheduler() => ReminderScheduler(
      service: service,
      settings: repo,
      workouts: workouts,
      activePlanId: () async => activePlan,
      clock: () => now,
      l10n: lookupAppLocalizations(const Locale('id')),
    );

    Future<String> seedPlan() async {
      final id = await workouts.saveDraftPlan(
        PlanDraftFixture.draft(days),
        source: 'template',
        generatorVersion: 't',
      );
      return id;
    }

    test('mati → semua jadwal dibatalkan', () async {
      service.scheduled[123] = ScheduledNotification(
        id: 123,
        channel: 'meals',
        when: now,
        title: '',
        body: '',
        route: '/',
      );
      final r = await scheduler().reconcile();
      expect(r.scheduled, 0);
      expect(service.scheduled, isEmpty);
    });

    test('rekonsiliasi berulang tidak membuat duplikat; teks dilokalkan', () async {
      await repo.save(on);
      activePlan = await seedPlan();
      final first = await scheduler().reconcile();
      final count = service.scheduled.length;
      await scheduler().reconcile();
      expect(service.scheduled.length, count);
      expect(first.scheduled, count);
      final workout = service.scheduled.values.firstWhere((n) => n.channel == 'workout');
      expect(workout.title, startsWith('Waktunya latihan: '));
      expect(workout.route, startsWith('/day/$activePlan/'));
      expect((await repo.read()).timezone, 'Asia/Jakarta');
    });

    test('sesi selesai → pengingat sesi hari itu dibatalkan, kategori lain tetap', () async {
      await repo.save(on);
      activePlan = await seedPlan();
      await scheduler().reconcile();
      bool todayWorkout() =>
          service.scheduled.values.any((n) => n.channel == 'workout' && n.when.day == 19);
      final meals = service.scheduled.values.where((n) => n.channel == 'meals').length;
      expect(todayWorkout(), isTrue);

      final planDays = await workouts.watchDays(activePlan!).first;
      final thursday = planDays.firstWhere((d) => d.weekday == 4);
      final sessionId = await workouts.startSession(
        planId: activePlan!,
        day: thursday,
        date: '2026-11-19',
      );
      await workouts.completeSession(sessionId);
      await scheduler().reconcile();
      expect(todayWorkout(), isFalse);
      expect(service.scheduled.values.where((n) => n.channel == 'meals').length, meals);
    });

    test('program berubah → jadwal latihan lama dibatalkan, tanpa sisa', () async {
      await repo.save(on);
      activePlan = await seedPlan();
      await scheduler().reconcile();
      final oldIds = service.scheduled.values
          .where((n) => n.channel == 'workout')
          .map((n) => n.id)
          .toSet();
      activePlan = await seedPlan();
      final r = await scheduler().reconcile();
      expect(r.cancelled, oldIds.length);
      expect(service.scheduled.keys.toSet().intersection(oldIds), isEmpty);
    });

    test('izin ditolak → tidak menjadwalkan (tidak dianggap berhasil)', () async {
      await repo.save(on);
      service.perm = NotificationPermission.denied;
      final r = await scheduler().reconcile();
      expect(r.scheduled, 0);
      expect(r.permission, NotificationPermission.denied);
      expect(service.scheduleCalls, 0);
    });
  });
}
