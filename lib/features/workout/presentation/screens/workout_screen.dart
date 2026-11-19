import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';

/// Tab Workout. Isi dibangun pada fase sesuai IMPLEMENTATION_PLAN.md §4.
class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabWorkout)),
      body: EmptyState(
        icon: Icons.fitness_center_outlined,
        title: l.emptyWorkoutTitle,
        message: l.emptyWorkoutMessage,
      ),
    );
  }
}
