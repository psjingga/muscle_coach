import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/network/functions_client.dart';
import '../domain/entities/workout.dart';

abstract interface class WorkoutRepository {
  Stream<WorkoutPlan?> watchPlan(String planId);
  Stream<List<PlanDay>> watchDays(String planId);

  /// Callable `createStarterPlan` → ID draft program.
  Future<String> createStarterPlan();

  /// Callable `activateWorkoutPlan`.
  Future<void> activatePlan(String planId);

  /// Buat sesi baru dengan salinan target hari tersebut → ID sesi.
  Future<String> startSession({required String planId, required PlanDay day, required String date});

  Stream<WorkoutSession?> watchSession(String sessionId);
  Stream<List<SetLog>> watchSets(String sessionId);

  /// Sesi yang sedang berjalan untuk hari program tertentu pada tanggal ini.
  Future<WorkoutSession?> findInProgress({
    required String planId,
    required String dayId,
    required String date,
  });

  Future<void> logSet(String sessionId, SetLog set);
  Future<void> deleteSet(String sessionId, String setId);

  Future<void> completeSession(String sessionId, {String? notes, int? energy, String? discomfort});

  /// Hapus sesi beserta seluruh set-nya.
  Future<void> deleteSession(String sessionId);

  /// Riwayat sesi selesai, terbaru dulu.
  Stream<List<WorkoutSession>> watchHistory({int limit = 30});

  /// Set dari sesi selesai terakhir untuk hari program yang sama.
  Future<({WorkoutSession session, List<SetLog> sets})?> lastCompleted({
    required String planId,
    required String dayId,
  });
}

class FirestoreWorkoutRepository implements WorkoutRepository {
  FirestoreWorkoutRepository(this._db, this._functions, this._uid);

  final FirebaseFirestore _db;
  final FunctionsClient _functions;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _user => _db.doc('users/$_uid');
  CollectionReference<Map<String, dynamic>> get _sessions => _user.collection('workoutSessions');

  static WorkoutSession _session(DocumentSnapshot<Map<String, dynamic>> s) =>
      WorkoutSession.fromJson(s.data()!).copyWith(id: s.id);

  static SetLog _set(DocumentSnapshot<Map<String, dynamic>> s) =>
      SetLog.fromJson(s.data()!).copyWith(id: s.id);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw FailureMapper.from(e);
    }
  }

  @override
  Stream<WorkoutPlan?> watchPlan(String planId) =>
      _user.collection('workoutPlans').doc(planId).snapshots().map((s) {
        final json = s.data();
        return json == null ? null : WorkoutPlan.fromJson(json).copyWith(id: s.id);
      });

  @override
  Stream<List<PlanDay>> watchDays(String planId) => _user
      .collection('workoutPlans/$planId/days')
      .orderBy('order')
      .snapshots()
      .map((q) => q.docs.map((d) => PlanDay.fromJson(d.data())).toList());

  @override
  Future<String> createStarterPlan() async {
    final result = await _functions.call('createStarterPlan');
    final id = result['planId'];
    if (id is! String) throw const AppFailure(FailureKind.unknown, debugMessage: 'no planId');
    return id;
  }

  @override
  Future<void> activatePlan(String planId) async {
    await _functions.call('activateWorkoutPlan', data: {'planId': planId});
  }

  @override
  Future<String> startSession({
    required String planId,
    required PlanDay day,
    required String date,
  }) => _guard(() async {
    final ref = _sessions.doc();
    // Tanpa await server: tetap tercatat saat offline lalu disinkronkan.
    final write = ref.set({
      'planId': planId,
      'dayId': day.id,
      'date': date,
      'weekday': day.weekday,
      'focus': day.focus,
      'status': 'in_progress',
      'planned': [for (final p in day.exercises) p.toJson()],
      'startedAt': FieldValue.serverTimestamp(),
      'completedAt': null,
      'notes': null,
      'energy': null,
      'discomfort': null,
      'schemaVersion': 1,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await write.timeout(const Duration(seconds: 3), onTimeout: () {});
    return ref.id;
  });

  @override
  Stream<WorkoutSession?> watchSession(String sessionId) =>
      _sessions.doc(sessionId).snapshots().map((s) => s.exists ? _session(s) : null);

  @override
  Stream<List<SetLog>> watchSets(String sessionId) =>
      _sessions.doc(sessionId).collection('sets').snapshots().map((q) => q.docs.map(_set).toList());

  @override
  Future<WorkoutSession?> findInProgress({
    required String planId,
    required String dayId,
    required String date,
  }) => _guard(() async {
    final q = await _sessions.where('date', isEqualTo: date).get();
    for (final d in q.docs) {
      final s = _session(d);
      if (s.planId == planId && s.dayId == dayId && s.status == SessionStatus.inProgress) return s;
    }
    return null;
  });

  @override
  Future<void> logSet(String sessionId, SetLog set) => _guard(() async {
    final col = _sessions.doc(sessionId).collection('sets');
    final ref = set.id.isEmpty ? col.doc() : col.doc(set.id);
    final write = ref.set({
      ...set.toJson(),
      'loggedAt': FieldValue.serverTimestamp(),
      'schemaVersion': 1,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    // UI tidak menunggu server (gym sering sinyal lemah); error tetap dilaporkan.
    await write.timeout(const Duration(seconds: 3), onTimeout: () {});
  });

  @override
  Future<void> deleteSet(String sessionId, String setId) => _guard(
    () => _sessions
        .doc(sessionId)
        .collection('sets')
        .doc(setId)
        .delete()
        .timeout(const Duration(seconds: 3), onTimeout: () {}),
  );

  @override
  Future<void> completeSession(
    String sessionId, {
    String? notes,
    int? energy,
    String? discomfort,
  }) => _guard(
    () => _sessions
        .doc(sessionId)
        .update({
          'status': 'completed',
          'completedAt': FieldValue.serverTimestamp(),
          'notes': notes,
          'energy': energy,
          'discomfort': discomfort,
          'updatedAt': FieldValue.serverTimestamp(),
        })
        .timeout(const Duration(seconds: 3), onTimeout: () {}),
  );

  @override
  Future<void> deleteSession(String sessionId) => _guard(() async {
    final ref = _sessions.doc(sessionId);
    final sets = await ref.collection('sets').get();
    final batch = _db.batch();
    for (final d in sets.docs) {
      batch.delete(d.reference);
    }
    batch.delete(ref);
    await batch.commit().timeout(const Duration(seconds: 3), onTimeout: () {});
  });

  @override
  Stream<List<WorkoutSession>> watchHistory({int limit = 30}) => _sessions
      .where('status', isEqualTo: 'completed')
      .orderBy('date', descending: true)
      .limit(limit)
      .snapshots()
      .map((q) => q.docs.map(_session).toList());

  @override
  Future<({WorkoutSession session, List<SetLog> sets})?> lastCompleted({
    required String planId,
    required String dayId,
  }) => _guard(() async {
    final q = await _sessions
        .where('planId', isEqualTo: planId)
        .where('dayId', isEqualTo: dayId)
        .where('status', isEqualTo: 'completed')
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    if (q.docs.isEmpty) return null;
    final session = _session(q.docs.first);
    final sets = await q.docs.first.reference.collection('sets').get();
    return (session: session, sets: sets.docs.map(_set).toList());
  });
}
