import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/app/theme/app_theme.dart';
import 'package:musclecoach/core/database/app_database.dart';
import 'package:musclecoach/core/notifications/notification_service.dart';
import 'package:musclecoach/features/profile/domain/entities/user_profile.dart';
import 'package:musclecoach/features/profile/presentation/providers/profile_providers.dart';
import 'package:musclecoach/features/reminders/data/notification_settings_repository.dart';
import 'package:musclecoach/features/reminders/domain/notification_settings.dart';
import 'package:musclecoach/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:musclecoach/features/reminders/presentation/screens/notification_settings_screen.dart';
import 'package:musclecoach/l10n/gen/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'reminders_test.dart' show FakeNotificationService;

/// Repository preferensi di memori (DB tidak pernah dibuka → tanpa timer drift).
class MemorySettingsRepository extends NotificationSettingsRepository {
  MemorySettingsRepository() : super(AppDatabase(NativeDatabase.memory()), DateTime.now);

  NotificationSettings current = const NotificationSettings();
  final _changes = StreamController<NotificationSettings>.broadcast();

  @override
  Stream<NotificationSettings> watch() async* {
    yield current;
    yield* _changes.stream;
  }

  @override
  Future<NotificationSettings> read() async => current;

  @override
  Future<void> save(NotificationSettings settings) async {
    current = settings;
    _changes.add(settings);
  }
}

void main() {
  tzdata.initializeTimeZones();

  late MemorySettingsRepository repo;
  late FakeNotificationService service;

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    repo = MemorySettingsRepository();
    service = FakeNotificationService()..perm = NotificationPermission.denied;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationSettingsRepositoryProvider.overrideWithValue(repo),
          notificationServiceProvider.overrideWithValue(service),
          userProfileProvider.overrideWith(
            (ref) => Stream<UserProfile?>.value(const UserProfile()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const NotificationSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder master() => find.byKey(const ValueKey('reminders-master'));
  bool masterOn(WidgetTester t) => t.widget<SwitchListTile>(master()).value;

  testWidgets('izin diminta setelah penjelasan + contoh jadwal; ditolak → tidak aktif', (
    tester,
  ) async {
    await pump(tester);
    expect(masterOn(tester), isFalse);
    // Belum pernah diminta → jangan langsung bilang "ditolak".
    expect(find.textContaining('Izin notifikasi ditolak'), findsNothing);
    // Pengaturan kategori terkunci selama saklar utama mati.
    expect(
      tester.widget<SwitchListTile>(find.byKey(const ValueKey('reminder-workout'))).onChanged,
      isNull,
    );

    await tester.tap(master());
    await tester.pumpAndSettle();
    expect(find.text('Izinkan notifikasi?'), findsOneWidget);
    expect(find.textContaining('Contoh: latihan'), findsOneWidget);
    await tester.tap(find.text('Izinkan'));
    await tester.pumpAndSettle();

    // OS menolak (fake) → tidak dianggap aktif, tampilkan panduan ke pengaturan sistem.
    expect(masterOn(tester), isFalse);
    expect(repo.current.enabled, isFalse);
    expect(find.textContaining('Izin notifikasi ditolak'), findsOneWidget);
    expect(find.text('Buka pengaturan sistem'), findsOneWidget);
    await tester.tap(find.text('Buka pengaturan sistem'));
    await tester.pumpAndSettle();
    expect(service.openedSettings, 1);
  });

  testWidgets('izin sudah diberikan (mis. dari pengaturan sistem) → langsung aktif', (
    tester,
  ) async {
    await pump(tester);
    service.perm = NotificationPermission.granted;
    await tester.tap(master());
    await tester.pumpAndSettle();
    expect(find.text('Izinkan notifikasi?'), findsNothing);
    expect(masterOn(tester), isTrue);
    expect(repo.current.enabled, isTrue);
    expect(find.textContaining('Aktifkan program latihan'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('reminder-workout')));
    await tester.pumpAndSettle();
    expect(repo.current.workout.enabled, isFalse);
  });

  testWidgets('pengingat aktif tetapi izin dicabut di sistem → peringatan tampil', (tester) async {
    await pump(tester);
    await repo.save(repo.current.copyWith(enabled: true));
    await tester.pumpAndSettle();
    expect(masterOn(tester), isFalse);
    expect(find.textContaining('Izin notifikasi ditolak'), findsOneWidget);
  });
}
