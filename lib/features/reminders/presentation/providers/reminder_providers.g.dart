// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

final class NotificationServiceProvider
    extends $FunctionalProvider<NotificationService, NotificationService, NotificationService>
    with $Provider<NotificationService> {
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() => r'426c0d018ccdaf957148c03b10466f7bee3dacac';

@ProviderFor(notificationSettingsRepository)
final notificationSettingsRepositoryProvider = NotificationSettingsRepositoryProvider._();

final class NotificationSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationSettingsRepository,
          NotificationSettingsRepository,
          NotificationSettingsRepository
        >
    with $Provider<NotificationSettingsRepository> {
  NotificationSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationSettingsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificationSettingsRepository create(Ref ref) {
    return notificationSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSettingsRepository>(value),
    );
  }
}

String _$notificationSettingsRepositoryHash() => r'ea0643408a72d0ff2570650ab496a2afb1ccbcbd';

@ProviderFor(notificationSettings)
final notificationSettingsProvider = NotificationSettingsProvider._();

final class NotificationSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationSettings>,
          NotificationSettings,
          Stream<NotificationSettings>
        >
    with $FutureModifier<NotificationSettings>, $StreamProvider<NotificationSettings> {
  NotificationSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsHash();

  @$internal
  @override
  $StreamProviderElement<NotificationSettings> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<NotificationSettings> create(Ref ref) {
    return notificationSettings(ref);
  }
}

String _$notificationSettingsHash() => r'056b977877d0efbe44306ab63b9997624d17a95d';

@ProviderFor(reminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

final class ReminderSchedulerProvider
    extends $FunctionalProvider<ReminderScheduler, ReminderScheduler, ReminderScheduler>
    with $Provider<ReminderScheduler> {
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<ReminderScheduler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReminderScheduler create(Ref ref) {
    return reminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderScheduler>(value),
    );
  }
}

String _$reminderSchedulerHash() => r'd63b264097ab4fd67a75f73f283d9d1b45da2c9c';

/// Hasil rekonsiliasi terakhir (jumlah terjadwal & status izin) untuk UI.

@ProviderFor(ReminderStatus)
final reminderStatusProvider = ReminderStatusProvider._();

/// Hasil rekonsiliasi terakhir (jumlah terjadwal & status izin) untuk UI.
final class ReminderStatusProvider extends $NotifierProvider<ReminderStatus, ReconcileResult?> {
  /// Hasil rekonsiliasi terakhir (jumlah terjadwal & status izin) untuk UI.
  ReminderStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderStatusHash();

  @$internal
  @override
  ReminderStatus create() => ReminderStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReconcileResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReconcileResult?>(value),
    );
  }
}

String _$reminderStatusHash() => r'237e62124fe7ac851e39cd05f15b78af6eb37787';

/// Hasil rekonsiliasi terakhir (jumlah terjadwal & status izin) untuk UI.

abstract class _$ReminderStatus extends $Notifier<ReconcileResult?> {
  ReconcileResult? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReconcileResult?, ReconcileResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReconcileResult?, ReconcileResult?>,
              ReconcileResult?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
