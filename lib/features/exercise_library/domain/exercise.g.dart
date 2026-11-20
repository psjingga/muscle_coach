// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: json['id'] as String,
  name: json['name'] as String,
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  primaryMuscles:
      (json['primaryMuscles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  secondaryMuscles:
      (json['secondaryMuscles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  pattern: json['pattern'] as String,
  equipment:
      (json['equipment'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  level: json['level'] as String,
  compound: json['compound'] as bool? ?? false,
  repUnit: json['repUnit'] as String? ?? 'reps',
  loadType: json['loadType'] as String? ?? 'total',
  instructions:
      (json['instructions'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  mistakes:
      (json['mistakes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  safety: (json['safety'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  needsSpotter: json['needsSpotter'] as bool? ?? false,
  alternatives:
      (json['alternatives'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  videoUrl: json['videoUrl'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'aliases': instance.aliases,
  'primaryMuscles': instance.primaryMuscles,
  'secondaryMuscles': instance.secondaryMuscles,
  'pattern': instance.pattern,
  'equipment': instance.equipment,
  'level': instance.level,
  'compound': instance.compound,
  'repUnit': instance.repUnit,
  'loadType': instance.loadType,
  'instructions': instance.instructions,
  'mistakes': instance.mistakes,
  'safety': instance.safety,
  'needsSpotter': instance.needsSpotter,
  'alternatives': instance.alternatives,
  'videoUrl': instance.videoUrl,
  'images': instance.images,
};
