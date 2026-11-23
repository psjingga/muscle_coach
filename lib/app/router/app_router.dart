import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/ai_coach/presentation/screens/ai_settings_screen.dart';
import '../../features/assessment/presentation/screens/assessment_wizard_screen.dart';
import '../../features/dashboard/presentation/screens/home_screen.dart';
import '../../features/reminders/presentation/screens/notification_settings_screen.dart';
import '../../features/exercise_library/presentation/screens/exercise_screens.dart';
import '../../features/goals/presentation/screens/goal_review_screen.dart';
import '../../features/nutrition/domain/food_log.dart';
import '../../features/nutrition/presentation/screens/add_food_screen.dart';
import '../../features/nutrition/presentation/screens/meal_plan_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../core/utils/formatters.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/providers/profile_providers.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/progress/presentation/screens/photo_compare_screen.dart';
import '../../features/progress/presentation/screens/check_in_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/progress/presentation/screens/weekly_review_screen.dart';
import '../../features/workout/presentation/screens/day_screen.dart';
import '../../features/workout/presentation/screens/history_screen.dart';
import '../../features/workout/presentation/screens/plan_screen.dart';
import '../../features/workout/presentation/screens/session_screen.dart';
import '../../features/workout/presentation/screens/workout_screen.dart';
import 'app_shell.dart';
import 'onboarding_redirect.dart';
import 'routes.dart';
import 'splash_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Router dibuat sekali; perubahan status onboarding memicu evaluasi ulang redirect.
  final onboarding = ValueNotifier(onboardingStatusOf(ref.read(userProfileProvider)));
  ref.listen(userProfileProvider, (_, next) => onboarding.value = onboardingStatusOf(next));

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: onboarding,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) =>
        onboardingRedirect(onboarding: onboarding.value, location: state.uri.toString()),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(
        path: Routes.assessment,
        builder: (_, state) => AssessmentWizardScreen(
          initialStep: int.tryParse(state.uri.queryParameters['step'] ?? ''),
        ),
      ),
      GoRoute(
        path: '${Routes.goal}/:goalId',
        builder: (_, state) => GoalReviewScreen(goalId: state.pathParameters['goalId']!),
      ),
      GoRoute(
        path: '${Routes.plan}/:planId',
        builder: (_, s) => PlanScreen(planId: s.pathParameters['planId']!),
      ),
      GoRoute(
        path: '${Routes.day}/:planId/:dayId',
        builder: (_, s) =>
            DayScreen(planId: s.pathParameters['planId']!, dayId: s.pathParameters['dayId']!),
      ),
      GoRoute(
        path: '${Routes.session}/:sessionId',
        builder: (_, s) => SessionScreen(sessionId: s.pathParameters['sessionId']!),
      ),
      GoRoute(path: Routes.history, builder: (_, _) => const HistoryScreen()),
      GoRoute(path: Routes.aiSettings, builder: (_, _) => const AiSettingsScreen()),
      GoRoute(path: Routes.reminders, builder: (_, _) => const NotificationSettingsScreen()),
      GoRoute(path: Routes.exercises, builder: (_, _) => const ExerciseLibraryScreen()),
      GoRoute(
        path: '${Routes.exercise}/:exerciseId',
        builder: (_, s) => ExerciseDetailScreen(exerciseId: s.pathParameters['exerciseId']!),
      ),
      GoRoute(
        path: Routes.addFood,
        builder: (_, s) => AddFoodScreen(
          date: s.uri.queryParameters['date'] ?? Fmt.toIsoDate(DateTime.now()),
          meal: MealSlot.values.asNameMap()[s.uri.queryParameters['meal']] ?? MealSlot.snack,
        ),
      ),
      GoRoute(
        path: '${Routes.mealPlan}/:id',
        builder: (_, s) => MealPlanScreen(planId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '${Routes.checkIn}/:date',
        builder: (_, s) => CheckInScreen(date: s.pathParameters['date']!),
      ),
      GoRoute(path: Routes.photoCompare, builder: (_, _) => const PhotoCompareScreen()),
      GoRoute(
        path: '${Routes.weeklyReview}/:week',
        builder: (_, s) => WeeklyReviewScreen(weekStart: s.pathParameters['week']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          _branch(Routes.home, const HomeScreen()),
          _branch(Routes.workout, const WorkoutScreen()),
          _branch(Routes.nutrition, const NutritionScreen()),
          _branch(Routes.progress, const ProgressScreen()),
          _branch(Routes.profile, const ProfileScreen()),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    onboarding.dispose();
    router.dispose();
  });
  return router;
}

StatefulShellBranch _branch(String path, Widget screen) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (_, _) => screen)],
);
