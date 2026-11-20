import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../data/nutrition_repository.dart';
import '../../domain/food_log.dart';
import '../../domain/meal_plan.dart';
import '../meal_plan_flow.dart';
import '../providers/nutrition_providers.dart';
import '../widgets/day_summary_card.dart';
import '../widgets/food_forms.dart';
import '../widgets/nutrition_labels.dart';

/// Tab Nutrisi: asupan harian vs target, catatan per waktu makan, contoh
/// menu (AI), dan pengingat minum air.
class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen> {
  /// Selisih hari dari hari ini (0 = hari ini, negatif = lalu).
  int _offset = 0;

  String get _date {
    final now = ref.read(clockProvider)();
    return Fmt.toIsoDate(DateTime(now.year, now.month, now.day + _offset));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final target = ref.watch(nutritionTargetNutrientsProvider);
    if (target == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.tabNutrition)),
        body: EmptyState(
          icon: Icons.restaurant_outlined,
          title: l.emptyNutritionTitle,
          message: l.emptyNutritionMessage,
        ),
      );
    }
    final date = _date;
    final day = ref.watch(dayNutritionProvider(date));
    final plan = ref.watch(activeMealPlanProvider).value;
    final info = ref.watch(foodSourceInfoProvider).value;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.tabNutrition)),
      body: day.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.errorUnknown)),
        data: (d) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            _DateBar(
              label: _offset == 0 ? l.nutritionToday : Fmt.isoDate(date),
              onPrev: () => setState(() => _offset--),
              onNext: _offset < 0 ? () => setState(() => _offset++) : null,
            ),
            DaySummaryCard(day: d),
            const SizedBox(height: 8),
            for (final slot in MealSlot.values)
              _MealSection(date: date, slot: slot, entries: d.forMeal(slot)),
            const SizedBox(height: 8),
            _MealPlanCard(plan: plan, date: date, entries: d.entries),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.water_drop_outlined),
                title: Text(l.nutritionWaterTitle),
                subtitle: Text(l.nutritionWaterBody),
              ),
            ),
            if (info != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  l.foodSourceAttribution(info.name, info.publisher, Fmt.isoDate(info.retrieved)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateBar extends StatelessWidget {
  const _DateBar({required this.label, required this.onPrev, required this.onNext});

  final String label;
  final VoidCallback onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        IconButton(
          tooltip: l.nutritionPrevDay,
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            label,
            key: const Key('nutrition-date'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: l.nutritionNextDay,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _MealSection extends ConsumerWidget {
  const _MealSection({required this.date, required this.slot, required this.entries});

  final String date;
  final MealSlot slot;
  final List<FoodLogEntry> entries;

  Future<void> _edit(BuildContext context, WidgetRef ref, FoodLogEntry e) async {
    final actions = ref.read(nutritionActionsProvider.notifier);
    final foodId = e.foodId;
    final food = foodId == null ? null : (await ref.read(foodCatalogProvider.future))[foodId];
    if (!context.mounted) return;
    if (food != null) {
      final res = await showPortionSheet(
        context,
        food: food,
        meal: e.meal,
        initialGrams: e.grams,
        allowDelete: true,
      );
      if (res == null) return;
      res.delete
          ? await actions.deleteEntry(e.id)
          : await actions.updateEntry(e.id, meal: res.meal, grams: res.grams);
    } else {
      // Catatan manual, atau makanan sendiri yang sudah dihapus.
      final res = await showManualEntrySheet(
        context,
        meal: e.meal,
        name: e.name,
        initial: e.nutrients,
        allowDelete: true,
      );
      if (res == null) return;
      res.delete
          ? await actions.deleteEntry(e.id)
          : await actions.updateEntry(e.id, meal: res.meal, manual: res.nutrients);
    }
    if (context.mounted) context.showSnack(context.l10n.entrySaved);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final total = entries.fold(0.0, (s, e) => s + e.nutrients.kcal);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entries.isEmpty ? l.meal(slot) : '${l.meal(slot)} · ${l.kcal(total)}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  key: Key('add-${slot.name}'),
                  onPressed: () => context.push(Routes.addFoodPath(date, slot.name)),
                  icon: const Icon(Icons.add),
                  label: Text(l.nutritionAddFood),
                ),
              ],
            ),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l.nutritionEmptyMeal,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final e in entries)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FoodEntryTile(entry: e, onTap: () => _edit(context, ref, e)),
              ),
          ],
        ),
      ),
    );
  }
}

class _MealPlanCard extends ConsumerWidget {
  const _MealPlanCard({required this.plan, required this.date, required this.entries});

  final MealPlan? plan;
  final String date;
  final List<FoodLogEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final p = plan;
    final logged = {for (final e in entries) ?e.planRef};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.mealPlanTitle, style: theme.textTheme.titleMedium)),
                if (p != null)
                  Chip(
                    label: Text(l.mealPlanAiLabel),
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.auto_awesome, size: 16),
                  ),
              ],
            ),
            if (p == null) ...[
              const SizedBox(height: 4),
              Text(l.mealPlanEmpty),
            ] else ...[
              for (var i = 0; i < p.meals.length; i++)
                _PlanMealRow(
                  plan: p,
                  index: i,
                  date: date,
                  eaten: logged.contains(LocalNutritionRepository.planRef(p.id, i)),
                ),
              Text(
                l.mealPlanTotals(
                  l.kcal(p.totals.kcal),
                  Fmt.integer(p.totals.protein),
                  Fmt.integer(p.totals.carbs),
                  Fmt.integer(p.totals.fat),
                ),
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (p != null)
                  OutlinedButton(
                    onPressed: () => context.push(Routes.mealPlanPath(p.id)),
                    child: Text(l.mealPlanOpen),
                  ),
                FilledButton.tonalIcon(
                  key: const Key('meal-plan-generate'),
                  onPressed: () => generateMealPlan(context, ref),
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(p == null ? l.mealPlanGenerate : l.mealPlanRegenerate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanMealRow extends ConsumerWidget {
  const _PlanMealRow({
    required this.plan,
    required this.index,
    required this.date,
    required this.eaten,
  });

  final MealPlan plan;
  final int index;
  final String date;
  final bool eaten;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = plan.meals[index];
    final actions = ref.read(nutritionActionsProvider.notifier);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${l.meal(m.slot)} · ${m.title}'),
      subtitle: Text(
        '${m.items.map((i) => '${i.name} ${l.gramValue(gramsText(i.grams))}').join(', ')}\n'
        '${l.kcal(m.totals.kcal)} · ${l.macros(m.totals)}',
      ),
      isThreeLine: true,
      trailing: eaten
          ? TextButton.icon(
              key: Key('plan-unlog-$index'),
              onPressed: () => actions.unlogPlannedMeal(date, plan, index),
              icon: const Icon(Icons.check_circle),
              label: Text(l.mealPlanUndoEaten),
            )
          : TextButton(
              key: Key('plan-log-$index'),
              onPressed: () async {
                final ok = await actions.logPlannedMeal(date, plan, index);
                if (ok && context.mounted) {
                  context.showSnack(l.mealPlanEatenSnack(l.meal(m.slot)));
                }
              },
              child: Text(l.mealPlanMarkEaten),
            ),
    );
  }
}
