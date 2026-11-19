// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfileStateTable extends ProfileState with TableInfo<$ProfileStateTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompletedMeta = const VerificationMeta(
    'onboardingCompleted',
  );
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeGoalIdMeta = const VerificationMeta('activeGoalId');
  @override
  late final GeneratedColumn<String> activeGoalId = GeneratedColumn<String>(
    'active_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeNutritionTargetIdMeta = const VerificationMeta(
    'activeNutritionTargetId',
  );
  @override
  late final GeneratedColumn<String> activeNutritionTargetId = GeneratedColumn<String>(
    'active_nutrition_target_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latestAssessmentIdMeta = const VerificationMeta(
    'latestAssessmentId',
  );
  @override
  late final GeneratedColumn<String> latestAssessmentId = GeneratedColumn<String>(
    'latest_assessment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeWorkoutPlanIdMeta = const VerificationMeta(
    'activeWorkoutPlanId',
  );
  @override
  late final GeneratedColumn<String> activeWorkoutPlanId = GeneratedColumn<String>(
    'active_workout_plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    onboardingCompleted,
    activeGoalId,
    activeNutritionTargetId,
    latestAssessmentId,
    activeWorkoutPlanId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('active_goal_id')) {
      context.handle(
        _activeGoalIdMeta,
        activeGoalId.isAcceptableOrUnknown(data['active_goal_id']!, _activeGoalIdMeta),
      );
    }
    if (data.containsKey('active_nutrition_target_id')) {
      context.handle(
        _activeNutritionTargetIdMeta,
        activeNutritionTargetId.isAcceptableOrUnknown(
          data['active_nutrition_target_id']!,
          _activeNutritionTargetIdMeta,
        ),
      );
    }
    if (data.containsKey('latest_assessment_id')) {
      context.handle(
        _latestAssessmentIdMeta,
        latestAssessmentId.isAcceptableOrUnknown(
          data['latest_assessment_id']!,
          _latestAssessmentIdMeta,
        ),
      );
    }
    if (data.containsKey('active_workout_plan_id')) {
      context.handle(
        _activeWorkoutPlanIdMeta,
        activeWorkoutPlanId.isAcceptableOrUnknown(
          data['active_workout_plan_id']!,
          _activeWorkoutPlanIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      activeGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_goal_id'],
      ),
      activeNutritionTargetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_nutrition_target_id'],
      ),
      latestAssessmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latest_assessment_id'],
      ),
      activeWorkoutPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_workout_plan_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfileStateTable createAlias(String alias) {
    return $ProfileStateTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String? displayName;
  final bool onboardingCompleted;
  final String? activeGoalId;
  final String? activeNutritionTargetId;
  final String? latestAssessmentId;
  final String? activeWorkoutPlanId;
  final DateTime updatedAt;
  const ProfileRow({
    required this.id,
    this.displayName,
    required this.onboardingCompleted,
    this.activeGoalId,
    this.activeNutritionTargetId,
    this.latestAssessmentId,
    this.activeWorkoutPlanId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    if (!nullToAbsent || activeGoalId != null) {
      map['active_goal_id'] = Variable<String>(activeGoalId);
    }
    if (!nullToAbsent || activeNutritionTargetId != null) {
      map['active_nutrition_target_id'] = Variable<String>(activeNutritionTargetId);
    }
    if (!nullToAbsent || latestAssessmentId != null) {
      map['latest_assessment_id'] = Variable<String>(latestAssessmentId);
    }
    if (!nullToAbsent || activeWorkoutPlanId != null) {
      map['active_workout_plan_id'] = Variable<String>(activeWorkoutPlanId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfileStateCompanion toCompanion(bool nullToAbsent) {
    return ProfileStateCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent ? const Value.absent() : Value(displayName),
      onboardingCompleted: Value(onboardingCompleted),
      activeGoalId: activeGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeGoalId),
      activeNutritionTargetId: activeNutritionTargetId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeNutritionTargetId),
      latestAssessmentId: latestAssessmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(latestAssessmentId),
      activeWorkoutPlanId: activeWorkoutPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeWorkoutPlanId),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      onboardingCompleted: serializer.fromJson<bool>(json['onboardingCompleted']),
      activeGoalId: serializer.fromJson<String?>(json['activeGoalId']),
      activeNutritionTargetId: serializer.fromJson<String?>(json['activeNutritionTargetId']),
      latestAssessmentId: serializer.fromJson<String?>(json['latestAssessmentId']),
      activeWorkoutPlanId: serializer.fromJson<String?>(json['activeWorkoutPlanId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'activeGoalId': serializer.toJson<String?>(activeGoalId),
      'activeNutritionTargetId': serializer.toJson<String?>(activeNutritionTargetId),
      'latestAssessmentId': serializer.toJson<String?>(latestAssessmentId),
      'activeWorkoutPlanId': serializer.toJson<String?>(activeWorkoutPlanId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileRow copyWith({
    int? id,
    Value<String?> displayName = const Value.absent(),
    bool? onboardingCompleted,
    Value<String?> activeGoalId = const Value.absent(),
    Value<String?> activeNutritionTargetId = const Value.absent(),
    Value<String?> latestAssessmentId = const Value.absent(),
    Value<String?> activeWorkoutPlanId = const Value.absent(),
    DateTime? updatedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    activeGoalId: activeGoalId.present ? activeGoalId.value : this.activeGoalId,
    activeNutritionTargetId: activeNutritionTargetId.present
        ? activeNutritionTargetId.value
        : this.activeNutritionTargetId,
    latestAssessmentId: latestAssessmentId.present
        ? latestAssessmentId.value
        : this.latestAssessmentId,
    activeWorkoutPlanId: activeWorkoutPlanId.present
        ? activeWorkoutPlanId.value
        : this.activeWorkoutPlanId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRow copyWithCompanion(ProfileStateCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present ? data.displayName.value : this.displayName,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      activeGoalId: data.activeGoalId.present ? data.activeGoalId.value : this.activeGoalId,
      activeNutritionTargetId: data.activeNutritionTargetId.present
          ? data.activeNutritionTargetId.value
          : this.activeNutritionTargetId,
      latestAssessmentId: data.latestAssessmentId.present
          ? data.latestAssessmentId.value
          : this.latestAssessmentId,
      activeWorkoutPlanId: data.activeWorkoutPlanId.present
          ? data.activeWorkoutPlanId.value
          : this.activeWorkoutPlanId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('activeGoalId: $activeGoalId, ')
          ..write('activeNutritionTargetId: $activeNutritionTargetId, ')
          ..write('latestAssessmentId: $latestAssessmentId, ')
          ..write('activeWorkoutPlanId: $activeWorkoutPlanId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    onboardingCompleted,
    activeGoalId,
    activeNutritionTargetId,
    latestAssessmentId,
    activeWorkoutPlanId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.activeGoalId == this.activeGoalId &&
          other.activeNutritionTargetId == this.activeNutritionTargetId &&
          other.latestAssessmentId == this.latestAssessmentId &&
          other.activeWorkoutPlanId == this.activeWorkoutPlanId &&
          other.updatedAt == this.updatedAt);
}

class ProfileStateCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String?> displayName;
  final Value<bool> onboardingCompleted;
  final Value<String?> activeGoalId;
  final Value<String?> activeNutritionTargetId;
  final Value<String?> latestAssessmentId;
  final Value<String?> activeWorkoutPlanId;
  final Value<DateTime> updatedAt;
  const ProfileStateCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.activeGoalId = const Value.absent(),
    this.activeNutritionTargetId = const Value.absent(),
    this.latestAssessmentId = const Value.absent(),
    this.activeWorkoutPlanId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProfileStateCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.activeGoalId = const Value.absent(),
    this.activeNutritionTargetId = const Value.absent(),
    this.latestAssessmentId = const Value.absent(),
    this.activeWorkoutPlanId = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<bool>? onboardingCompleted,
    Expression<String>? activeGoalId,
    Expression<String>? activeNutritionTargetId,
    Expression<String>? latestAssessmentId,
    Expression<String>? activeWorkoutPlanId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (onboardingCompleted != null) 'onboarding_completed': onboardingCompleted,
      if (activeGoalId != null) 'active_goal_id': activeGoalId,
      if (activeNutritionTargetId != null) 'active_nutrition_target_id': activeNutritionTargetId,
      if (latestAssessmentId != null) 'latest_assessment_id': latestAssessmentId,
      if (activeWorkoutPlanId != null) 'active_workout_plan_id': activeWorkoutPlanId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProfileStateCompanion copyWith({
    Value<int>? id,
    Value<String?>? displayName,
    Value<bool>? onboardingCompleted,
    Value<String?>? activeGoalId,
    Value<String?>? activeNutritionTargetId,
    Value<String?>? latestAssessmentId,
    Value<String?>? activeWorkoutPlanId,
    Value<DateTime>? updatedAt,
  }) {
    return ProfileStateCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      activeGoalId: activeGoalId ?? this.activeGoalId,
      activeNutritionTargetId: activeNutritionTargetId ?? this.activeNutritionTargetId,
      latestAssessmentId: latestAssessmentId ?? this.latestAssessmentId,
      activeWorkoutPlanId: activeWorkoutPlanId ?? this.activeWorkoutPlanId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (activeGoalId.present) {
      map['active_goal_id'] = Variable<String>(activeGoalId.value);
    }
    if (activeNutritionTargetId.present) {
      map['active_nutrition_target_id'] = Variable<String>(activeNutritionTargetId.value);
    }
    if (latestAssessmentId.present) {
      map['latest_assessment_id'] = Variable<String>(latestAssessmentId.value);
    }
    if (activeWorkoutPlanId.present) {
      map['active_workout_plan_id'] = Variable<String>(activeWorkoutPlanId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileStateCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('activeGoalId: $activeGoalId, ')
          ..write('activeNutritionTargetId: $activeNutritionTargetId, ')
          ..write('latestAssessmentId: $latestAssessmentId, ')
          ..write('activeWorkoutPlanId: $activeWorkoutPlanId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AssessmentsTable extends Assessments with TableInfo<$AssessmentsTable, AssessmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consentVersionMeta = const VerificationMeta('consentVersion');
  @override
  late final GeneratedColumn<String> consentVersion = GeneratedColumn<String>(
    'consent_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta('schemaVersion');
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    step,
    data,
    consentVersion,
    schemaVersion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssessmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('step')) {
      context.handle(_stepMeta, step.isAcceptableOrUnknown(data['step']!, _stepMeta));
    }
    if (data.containsKey('data')) {
      context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('consent_version')) {
      context.handle(
        _consentVersionMeta,
        consentVersion.isAcceptableOrUnknown(data['consent_version']!, _consentVersionMeta),
      );
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(data['schema_version']!, _schemaVersionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      step: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}step'])!,
      data: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      consentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consent_version'],
      ),
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AssessmentsTable createAlias(String alias) {
    return $AssessmentsTable(attachedDatabase, alias);
  }
}

class AssessmentRow extends DataClass implements Insertable<AssessmentRow> {
  final String id;
  final String status;
  final int step;
  final String data;
  final String? consentVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AssessmentRow({
    required this.id,
    required this.status,
    required this.step,
    required this.data,
    this.consentVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['step'] = Variable<int>(step);
    map['data'] = Variable<String>(data);
    if (!nullToAbsent || consentVersion != null) {
      map['consent_version'] = Variable<String>(consentVersion);
    }
    map['schema_version'] = Variable<int>(schemaVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AssessmentsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentsCompanion(
      id: Value(id),
      status: Value(status),
      step: Value(step),
      data: Value(data),
      consentVersion: consentVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(consentVersion),
      schemaVersion: Value(schemaVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssessmentRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentRow(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      step: serializer.fromJson<int>(json['step']),
      data: serializer.fromJson<String>(json['data']),
      consentVersion: serializer.fromJson<String?>(json['consentVersion']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'step': serializer.toJson<int>(step),
      'data': serializer.toJson<String>(data),
      'consentVersion': serializer.toJson<String?>(consentVersion),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssessmentRow copyWith({
    String? id,
    String? status,
    int? step,
    String? data,
    Value<String?> consentVersion = const Value.absent(),
    int? schemaVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AssessmentRow(
    id: id ?? this.id,
    status: status ?? this.status,
    step: step ?? this.step,
    data: data ?? this.data,
    consentVersion: consentVersion.present ? consentVersion.value : this.consentVersion,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssessmentRow copyWithCompanion(AssessmentsCompanion data) {
    return AssessmentRow(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      step: data.step.present ? data.step.value : this.step,
      data: data.data.present ? data.data.value : this.data,
      consentVersion: data.consentVersion.present ? data.consentVersion.value : this.consentVersion,
      schemaVersion: data.schemaVersion.present ? data.schemaVersion.value : this.schemaVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentRow(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('step: $step, ')
          ..write('data: $data, ')
          ..write('consentVersion: $consentVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, status, step, data, consentVersion, schemaVersion, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentRow &&
          other.id == this.id &&
          other.status == this.status &&
          other.step == this.step &&
          other.data == this.data &&
          other.consentVersion == this.consentVersion &&
          other.schemaVersion == this.schemaVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AssessmentsCompanion extends UpdateCompanion<AssessmentRow> {
  final Value<String> id;
  final Value<String> status;
  final Value<int> step;
  final Value<String> data;
  final Value<String?> consentVersion;
  final Value<int> schemaVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AssessmentsCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.step = const Value.absent(),
    this.data = const Value.absent(),
    this.consentVersion = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssessmentsCompanion.insert({
    required String id,
    required String status,
    this.step = const Value.absent(),
    required String data,
    this.consentVersion = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       data = Value(data),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AssessmentRow> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<int>? step,
    Expression<String>? data,
    Expression<String>? consentVersion,
    Expression<int>? schemaVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (step != null) 'step': step,
      if (data != null) 'data': data,
      if (consentVersion != null) 'consent_version': consentVersion,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssessmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<int>? step,
    Value<String>? data,
    Value<String?>? consentVersion,
    Value<int>? schemaVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AssessmentsCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      step: step ?? this.step,
      data: data ?? this.data,
      consentVersion: consentVersion ?? this.consentVersion,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (consentVersion.present) {
      map['consent_version'] = Variable<String>(consentVersion.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('step: $step, ')
          ..write('data: $data, ')
          ..write('consentVersion: $consentVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsentsTable extends Consents with TableInfo<$ConsentsTable, ConsentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedAtMeta = const VerificationMeta('acceptedAt');
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
    'accepted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, version, acceptedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConsentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta, version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
        _acceptedAtMeta,
        acceptedAt.isAcceptableOrUnknown(data['accepted_at']!, _acceptedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acceptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConsentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsentRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      acceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accepted_at'],
      )!,
    );
  }

  @override
  $ConsentsTable createAlias(String alias) {
    return $ConsentsTable(attachedDatabase, alias);
  }
}

class ConsentRow extends DataClass implements Insertable<ConsentRow> {
  final String id;
  final String version;
  final DateTime acceptedAt;
  const ConsentRow({required this.id, required this.version, required this.acceptedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<String>(version);
    map['accepted_at'] = Variable<DateTime>(acceptedAt);
    return map;
  }

  ConsentsCompanion toCompanion(bool nullToAbsent) {
    return ConsentsCompanion(id: Value(id), version: Value(version), acceptedAt: Value(acceptedAt));
  }

  factory ConsentRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsentRow(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<String>(json['version']),
      acceptedAt: serializer.fromJson<DateTime>(json['acceptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<String>(version),
      'acceptedAt': serializer.toJson<DateTime>(acceptedAt),
    };
  }

  ConsentRow copyWith({String? id, String? version, DateTime? acceptedAt}) => ConsentRow(
    id: id ?? this.id,
    version: version ?? this.version,
    acceptedAt: acceptedAt ?? this.acceptedAt,
  );
  ConsentRow copyWithCompanion(ConsentsCompanion data) {
    return ConsentRow(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      acceptedAt: data.acceptedAt.present ? data.acceptedAt.value : this.acceptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRow(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, acceptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsentRow &&
          other.id == this.id &&
          other.version == this.version &&
          other.acceptedAt == this.acceptedAt);
}

class ConsentsCompanion extends UpdateCompanion<ConsentRow> {
  final Value<String> id;
  final Value<String> version;
  final Value<DateTime> acceptedAt;
  final Value<int> rowid;
  const ConsentsCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsentsCompanion.insert({
    required String id,
    required String version,
    required DateTime acceptedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       version = Value(version),
       acceptedAt = Value(acceptedAt);
  static Insertable<ConsentRow> custom({
    Expression<String>? id,
    Expression<String>? version,
    Expression<DateTime>? acceptedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsentsCompanion copyWith({
    Value<String>? id,
    Value<String>? version,
    Value<DateTime>? acceptedAt,
    Value<int>? rowid,
  }) {
    return ConsentsCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentsCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assessmentIdMeta = const VerificationMeta('assessmentId');
  @override
  late final GeneratedColumn<String> assessmentId = GeneratedColumn<String>(
    'assessment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warningsAcknowledgedMeta = const VerificationMeta(
    'warningsAcknowledged',
  );
  @override
  late final GeneratedColumn<bool> warningsAcknowledged = GeneratedColumn<bool>(
    'warnings_acknowledged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warnings_acknowledged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activatedAtMeta = const VerificationMeta('activatedAt');
  @override
  late final GeneratedColumn<DateTime> activatedAt = GeneratedColumn<DateTime>(
    'activated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    assessmentId,
    data,
    warningsAcknowledged,
    createdAt,
    activatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<GoalRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('assessment_id')) {
      context.handle(
        _assessmentIdMeta,
        assessmentId.isAcceptableOrUnknown(data['assessment_id']!, _assessmentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assessmentIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('warnings_acknowledged')) {
      context.handle(
        _warningsAcknowledgedMeta,
        warningsAcknowledged.isAcceptableOrUnknown(
          data['warnings_acknowledged']!,
          _warningsAcknowledgedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('activated_at')) {
      context.handle(
        _activatedAtMeta,
        activatedAt.isAcceptableOrUnknown(data['activated_at']!, _activatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      assessmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment_id'],
      )!,
      data: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      warningsAcknowledged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}warnings_acknowledged'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      activatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}activated_at'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String id;
  final String status;
  final String assessmentId;
  final String data;
  final bool warningsAcknowledged;
  final DateTime createdAt;
  final DateTime? activatedAt;
  final DateTime? archivedAt;
  const GoalRow({
    required this.id,
    required this.status,
    required this.assessmentId,
    required this.data,
    required this.warningsAcknowledged,
    required this.createdAt,
    this.activatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['assessment_id'] = Variable<String>(assessmentId);
    map['data'] = Variable<String>(data);
    map['warnings_acknowledged'] = Variable<bool>(warningsAcknowledged);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || activatedAt != null) {
      map['activated_at'] = Variable<DateTime>(activatedAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      status: Value(status),
      assessmentId: Value(assessmentId),
      data: Value(data),
      warningsAcknowledged: Value(warningsAcknowledged),
      createdAt: Value(createdAt),
      activatedAt: activatedAt == null && nullToAbsent ? const Value.absent() : Value(activatedAt),
      archivedAt: archivedAt == null && nullToAbsent ? const Value.absent() : Value(archivedAt),
    );
  }

  factory GoalRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      assessmentId: serializer.fromJson<String>(json['assessmentId']),
      data: serializer.fromJson<String>(json['data']),
      warningsAcknowledged: serializer.fromJson<bool>(json['warningsAcknowledged']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      activatedAt: serializer.fromJson<DateTime?>(json['activatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'assessmentId': serializer.toJson<String>(assessmentId),
      'data': serializer.toJson<String>(data),
      'warningsAcknowledged': serializer.toJson<bool>(warningsAcknowledged),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'activatedAt': serializer.toJson<DateTime?>(activatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  GoalRow copyWith({
    String? id,
    String? status,
    String? assessmentId,
    String? data,
    bool? warningsAcknowledged,
    DateTime? createdAt,
    Value<DateTime?> activatedAt = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => GoalRow(
    id: id ?? this.id,
    status: status ?? this.status,
    assessmentId: assessmentId ?? this.assessmentId,
    data: data ?? this.data,
    warningsAcknowledged: warningsAcknowledged ?? this.warningsAcknowledged,
    createdAt: createdAt ?? this.createdAt,
    activatedAt: activatedAt.present ? activatedAt.value : this.activatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      assessmentId: data.assessmentId.present ? data.assessmentId.value : this.assessmentId,
      data: data.data.present ? data.data.value : this.data,
      warningsAcknowledged: data.warningsAcknowledged.present
          ? data.warningsAcknowledged.value
          : this.warningsAcknowledged,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      activatedAt: data.activatedAt.present ? data.activatedAt.value : this.activatedAt,
      archivedAt: data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('data: $data, ')
          ..write('warningsAcknowledged: $warningsAcknowledged, ')
          ..write('createdAt: $createdAt, ')
          ..write('activatedAt: $activatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    assessmentId,
    data,
    warningsAcknowledged,
    createdAt,
    activatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.status == this.status &&
          other.assessmentId == this.assessmentId &&
          other.data == this.data &&
          other.warningsAcknowledged == this.warningsAcknowledged &&
          other.createdAt == this.createdAt &&
          other.activatedAt == this.activatedAt &&
          other.archivedAt == this.archivedAt);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> id;
  final Value<String> status;
  final Value<String> assessmentId;
  final Value<String> data;
  final Value<bool> warningsAcknowledged;
  final Value<DateTime> createdAt;
  final Value<DateTime?> activatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.assessmentId = const Value.absent(),
    this.data = const Value.absent(),
    this.warningsAcknowledged = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.activatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String status,
    required String assessmentId,
    required String data,
    this.warningsAcknowledged = const Value.absent(),
    required DateTime createdAt,
    this.activatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       assessmentId = Value(assessmentId),
       data = Value(data),
       createdAt = Value(createdAt);
  static Insertable<GoalRow> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<String>? assessmentId,
    Expression<String>? data,
    Expression<bool>? warningsAcknowledged,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? activatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (data != null) 'data': data,
      if (warningsAcknowledged != null) 'warnings_acknowledged': warningsAcknowledged,
      if (createdAt != null) 'created_at': createdAt,
      if (activatedAt != null) 'activated_at': activatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<String>? assessmentId,
    Value<String>? data,
    Value<bool>? warningsAcknowledged,
    Value<DateTime>? createdAt,
    Value<DateTime?>? activatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      assessmentId: assessmentId ?? this.assessmentId,
      data: data ?? this.data,
      warningsAcknowledged: warningsAcknowledged ?? this.warningsAcknowledged,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assessmentId.present) {
      map['assessment_id'] = Variable<String>(assessmentId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (warningsAcknowledged.present) {
      map['warnings_acknowledged'] = Variable<bool>(warningsAcknowledged.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (activatedAt.present) {
      map['activated_at'] = Variable<DateTime>(activatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('data: $data, ')
          ..write('warningsAcknowledged: $warningsAcknowledged, ')
          ..write('createdAt: $createdAt, ')
          ..write('activatedAt: $activatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionTargetsTable extends NutritionTargets
    with TableInfo<$NutritionTargetsTable, NutritionTargetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configVersionMeta = const VerificationMeta('configVersion');
  @override
  late final GeneratedColumn<String> configVersion = GeneratedColumn<String>(
    'config_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    status,
    data,
    configVersion,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutritionTargetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta, goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('data')) {
      context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('config_version')) {
      context.handle(
        _configVersionMeta,
        configVersion.isAcceptableOrUnknown(data['config_version']!, _configVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_configVersionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionTargetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionTargetRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      data: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      configVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $NutritionTargetsTable createAlias(String alias) {
    return $NutritionTargetsTable(attachedDatabase, alias);
  }
}

class NutritionTargetRow extends DataClass implements Insertable<NutritionTargetRow> {
  final String id;
  final String goalId;
  final String status;
  final String data;
  final String configVersion;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const NutritionTargetRow({
    required this.id,
    required this.goalId,
    required this.status,
    required this.data,
    required this.configVersion,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['status'] = Variable<String>(status);
    map['data'] = Variable<String>(data);
    map['config_version'] = Variable<String>(configVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  NutritionTargetsCompanion toCompanion(bool nullToAbsent) {
    return NutritionTargetsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      status: Value(status),
      data: Value(data),
      configVersion: Value(configVersion),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent ? const Value.absent() : Value(archivedAt),
    );
  }

  factory NutritionTargetRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionTargetRow(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      status: serializer.fromJson<String>(json['status']),
      data: serializer.fromJson<String>(json['data']),
      configVersion: serializer.fromJson<String>(json['configVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'status': serializer.toJson<String>(status),
      'data': serializer.toJson<String>(data),
      'configVersion': serializer.toJson<String>(configVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  NutritionTargetRow copyWith({
    String? id,
    String? goalId,
    String? status,
    String? data,
    String? configVersion,
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => NutritionTargetRow(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    status: status ?? this.status,
    data: data ?? this.data,
    configVersion: configVersion ?? this.configVersion,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  NutritionTargetRow copyWithCompanion(NutritionTargetsCompanion data) {
    return NutritionTargetRow(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      status: data.status.present ? data.status.value : this.status,
      data: data.data.present ? data.data.value : this.data,
      configVersion: data.configVersion.present ? data.configVersion.value : this.configVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionTargetRow(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('status: $status, ')
          ..write('data: $data, ')
          ..write('configVersion: $configVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, status, data, configVersion, createdAt, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionTargetRow &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.status == this.status &&
          other.data == this.data &&
          other.configVersion == this.configVersion &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class NutritionTargetsCompanion extends UpdateCompanion<NutritionTargetRow> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> status;
  final Value<String> data;
  final Value<String> configVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const NutritionTargetsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.status = const Value.absent(),
    this.data = const Value.absent(),
    this.configVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionTargetsCompanion.insert({
    required String id,
    required String goalId,
    required String status,
    required String data,
    required String configVersion,
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       status = Value(status),
       data = Value(data),
       configVersion = Value(configVersion),
       createdAt = Value(createdAt);
  static Insertable<NutritionTargetRow> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? status,
    Expression<String>? data,
    Expression<String>? configVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (status != null) 'status': status,
      if (data != null) 'data': data,
      if (configVersion != null) 'config_version': configVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionTargetsCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<String>? status,
    Value<String>? data,
    Value<String>? configVersion,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return NutritionTargetsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      status: status ?? this.status,
      data: data ?? this.data,
      configVersion: configVersion ?? this.configVersion,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (configVersion.present) {
      map['config_version'] = Variable<String>(configVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionTargetsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('status: $status, ')
          ..write('data: $data, ')
          ..write('configVersion: $configVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlansTable extends WorkoutPlans with TableInfo<$WorkoutPlansTable, WorkoutPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatorVersionMeta = const VerificationMeta('generatorVersion');
  @override
  late final GeneratedColumn<String> generatorVersion = GeneratedColumn<String>(
    'generator_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogVersionMeta = const VerificationMeta('catalogVersion');
  @override
  late final GeneratedColumn<String> catalogVersion = GeneratedColumn<String>(
    'catalog_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assessmentIdMeta = const VerificationMeta('assessmentId');
  @override
  late final GeneratedColumn<String> assessmentId = GeneratedColumn<String>(
    'assessment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitMeta = const VerificationMeta('split');
  @override
  late final GeneratedColumn<String> split = GeneratedColumn<String>(
    'split',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysPerWeekMeta = const VerificationMeta('daysPerWeek');
  @override
  late final GeneratedColumn<int> daysPerWeek = GeneratedColumn<int>(
    'days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionMinutesMeta = const VerificationMeta('sessionMinutes');
  @override
  late final GeneratedColumn<int> sessionMinutes = GeneratedColumn<int>(
    'session_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warningsMeta = const VerificationMeta('warnings');
  @override
  late final GeneratedColumn<String> warnings = GeneratedColumn<String>(
    'warnings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activatedAtMeta = const VerificationMeta('activatedAt');
  @override
  late final GeneratedColumn<DateTime> activatedAt = GeneratedColumn<DateTime>(
    'activated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    source,
    generatorVersion,
    catalogVersion,
    assessmentId,
    split,
    level,
    daysPerWeek,
    sessionMinutes,
    warnings,
    createdAt,
    activatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('generator_version')) {
      context.handle(
        _generatorVersionMeta,
        generatorVersion.isAcceptableOrUnknown(data['generator_version']!, _generatorVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_generatorVersionMeta);
    }
    if (data.containsKey('catalog_version')) {
      context.handle(
        _catalogVersionMeta,
        catalogVersion.isAcceptableOrUnknown(data['catalog_version']!, _catalogVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_catalogVersionMeta);
    }
    if (data.containsKey('assessment_id')) {
      context.handle(
        _assessmentIdMeta,
        assessmentId.isAcceptableOrUnknown(data['assessment_id']!, _assessmentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assessmentIdMeta);
    }
    if (data.containsKey('split')) {
      context.handle(_splitMeta, split.isAcceptableOrUnknown(data['split']!, _splitMeta));
    } else if (isInserting) {
      context.missing(_splitMeta);
    }
    if (data.containsKey('level')) {
      context.handle(_levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('days_per_week')) {
      context.handle(
        _daysPerWeekMeta,
        daysPerWeek.isAcceptableOrUnknown(data['days_per_week']!, _daysPerWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_daysPerWeekMeta);
    }
    if (data.containsKey('session_minutes')) {
      context.handle(
        _sessionMinutesMeta,
        sessionMinutes.isAcceptableOrUnknown(data['session_minutes']!, _sessionMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionMinutesMeta);
    }
    if (data.containsKey('warnings')) {
      context.handle(
        _warningsMeta,
        warnings.isAcceptableOrUnknown(data['warnings']!, _warningsMeta),
      );
    } else if (isInserting) {
      context.missing(_warningsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('activated_at')) {
      context.handle(
        _activatedAtMeta,
        activatedAt.isAcceptableOrUnknown(data['activated_at']!, _activatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      generatorVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generator_version'],
      )!,
      catalogVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_version'],
      )!,
      assessmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment_id'],
      )!,
      split: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      daysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_per_week'],
      )!,
      sessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_minutes'],
      )!,
      warnings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warnings'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      activatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}activated_at'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $WorkoutPlansTable createAlias(String alias) {
    return $WorkoutPlansTable(attachedDatabase, alias);
  }
}

class WorkoutPlanRow extends DataClass implements Insertable<WorkoutPlanRow> {
  final String id;
  final String status;
  final String source;
  final String generatorVersion;
  final String catalogVersion;
  final String assessmentId;
  final String split;
  final String level;
  final int daysPerWeek;
  final int sessionMinutes;
  final String warnings;
  final DateTime createdAt;
  final DateTime? activatedAt;
  final DateTime? archivedAt;
  const WorkoutPlanRow({
    required this.id,
    required this.status,
    required this.source,
    required this.generatorVersion,
    required this.catalogVersion,
    required this.assessmentId,
    required this.split,
    required this.level,
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.warnings,
    required this.createdAt,
    this.activatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    map['generator_version'] = Variable<String>(generatorVersion);
    map['catalog_version'] = Variable<String>(catalogVersion);
    map['assessment_id'] = Variable<String>(assessmentId);
    map['split'] = Variable<String>(split);
    map['level'] = Variable<String>(level);
    map['days_per_week'] = Variable<int>(daysPerWeek);
    map['session_minutes'] = Variable<int>(sessionMinutes);
    map['warnings'] = Variable<String>(warnings);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || activatedAt != null) {
      map['activated_at'] = Variable<DateTime>(activatedAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  WorkoutPlansCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlansCompanion(
      id: Value(id),
      status: Value(status),
      source: Value(source),
      generatorVersion: Value(generatorVersion),
      catalogVersion: Value(catalogVersion),
      assessmentId: Value(assessmentId),
      split: Value(split),
      level: Value(level),
      daysPerWeek: Value(daysPerWeek),
      sessionMinutes: Value(sessionMinutes),
      warnings: Value(warnings),
      createdAt: Value(createdAt),
      activatedAt: activatedAt == null && nullToAbsent ? const Value.absent() : Value(activatedAt),
      archivedAt: archivedAt == null && nullToAbsent ? const Value.absent() : Value(archivedAt),
    );
  }

  factory WorkoutPlanRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanRow(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      generatorVersion: serializer.fromJson<String>(json['generatorVersion']),
      catalogVersion: serializer.fromJson<String>(json['catalogVersion']),
      assessmentId: serializer.fromJson<String>(json['assessmentId']),
      split: serializer.fromJson<String>(json['split']),
      level: serializer.fromJson<String>(json['level']),
      daysPerWeek: serializer.fromJson<int>(json['daysPerWeek']),
      sessionMinutes: serializer.fromJson<int>(json['sessionMinutes']),
      warnings: serializer.fromJson<String>(json['warnings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      activatedAt: serializer.fromJson<DateTime?>(json['activatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'generatorVersion': serializer.toJson<String>(generatorVersion),
      'catalogVersion': serializer.toJson<String>(catalogVersion),
      'assessmentId': serializer.toJson<String>(assessmentId),
      'split': serializer.toJson<String>(split),
      'level': serializer.toJson<String>(level),
      'daysPerWeek': serializer.toJson<int>(daysPerWeek),
      'sessionMinutes': serializer.toJson<int>(sessionMinutes),
      'warnings': serializer.toJson<String>(warnings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'activatedAt': serializer.toJson<DateTime?>(activatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  WorkoutPlanRow copyWith({
    String? id,
    String? status,
    String? source,
    String? generatorVersion,
    String? catalogVersion,
    String? assessmentId,
    String? split,
    String? level,
    int? daysPerWeek,
    int? sessionMinutes,
    String? warnings,
    DateTime? createdAt,
    Value<DateTime?> activatedAt = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => WorkoutPlanRow(
    id: id ?? this.id,
    status: status ?? this.status,
    source: source ?? this.source,
    generatorVersion: generatorVersion ?? this.generatorVersion,
    catalogVersion: catalogVersion ?? this.catalogVersion,
    assessmentId: assessmentId ?? this.assessmentId,
    split: split ?? this.split,
    level: level ?? this.level,
    daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    warnings: warnings ?? this.warnings,
    createdAt: createdAt ?? this.createdAt,
    activatedAt: activatedAt.present ? activatedAt.value : this.activatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  WorkoutPlanRow copyWithCompanion(WorkoutPlansCompanion data) {
    return WorkoutPlanRow(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      generatorVersion: data.generatorVersion.present
          ? data.generatorVersion.value
          : this.generatorVersion,
      catalogVersion: data.catalogVersion.present ? data.catalogVersion.value : this.catalogVersion,
      assessmentId: data.assessmentId.present ? data.assessmentId.value : this.assessmentId,
      split: data.split.present ? data.split.value : this.split,
      level: data.level.present ? data.level.value : this.level,
      daysPerWeek: data.daysPerWeek.present ? data.daysPerWeek.value : this.daysPerWeek,
      sessionMinutes: data.sessionMinutes.present ? data.sessionMinutes.value : this.sessionMinutes,
      warnings: data.warnings.present ? data.warnings.value : this.warnings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      activatedAt: data.activatedAt.present ? data.activatedAt.value : this.activatedAt,
      archivedAt: data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanRow(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('split: $split, ')
          ..write('level: $level, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('warnings: $warnings, ')
          ..write('createdAt: $createdAt, ')
          ..write('activatedAt: $activatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    source,
    generatorVersion,
    catalogVersion,
    assessmentId,
    split,
    level,
    daysPerWeek,
    sessionMinutes,
    warnings,
    createdAt,
    activatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanRow &&
          other.id == this.id &&
          other.status == this.status &&
          other.source == this.source &&
          other.generatorVersion == this.generatorVersion &&
          other.catalogVersion == this.catalogVersion &&
          other.assessmentId == this.assessmentId &&
          other.split == this.split &&
          other.level == this.level &&
          other.daysPerWeek == this.daysPerWeek &&
          other.sessionMinutes == this.sessionMinutes &&
          other.warnings == this.warnings &&
          other.createdAt == this.createdAt &&
          other.activatedAt == this.activatedAt &&
          other.archivedAt == this.archivedAt);
}

class WorkoutPlansCompanion extends UpdateCompanion<WorkoutPlanRow> {
  final Value<String> id;
  final Value<String> status;
  final Value<String> source;
  final Value<String> generatorVersion;
  final Value<String> catalogVersion;
  final Value<String> assessmentId;
  final Value<String> split;
  final Value<String> level;
  final Value<int> daysPerWeek;
  final Value<int> sessionMinutes;
  final Value<String> warnings;
  final Value<DateTime> createdAt;
  final Value<DateTime?> activatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const WorkoutPlansCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.generatorVersion = const Value.absent(),
    this.catalogVersion = const Value.absent(),
    this.assessmentId = const Value.absent(),
    this.split = const Value.absent(),
    this.level = const Value.absent(),
    this.daysPerWeek = const Value.absent(),
    this.sessionMinutes = const Value.absent(),
    this.warnings = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.activatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlansCompanion.insert({
    required String id,
    required String status,
    required String source,
    required String generatorVersion,
    required String catalogVersion,
    required String assessmentId,
    required String split,
    required String level,
    required int daysPerWeek,
    required int sessionMinutes,
    required String warnings,
    required DateTime createdAt,
    this.activatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       source = Value(source),
       generatorVersion = Value(generatorVersion),
       catalogVersion = Value(catalogVersion),
       assessmentId = Value(assessmentId),
       split = Value(split),
       level = Value(level),
       daysPerWeek = Value(daysPerWeek),
       sessionMinutes = Value(sessionMinutes),
       warnings = Value(warnings),
       createdAt = Value(createdAt);
  static Insertable<WorkoutPlanRow> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? generatorVersion,
    Expression<String>? catalogVersion,
    Expression<String>? assessmentId,
    Expression<String>? split,
    Expression<String>? level,
    Expression<int>? daysPerWeek,
    Expression<int>? sessionMinutes,
    Expression<String>? warnings,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? activatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (generatorVersion != null) 'generator_version': generatorVersion,
      if (catalogVersion != null) 'catalog_version': catalogVersion,
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (split != null) 'split': split,
      if (level != null) 'level': level,
      if (daysPerWeek != null) 'days_per_week': daysPerWeek,
      if (sessionMinutes != null) 'session_minutes': sessionMinutes,
      if (warnings != null) 'warnings': warnings,
      if (createdAt != null) 'created_at': createdAt,
      if (activatedAt != null) 'activated_at': activatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<String>? source,
    Value<String>? generatorVersion,
    Value<String>? catalogVersion,
    Value<String>? assessmentId,
    Value<String>? split,
    Value<String>? level,
    Value<int>? daysPerWeek,
    Value<int>? sessionMinutes,
    Value<String>? warnings,
    Value<DateTime>? createdAt,
    Value<DateTime?>? activatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return WorkoutPlansCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      source: source ?? this.source,
      generatorVersion: generatorVersion ?? this.generatorVersion,
      catalogVersion: catalogVersion ?? this.catalogVersion,
      assessmentId: assessmentId ?? this.assessmentId,
      split: split ?? this.split,
      level: level ?? this.level,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      warnings: warnings ?? this.warnings,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (generatorVersion.present) {
      map['generator_version'] = Variable<String>(generatorVersion.value);
    }
    if (catalogVersion.present) {
      map['catalog_version'] = Variable<String>(catalogVersion.value);
    }
    if (assessmentId.present) {
      map['assessment_id'] = Variable<String>(assessmentId.value);
    }
    if (split.present) {
      map['split'] = Variable<String>(split.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (daysPerWeek.present) {
      map['days_per_week'] = Variable<int>(daysPerWeek.value);
    }
    if (sessionMinutes.present) {
      map['session_minutes'] = Variable<int>(sessionMinutes.value);
    }
    if (warnings.present) {
      map['warnings'] = Variable<String>(warnings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (activatedAt.present) {
      map['activated_at'] = Variable<DateTime>(activatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlansCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('split: $split, ')
          ..write('level: $level, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('warnings: $warnings, ')
          ..write('createdAt: $createdAt, ')
          ..write('activatedAt: $activatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warmupMinutesMeta = const VerificationMeta('warmupMinutes');
  @override
  late final GeneratedColumn<int> warmupMinutes = GeneratedColumn<int>(
    'warmup_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta('estimatedMinutes');
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exercisesMeta = const VerificationMeta('exercises');
  @override
  late final GeneratedColumn<String> exercises = GeneratedColumn<String>(
    'exercises',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    planId,
    id,
    position,
    weekday,
    focus,
    warmupMinutes,
    estimatedMinutes,
    exercises,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanDayRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta, planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta, weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(_focusMeta, focus.isAcceptableOrUnknown(data['focus']!, _focusMeta));
    } else if (isInserting) {
      context.missing(_focusMeta);
    }
    if (data.containsKey('warmup_minutes')) {
      context.handle(
        _warmupMinutesMeta,
        warmupMinutes.isAcceptableOrUnknown(data['warmup_minutes']!, _warmupMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_warmupMinutesMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(data['estimated_minutes']!, _estimatedMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('exercises')) {
      context.handle(
        _exercisesMeta,
        exercises.isAcceptableOrUnknown(data['exercises']!, _exercisesMeta),
      );
    } else if (isInserting) {
      context.missing(_exercisesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planId, id};
  @override
  PlanDayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDayRow(
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      )!,
      warmupMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warmup_minutes'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      exercises: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercises'],
      )!,
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }
}

class PlanDayRow extends DataClass implements Insertable<PlanDayRow> {
  final String planId;
  final String id;
  final int position;
  final int weekday;
  final String focus;
  final int warmupMinutes;
  final int estimatedMinutes;
  final String exercises;
  const PlanDayRow({
    required this.planId,
    required this.id,
    required this.position,
    required this.weekday,
    required this.focus,
    required this.warmupMinutes,
    required this.estimatedMinutes,
    required this.exercises,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_id'] = Variable<String>(planId);
    map['id'] = Variable<String>(id);
    map['position'] = Variable<int>(position);
    map['weekday'] = Variable<int>(weekday);
    map['focus'] = Variable<String>(focus);
    map['warmup_minutes'] = Variable<int>(warmupMinutes);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['exercises'] = Variable<String>(exercises);
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(
      planId: Value(planId),
      id: Value(id),
      position: Value(position),
      weekday: Value(weekday),
      focus: Value(focus),
      warmupMinutes: Value(warmupMinutes),
      estimatedMinutes: Value(estimatedMinutes),
      exercises: Value(exercises),
    );
  }

  factory PlanDayRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDayRow(
      planId: serializer.fromJson<String>(json['planId']),
      id: serializer.fromJson<String>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      weekday: serializer.fromJson<int>(json['weekday']),
      focus: serializer.fromJson<String>(json['focus']),
      warmupMinutes: serializer.fromJson<int>(json['warmupMinutes']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      exercises: serializer.fromJson<String>(json['exercises']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planId': serializer.toJson<String>(planId),
      'id': serializer.toJson<String>(id),
      'position': serializer.toJson<int>(position),
      'weekday': serializer.toJson<int>(weekday),
      'focus': serializer.toJson<String>(focus),
      'warmupMinutes': serializer.toJson<int>(warmupMinutes),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'exercises': serializer.toJson<String>(exercises),
    };
  }

  PlanDayRow copyWith({
    String? planId,
    String? id,
    int? position,
    int? weekday,
    String? focus,
    int? warmupMinutes,
    int? estimatedMinutes,
    String? exercises,
  }) => PlanDayRow(
    planId: planId ?? this.planId,
    id: id ?? this.id,
    position: position ?? this.position,
    weekday: weekday ?? this.weekday,
    focus: focus ?? this.focus,
    warmupMinutes: warmupMinutes ?? this.warmupMinutes,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    exercises: exercises ?? this.exercises,
  );
  PlanDayRow copyWithCompanion(PlanDaysCompanion data) {
    return PlanDayRow(
      planId: data.planId.present ? data.planId.value : this.planId,
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      focus: data.focus.present ? data.focus.value : this.focus,
      warmupMinutes: data.warmupMinutes.present ? data.warmupMinutes.value : this.warmupMinutes,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      exercises: data.exercises.present ? data.exercises.value : this.exercises,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDayRow(')
          ..write('planId: $planId, ')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('weekday: $weekday, ')
          ..write('focus: $focus, ')
          ..write('warmupMinutes: $warmupMinutes, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('exercises: $exercises')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(planId, id, position, weekday, focus, warmupMinutes, estimatedMinutes, exercises);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDayRow &&
          other.planId == this.planId &&
          other.id == this.id &&
          other.position == this.position &&
          other.weekday == this.weekday &&
          other.focus == this.focus &&
          other.warmupMinutes == this.warmupMinutes &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.exercises == this.exercises);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDayRow> {
  final Value<String> planId;
  final Value<String> id;
  final Value<int> position;
  final Value<int> weekday;
  final Value<String> focus;
  final Value<int> warmupMinutes;
  final Value<int> estimatedMinutes;
  final Value<String> exercises;
  final Value<int> rowid;
  const PlanDaysCompanion({
    this.planId = const Value.absent(),
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.weekday = const Value.absent(),
    this.focus = const Value.absent(),
    this.warmupMinutes = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.exercises = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    required String planId,
    required String id,
    required int position,
    required int weekday,
    required String focus,
    required int warmupMinutes,
    required int estimatedMinutes,
    required String exercises,
    this.rowid = const Value.absent(),
  }) : planId = Value(planId),
       id = Value(id),
       position = Value(position),
       weekday = Value(weekday),
       focus = Value(focus),
       warmupMinutes = Value(warmupMinutes),
       estimatedMinutes = Value(estimatedMinutes),
       exercises = Value(exercises);
  static Insertable<PlanDayRow> custom({
    Expression<String>? planId,
    Expression<String>? id,
    Expression<int>? position,
    Expression<int>? weekday,
    Expression<String>? focus,
    Expression<int>? warmupMinutes,
    Expression<int>? estimatedMinutes,
    Expression<String>? exercises,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planId != null) 'plan_id': planId,
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (weekday != null) 'weekday': weekday,
      if (focus != null) 'focus': focus,
      if (warmupMinutes != null) 'warmup_minutes': warmupMinutes,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (exercises != null) 'exercises': exercises,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanDaysCompanion copyWith({
    Value<String>? planId,
    Value<String>? id,
    Value<int>? position,
    Value<int>? weekday,
    Value<String>? focus,
    Value<int>? warmupMinutes,
    Value<int>? estimatedMinutes,
    Value<String>? exercises,
    Value<int>? rowid,
  }) {
    return PlanDaysCompanion(
      planId: planId ?? this.planId,
      id: id ?? this.id,
      position: position ?? this.position,
      weekday: weekday ?? this.weekday,
      focus: focus ?? this.focus,
      warmupMinutes: warmupMinutes ?? this.warmupMinutes,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      exercises: exercises ?? this.exercises,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (warmupMinutes.present) {
      map['warmup_minutes'] = Variable<int>(warmupMinutes.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (exercises.present) {
      map['exercises'] = Variable<String>(exercises.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('planId: $planId, ')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('weekday: $weekday, ')
          ..write('focus: $focus, ')
          ..write('warmupMinutes: $warmupMinutes, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('exercises: $exercises, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedMeta = const VerificationMeta('planned');
  @override
  late final GeneratedColumn<String> planned = GeneratedColumn<String>(
    'planned',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
    'energy',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discomfortMeta = const VerificationMeta('discomfort');
  @override
  late final GeneratedColumn<String> discomfort = GeneratedColumn<String>(
    'discomfort',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    dayId,
    date,
    weekday,
    focus,
    status,
    planned,
    notes,
    energy,
    discomfort,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta, planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(_dayIdMeta, dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta));
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta, weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(_focusMeta, focus.isAcceptableOrUnknown(data['focus']!, _focusMeta));
    } else if (isInserting) {
      context.missing(_focusMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('planned')) {
      context.handle(_plannedMeta, planned.isAcceptableOrUnknown(data['planned']!, _plannedMeta));
    } else if (isInserting) {
      context.missing(_plannedMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('energy')) {
      context.handle(_energyMeta, energy.isAcceptableOrUnknown(data['energy']!, _energyMeta));
    }
    if (data.containsKey('discomfort')) {
      context.handle(
        _discomfortMeta,
        discomfort.isAcceptableOrUnknown(data['discomfort']!, _discomfortMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(data['completed_at']!, _completedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      date: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      planned: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      energy: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}energy']),
      discomfort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discomfort'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSessionRow extends DataClass implements Insertable<WorkoutSessionRow> {
  final String id;
  final String planId;
  final String dayId;

  /// Tanggal lokal `YYYY-MM-DD`.
  final String date;
  final int weekday;
  final String focus;
  final String status;

  /// Salinan target (JSON) — tidak diubah setelah sesi dibuat.
  final String planned;
  final String? notes;
  final int? energy;
  final String? discomfort;
  final DateTime startedAt;
  final DateTime? completedAt;
  const WorkoutSessionRow({
    required this.id,
    required this.planId,
    required this.dayId,
    required this.date,
    required this.weekday,
    required this.focus,
    required this.status,
    required this.planned,
    this.notes,
    this.energy,
    this.discomfort,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['day_id'] = Variable<String>(dayId);
    map['date'] = Variable<String>(date);
    map['weekday'] = Variable<int>(weekday);
    map['focus'] = Variable<String>(focus);
    map['status'] = Variable<String>(status);
    map['planned'] = Variable<String>(planned);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || energy != null) {
      map['energy'] = Variable<int>(energy);
    }
    if (!nullToAbsent || discomfort != null) {
      map['discomfort'] = Variable<String>(discomfort);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      planId: Value(planId),
      dayId: Value(dayId),
      date: Value(date),
      weekday: Value(weekday),
      focus: Value(focus),
      status: Value(status),
      planned: Value(planned),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      energy: energy == null && nullToAbsent ? const Value.absent() : Value(energy),
      discomfort: discomfort == null && nullToAbsent ? const Value.absent() : Value(discomfort),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent ? const Value.absent() : Value(completedAt),
    );
  }

  factory WorkoutSessionRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionRow(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      dayId: serializer.fromJson<String>(json['dayId']),
      date: serializer.fromJson<String>(json['date']),
      weekday: serializer.fromJson<int>(json['weekday']),
      focus: serializer.fromJson<String>(json['focus']),
      status: serializer.fromJson<String>(json['status']),
      planned: serializer.fromJson<String>(json['planned']),
      notes: serializer.fromJson<String?>(json['notes']),
      energy: serializer.fromJson<int?>(json['energy']),
      discomfort: serializer.fromJson<String?>(json['discomfort']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'dayId': serializer.toJson<String>(dayId),
      'date': serializer.toJson<String>(date),
      'weekday': serializer.toJson<int>(weekday),
      'focus': serializer.toJson<String>(focus),
      'status': serializer.toJson<String>(status),
      'planned': serializer.toJson<String>(planned),
      'notes': serializer.toJson<String?>(notes),
      'energy': serializer.toJson<int?>(energy),
      'discomfort': serializer.toJson<String?>(discomfort),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  WorkoutSessionRow copyWith({
    String? id,
    String? planId,
    String? dayId,
    String? date,
    int? weekday,
    String? focus,
    String? status,
    String? planned,
    Value<String?> notes = const Value.absent(),
    Value<int?> energy = const Value.absent(),
    Value<String?> discomfort = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSessionRow(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    dayId: dayId ?? this.dayId,
    date: date ?? this.date,
    weekday: weekday ?? this.weekday,
    focus: focus ?? this.focus,
    status: status ?? this.status,
    planned: planned ?? this.planned,
    notes: notes.present ? notes.value : this.notes,
    energy: energy.present ? energy.value : this.energy,
    discomfort: discomfort.present ? discomfort.value : this.discomfort,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  WorkoutSessionRow copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      date: data.date.present ? data.date.value : this.date,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      focus: data.focus.present ? data.focus.value : this.focus,
      status: data.status.present ? data.status.value : this.status,
      planned: data.planned.present ? data.planned.value : this.planned,
      notes: data.notes.present ? data.notes.value : this.notes,
      energy: data.energy.present ? data.energy.value : this.energy,
      discomfort: data.discomfort.present ? data.discomfort.value : this.discomfort,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('dayId: $dayId, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday, ')
          ..write('focus: $focus, ')
          ..write('status: $status, ')
          ..write('planned: $planned, ')
          ..write('notes: $notes, ')
          ..write('energy: $energy, ')
          ..write('discomfort: $discomfort, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    dayId,
    date,
    weekday,
    focus,
    status,
    planned,
    notes,
    energy,
    discomfort,
    startedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionRow &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.dayId == this.dayId &&
          other.date == this.date &&
          other.weekday == this.weekday &&
          other.focus == this.focus &&
          other.status == this.status &&
          other.planned == this.planned &&
          other.notes == this.notes &&
          other.energy == this.energy &&
          other.discomfort == this.discomfort &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSessionRow> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> dayId;
  final Value<String> date;
  final Value<int> weekday;
  final Value<String> focus;
  final Value<String> status;
  final Value<String> planned;
  final Value<String?> notes;
  final Value<int?> energy;
  final Value<String?> discomfort;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.dayId = const Value.absent(),
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
    this.focus = const Value.absent(),
    this.status = const Value.absent(),
    this.planned = const Value.absent(),
    this.notes = const Value.absent(),
    this.energy = const Value.absent(),
    this.discomfort = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String planId,
    required String dayId,
    required String date,
    required int weekday,
    required String focus,
    required String status,
    required String planned,
    this.notes = const Value.absent(),
    this.energy = const Value.absent(),
    this.discomfort = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       dayId = Value(dayId),
       date = Value(date),
       weekday = Value(weekday),
       focus = Value(focus),
       status = Value(status),
       planned = Value(planned),
       startedAt = Value(startedAt);
  static Insertable<WorkoutSessionRow> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? dayId,
    Expression<String>? date,
    Expression<int>? weekday,
    Expression<String>? focus,
    Expression<String>? status,
    Expression<String>? planned,
    Expression<String>? notes,
    Expression<int>? energy,
    Expression<String>? discomfort,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (dayId != null) 'day_id': dayId,
      if (date != null) 'date': date,
      if (weekday != null) 'weekday': weekday,
      if (focus != null) 'focus': focus,
      if (status != null) 'status': status,
      if (planned != null) 'planned': planned,
      if (notes != null) 'notes': notes,
      if (energy != null) 'energy': energy,
      if (discomfort != null) 'discomfort': discomfort,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<String>? dayId,
    Value<String>? date,
    Value<int>? weekday,
    Value<String>? focus,
    Value<String>? status,
    Value<String>? planned,
    Value<String?>? notes,
    Value<int?>? energy,
    Value<String?>? discomfort,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      dayId: dayId ?? this.dayId,
      date: date ?? this.date,
      weekday: weekday ?? this.weekday,
      focus: focus ?? this.focus,
      status: status ?? this.status,
      planned: planned ?? this.planned,
      notes: notes ?? this.notes,
      energy: energy ?? this.energy,
      discomfort: discomfort ?? this.discomfort,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (planned.present) {
      map['planned'] = Variable<String>(planned.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (discomfort.present) {
      map['discomfort'] = Variable<String>(discomfort.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('dayId: $dayId, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday, ')
          ..write('focus: $focus, ')
          ..write('status: $status, ')
          ..write('planned: $planned, ')
          ..write('notes: $notes, ')
          ..write('energy: $energy, ')
          ..write('discomfort: $discomfort, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIndexMeta = const VerificationMeta('exerciseIndex');
  @override
  late final GeneratedColumn<int> exerciseIndex = GeneratedColumn<int>(
    'exercise_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta('setNumber');
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<int> rir = GeneratedColumn<int>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    exerciseIndex,
    setNumber,
    weightKg,
    reps,
    rir,
    status,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('exercise_index')) {
      context.handle(
        _exerciseIndexMeta,
        exerciseIndex.isAcceptableOrUnknown(data['exercise_index']!, _exerciseIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIndexMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(_repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rir')) {
      context.handle(_rirMeta, rir.isAcceptableOrUnknown(data['rir']!, _rirMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLogRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      exerciseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_index'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      reps: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      rir: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}rir']),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLogRow extends DataClass implements Insertable<SetLogRow> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int exerciseIndex;
  final int setNumber;
  final double? weightKg;
  final int reps;
  final int? rir;
  final String status;
  final DateTime loggedAt;
  const SetLogRow({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseIndex,
    required this.setNumber,
    this.weightKg,
    required this.reps,
    this.rir,
    required this.status,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['exercise_index'] = Variable<int>(exerciseIndex);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<int>(rir);
    }
    map['status'] = Variable<String>(status);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      exerciseIndex: Value(exerciseIndex),
      setNumber: Value(setNumber),
      weightKg: weightKg == null && nullToAbsent ? const Value.absent() : Value(weightKg),
      reps: Value(reps),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      status: Value(status),
      loggedAt: Value(loggedAt),
    );
  }

  factory SetLogRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLogRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      exerciseIndex: serializer.fromJson<int>(json['exerciseIndex']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      rir: serializer.fromJson<int?>(json['rir']),
      status: serializer.fromJson<String>(json['status']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'exerciseIndex': serializer.toJson<int>(exerciseIndex),
      'setNumber': serializer.toJson<int>(setNumber),
      'weightKg': serializer.toJson<double?>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'rir': serializer.toJson<int?>(rir),
      'status': serializer.toJson<String>(status),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  SetLogRow copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? exerciseIndex,
    int? setNumber,
    Value<double?> weightKg = const Value.absent(),
    int? reps,
    Value<int?> rir = const Value.absent(),
    String? status,
    DateTime? loggedAt,
  }) => SetLogRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    exerciseIndex: exerciseIndex ?? this.exerciseIndex,
    setNumber: setNumber ?? this.setNumber,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    reps: reps ?? this.reps,
    rir: rir.present ? rir.value : this.rir,
    status: status ?? this.status,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  SetLogRow copyWithCompanion(SetLogsCompanion data) {
    return SetLogRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      exerciseIndex: data.exerciseIndex.present ? data.exerciseIndex.value : this.exerciseIndex,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      rir: data.rir.present ? data.rir.value : this.rir,
      status: data.status.present ? data.status.value : this.status,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLogRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseIndex: $exerciseIndex, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rir: $rir, ')
          ..write('status: $status, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    exerciseIndex,
    setNumber,
    weightKg,
    reps,
    rir,
    status,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLogRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.exerciseIndex == this.exerciseIndex &&
          other.setNumber == this.setNumber &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.rir == this.rir &&
          other.status == this.status &&
          other.loggedAt == this.loggedAt);
}

class SetLogsCompanion extends UpdateCompanion<SetLogRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> exerciseIndex;
  final Value<int> setNumber;
  final Value<double?> weightKg;
  final Value<int> reps;
  final Value<int?> rir;
  final Value<String> status;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseIndex = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rir = const Value.absent(),
    this.status = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetLogsCompanion.insert({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int exerciseIndex,
    required int setNumber,
    this.weightKg = const Value.absent(),
    required int reps,
    this.rir = const Value.absent(),
    required String status,
    required DateTime loggedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       exerciseIndex = Value(exerciseIndex),
       setNumber = Value(setNumber),
       reps = Value(reps),
       status = Value(status),
       loggedAt = Value(loggedAt);
  static Insertable<SetLogRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? exerciseIndex,
    Expression<int>? setNumber,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? rir,
    Expression<String>? status,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (exerciseIndex != null) 'exercise_index': exerciseIndex,
      if (setNumber != null) 'set_number': setNumber,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (rir != null) 'rir': rir,
      if (status != null) 'status': status,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? exerciseIndex,
    Value<int>? setNumber,
    Value<double?>? weightKg,
    Value<int>? reps,
    Value<int?>? rir,
    Value<String>? status,
    Value<DateTime>? loggedAt,
    Value<int>? rowid,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rir: rir ?? this.rir,
      status: status ?? this.status,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (exerciseIndex.present) {
      map['exercise_index'] = Variable<int>(exerciseIndex.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rir.present) {
      map['rir'] = Variable<int>(rir.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseIndex: $exerciseIndex, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rir: $rir, ')
          ..write('status: $status, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfileStateTable profileState = $ProfileStateTable(this);
  late final $AssessmentsTable assessments = $AssessmentsTable(this);
  late final $ConsentsTable consents = $ConsentsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $NutritionTargetsTable nutritionTargets = $NutritionTargetsTable(this);
  late final $WorkoutPlansTable workoutPlans = $WorkoutPlansTable(this);
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(this);
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profileState,
    assessments,
    consents,
    goals,
    nutritionTargets,
    workoutPlans,
    planDays,
    workoutSessions,
    setLogs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('workout_plans', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('plan_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('workout_sessions', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('set_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfileStateTableCreateCompanionBuilder = ProfileStateCompanion Function({
  Value<int> id,
  Value<String?> displayName,
  Value<bool> onboardingCompleted,
  Value<String?> activeGoalId,
  Value<String?> activeNutritionTargetId,
  Value<String?> latestAssessmentId,
  Value<String?> activeWorkoutPlanId,
  required DateTime updatedAt,
});
typedef $$ProfileStateTableUpdateCompanionBuilder = ProfileStateCompanion Function({
  Value<int> id,
  Value<String?> displayName,
  Value<bool> onboardingCompleted,
  Value<String?> activeGoalId,
  Value<String?> activeNutritionTargetId,
  Value<String?> latestAssessmentId,
  Value<String?> activeWorkoutPlanId,
  Value<DateTime> updatedAt,
});

class $$ProfileStateTableFilterComposer extends Composer<_$AppDatabase, $ProfileStateTable> {
  $$ProfileStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeGoalId =>
      $composableBuilder(column: $table.activeGoalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeNutritionTargetId => $composableBuilder(
    column: $table.activeNutritionTargetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latestAssessmentId => $composableBuilder(
    column: $table.latestAssessmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeWorkoutPlanId => $composableBuilder(
    column: $table.activeWorkoutPlanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ProfileStateTableOrderingComposer extends Composer<_$AppDatabase, $ProfileStateTable> {
  $$ProfileStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeGoalId =>
      $composableBuilder(column: $table.activeGoalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeNutritionTargetId => $composableBuilder(
    column: $table.activeNutritionTargetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latestAssessmentId => $composableBuilder(
    column: $table.latestAssessmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeWorkoutPlanId => $composableBuilder(
    column: $table.activeWorkoutPlanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProfileStateTableAnnotationComposer extends Composer<_$AppDatabase, $ProfileStateTable> {
  $$ProfileStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted =>
      $composableBuilder(column: $table.onboardingCompleted, builder: (column) => column);

  GeneratedColumn<String> get activeGoalId =>
      $composableBuilder(column: $table.activeGoalId, builder: (column) => column);

  GeneratedColumn<String> get activeNutritionTargetId =>
      $composableBuilder(column: $table.activeNutritionTargetId, builder: (column) => column);

  GeneratedColumn<String> get latestAssessmentId =>
      $composableBuilder(column: $table.latestAssessmentId, builder: (column) => column);

  GeneratedColumn<String> get activeWorkoutPlanId =>
      $composableBuilder(column: $table.activeWorkoutPlanId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfileStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileStateTable,
          ProfileRow,
          $$ProfileStateTableFilterComposer,
          $$ProfileStateTableOrderingComposer,
          $$ProfileStateTableAnnotationComposer,
          $$ProfileStateTableCreateCompanionBuilder,
          $$ProfileStateTableUpdateCompanionBuilder,
          (ProfileRow, BaseReferences<_$AppDatabase, $ProfileStateTable, ProfileRow>),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfileStateTableTableManager(_$AppDatabase db, $ProfileStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ProfileStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ProfileStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<String?> activeGoalId = const Value.absent(),
                Value<String?> activeNutritionTargetId = const Value.absent(),
                Value<String?> latestAssessmentId = const Value.absent(),
                Value<String?> activeWorkoutPlanId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProfileStateCompanion(
                id: id,
                displayName: displayName,
                onboardingCompleted: onboardingCompleted,
                activeGoalId: activeGoalId,
                activeNutritionTargetId: activeNutritionTargetId,
                latestAssessmentId: latestAssessmentId,
                activeWorkoutPlanId: activeWorkoutPlanId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<String?> activeGoalId = const Value.absent(),
                Value<String?> activeNutritionTargetId = const Value.absent(),
                Value<String?> latestAssessmentId = const Value.absent(),
                Value<String?> activeWorkoutPlanId = const Value.absent(),
                required DateTime updatedAt,
              }) => ProfileStateCompanion.insert(
                id: id,
                displayName: displayName,
                onboardingCompleted: onboardingCompleted,
                activeGoalId: activeGoalId,
                activeNutritionTargetId: activeNutritionTargetId,
                latestAssessmentId: latestAssessmentId,
                activeWorkoutPlanId: activeWorkoutPlanId,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileStateTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfileStateTable, ProfileRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileStateTable,
      ProfileRow,
      $$ProfileStateTableFilterComposer,
      $$ProfileStateTableOrderingComposer,
      $$ProfileStateTableAnnotationComposer,
      $$ProfileStateTableCreateCompanionBuilder,
      $$ProfileStateTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfileStateTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$AssessmentsTableCreateCompanionBuilder = AssessmentsCompanion Function({
  required String id,
  required String status,
  Value<int> step,
  required String data,
  Value<String?> consentVersion,
  Value<int> schemaVersion,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AssessmentsTableUpdateCompanionBuilder = AssessmentsCompanion Function({
  Value<String> id,
  Value<String> status,
  Value<int> step,
  Value<String> data,
  Value<String?> consentVersion,
  Value<int> schemaVersion,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AssessmentsTableFilterComposer extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get consentVersion =>
      $composableBuilder(column: $table.consentVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get schemaVersion =>
      $composableBuilder(column: $table.schemaVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AssessmentsTableOrderingComposer extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AssessmentsTableAnnotationComposer extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get consentVersion =>
      $composableBuilder(column: $table.consentVersion, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion =>
      $composableBuilder(column: $table.schemaVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssessmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssessmentsTable,
          AssessmentRow,
          $$AssessmentsTableFilterComposer,
          $$AssessmentsTableOrderingComposer,
          $$AssessmentsTableAnnotationComposer,
          $$AssessmentsTableCreateCompanionBuilder,
          $$AssessmentsTableUpdateCompanionBuilder,
          (AssessmentRow, BaseReferences<_$AppDatabase, $AssessmentsTable, AssessmentRow>),
          AssessmentRow,
          PrefetchHooks Function()
        > {
  $$AssessmentsTableTableManager(_$AppDatabase db, $AssessmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssessmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<String?> consentVersion = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssessmentsCompanion(
                id: id,
                status: status,
                step: step,
                data: data,
                consentVersion: consentVersion,
                schemaVersion: schemaVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                Value<int> step = const Value.absent(),
                required String data,
                Value<String?> consentVersion = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssessmentsCompanion.insert(
                id: id,
                status: status,
                step: step,
                data: data,
                consentVersion: consentVersion,
                schemaVersion: schemaVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssessmentsTable, AssessmentRow>(table),
                  BaseReferences<_$AppDatabase, $AssessmentsTable, AssessmentRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssessmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssessmentsTable,
      AssessmentRow,
      $$AssessmentsTableFilterComposer,
      $$AssessmentsTableOrderingComposer,
      $$AssessmentsTableAnnotationComposer,
      $$AssessmentsTableCreateCompanionBuilder,
      $$AssessmentsTableUpdateCompanionBuilder,
      (AssessmentRow, BaseReferences<_$AppDatabase, $AssessmentsTable, AssessmentRow>),
      AssessmentRow,
      PrefetchHooks Function()
    >;
typedef $$ConsentsTableCreateCompanionBuilder = ConsentsCompanion Function({
  required String id,
  required String version,
  required DateTime acceptedAt,
  Value<int> rowid,
});
typedef $$ConsentsTableUpdateCompanionBuilder = ConsentsCompanion Function({
  Value<String> id,
  Value<String> version,
  Value<DateTime> acceptedAt,
  Value<int> rowid,
});

class $$ConsentsTableFilterComposer extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get acceptedAt =>
      $composableBuilder(column: $table.acceptedAt, builder: (column) => ColumnFilters(column));
}

class $$ConsentsTableOrderingComposer extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get acceptedAt =>
      $composableBuilder(column: $table.acceptedAt, builder: (column) => ColumnOrderings(column));
}

class $$ConsentsTableAnnotationComposer extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get acceptedAt =>
      $composableBuilder(column: $table.acceptedAt, builder: (column) => column);
}

class $$ConsentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsentsTable,
          ConsentRow,
          $$ConsentsTableFilterComposer,
          $$ConsentsTableOrderingComposer,
          $$ConsentsTableAnnotationComposer,
          $$ConsentsTableCreateCompanionBuilder,
          $$ConsentsTableUpdateCompanionBuilder,
          (ConsentRow, BaseReferences<_$AppDatabase, $ConsentsTable, ConsentRow>),
          ConsentRow,
          PrefetchHooks Function()
        > {
  $$ConsentsTableTableManager(_$AppDatabase db, $ConsentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ConsentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ConsentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<DateTime> acceptedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ConsentsCompanion(id: id, version: version, acceptedAt: acceptedAt, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String version,
                required DateTime acceptedAt,
                Value<int> rowid = const Value.absent(),
              }) => ConsentsCompanion.insert(
                id: id,
                version: version,
                acceptedAt: acceptedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConsentsTable, ConsentRow>(table),
                  BaseReferences<_$AppDatabase, $ConsentsTable, ConsentRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsentsTable,
      ConsentRow,
      $$ConsentsTableFilterComposer,
      $$ConsentsTableOrderingComposer,
      $$ConsentsTableAnnotationComposer,
      $$ConsentsTableCreateCompanionBuilder,
      $$ConsentsTableUpdateCompanionBuilder,
      (ConsentRow, BaseReferences<_$AppDatabase, $ConsentsTable, ConsentRow>),
      ConsentRow,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String status,
  required String assessmentId,
  required String data,
  Value<bool> warningsAcknowledged,
  required DateTime createdAt,
  Value<DateTime?> activatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> status,
  Value<String> assessmentId,
  Value<String> data,
  Value<bool> warningsAcknowledged,
  Value<DateTime> createdAt,
  Value<DateTime?> activatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assessmentId =>
      $composableBuilder(column: $table.assessmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get warningsAcknowledged => $composableBuilder(
    column: $table.warningsAcknowledged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get activatedAt =>
      $composableBuilder(column: $table.activatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableOrderingComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assessmentId =>
      $composableBuilder(column: $table.assessmentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get warningsAcknowledged => $composableBuilder(
    column: $table.warningsAcknowledged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get activatedAt =>
      $composableBuilder(column: $table.activatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get assessmentId =>
      $composableBuilder(column: $table.assessmentId, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get warningsAcknowledged =>
      $composableBuilder(column: $table.warningsAcknowledged, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get activatedAt =>
      $composableBuilder(column: $table.activatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalRow,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalRow, BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>),
          GoalRow,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> assessmentId = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<bool> warningsAcknowledged = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> activatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                status: status,
                assessmentId: assessmentId,
                data: data,
                warningsAcknowledged: warningsAcknowledged,
                createdAt: createdAt,
                activatedAt: activatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                required String assessmentId,
                required String data,
                Value<bool> warningsAcknowledged = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> activatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                status: status,
                assessmentId: assessmentId,
                data: data,
                warningsAcknowledged: warningsAcknowledged,
                createdAt: createdAt,
                activatedAt: activatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, GoalRow>(table),
                  BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalRow,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalRow, BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>),
      GoalRow,
      PrefetchHooks Function()
    >;
typedef $$NutritionTargetsTableCreateCompanionBuilder = NutritionTargetsCompanion Function({
  required String id,
  required String goalId,
  required String status,
  required String data,
  required String configVersion,
  required DateTime createdAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$NutritionTargetsTableUpdateCompanionBuilder = NutritionTargetsCompanion Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> status,
  Value<String> data,
  Value<String> configVersion,
  Value<DateTime> createdAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

class $$NutritionTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionTargetsTable> {
  $$NutritionTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configVersion =>
      $composableBuilder(column: $table.configVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => ColumnFilters(column));
}

class $$NutritionTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionTargetsTable> {
  $$NutritionTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configVersion => $composableBuilder(
    column: $table.configVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$NutritionTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionTargetsTable> {
  $$NutritionTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get configVersion =>
      $composableBuilder(column: $table.configVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => column);
}

class $$NutritionTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutritionTargetsTable,
          NutritionTargetRow,
          $$NutritionTargetsTableFilterComposer,
          $$NutritionTargetsTableOrderingComposer,
          $$NutritionTargetsTableAnnotationComposer,
          $$NutritionTargetsTableCreateCompanionBuilder,
          $$NutritionTargetsTableUpdateCompanionBuilder,
          (
            NutritionTargetRow,
            BaseReferences<_$AppDatabase, $NutritionTargetsTable, NutritionTargetRow>,
          ),
          NutritionTargetRow,
          PrefetchHooks Function()
        > {
  $$NutritionTargetsTableTableManager(_$AppDatabase db, $NutritionTargetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionTargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<String> configVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionTargetsCompanion(
                id: id,
                goalId: goalId,
                status: status,
                data: data,
                configVersion: configVersion,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required String status,
                required String data,
                required String configVersion,
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionTargetsCompanion.insert(
                id: id,
                goalId: goalId,
                status: status,
                data: data,
                configVersion: configVersion,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NutritionTargetsTable, NutritionTargetRow>(table),
                  BaseReferences<_$AppDatabase, $NutritionTargetsTable, NutritionTargetRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutritionTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutritionTargetsTable,
      NutritionTargetRow,
      $$NutritionTargetsTableFilterComposer,
      $$NutritionTargetsTableOrderingComposer,
      $$NutritionTargetsTableAnnotationComposer,
      $$NutritionTargetsTableCreateCompanionBuilder,
      $$NutritionTargetsTableUpdateCompanionBuilder,
      (
        NutritionTargetRow,
        BaseReferences<_$AppDatabase, $NutritionTargetsTable, NutritionTargetRow>,
      ),
      NutritionTargetRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutPlansTableCreateCompanionBuilder = WorkoutPlansCompanion Function({
  required String id,
  required String status,
  required String source,
  required String generatorVersion,
  required String catalogVersion,
  required String assessmentId,
  required String split,
  required String level,
  required int daysPerWeek,
  required int sessionMinutes,
  required String warnings,
  required DateTime createdAt,
  Value<DateTime?> activatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$WorkoutPlansTableUpdateCompanionBuilder = WorkoutPlansCompanion Function({
  Value<String> id,
  Value<String> status,
  Value<String> source,
  Value<String> generatorVersion,
  Value<String> catalogVersion,
  Value<String> assessmentId,
  Value<String> split,
  Value<String> level,
  Value<int> daysPerWeek,
  Value<int> sessionMinutes,
  Value<String> warnings,
  Value<DateTime> createdAt,
  Value<DateTime?> activatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

final class $$WorkoutPlansTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlanRow> {
  $$WorkoutPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanDaysTable, List<PlanDayRow>> _planDaysRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.planDays,
    aliasName: 'workout_plans__id__plan_days__plan_id',
  );

  $$PlanDaysTableProcessedTableManager get planDaysRefs {
    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planDaysRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutPlansTableFilterComposer extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogVersion =>
      $composableBuilder(column: $table.catalogVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assessmentId =>
      $composableBuilder(column: $table.assessmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get split =>
      $composableBuilder(column: $table.split, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get daysPerWeek =>
      $composableBuilder(column: $table.daysPerWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionMinutes =>
      $composableBuilder(column: $table.sessionMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get warnings =>
      $composableBuilder(column: $table.warnings, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get activatedAt =>
      $composableBuilder(column: $table.activatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> planDaysRefs(Expression<bool> Function($$PlanDaysTableFilterComposer f) f) {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutPlansTableOrderingComposer extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assessmentId =>
      $composableBuilder(column: $table.assessmentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get split =>
      $composableBuilder(column: $table.split, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get daysPerWeek =>
      $composableBuilder(column: $table.daysPerWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warnings =>
      $composableBuilder(column: $table.warnings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get activatedAt =>
      $composableBuilder(column: $table.activatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutPlansTableAnnotationComposer extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get generatorVersion =>
      $composableBuilder(column: $table.generatorVersion, builder: (column) => column);

  GeneratedColumn<String> get catalogVersion =>
      $composableBuilder(column: $table.catalogVersion, builder: (column) => column);

  GeneratedColumn<String> get assessmentId =>
      $composableBuilder(column: $table.assessmentId, builder: (column) => column);

  GeneratedColumn<String> get split =>
      $composableBuilder(column: $table.split, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get daysPerWeek =>
      $composableBuilder(column: $table.daysPerWeek, builder: (column) => column);

  GeneratedColumn<int> get sessionMinutes =>
      $composableBuilder(column: $table.sessionMinutes, builder: (column) => column);

  GeneratedColumn<String> get warnings =>
      $composableBuilder(column: $table.warnings, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get activatedAt =>
      $composableBuilder(column: $table.activatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt =>
      $composableBuilder(column: $table.archivedAt, builder: (column) => column);

  Expression<T> planDaysRefs<T extends Object>(
    Expression<T> Function($$PlanDaysTableAnnotationComposer a) f,
  ) {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPlansTable,
          WorkoutPlanRow,
          $$WorkoutPlansTableFilterComposer,
          $$WorkoutPlansTableOrderingComposer,
          $$WorkoutPlansTableAnnotationComposer,
          $$WorkoutPlansTableCreateCompanionBuilder,
          $$WorkoutPlansTableUpdateCompanionBuilder,
          (WorkoutPlanRow, $$WorkoutPlansTableReferences),
          WorkoutPlanRow,
          PrefetchHooks Function({bool planDaysRefs})
        > {
  $$WorkoutPlansTableTableManager(_$AppDatabase db, $WorkoutPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$WorkoutPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$WorkoutPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> generatorVersion = const Value.absent(),
                Value<String> catalogVersion = const Value.absent(),
                Value<String> assessmentId = const Value.absent(),
                Value<String> split = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int> daysPerWeek = const Value.absent(),
                Value<int> sessionMinutes = const Value.absent(),
                Value<String> warnings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> activatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion(
                id: id,
                status: status,
                source: source,
                generatorVersion: generatorVersion,
                catalogVersion: catalogVersion,
                assessmentId: assessmentId,
                split: split,
                level: level,
                daysPerWeek: daysPerWeek,
                sessionMinutes: sessionMinutes,
                warnings: warnings,
                createdAt: createdAt,
                activatedAt: activatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                required String source,
                required String generatorVersion,
                required String catalogVersion,
                required String assessmentId,
                required String split,
                required String level,
                required int daysPerWeek,
                required int sessionMinutes,
                required String warnings,
                required DateTime createdAt,
                Value<DateTime?> activatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion.insert(
                id: id,
                status: status,
                source: source,
                generatorVersion: generatorVersion,
                catalogVersion: catalogVersion,
                assessmentId: assessmentId,
                split: split,
                level: level,
                daysPerWeek: daysPerWeek,
                sessionMinutes: sessionMinutes,
                warnings: warnings,
                createdAt: createdAt,
                activatedAt: activatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutPlansTable, WorkoutPlanRow>(table),
                  $$WorkoutPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (planDaysRefs) db.planDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planDaysRefs)
                    await $_getPrefetchedDataByColumns<
                      WorkoutPlanRow,
                      $WorkoutPlansTable,
                      PlanDayRow,
                      $PlanDaysTable
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutPlansTableReferences._planDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutPlansTableReferences(db, table, p0).planDaysRefs,
                      currentColumn: 'id',
                      referencedColumn: 'plan_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPlansTable,
      WorkoutPlanRow,
      $$WorkoutPlansTableFilterComposer,
      $$WorkoutPlansTableOrderingComposer,
      $$WorkoutPlansTableAnnotationComposer,
      $$WorkoutPlansTableCreateCompanionBuilder,
      $$WorkoutPlansTableUpdateCompanionBuilder,
      (WorkoutPlanRow, $$WorkoutPlansTableReferences),
      WorkoutPlanRow,
      PrefetchHooks Function({bool planDaysRefs})
    >;
typedef $$PlanDaysTableCreateCompanionBuilder = PlanDaysCompanion Function({
  required String planId,
  required String id,
  required int position,
  required int weekday,
  required String focus,
  required int warmupMinutes,
  required int estimatedMinutes,
  required String exercises,
  Value<int> rowid,
});
typedef $$PlanDaysTableUpdateCompanionBuilder = PlanDaysCompanion Function({
  Value<String> planId,
  Value<String> id,
  Value<int> position,
  Value<int> weekday,
  Value<String> focus,
  Value<int> warmupMinutes,
  Value<int> estimatedMinutes,
  Value<String> exercises,
  Value<int> rowid,
});

final class $$PlanDaysTableReferences
    extends BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDayRow> {
  $$PlanDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutPlansTable _planIdTable(_$AppDatabase db) =>
      db.workoutPlans.createAlias('plan_days__plan_id__workout_plans__id');

  $$WorkoutPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$WorkoutPlansTableTableManager(
      $_db,
      $_db.workoutPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlanDaysTableFilterComposer extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warmupMinutes =>
      $composableBuilder(column: $table.warmupMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exercises =>
      $composableBuilder(column: $table.exercises, builder: (column) => ColumnFilters(column));

  $$WorkoutPlansTableFilterComposer get planId {
    final $$WorkoutPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WorkoutPlansTableFilterComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableOrderingComposer extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warmupMinutes => $composableBuilder(
    column: $table.warmupMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercises =>
      $composableBuilder(column: $table.exercises, builder: (column) => ColumnOrderings(column));

  $$WorkoutPlansTableOrderingComposer get planId {
    final $$WorkoutPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WorkoutPlansTableOrderingComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableAnnotationComposer extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<int> get warmupMinutes =>
      $composableBuilder(column: $table.warmupMinutes, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes =>
      $composableBuilder(column: $table.estimatedMinutes, builder: (column) => column);

  GeneratedColumn<String> get exercises =>
      $composableBuilder(column: $table.exercises, builder: (column) => column);

  $$WorkoutPlansTableAnnotationComposer get planId {
    final $$WorkoutPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WorkoutPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanDaysTable,
          PlanDayRow,
          $$PlanDaysTableFilterComposer,
          $$PlanDaysTableOrderingComposer,
          $$PlanDaysTableAnnotationComposer,
          $$PlanDaysTableCreateCompanionBuilder,
          $$PlanDaysTableUpdateCompanionBuilder,
          (PlanDayRow, $$PlanDaysTableReferences),
          PlanDayRow,
          PrefetchHooks Function({bool planId})
        > {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<int> warmupMinutes = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<String> exercises = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion(
                planId: planId,
                id: id,
                position: position,
                weekday: weekday,
                focus: focus,
                warmupMinutes: warmupMinutes,
                estimatedMinutes: estimatedMinutes,
                exercises: exercises,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planId,
                required String id,
                required int position,
                required int weekday,
                required String focus,
                required int warmupMinutes,
                required int estimatedMinutes,
                required String exercises,
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion.insert(
                planId: planId,
                id: id,
                position: position,
                weekday: weekday,
                focus: focus,
                warmupMinutes: warmupMinutes,
                estimatedMinutes: estimatedMinutes,
                exercises: exercises,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanDaysTable, PlanDayRow>(table),
                  $$PlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.planId,
                        referencedTable: $$PlanDaysTableReferences._planIdTable(db),
                        referencedColumn: $$PlanDaysTableReferences._planIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanDaysTable,
      PlanDayRow,
      $$PlanDaysTableFilterComposer,
      $$PlanDaysTableOrderingComposer,
      $$PlanDaysTableAnnotationComposer,
      $$PlanDaysTableCreateCompanionBuilder,
      $$PlanDaysTableUpdateCompanionBuilder,
      (PlanDayRow, $$PlanDaysTableReferences),
      PlanDayRow,
      PrefetchHooks Function({bool planId})
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion Function({
  required String id,
  required String planId,
  required String dayId,
  required String date,
  required int weekday,
  required String focus,
  required String status,
  required String planned,
  Value<String?> notes,
  Value<int?> energy,
  Value<String?> discomfort,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion Function({
  Value<String> id,
  Value<String> planId,
  Value<String> dayId,
  Value<String> date,
  Value<int> weekday,
  Value<String> focus,
  Value<String> status,
  Value<String> planned,
  Value<String?> notes,
  Value<int?> energy,
  Value<String?> discomfort,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

final class $$WorkoutSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSessionRow> {
  $$WorkoutSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SetLogsTable, List<SetLogRow>> _setLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.setLogs,
        aliasName: 'workout_sessions__id__set_logs__session_id',
      );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutSessionsTableFilterComposer extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planned =>
      $composableBuilder(column: $table.planned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discomfort =>
      $composableBuilder(column: $table.discomfort, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> setLogsRefs(Expression<bool> Function($$SetLogsTableFilterComposer f) f) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planned =>
      $composableBuilder(column: $table.planned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discomfort =>
      $composableBuilder(column: $table.discomfort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get planned =>
      $composableBuilder(column: $table.planned, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<String> get discomfort =>
      $composableBuilder(column: $table.discomfort, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => column);

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSessionRow,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSessionRow, $$WorkoutSessionsTableReferences),
          WorkoutSessionRow,
          PrefetchHooks Function({bool setLogsRefs})
        > {
  $$WorkoutSessionsTableTableManager(_$AppDatabase db, $WorkoutSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> planned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> energy = const Value.absent(),
                Value<String?> discomfort = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                planId: planId,
                dayId: dayId,
                date: date,
                weekday: weekday,
                focus: focus,
                status: status,
                planned: planned,
                notes: notes,
                energy: energy,
                discomfort: discomfort,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required String dayId,
                required String date,
                required int weekday,
                required String focus,
                required String status,
                required String planned,
                Value<String?> notes = const Value.absent(),
                Value<int?> energy = const Value.absent(),
                Value<String?> discomfort = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                planId: planId,
                dayId: dayId,
                date: date,
                weekday: weekday,
                focus: focus,
                status: status,
                planned: planned,
                notes: notes,
                energy: energy,
                discomfort: discomfort,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSessionRow>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedDataByColumns<
                      WorkoutSessionRow,
                      $WorkoutSessionsTable,
                      SetLogRow,
                      $SetLogsTable
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences._setLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(db, table, p0).setLogsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSessionRow,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSessionRow, $$WorkoutSessionsTableReferences),
      WorkoutSessionRow,
      PrefetchHooks Function({bool setLogsRefs})
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  required String id,
  required String sessionId,
  required String exerciseId,
  required int exerciseIndex,
  required int setNumber,
  Value<double?> weightKg,
  required int reps,
  Value<int?> rir,
  required String status,
  required DateTime loggedAt,
  Value<int> rowid,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> exerciseId,
  Value<int> exerciseIndex,
  Value<int> setNumber,
  Value<double?> weightKg,
  Value<int> reps,
  Value<int?> rir,
  Value<String> status,
  Value<DateTime> loggedAt,
  Value<int> rowid,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLogRow> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias('set_logs__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SetLogsTableFilterComposer extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId =>
      $composableBuilder(column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exerciseIndex =>
      $composableBuilder(column: $table.exerciseIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => ColumnFilters(column));

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId =>
      $composableBuilder(column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exerciseIndex => $composableBuilder(
    column: $table.exerciseIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => ColumnOrderings(column));

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId =>
      $composableBuilder(column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<int> get exerciseIndex =>
      $composableBuilder(column: $table.exerciseIndex, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLogRow,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLogRow, $$SetLogsTableReferences),
          SetLogRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> exerciseIndex = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int?> rir = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                exerciseIndex: exerciseIndex,
                setNumber: setNumber,
                weightKg: weightKg,
                reps: reps,
                rir: rir,
                status: status,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String exerciseId,
                required int exerciseIndex,
                required int setNumber,
                Value<double?> weightKg = const Value.absent(),
                required int reps,
                Value<int?> rir = const Value.absent(),
                required String status,
                required DateTime loggedAt,
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                exerciseIndex: exerciseIndex,
                setNumber: setNumber,
                weightKg: weightKg,
                reps: reps,
                rir: rir,
                status: status,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLogRow>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SetLogsTableReferences._sessionIdTable(db),
                        referencedColumn: $$SetLogsTableReferences._sessionIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLogRow,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLogRow, $$SetLogsTableReferences),
      SetLogRow,
      PrefetchHooks Function({bool sessionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfileStateTableTableManager get profileState =>
      $$ProfileStateTableTableManager(_db, _db.profileState);
  $$AssessmentsTableTableManager get assessments =>
      $$AssessmentsTableTableManager(_db, _db.assessments);
  $$ConsentsTableTableManager get consents => $$ConsentsTableTableManager(_db, _db.consents);
  $$GoalsTableTableManager get goals => $$GoalsTableTableManager(_db, _db.goals);
  $$NutritionTargetsTableTableManager get nutritionTargets =>
      $$NutritionTargetsTableTableManager(_db, _db.nutritionTargets);
  $$WorkoutPlansTableTableManager get workoutPlans =>
      $$WorkoutPlansTableTableManager(_db, _db.workoutPlans);
  $$PlanDaysTableTableManager get planDays => $$PlanDaysTableTableManager(_db, _db.planDays);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SetLogsTableTableManager get setLogs => $$SetLogsTableTableManager(_db, _db.setLogs);
}
