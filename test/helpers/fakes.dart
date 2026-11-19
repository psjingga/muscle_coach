import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:musclecoach/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:musclecoach/features/auth/domain/entities/auth_user.dart';
import 'package:musclecoach/features/auth/domain/repositories/auth_repository.dart';
import 'package:musclecoach/features/goals/domain/repositories/goal_repository.dart';
import 'package:musclecoach/features/profile/domain/account_repository.dart';
import 'package:musclecoach/features/workout/data/workout_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

const testUser = AuthUser(uid: 'u1', email: 'a@b.co', emailVerified: false);

/// Mock repository dengan stream status login yang bisa dikendalikan test.
({MockAuthRepository auth, MockAccountRepository account, StreamController<AuthUser?> users})
createAuthMocks() {
  final auth = MockAuthRepository();
  final account = MockAccountRepository();
  final users = StreamController<AuthUser?>.broadcast();
  when(auth.userChanges).thenAnswer((_) => users.stream);
  when(account.ensureUserProfile).thenAnswer((_) async {});
  return (auth: auth, account: account, users: users);
}

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

class MockGoalRepository extends Mock implements GoalRepository {}

class MockWorkoutRepository extends Mock implements WorkoutRepository {}
