import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';

/// Tab Nutrition. Isi dibangun pada fase sesuai IMPLEMENTATION_PLAN.md §4.
class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabNutrition)),
      body: EmptyState(
        icon: Icons.restaurant_outlined,
        title: l.emptyNutritionTitle,
        message: l.emptyNutritionMessage,
      ),
    );
  }
}
