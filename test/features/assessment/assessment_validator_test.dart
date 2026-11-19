import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/features/assessment/domain/entities/assessment_data.dart';
import 'package:musclecoach/features/assessment/domain/validators/assessment_validator.dart';

import '../../fixtures/assessment_fixtures.dart';

typedef I = AssessmentIssue;

void main() {
  Set<I> issues(int step, AssessmentData d, {bool consent = false}) =>
      AssessmentValidator.validateStep(step, d, now: testNow, consentGiven: consent);

  test('assessment lengkap valid di semua langkah', () {
    for (var i = 0; i < AssessmentValidator.stepCount - 1; i++) {
      expect(issues(i, completeAssessment), isEmpty, reason: 'langkah $i');
    }
    expect(issues(6, completeAssessment, consent: true), isEmpty);
    expect(
      AssessmentValidator.firstInvalidStep(completeAssessment, now: testNow, consentGiven: true),
      isNull,
    );
  });

  test('assessment kosong: field wajib dilaporkan per langkah', () {
    const empty = AssessmentData();
    expect(issues(0, empty), {
      I.birthDateRequired,
      I.sexRequired,
      I.heightRequired,
      I.weightRequired,
    });
    expect(issues(1, empty), {I.goalRequired, I.targetWeeksRequired});
    expect(issues(2, empty), {I.levelRequired, I.trainingAgeRequired, I.sessionsRequired});
    expect(issues(3, empty), {
      I.trainingDaysRequired,
      I.sessionMinutesRequired,
      I.locationRequired,
      I.equipmentRequired,
    });
    expect(issues(4, empty), {I.activityRequired, I.occupationRequired, I.sleepRequired});
    // Jumlah makan punya default 3.
    expect(issues(5, empty), {I.dietRequired, I.cookingRequired});
    expect(issues(6, empty), {I.consentRequired});
    expect(AssessmentValidator.firstInvalidStep(empty, now: testNow), 0);
  });

  test('usia 16–90 tahun, dihitung dari tanggal lahir', () {
    AssessmentData withBirth(String d) =>
        completeAssessment.copyWith(profile: completeAssessment.profile.copyWith(birthDate: d));
    expect(issues(0, withBirth('2010-11-19')), isEmpty); // tepat 16
    expect(issues(0, withBirth('2010-11-20')), {I.ageOutOfRange}); // 15
    expect(issues(0, withBirth('1930-01-01')), {I.ageOutOfRange});
    expect(AssessmentValidator.ageOn('1996-05-10', testNow), 30);
    expect(AssessmentValidator.ageOn('bukan-tanggal', testNow), isNull);
  });

  test('batas angka sama dengan server', () {
    final p = completeAssessment.profile;
    expect(issues(0, completeAssessment.copyWith(profile: p.copyWith(heightCm: 119))), {
      I.heightOutOfRange,
    });
    expect(issues(0, completeAssessment.copyWith(profile: p.copyWith(weightKg: 251))), {
      I.weightOutOfRange,
    });
    final g = completeAssessment.goal;
    expect(issues(1, completeAssessment.copyWith(goal: g.copyWith(targetWeeks: 3))), {
      I.targetWeeksOutOfRange,
    });
    expect(issues(1, completeAssessment.copyWith(goal: g.copyWith(targetWeightKg: null))), isEmpty);
    final a = completeAssessment.activity;
    expect(issues(4, completeAssessment.copyWith(activity: a.copyWith(sleepHours: 2))), {
      I.sleepOutOfRange,
    });
  });

  test('peralatan: wajib dumbbell/barbell; beban maks. hanya dicek bila alat dipilih', () {
    final av = completeAssessment.availability;
    AssessmentData withEq(EquipmentSelection e, {double? db, double? bb}) =>
        completeAssessment.copyWith(
          availability: av.copyWith(equipment: e, dumbbellMaxKg: db, barbellMaxKg: bb),
        );
    expect(issues(3, withEq(const EquipmentSelection(bench: true, rack: true))), {
      I.equipmentRequired,
    });
    expect(issues(3, withEq(const EquipmentSelection(dumbbell: true), db: 500)), {
      I.dumbbellMaxOutOfRange,
    });
    // Barbell tidak dipilih → beban barbell diabaikan.
    expect(issues(3, withEq(const EquipmentSelection(dumbbell: true), bb: 1)), isEmpty);
  });

  test('normalizeAssessment membuang beban alat yang tidak dimiliki', () {
    final n = normalizeAssessment(completeAssessment);
    expect(n.availability.dumbbellMaxKg, 24);
    expect(n.availability.barbellMaxKg, isNull);
  });

  test('assessmentPayload: trim, string kosong → null, hari diurutkan, nilai JSON server', () {
    final json = assessmentPayload(normalizeAssessment(completeAssessment));
    final profile = json['profile']! as Map<String, Object?>;
    expect(profile['nickname'], 'Budi');
    expect(profile['sex'], 'male');
    final goal = json['goal']! as Map<String, Object?>;
    expect(goal['primary'], 'muscle_gain');
    final exp = json['experience']! as Map<String, Object?>;
    expect(exp['trainingAge'], 'lt_6m');
    expect(exp['knownExercises'], isNull);
    final av = json['availability']! as Map<String, Object?>;
    expect(av['trainingDays'], [1, 3, 5]);
    expect(av['equipment'], {
      'dumbbell': true,
      'barbell': false,
      'bench': true,
      'rack': false,
      'pullUpBar': false,
    });
    final safety = json['safety']! as Map<String, Object?>;
    expect(safety['medicalFlags'], isEmpty);
    expect(json.keys.toSet(), {
      'profile',
      'goal',
      'experience',
      'availability',
      'activity',
      'nutrition',
      'safety',
    });
  });

  test('round-trip JSON draft', () {
    final json = completeAssessment.toJson();
    expect(AssessmentData.fromJson(json), completeAssessment);
    const flags = SafetySection(
      medicalFlags: [MedicalFlag.eatingDisorderHistory],
      redFlags: [RedFlag.unusualBreathlessness],
    );
    expect(flags.toJson()['medicalFlags'], ['eating_disorder_history']);
    expect(flags.toJson()['redFlags'], ['unusual_breathlessness']);
  });
}
