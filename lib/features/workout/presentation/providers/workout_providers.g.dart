// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// keepAlive: repository memegang closure pembaca katalog yang dipakai
/// setelah operasi async — `ref` milik provider autoDispose bisa sudah mati.

@ProviderFor(workoutRepository)
final workoutRepositoryProvider = WorkoutRepositoryProvider._();

/// keepAlive: repository memegang closure pembaca katalog yang dipakai
/// setelah operasi async — `ref` milik provider autoDispose bisa sudah mati.

final class WorkoutRepositoryProvider
    extends $FunctionalProvider<WorkoutRepository, WorkoutRepository, WorkoutRepository>
    with $Provider<WorkoutRepository> {
  /// keepAlive: repository memegang closure pembaca katalog yang dipakai
  /// setelah operasi async — `ref` milik provider autoDispose bisa sudah mati.
  WorkoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkoutRepository create(Ref ref) {
    return workoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutRepository>(value),
    );
  }
}

String _$workoutRepositoryHash() => r'47dd9606ccd1309be8236268e9b4a1b83f0e4a03';

@ProviderFor(workoutPlan)
final workoutPlanProvider = WorkoutPlanFamily._();

final class WorkoutPlanProvider
    extends $FunctionalProvider<AsyncValue<WorkoutPlan?>, WorkoutPlan?, Stream<WorkoutPlan?>>
    with $FutureModifier<WorkoutPlan?>, $StreamProvider<WorkoutPlan?> {
  WorkoutPlanProvider._({required WorkoutPlanFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'workoutPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutPlanHash();

  @override
  String toString() {
    return r'workoutPlanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<WorkoutPlan?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<WorkoutPlan?> create(Ref ref) {
    final argument = this.argument as String;
    return workoutPlan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutPlanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutPlanHash() => r'8aa43205e86c39d74a0cb42efc15834816e21c73';

final class WorkoutPlanFamily extends $Family
    with $FunctionalFamilyOverride<Stream<WorkoutPlan?>, String> {
  WorkoutPlanFamily._()
    : super(
        retry: null,
        name: r'workoutPlanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkoutPlanProvider call(String planId) => WorkoutPlanProvider._(argument: planId, from: this);

  @override
  String toString() => r'workoutPlanProvider';
}

@ProviderFor(planDays)
final planDaysProvider = PlanDaysFamily._();

final class PlanDaysProvider
    extends $FunctionalProvider<AsyncValue<List<PlanDay>>, List<PlanDay>, Stream<List<PlanDay>>>
    with $FutureModifier<List<PlanDay>>, $StreamProvider<List<PlanDay>> {
  PlanDaysProvider._({required PlanDaysFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'planDaysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planDaysHash();

  @override
  String toString() {
    return r'planDaysProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PlanDay>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<PlanDay>> create(Ref ref) {
    final argument = this.argument as String;
    return planDays(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlanDaysProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$planDaysHash() => r'9a4e194f6c9e4256f8b0b11f9e5947fe56327eb9';

final class PlanDaysFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PlanDay>>, String> {
  PlanDaysFamily._()
    : super(
        retry: null,
        name: r'planDaysProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlanDaysProvider call(String planId) => PlanDaysProvider._(argument: planId, from: this);

  @override
  String toString() => r'planDaysProvider';
}

/// ID program aktif dari profil.

@ProviderFor(activePlanId)
final activePlanIdProvider = ActivePlanIdProvider._();

/// ID program aktif dari profil.

final class ActivePlanIdProvider extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// ID program aktif dari profil.
  ActivePlanIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePlanIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePlanIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return activePlanId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }
}

String _$activePlanIdHash() => r'e187e086719aa248999975d6ab0083ba78a5c268';

@ProviderFor(workoutSession)
final workoutSessionProvider = WorkoutSessionFamily._();

final class WorkoutSessionProvider
    extends
        $FunctionalProvider<AsyncValue<WorkoutSession?>, WorkoutSession?, Stream<WorkoutSession?>>
    with $FutureModifier<WorkoutSession?>, $StreamProvider<WorkoutSession?> {
  WorkoutSessionProvider._({
    required WorkoutSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workoutSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutSessionHash();

  @override
  String toString() {
    return r'workoutSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<WorkoutSession?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<WorkoutSession?> create(Ref ref) {
    final argument = this.argument as String;
    return workoutSession(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutSessionHash() => r'20b2e184f40c0568964c7bb6cca1e00f3f760f76';

final class WorkoutSessionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<WorkoutSession?>, String> {
  WorkoutSessionFamily._()
    : super(
        retry: null,
        name: r'workoutSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkoutSessionProvider call(String sessionId) =>
      WorkoutSessionProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'workoutSessionProvider';
}

@ProviderFor(sessionSets)
final sessionSetsProvider = SessionSetsFamily._();

final class SessionSetsProvider
    extends $FunctionalProvider<AsyncValue<List<SetLog>>, List<SetLog>, Stream<List<SetLog>>>
    with $FutureModifier<List<SetLog>>, $StreamProvider<List<SetLog>> {
  SessionSetsProvider._({required SessionSetsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'sessionSetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionSetsHash();

  @override
  String toString() {
    return r'sessionSetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SetLog>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<SetLog>> create(Ref ref) {
    final argument = this.argument as String;
    return sessionSets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionSetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionSetsHash() => r'aaa8edc7cbe3209277b5b01076d34e8669fa592d';

final class SessionSetsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SetLog>>, String> {
  SessionSetsFamily._()
    : super(
        retry: null,
        name: r'sessionSetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionSetsProvider call(String sessionId) =>
      SessionSetsProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionSetsProvider';
}

@ProviderFor(workoutHistory)
final workoutHistoryProvider = WorkoutHistoryProvider._();

final class WorkoutHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutSession>>,
          List<WorkoutSession>,
          Stream<List<WorkoutSession>>
        >
    with $FutureModifier<List<WorkoutSession>>, $StreamProvider<List<WorkoutSession>> {
  WorkoutHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<WorkoutSession>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutSession>> create(Ref ref) {
    return workoutHistory(ref);
  }
}

String _$workoutHistoryHash() => r'8fbd96197ba3a60fdc91045a8bd14cc5e5cc7d65';

/// Sesi hari ini (berjalan/selesai) untuk kartu latihan di Beranda.

@ProviderFor(todaySessions)
final todaySessionsProvider = TodaySessionsProvider._();

/// Sesi hari ini (berjalan/selesai) untuk kartu latihan di Beranda.

final class TodaySessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutSession>>,
          List<WorkoutSession>,
          Stream<List<WorkoutSession>>
        >
    with $FutureModifier<List<WorkoutSession>>, $StreamProvider<List<WorkoutSession>> {
  /// Sesi hari ini (berjalan/selesai) untuk kartu latihan di Beranda.
  TodaySessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaySessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaySessionsHash();

  @$internal
  @override
  $StreamProviderElement<List<WorkoutSession>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutSession>> create(Ref ref) {
    return todaySessions(ref);
  }
}

String _$todaySessionsHash() => r'89132085375707747b055da5a19359b2d2611972';

/// Hasil sesi selesai terakhir untuk hari program yang sama ("Terakhir: …").

@ProviderFor(lastPerformance)
final lastPerformanceProvider = LastPerformanceFamily._();

/// Hasil sesi selesai terakhir untuk hari program yang sama ("Terakhir: …").

final class LastPerformanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<({WorkoutSession session, List<SetLog> sets})?>,
          ({WorkoutSession session, List<SetLog> sets})?,
          FutureOr<({WorkoutSession session, List<SetLog> sets})?>
        >
    with
        $FutureModifier<({WorkoutSession session, List<SetLog> sets})?>,
        $FutureProvider<({WorkoutSession session, List<SetLog> sets})?> {
  /// Hasil sesi selesai terakhir untuk hari program yang sama ("Terakhir: …").
  LastPerformanceProvider._({
    required LastPerformanceFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'lastPerformanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lastPerformanceHash();

  @override
  String toString() {
    return r'lastPerformanceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<({WorkoutSession session, List<SetLog> sets})?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({WorkoutSession session, List<SetLog> sets})?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return lastPerformance(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LastPerformanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lastPerformanceHash() => r'07effd691e69b9ef6cc8506b78f1147e98b10b80';

/// Hasil sesi selesai terakhir untuk hari program yang sama ("Terakhir: …").

final class LastPerformanceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({WorkoutSession session, List<SetLog> sets})?>,
          (String, String)
        > {
  LastPerformanceFamily._()
    : super(
        retry: null,
        name: r'lastPerformanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hasil sesi selesai terakhir untuk hari program yang sama ("Terakhir: …").

  LastPerformanceProvider call(String planId, String dayId) =>
      LastPerformanceProvider._(argument: (planId, dayId), from: this);

  @override
  String toString() => r'lastPerformanceProvider';
}

/// Aksi program & sesi. `state` = status aksi terakhir (untuk tombol/snackbar).

@ProviderFor(WorkoutActions)
final workoutActionsProvider = WorkoutActionsProvider._();

/// Aksi program & sesi. `state` = status aksi terakhir (untuk tombol/snackbar).
final class WorkoutActionsProvider extends $AsyncNotifierProvider<WorkoutActions, void> {
  /// Aksi program & sesi. `state` = status aksi terakhir (untuk tombol/snackbar).
  WorkoutActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutActionsHash();

  @$internal
  @override
  WorkoutActions create() => WorkoutActions();
}

String _$workoutActionsHash() => r'246f7828b790603f197870a0a1c5c81923dc0ea6';

/// Aksi program & sesi. `state` = status aksi terakhir (untuk tombol/snackbar).

abstract class _$WorkoutActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Pencatatan set dalam satu sesi + timer istirahat.

@ProviderFor(SessionLogger)
final sessionLoggerProvider = SessionLoggerFamily._();

/// Pencatatan set dalam satu sesi + timer istirahat.
final class SessionLoggerProvider extends $NotifierProvider<SessionLogger, RestTimer?> {
  /// Pencatatan set dalam satu sesi + timer istirahat.
  SessionLoggerProvider._({required SessionLoggerFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'sessionLoggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionLoggerHash();

  @override
  String toString() {
    return r'sessionLoggerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SessionLogger create() => SessionLogger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RestTimer? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RestTimer?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is SessionLoggerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionLoggerHash() => r'0025aec0d6442b53fcf732d5e2a2aba23e599a08';

/// Pencatatan set dalam satu sesi + timer istirahat.

final class SessionLoggerFamily extends $Family
    with $ClassFamilyOverride<SessionLogger, RestTimer?, RestTimer?, RestTimer?, String> {
  SessionLoggerFamily._()
    : super(
        retry: null,
        name: r'sessionLoggerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Pencatatan set dalam satu sesi + timer istirahat.

  SessionLoggerProvider call(String sessionId) =>
      SessionLoggerProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionLoggerProvider';
}

/// Pencatatan set dalam satu sesi + timer istirahat.

abstract class _$SessionLogger extends $Notifier<RestTimer?> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  RestTimer? build(String sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RestTimer?, RestTimer?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RestTimer?, RestTimer?>,
              RestTimer?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
