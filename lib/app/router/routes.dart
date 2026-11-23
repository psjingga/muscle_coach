/// Path rute aplikasi.
abstract final class Routes {
  static const splash = '/splash';

  static const onboarding = '/onboarding';
  static const assessment = '/assessment';
  static const goal = '/goal';

  static const plan = '/plan';
  static const day = '/day';
  static const session = '/session';
  static const history = '/history';
  static const exercises = '/exercises';
  static const exercise = '/exercise';
  static const aiSettings = '/settings/ai';
  static const reminders = '/settings/reminders';
  static const addFood = '/food/add';
  static const mealPlan = '/meal-plan';
  static const checkIn = '/check-in';
  static const weeklyReview = '/weekly-review';
  static const photoCompare = '/progress-photos/compare';

  static const home = '/home';
  static const workout = '/workout';
  static const nutrition = '/nutrition';
  static const progress = '/progress';
  static const profile = '/profile';

  /// `/assessment?step=1`
  static String assessmentPath({int? step}) => step == null ? assessment : '$assessment?step=$step';

  static String goalPath(String goalId) => '$goal/$goalId';
  static String planPath(String planId) => '$plan/$planId';
  static String dayPath(String planId, String dayId) => '$day/$planId/$dayId';
  static String sessionPath(String sessionId) => '$session/$sessionId';
  static String exercisePath(String exerciseId) => '$exercise/$exerciseId';
  static String mealPlanPath(String id) => '$mealPlan/$id';
  static String checkInPath(String date) => '$checkIn/$date';
  static String weeklyReviewPath(String weekStart) => '$weeklyReview/$weekStart';

  /// `/food/add?date=2026-11-20&meal=lunch`
  static String addFoodPath(String date, String meal) => '$addFood?date=$date&meal=$meal';

  /// Rute yang boleh dibuka selama onboarding belum selesai.
  static bool isOnboardingRoute(String location) =>
      location == onboarding ||
      location == assessment ||
      location.startsWith('$assessment?') ||
      location.startsWith('$goal/');
}
