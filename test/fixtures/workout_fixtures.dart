import 'package:musclecoach/features/workout/domain/entities/workout.dart';

const gobletSquat = PlannedExercise(
  exerciseId: 'goblet_squat',
  name: 'Goblet Squat',
  sets: 3,
  repMin: 8,
  repMax: 12,
  loadType: 'total',
  restSec: 120,
  rirMin: 2,
  rirMax: 3,
);

const dbPress = PlannedExercise(
  exerciseId: 'dumbbell_bench_press',
  name: 'Dumbbell Bench Press',
  sets: 3,
  repMin: 8,
  repMax: 12,
  loadType: 'per_hand',
  restSec: 120,
  rirMin: 2,
  rirMax: 3,
  priority: true,
);

const plank = PlannedExercise(
  exerciseId: 'plank',
  name: 'Plank',
  sets: 2,
  repMin: 20,
  repMax: 40,
  repUnit: 'seconds',
  loadType: 'bodyweight',
  restSec: 60,
  rirMin: 2,
  rirMax: 3,
);

const dayA = PlanDay(
  id: 'd1',
  order: 0,
  weekday: 4,
  focus: 'full_body_a',
  warmupMinutes: 8,
  estimatedMinutes: 40,
  exercises: [gobletSquat, dbPress, plank],
);

const dayB = PlanDay(
  id: 'd2',
  order: 1,
  weekday: 6,
  focus: 'full_body_b',
  warmupMinutes: 8,
  estimatedMinutes: 40,
  exercises: [gobletSquat],
);

const activePlan = WorkoutPlan(
  id: 'p1',
  status: PlanStatus.active,
  split: 'full_body',
  level: 'beginner',
  daysPerWeek: 2,
  sessionMinutes: 45,
  warnings: ['review_injuries'],
);

const session = WorkoutSession(
  id: 's1',
  planId: 'p1',
  dayId: 'd1',
  date: '2026-11-19',
  weekday: 4,
  focus: 'full_body_a',
  status: SessionStatus.inProgress,
  planned: [gobletSquat, dbPress, plank],
);

SetLog doneSet(int index, int number, {double? kg, int reps = 10, int? rir}) => SetLog(
  id: 'set-$index-$number',
  exerciseId: session.planned[index].exerciseId,
  exerciseIndex: index,
  setNumber: number,
  weightKg: kg,
  reps: reps,
  rir: rir,
  status: SetStatus.done,
);
