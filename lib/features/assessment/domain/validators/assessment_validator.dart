import '../entities/assessment_data.dart';

/// Masalah input per field. Pesan diterjemahkan di presentation.
enum AssessmentIssue {
  birthDateRequired,
  ageOutOfRange,
  sexRequired,
  heightRequired,
  heightOutOfRange,
  weightRequired,
  weightOutOfRange,
  goalRequired,
  targetWeightOutOfRange,
  targetWeeksRequired,
  targetWeeksOutOfRange,
  levelRequired,
  trainingAgeRequired,
  sessionsRequired,
  sessionsOutOfRange,
  trainingDaysRequired,
  sessionMinutesRequired,
  locationRequired,
  equipmentRequired,
  dumbbellMaxOutOfRange,
  barbellMaxOutOfRange,
  activityRequired,
  occupationRequired,
  sleepRequired,
  sleepOutOfRange,
  dietRequired,
  mealsRequired,
  cookingRequired,
  budgetOutOfRange,
  consentRequired,
}

/// Validator terpusat wizard assessment. Batas sama dengan skema server
/// (`functions/src/assessment/schema.ts`).
abstract final class AssessmentValidator {
  static const stepCount = 7;

  /// Indeks langkah "Tujuan" (target berat & waktu).
  static const goalStep = 1;

  static const minAge = 16;
  static const maxAge = 90;
  static const heightRange = (min: 120.0, max: 230.0);
  static const weightRange = (min: 35.0, max: 250.0);
  static const targetWeeksRange = (min: 4, max: 104);
  static const sessionsRange = (min: 0, max: 14);
  static const dumbbellRange = (min: 1.0, max: 100.0);
  static const barbellRange = (min: 10.0, max: 500.0);
  static const sleepRange = (min: 3.0, max: 14.0);
  static const maxBudgetIdr = 10000000;

  static bool _outside(num v, ({num min, num max}) r) => v < r.min || v > r.max;

  /// Usia penuh pada [now] dari `YYYY-MM-DD`; `null` bila format salah.
  static int? ageOn(String birthDate, DateTime now) {
    final d = DateTime.tryParse(birthDate);
    if (d == null) return null;
    var age = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) age--;
    return age;
  }

  static Set<AssessmentIssue> validateStep(
    int step,
    AssessmentData data, {
    required DateTime now,
    bool consentGiven = false,
  }) => switch (step) {
    0 => _profile(data.profile, now),
    1 => _goal(data.goal),
    2 => _experience(data.experience),
    3 => _availability(data.availability),
    4 => _activity(data.activity),
    5 => _nutrition(data.nutrition),
    6 => {if (!consentGiven) AssessmentIssue.consentRequired},
    _ => throw RangeError.range(step, 0, stepCount - 1),
  };

  /// Langkah pertama yang belum valid, atau `null` bila semua lengkap.
  static int? firstInvalidStep(
    AssessmentData data, {
    required DateTime now,
    bool consentGiven = false,
  }) {
    for (var i = 0; i < stepCount; i++) {
      if (validateStep(i, data, now: now, consentGiven: consentGiven).isNotEmpty) return i;
    }
    return null;
  }

  static Set<AssessmentIssue> _profile(ProfileSection p, DateTime now) {
    final issues = <AssessmentIssue>{};
    final birth = p.birthDate;
    if (birth == null) {
      issues.add(AssessmentIssue.birthDateRequired);
    } else {
      final age = ageOn(birth, now);
      if (age == null || age < minAge || age > maxAge) issues.add(AssessmentIssue.ageOutOfRange);
    }
    if (p.sex == null) issues.add(AssessmentIssue.sexRequired);
    switch (p.heightCm) {
      case null:
        issues.add(AssessmentIssue.heightRequired);
      case final h when _outside(h, heightRange):
        issues.add(AssessmentIssue.heightOutOfRange);
    }
    switch (p.weightKg) {
      case null:
        issues.add(AssessmentIssue.weightRequired);
      case final w when _outside(w, weightRange):
        issues.add(AssessmentIssue.weightOutOfRange);
    }
    return issues;
  }

  static Set<AssessmentIssue> _goal(GoalSection g) => {
    if (g.primary == null) AssessmentIssue.goalRequired,
    if (g.targetWeightKg case final t? when _outside(t, weightRange))
      AssessmentIssue.targetWeightOutOfRange,
    if (g.targetWeeks == null)
      AssessmentIssue.targetWeeksRequired
    else if (_outside(g.targetWeeks!, targetWeeksRange))
      AssessmentIssue.targetWeeksOutOfRange,
  };

  static Set<AssessmentIssue> _experience(ExperienceSection e) => {
    if (e.level == null) AssessmentIssue.levelRequired,
    if (e.trainingAge == null) AssessmentIssue.trainingAgeRequired,
    if (e.currentSessionsPerWeek == null)
      AssessmentIssue.sessionsRequired
    else if (_outside(e.currentSessionsPerWeek!, sessionsRange))
      AssessmentIssue.sessionsOutOfRange,
  };

  static Set<AssessmentIssue> _availability(AvailabilitySection a) => {
    if (a.trainingDays.isEmpty) AssessmentIssue.trainingDaysRequired,
    if (a.sessionMinutes == null || !sessionMinuteOptions.contains(a.sessionMinutes))
      AssessmentIssue.sessionMinutesRequired,
    if (a.location == null) AssessmentIssue.locationRequired,
    if (!a.equipment.dumbbell && !a.equipment.barbell) AssessmentIssue.equipmentRequired,
    if (a.equipment.dumbbell &&
        a.dumbbellMaxKg != null &&
        _outside(a.dumbbellMaxKg!, dumbbellRange))
      AssessmentIssue.dumbbellMaxOutOfRange,
    if (a.equipment.barbell && a.barbellMaxKg != null && _outside(a.barbellMaxKg!, barbellRange))
      AssessmentIssue.barbellMaxOutOfRange,
  };

  static Set<AssessmentIssue> _activity(ActivitySection a) => {
    if (a.level == null) AssessmentIssue.activityRequired,
    if (a.occupation == null) AssessmentIssue.occupationRequired,
    if (a.sleepHours == null)
      AssessmentIssue.sleepRequired
    else if (_outside(a.sleepHours!, sleepRange))
      AssessmentIssue.sleepOutOfRange,
  };

  static Set<AssessmentIssue> _nutrition(NutritionSection n) => {
    if (n.diet == null) AssessmentIssue.dietRequired,
    if (n.mealsPerDay == null) AssessmentIssue.mealsRequired,
    if (n.cooking == null) AssessmentIssue.cookingRequired,
    if (n.dailyBudgetIdr case final b? when b < 0 || b > maxBudgetIdr)
      AssessmentIssue.budgetOutOfRange,
  };
}

/// Bersihkan data yang tidak relevan sebelum dikirim (mis. beban maks.
/// dumbbell padahal tidak punya dumbbell).
AssessmentData normalizeAssessment(AssessmentData d) => d.copyWith(
  availability: d.availability.copyWith(
    dumbbellMaxKg: d.availability.equipment.dumbbell ? d.availability.dumbbellMaxKg : null,
    barbellMaxKg: d.availability.equipment.barbell ? d.availability.barbellMaxKg : null,
  ),
);
