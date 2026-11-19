import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/entities/workout.dart';

/// Label latihan, program, otot, dan alat.
extension WorkoutLabels on AppLocalizations {
  String focus(String code) => switch (code) {
    'full_body_a' => focusFullBodyA,
    'full_body_b' => focusFullBodyB,
    'full_body_c' => focusFullBodyC,
    'upper_a' => focusUpperA,
    'upper_b' => focusUpperB,
    'lower_a' => focusLowerA,
    'lower_b' => focusLowerB,
    _ => code,
  };

  String split(String code) => code == 'upper_lower' ? splitUpperLower : splitFullBody;

  String weekdayLong(int isoDay) => switch (isoDay) {
    1 => weekdayLong1,
    2 => weekdayLong2,
    3 => weekdayLong3,
    4 => weekdayLong4,
    5 => weekdayLong5,
    6 => weekdayLong6,
    _ => weekdayLong7,
  };

  String? planWarning(String code) => switch (code) {
    'review_injuries' => planWarningReviewInjuries,
    'days_reduced' => planWarningDaysReduced,
    'limited_equipment' => planWarningLimitedEquipment,
    'spotter_or_safeties' => planWarningSpotter,
    'consecutive_muscle_overlap' => planWarningConsecutive,
    _ => null,
  };

  String muscleCode(String code) => switch (code) {
    'chest' => muscleChest,
    'upper_back' => muscleUpperBack,
    'lats' => muscleLats,
    'traps' => muscleTraps,
    'front_delts' => muscleFrontDelts,
    'side_delts' => muscleSideDelts,
    'rear_delts' => muscleRearDelts,
    'biceps' => muscleBiceps,
    'triceps' => muscleTriceps,
    'forearms' => muscleForearms,
    'quads' => muscleQuads,
    'hamstrings' => muscleHamstrings,
    'glutes' => muscleGlutes,
    'adductors' => muscleAdductors,
    'calves' => muscleCalves,
    'core' => muscleCore,
    _ => code,
  };

  String equipmentCode(String code) => switch (code) {
    'dumbbell' => equipDumbbell,
    'barbell' => equipBarbell,
    'bench' => equipBench,
    'rack' => equipRack,
    'pull_up_bar' => equipPullUpBar,
    _ => code,
  };

  String levelCode(String code) => switch (code) {
    'beginner' => levelBeginner,
    'intermediate' => levelIntermediate,
    'advanced' => levelAdvanced,
    _ => code,
  };

  /// "2 mnt" / "75 dtk"
  String duration(int seconds) => seconds >= 60 && seconds % 60 == 0
      ? minutesShortValue(seconds ~/ 60)
      : (seconds > 60
            ? '${minutesShortValue(seconds ~/ 60)} ${secondsValue(seconds % 60)}'
            : secondsValue(seconds));

  String prescriptionOf(PlannedExercise p) => p.isTimed
      ? prescriptionTimed(p.sets, p.repMin, p.repMax)
      : prescription(p.sets, p.repMin, p.repMax);

  String restRirOf(PlannedExercise p) => restAndRir(duration(p.restSec), p.rirMin, p.rirMax);

  String weightLabel(PlannedExercise p) => switch (p.loadType) {
    'per_hand' => weightLabelPerHand,
    'bodyweight' => weightLabelBodyweight,
    _ => weightLabelTotal,
  };

  /// "20 kg × 10", "× 30 dtk", "20 kg × 10 · RIR 2", "dilewati"
  String setSummary(SetLog s, PlannedExercise? p) {
    if (s.status == SetStatus.skipped) return setSkipped;
    final amount = (p?.isTimed ?? false) ? secondsValue(s.reps) : '${s.reps}';
    final weight = s.weightKg == null ? '' : '${kgValue(Fmt.one(s.weightKg!))} ';
    final rir = s.rir == null ? '' : ' · RIR ${s.rir}';
    return '$weight× $amount$rir';
  }
}
