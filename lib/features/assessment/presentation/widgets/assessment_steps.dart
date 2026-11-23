import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../application/assessment_wizard_controller.dart';
import '../../../../core/database/database_providers.dart';
import '../../domain/entities/assessment_data.dart';
import '../../domain/validators/assessment_validator.dart';
import 'assessment_labels.dart';
import 'form_fields.dart';

typedef _I = AssessmentIssue;

/// Isi satu langkah wizard. Widget hanya menampilkan & meneruskan input ke
/// controller; validasi ada di `AssessmentValidator`.
class AssessmentStepView extends ConsumerWidget {
  const AssessmentStepView({super.key, required this.state});

  final AssessmentWizardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(assessmentWizardProvider.notifier);
    final issues = state.showErrors ? c.issuesFor(state) : const <AssessmentIssue>{};
    final now = ref.read(clockProvider)();
    final args = _StepArgs(state.data, issues, c, now);
    return switch (state.step) {
      0 => _ProfileStep(args),
      1 => _GoalStep(args),
      2 => _ExperienceStep(args),
      3 => _AvailabilityStep(args),
      4 => _ActivityStep(args),
      5 => _NutritionStep(args),
      _ => _SafetyStep(args, state),
    };
  }
}

class _StepArgs {
  const _StepArgs(this.data, this.issues, this.c, this.now);

  final AssessmentData data;
  final Set<AssessmentIssue> issues;
  final AssessmentWizard c;
  final DateTime now;
}

class _ProfileStep extends StatelessWidget {
  const _ProfileStep(this.a);

  final _StepArgs a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = a.data.profile;
    void set(ProfileSection Function(ProfileSection) f) =>
        a.c.edit((d) => d.copyWith(profile: f(d.profile)));
    final birth = p.birthDate == null ? null : DateTime.tryParse(p.birthDate!);
    final age = p.birthDate == null ? null : AssessmentValidator.ageOn(p.birthDate!, a.now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextInput(
          label: l.fieldNickname,
          value: p.nickname,
          maxLength: 40,
          maxLines: 1,
          onChanged: (v) => set((s) => s.copyWith(nickname: v)),
        ),
        DateInput(
          label: l.fieldBirthDate,
          hint: l.birthDateHint,
          value: birth,
          helper: age == null ? null : l.ageYears(age),
          error: l.issueFor(a.issues, [_I.birthDateRequired, _I.ageOutOfRange]),
          initialDate: DateTime(a.now.year - 25, a.now.month, a.now.day),
          firstDate: DateTime(a.now.year - AssessmentValidator.maxAge - 1),
          lastDate: DateTime(a.now.year - AssessmentValidator.minAge, a.now.month, a.now.day),
          onChanged: (d) => set((s) => s.copyWith(birthDate: Fmt.toIsoDate(d))),
        ),
        ChoiceGroup<Sex>(
          label: l.fieldSex,
          helper: l.sexHelp,
          options: Sex.values,
          labelOf: l.sex,
          selected: p.sex,
          error: l.issueFor(a.issues, [_I.sexRequired]),
          onSelected: (v) => set((s) => s.copyWith(sex: v)),
        ),
        NumberInput(
          label: l.fieldHeight,
          unit: l.unitCm,
          value: p.heightCm,
          error: l.issueFor(a.issues, [_I.heightRequired, _I.heightOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(heightCm: v?.toDouble())),
        ),
        NumberInput(
          label: l.fieldWeight,
          unit: l.unitKg,
          value: p.weightKg,
          error: l.issueFor(a.issues, [_I.weightRequired, _I.weightOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(weightKg: v?.toDouble())),
        ),
      ],
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep(this.a);

  final _StepArgs a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final g = a.data.goal;
    void set(GoalSection Function(GoalSection) f) => a.c.edit((d) => d.copyWith(goal: f(d.goal)));
    final weeks = g.targetWeeks;
    final targetDate = weeks == null ? null : Fmt.date(a.now.add(Duration(days: weeks * 7)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup<PrimaryGoal>(
          label: l.fieldPrimaryGoal,
          helper: l.recompositionHelp,
          options: PrimaryGoal.values,
          labelOf: l.primaryGoal,
          selected: g.primary,
          error: l.issueFor(a.issues, [_I.goalRequired]),
          onSelected: (v) => set((s) => s.copyWith(primary: v)),
        ),
        NumberInput(
          label: l.fieldTargetWeight,
          unit: l.unitKg,
          helper: l.targetWeightHelp,
          value: g.targetWeightKg,
          error: l.issueFor(a.issues, [_I.targetWeightOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(targetWeightKg: v?.toDouble())),
        ),
        NumberInput(
          label: l.fieldTargetWeeks,
          unit: l.unitWeeks,
          decimal: false,
          helper: targetDate == null ? null : l.targetWeeksHelp(targetDate),
          value: g.targetWeeks,
          error: l.issueFor(a.issues, [_I.targetWeeksRequired, _I.targetWeeksOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(targetWeeks: v?.toInt())),
        ),
        MultiChoiceGroup<MuscleGroup>(
          label: l.fieldPriorityMuscles,
          options: MuscleGroup.values,
          labelOf: l.muscle,
          selected: g.priorityMuscles,
          onChanged: (v) => set((s) => s.copyWith(priorityMuscles: v)),
        ),
        TextInput(
          label: l.fieldMotivation,
          value: g.motivation,
          onChanged: (v) => set((s) => s.copyWith(motivation: v)),
        ),
      ],
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  const _ExperienceStep(this.a);

  final _StepArgs a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = a.data.experience;
    void set(ExperienceSection Function(ExperienceSection) f) =>
        a.c.edit((d) => d.copyWith(experience: f(d.experience)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup<ExperienceLevel>(
          label: l.fieldLevel,
          options: ExperienceLevel.values,
          labelOf: l.level,
          selected: e.level,
          error: l.issueFor(a.issues, [_I.levelRequired]),
          onSelected: (v) => set((s) => s.copyWith(level: v)),
        ),
        ChoiceGroup<TrainingAge>(
          label: l.fieldTrainingAge,
          options: TrainingAge.values,
          labelOf: l.trainingAge,
          selected: e.trainingAge,
          error: l.issueFor(a.issues, [_I.trainingAgeRequired]),
          onSelected: (v) => set((s) => s.copyWith(trainingAge: v)),
        ),
        NumberInput(
          label: AssessmentValidator.sessionsOptional(e)
              ? '${l.fieldCurrentSessions} ${l.optionalSuffix}'
              : l.fieldCurrentSessions,
          unit: l.unitPerWeek,
          decimal: false,
          helper: AssessmentValidator.sessionsOptional(e) ? l.currentSessionsOptionalHelp : null,
          value: e.currentSessionsPerWeek,
          error: l.issueFor(a.issues, [_I.sessionsRequired, _I.sessionsOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(currentSessionsPerWeek: v?.toInt())),
        ),
        TextInput(
          label: l.fieldKnownExercises,
          hint: l.knownExercisesHint,
          value: e.knownExercises,
          onChanged: (v) => set((s) => s.copyWith(knownExercises: v)),
        ),
        TextInput(
          label: l.fieldWorkingWeights,
          hint: l.workingWeightsHint,
          value: e.workingWeights,
          onChanged: (v) => set((s) => s.copyWith(workingWeights: v)),
        ),
      ],
    );
  }
}

class _AvailabilityStep extends StatelessWidget {
  const _AvailabilityStep(this.a);

  final _StepArgs a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final av = a.data.availability;
    final eq = av.equipment;
    void set(AvailabilitySection Function(AvailabilitySection) f) =>
        a.c.edit((d) => d.copyWith(availability: f(d.availability)));
    void setEq(EquipmentSelection Function(EquipmentSelection) f) =>
        set((s) => s.copyWith(equipment: f(s.equipment)));
    final equipmentOptions = <(String, bool, EquipmentSelection Function(bool))>[
      (l.equipDumbbell, eq.dumbbell, (v) => eq.copyWith(dumbbell: v)),
      (l.equipBarbell, eq.barbell, (v) => eq.copyWith(barbell: v)),
      (l.equipBench, eq.bench, (v) => eq.copyWith(bench: v)),
      (l.equipRack, eq.rack, (v) => eq.copyWith(rack: v)),
      (l.equipPullUpBar, eq.pullUpBar, (v) => eq.copyWith(pullUpBar: v)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MultiChoiceGroup<int>(
          label: l.fieldTrainingDays,
          options: const [1, 2, 3, 4, 5, 6, 7],
          labelOf: l.weekday,
          selected: av.trainingDays,
          error: l.issueFor(a.issues, [_I.trainingDaysRequired]),
          onChanged: (v) => set((s) => s.copyWith(trainingDays: v)),
        ),
        ChoiceGroup<int>(
          label: l.fieldSessionMinutes,
          options: sessionMinuteOptions,
          labelOf: l.minutesValue,
          selected: av.sessionMinutes,
          error: l.issueFor(a.issues, [_I.sessionMinutesRequired]),
          onSelected: (v) => set((s) => s.copyWith(sessionMinutes: v)),
        ),
        ChoiceGroup<TrainingLocation>(
          label: l.fieldLocation,
          options: TrainingLocation.values,
          labelOf: l.location,
          selected: av.location,
          error: l.issueFor(a.issues, [_I.locationRequired]),
          onSelected: (v) => set((s) => s.copyWith(location: v)),
        ),
        FieldBlock(
          label: l.fieldEquipment,
          helper: l.equipmentHelp,
          error: l.issueFor(a.issues, [_I.equipmentRequired]),
          child: Column(
            children: [
              for (final (label, value, change) in equipmentOptions)
                CheckTile(
                  title: Text(label),
                  value: value,
                  onChanged: (v) => setEq((_) => change(v ?? false)),
                ),
            ],
          ),
        ),
        if (eq.dumbbell)
          NumberInput(
            label: l.fieldDumbbellMax,
            unit: l.unitKg,
            value: av.dumbbellMaxKg,
            error: l.issueFor(a.issues, [_I.dumbbellMaxOutOfRange]),
            onChanged: (v) => set((s) => s.copyWith(dumbbellMaxKg: v?.toDouble())),
          ),
        if (eq.barbell)
          NumberInput(
            label: l.fieldBarbellMax,
            unit: l.unitKg,
            value: av.barbellMaxKg,
            error: l.issueFor(a.issues, [_I.barbellMaxOutOfRange]),
            onChanged: (v) => set((s) => s.copyWith(barbellMaxKg: v?.toDouble())),
          ),
        TextInput(
          label: l.fieldTrainingPreferences,
          value: av.preferences,
          onChanged: (v) => set((s) => s.copyWith(preferences: v)),
        ),
      ],
    );
  }
}

class _ActivityStep extends StatelessWidget {
  const _ActivityStep(this.a);

  final _StepArgs a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ac = a.data.activity;
    void set(ActivitySection Function(ActivitySection) f) =>
        a.c.edit((d) => d.copyWith(activity: f(d.activity)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup<ActivityLevel>(
          label: l.fieldActivityLevel,
          helper: l.activityHelp,
          options: ActivityLevel.values,
          labelOf: l.activityLevel,
          selected: ac.level,
          error: l.issueFor(a.issues, [_I.activityRequired]),
          onSelected: (v) => set((s) => s.copyWith(level: v)),
        ),
        ChoiceGroup<Occupation>(
          label: l.fieldOccupation,
          options: Occupation.values,
          labelOf: l.occupation,
          selected: ac.occupation,
          error: l.issueFor(a.issues, [_I.occupationRequired]),
          onSelected: (v) => set((s) => s.copyWith(occupation: v)),
        ),
        NumberInput(
          label: l.fieldSleep,
          unit: l.unitHours,
          value: ac.sleepHours,
          error: l.issueFor(a.issues, [_I.sleepRequired, _I.sleepOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(sleepHours: v?.toDouble())),
        ),
        ChoiceGroup<StressLevel>(
          label: l.fieldStress,
          options: StressLevel.values,
          labelOf: l.stress,
          selected: ac.stress,
          // Opsional: ketuk lagi untuk membatalkan pilihan.
          onSelected: (v) => set((s) => s.copyWith(stress: s.stress == v ? null : v)),
        ),
        TextInput(
          label: l.fieldCardio,
          value: ac.cardio,
          onChanged: (v) => set((s) => s.copyWith(cardio: v)),
        ),
      ],
    );
  }
}

class _NutritionStep extends StatelessWidget {
  const _NutritionStep(this.a);

  final _StepArgs a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final n = a.data.nutrition;
    void set(NutritionSection Function(NutritionSection) f) =>
        a.c.edit((d) => d.copyWith(nutrition: f(d.nutrition)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup<Diet>(
          label: l.fieldDiet,
          options: Diet.values,
          labelOf: l.diet,
          selected: n.diet,
          error: l.issueFor(a.issues, [_I.dietRequired]),
          onSelected: (v) => set((s) => s.copyWith(diet: v)),
        ),
        ChoiceGroup<int>(
          label: l.fieldMealsPerDay,
          options: const [2, 3, 4, 5, 6],
          labelOf: (v) => '$v',
          selected: n.mealsPerDay,
          error: l.issueFor(a.issues, [_I.mealsRequired]),
          onSelected: (v) => set((s) => s.copyWith(mealsPerDay: v)),
        ),
        ChoiceGroup<Cooking>(
          label: l.fieldCooking,
          options: Cooking.values,
          labelOf: l.cooking,
          selected: n.cooking,
          error: l.issueFor(a.issues, [_I.cookingRequired]),
          onSelected: (v) => set((s) => s.copyWith(cooking: v)),
        ),
        NumberInput(
          label: l.fieldBudget,
          prefix: '${l.unitIdr} ',
          decimal: false,
          value: n.dailyBudgetIdr,
          error: l.issueFor(a.issues, [_I.budgetOutOfRange]),
          onChanged: (v) => set((s) => s.copyWith(dailyBudgetIdr: v?.toInt())),
        ),
        TextInput(
          label: l.fieldAllergies,
          value: n.allergies,
          onChanged: (v) => set((s) => s.copyWith(allergies: v)),
        ),
        TextInput(
          label: l.fieldDislikes,
          value: n.dislikes,
          onChanged: (v) => set((s) => s.copyWith(dislikes: v)),
        ),
        TextInput(
          label: l.fieldFoodPreferences,
          value: n.preferences,
          onChanged: (v) => set((s) => s.copyWith(preferences: v)),
        ),
        TextInput(
          label: l.fieldNutritionNotes,
          value: n.notes,
          onChanged: (v) => set((s) => s.copyWith(notes: v)),
        ),
        StepNote(l.foodLocationIndonesia, icon: Icons.place_outlined),
      ],
    );
  }
}

class _SafetyStep extends StatelessWidget {
  const _SafetyStep(this.a, this.state);

  final _StepArgs a;
  final AssessmentWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final sf = a.data.safety;
    void set(SafetySection Function(SafetySection) f) =>
        a.c.edit((d) => d.copyWith(safety: f(d.safety)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StepNote(l.safetyIntro, icon: Icons.lock_outline),
        TextInput(
          label: l.fieldInjuries,
          value: sf.injuries,
          onChanged: (v) => set((s) => s.copyWith(injuries: v)),
        ),
        TextInput(
          label: l.fieldAvoidedMovements,
          value: sf.avoidedMovements,
          onChanged: (v) => set((s) => s.copyWith(avoidedMovements: v)),
        ),
        CheckList<RedFlag>(
          label: l.fieldRedFlags,
          options: RedFlag.values,
          labelOf: l.redFlag,
          selected: sf.redFlags,
          onChanged: (v) => set((s) => s.copyWith(redFlags: v)),
        ),
        CheckList<MedicalFlag>(
          label: l.fieldMedicalFlags,
          helper: l.medicalFlagsHelp,
          options: MedicalFlag.values,
          labelOf: l.medicalFlag,
          selected: sf.medicalFlags,
          onChanged: (v) => set((s) => s.copyWith(medicalFlags: v)),
        ),
        const Divider(height: 32),
        FieldBlock(
          label: l.consentTitle,
          error: l.issueFor(a.issues, [_I.consentRequired]),
          child: Column(
            children: [
              CheckTile(
                title: Text(l.consentDisclaimer, style: theme.textTheme.bodyMedium),
                value: state.consentDisclaimer,
                onChanged: (v) => a.c.setConsent(disclaimer: v ?? false),
              ),
              CheckTile(
                title: Text(l.consentHealthData, style: theme.textTheme.bodyMedium),
                value: state.consentHealthData,
                onChanged: (v) => a.c.setConsent(healthData: v ?? false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
