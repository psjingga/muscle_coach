import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/goal.dart';

extension GoalLabels on AppLocalizations {
  String goalReason(GoalReason r, Goal g) {
    final e = g.evaluation;
    final maxKg = g.startWeightKg * e.maxWeeklyGainPct / 100;
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
