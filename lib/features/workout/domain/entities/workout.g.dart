// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlannedExercise _$PlannedExerciseFromJson(Map<String, dynamic> json) => _PlannedExercise(
  exerciseId: json['exerciseId'] as String,
  name: json['name'] as String,
  sets: (json['sets'] as num).toInt(),
  repMin: (json['repMin'] as num).toInt(),
  repMax: (json['repMax'] as num).toInt(),
  repUnit: json['repUnit'] as String? ?? 'reps',
  loadType: json['loadType'] as String? ?? 'total',
  restSec: (json['restSec'] as num).toInt(),
  rirMin: (json['rirMin'] as num).toInt(),
  rirMax: (json['rirMax'] as num).toInt(),
  priority: json['priority'] as bool? ?? false,
);

Map<String, dynamic> _$PlannedExerciseToJson(_PlannedExercise instance) => <String, dynamic>{
  'exerciseId': instance.exerciseId,
  'name': instance.name,
  'sets': instance.sets,
  'repMin': instance.repMin,
  'repMax': instance.repMax,
  'repUnit': instance.repUnit,
  'loadType': instance.loadType,
  'restSec': instance.restSec,
  'rirMin': instance.rirMin,
  'rirMax': instance.rirMax,
  'priority': instance.priority,
};

_PlanDay _$PlanDayFromJson(Map<String, dynamic> json) => _PlanDay(
  id: json['id'] as String,
  order: (json['order'] as num).toInt(),
  weekday: (json['weekday'] as num).toInt(),
  focus: json['focus'] as String,
  warmupMinutes: (json['warmupMinutes'] as num).toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => PlannedExercise.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlanDayToJson(_PlanDay instance) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'weekday': instance.weekday,
  'focus': instance.focus,
  'warmupMinutes': instance.warmupMinutes,
  'estimatedMinutes': instance.estimatedMinutes,
  'exercises': instance.exercises.map((e) => e.toJson()).toList(),
};

_WorkoutPlan _$WorkoutPlanFromJson(Map<String, dynamic> json) => _WorkoutPlan(
  status: $enumDecode(_$PlanStatusEnumMap, json['status']),
  source: json['source'] as String? ?? 'template',
  split: json['split'] as String,
  level: json['level'] as String,
  daysPerWeek: (json['daysPerWeek'] as num).toInt(),
  sessionMinutes: (json['sessionMinutes'] as num).toInt(),
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$WorkoutPlanToJson(_WorkoutPlan instance) => <String, dynamic>{
  'status': _$PlanStatusEnumMap[instance.status]!,
  'source': instance.source,
  'split': instance.split,
  'level': instance.level,
  'daysPerWeek': instance.daysPerWeek,
  'sessionMinutes': instance.sessionMinutes,
  'warnings': instance.warnings,
};

const _$PlanStatusEnumMap = {
  PlanStatus.draft: 'draft',
  PlanStatus.active: 'active',
  PlanStatus.archived: 'archived',
};

_WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) => _WorkoutSession(
  planId: json['planId'] as String,
  dayId: json['dayId'] as String,
  date: json['date'] as String,
  weekday: (json['weekday'] as num).toInt(),
  focus: json['focus'] as String,
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  planned: (json['planned'] as List<dynamic>)
      .map((e) => PlannedExercise.fromJson(e as Map<String, dynamic>))
      .toList(),
  notes: json['notes'] as String?,
  energy: (json['energy'] as num?)?.toInt(),
  discomfort: json['discomfort'] as String?,
);

Map<String, dynamic> _$WorkoutSessionToJson(_WorkoutSession instance) => <String, dynamic>{
  'planId': instance.planId,
  'dayId': instance.dayId,
  'date': instance.date,
  'weekday': instance.weekday,
  'focus': instance.focus,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'planned': instance.planned.map((e) => e.toJson()).toList(),
  'notes': instance.notes,
  'energy': instance.energy,
  'discomfort': instance.discomfort,
};

const _$SessionStatusEnumMap = {
  SessionStatus.inProgress: 'in_progress',
  SessionStatus.completed: 'completed',
  SessionStatus.skipped: 'skipped',
};

_SetLog _$SetLogFromJson(Map<String, dynamic> json) => _SetLog(
  exerciseId: json['exerciseId'] as String,
  exerciseIndex: (json['exerciseIndex'] as num).toInt(),
  setNumber: (json['setNumber'] as num).toInt(),
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  reps: (json['reps'] as num).toInt(),
  rir: (json['rir'] as num?)?.toInt(),
  status: $enumDecode(_$SetStatusEnumMap, json['status']),
);

Map<String, dynamic> _$SetLogToJson(_SetLog instance) => <String, dynamic>{
  'exerciseId': instance.exerciseId,
  'exerciseIndex': instance.exerciseIndex,
  'setNumber': instance.setNumber,
  'weightKg': instance.weightKg,
  'reps': instance.reps,
  'rir': instance.rir,
  'status': _$SetStatusEnumMap[instance.status]!,
};

const _$SetStatusEnumMap = {SetStatus.done: 'done', SetStatus.skipped: 'skipped'};
