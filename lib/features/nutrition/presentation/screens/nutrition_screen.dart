import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/tab_app_bar.dart';
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
        appBar: TabAppBar(title: l.tabNutrition),
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
    final palette = context.palette;
    return Scaffold(
      appBar: TabAppBar(title: l.tabNutrition),
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
            const SizedBox(height: 12),
            DaySummaryCard(day: d),
            for (final slot in MealSlot.values) ...[
              const SizedBox(height: 12),
              _MealSection(date: date, slot: slot, entries: d.forMeal(slot)),
            ],
            const SizedBox(height: 12),
            _MealPlanCard(plan: plan, date: date, entries: d.entries),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: palette.surface2, shape: BoxShape.circle),
                      child: Icon(Icons.water_drop_outlined, size: 20, color: palette.protein),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.nutritionWaterTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            l.nutritionWaterBody,
                            style: TextStyle(fontSize: 12, color: palette.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (info != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  l.foodSourceAttribution(info.name, info.publisher, Fmt.isoDate(info.retrieved)),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: palette.muted),
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
    final theme = Theme.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: l.nutritionPrevDay,
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Text(
              label,
              key: const Key('nutrition-date'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ),
          IconButton(
            tooltip: l.nutritionNextDay,
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
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

  static IconData _icon(MealSlot slot) => switch (slot) {
    MealSlot.breakfast => Icons.wb_twilight_rounded,
    MealSlot.lunch => Icons.wb_sunny_outlined,
    MealSlot.dinner => Icons.dark_mode_outlined,
    MealSlot.snack => Icons.bakery_dining_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final total = entries.fold(0.0, (s, e) => s + e.nutrients.kcal);
    void add() => context.push(Routes.addFoodPath(date, slot.name));
    final title = Row(
      children: [
        Icon(_icon(slot), size: 20, color: palette.muted),
        const SizedBox(width: 8),
        Text(l.meal(slot), style: theme.textTheme.titleMedium),
      ],
    );
    if (entries.isEmpty) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: add,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: Text(
                          l.nutritionEmptyMeal,
                          style: TextStyle(fontSize: 12, color: palette.muted),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  key: Key('add-${slot.name}'),
                  onPressed: add,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l.nutritionAddFood),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(child: title),
                Text(
                  l.kcal(total),
                  key: Key('meal-kcal-${slot.name}'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
              ],
            ),
          ),
          for (final e in entries) ...[
            Divider(height: 1, indent: 16, endIndent: 16, color: theme.colorScheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FoodEntryTile(entry: e, onTap: () => _edit(context, ref, e)),
            ),
          ],
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton.icon(
                key: Key('add-${slot.name}'),
                onPressed: add,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l.nutritionAddFood),
              ),
            ),
          ),
        ],
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
    final palette = context.palette;
    final p = plan;
    final logged = {for (final e in entries) ?e.planRef};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(l.mealPlanTitle, style: theme.textTheme.titleMedium)),
                if (p != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      l.mealPlanAiLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (p == null)
              Text(l.mealPlanEmpty, style: TextStyle(color: palette.muted))
            else ...[
              for (var i = 0; i < p.meals.length; i++)
                _PlanMealRow(
                  plan: p,
                  index: i,
                  date: date,
                  eaten: logged.contains(LocalNutritionRepository.planRef(p.id, i)),
                ),
              const SizedBox(height: 4),
              Text(
                l.mealPlanTotals(
                  l.kcal(p.totals.kcal),
                  Fmt.integer(p.totals.protein),
                  Fmt.integer(p.totals.carbs),
                  Fmt.integer(p.totals.fat),
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFeatures: tabular,
                  color: palette.muted,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (p != null) ...[
                  Expanded(
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.surface2,
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => context.push(Routes.mealPlanPath(p.id)),
                      child: Text(l.mealPlanOpen),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: FilledButton.tonalIcon(
                    key: const Key('meal-plan-generate'),
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.accentSoft,
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () => generateMealPlan(context, ref),
                    icon: Icon(p == null ? Icons.auto_awesome_rounded : Icons.refresh_rounded),
                    label: Text(
                      p == null ? l.mealPlanGenerate : l.mealPlanRegenerate,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
    final theme = Theme.of(context);
    final palette = context.palette;
    final pill = TextButton.styleFrom(
      minimumSize: const Size(48, 36),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l.meal(m.slot)} · ${m.title}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${m.items.map((i) => '${i.name} ${l.gramValue(gramsText(i.grams))}').join(', ')}'
                  ' · ${l.kcal(m.totals.kcal)}',
                  style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          eaten
              ? TextButton.icon(
                  key: Key('plan-unlog-$index'),
                  style: pill.copyWith(
                    backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primary),
                    foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimary),
                  ),
                  onPressed: () => actions.unlogPlannedMeal(date, plan, index),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: Text(l.mealPlanUndoEaten),
                )
              : TextButton(
                  key: Key('plan-log-$index'),
                  style: pill.copyWith(backgroundColor: WidgetStatePropertyAll(palette.accentSoft)),
                  onPressed: () async {
                    final ok = await actions.logPlannedMeal(date, plan, index);
                    if (ok && context.mounted) {
                      context.showSnack(l.mealPlanEatenSnack(l.meal(m.slot)));
                    }
                  },
                  child: Text(l.mealPlanMarkEaten),
                ),
        ],
      ),
    );
  }
}
