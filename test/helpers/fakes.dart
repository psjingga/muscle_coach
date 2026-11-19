import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:musclecoach/features/goals/domain/repositories/goal_repository.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

class MockGoalRepository extends Mock implements GoalRepository {}

class MockWorkoutRepository extends Mock implements WorkoutRepository {}
