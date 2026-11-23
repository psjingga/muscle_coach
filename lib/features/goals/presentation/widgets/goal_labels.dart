import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/goal.dart';

extension GoalLabels on AppLocalizations {
  String goalReason(GoalReason r, Goal g) => goalReasonFor(r, g.evaluation, g.startWeightKg);

  String goalReasonFor(GoalReason r, GoalEvaluation e, double startKg) {
    final maxKg = startKg * e.maxWeeklyGainPct / 100;
    return switch (r) {
      GoalReason.targetBelowCurrent => reasonTargetBelowCurrent,
      GoalReason.rateTooFast => reasonRateTooFast(
        Fmt.two(e.weeklyChangeKg ?? 0),
        Fmt.two(maxKg),
        Fmt.two(e.maxWeeklyGainPct),
      ),
      GoalReason.recompositionWeightChange => reasonRecomposition(Fmt.signed(e.deltaKg ?? 0)),
    };
  }

  /// Penjelasan mengapa batas laju diperketat; `null` bila tidak konservatif.
  String? conservativeNote(SafetyAssessment s) {
    if (!s.conservative) return null;
    const medical = {
      SafetyWarning.pregnant,
      SafetyWarning.chronicCondition,
      SafetyWarning.eatingDisorderHistory,
      SafetyWarning.injuryRecovery,
      SafetyWarning.medication,
    };
    final reasons = [
      if (s.warnings.contains(SafetyWarning.lowBmi)) conservativeReasonLowBmi,
      if (s.warnings.contains(SafetyWarning.minorAge)) conservativeReasonMinor,
      if (s.warnings.any(medical.contains)) conservativeReasonMedical,
    ];
    return reasons.isEmpty ? null : conservativeLimitNote(reasons.join(', '));
  }

  String safetyWarning(SafetyWarning w, Goal g) => switch (w) {
    SafetyWarning.redFlagSymptoms => warningRedFlag,
    SafetyWarning.minorAge => warningMinorAge,
    SafetyWarning.lowBmi => warningLowBmi(Fmt.one(g.bmi)),
    SafetyWarning.highBmi => warningHighBmi(Fmt.one(g.bmi)),
    SafetyWarning.pregnant => warningPregnant,
    SafetyWarning.chronicCondition => warningChronic,
    SafetyWarning.eatingDisorderHistory => warningEatingDisorder,
    SafetyWarning.injuryRecovery => warningInjuryRecovery,
    SafetyWarning.medication => warningMedication,
  };

  String kcalOf(NumRange r) => r.isSingle
      ? kcalValue(Fmt.integer(r.min))
      : kcalRangeValue(Fmt.integer(r.min), Fmt.integer(r.max));
}
