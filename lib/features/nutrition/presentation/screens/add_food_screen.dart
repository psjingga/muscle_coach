import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/food.dart';
import '../../domain/food_log.dart';
import '../providers/nutrition_providers.dart';
import '../widgets/food_forms.dart';
import '../widgets/nutrition_labels.dart';

/// Cari makanan di katalog (TKPI + milik sendiri) lalu catat porsinya.
class AddFoodScreen extends ConsumerStatefulWidget {
  const AddFoodScreen({super.key, required this.date, required this.meal});

  final String date;
  final MealSlot meal;

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final _query = TextEditingController();
  Timer? _debounce;
  String _q = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _q = v.trim());
    });
  }

  Future<void> _pick(Food food) async {
    final last = ref.read(recentGramsProvider).value?[food.id];
    final res = await showPortionSheet(context, food: food, meal: widget.meal, lastGrams: last);
    if (res == null || !mounted) return;
    final ok = await ref
        .read(nutritionActionsProvider.notifier)
        .logFood(date: widget.date, meal: res.meal, food: food, grams: res.grams);
    if (!mounted) return;
    if (ok) {
      context.showSnack(context.l10n.entrySaved);
      Navigator.pop(context);
    } else {
      context.showSnack(context.l10n.errorUnknown);
    }
  }

  Future<void> _custom() async {
    final input = await Navigator.of(context)
        .push<CustomFoodInput>(MaterialPageRoute(builder: (_) => const CustomFoodScreen()));
    if (input == null || !mounted) return;
    final actions = ref.read(nutritionActionsProvider.notifier);
    final id = await actions.addCustomFood(
      name: input.name,
      per100g: input.per100g,
      servingGrams: input.basisGrams == 100 ? null : input.basisGrams,
    );
    if (id == null || !mounted) return;
    context.showSnack(context.l10n.customFoodSaved);
    // Langsung dari repository: cache katalog mungkin belum memuat makanan baru.
    final food = (await ref.read(nutritionRepositoryProvider).catalog())[id];
    if (food != null && mounted) await _pick(food);
  }

  Future<void> _manual() async {
    final res = await showManualEntrySheet(context, meal: widget.meal);
    if (res == null || !mounted) return;
    final ok = await ref
        .read(nutritionActionsProvider.notifier)
        .logManual(date: widget.date, meal: res.meal, name: res.name, nutrients: res.nutrients);
    if (!mounted) return;
    if (ok) {
      context.showSnack(context.l10n.entrySaved);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final results = ref.watch(foodSearchProvider(_q));
    final info = ref.watch(foodSourceInfoProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.nutritionAddTo(l.meal(widget.meal)))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              key: const Key('food-search'),
              controller: _query,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l.foodSearchHint,
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.close,
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _query.clear();
                          setState(() => _q = '');
                        },
                      ),
              ),
              onChanged: _onChanged,
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l.errorUnknown)),
              data: (foods) => ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  if (_q.isEmpty && foods.isNotEmpty)
                    _Header(l.foodRecent)
                  else if (_q.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l.foodRecentEmpty, style: theme.textTheme.bodyMedium),
                    )
                  else if (foods.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l.foodNoResult, style: theme.textTheme.bodyMedium),
                    ),
                  for (final f in foods) _FoodTile(food: f, onTap: () => _pick(f)),
                  const Divider(),
                  ListTile(
                    key: const Key('food-add-custom'),
                    leading: const Icon(Icons.qr_code_2),
                    title: Text(l.foodAddCustom),
                    onTap: _custom,
                  ),
                  ListTile(
                    key: const Key('food-add-manual'),
                    leading: const Icon(Icons.edit_note),
                    title: Text(l.foodAddManual),
                    onTap: _manual,
                  ),
                  if (info != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l.foodSourceAttribution(
                          info.name,
                          info.publisher,
                          Fmt.isoDate(info.retrieved),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _FoodTile extends StatelessWidget {
  const _FoodTile({required this.food, required this.onTap});

  final Food food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final badge = switch (food) {
      Food(origin: FoodOrigin.custom) => l.foodCustomBadge,
      Food(quality: NutritionQuality.inconsistent) => l.foodInconsistentBadge,
      _ => null,
    };
    return ListTile(
      key: Key('food-${food.id}'),
      title: Text(food.name),
      subtitle: Text([?food.category, l.foodPer100(Fmt.integer(food.per100g.kcal))].join(' · ')),
      trailing: badge == null
          ? const Icon(Icons.add_circle_outline)
          : Chip(
              label: Text(badge),
              visualDensity: VisualDensity.compact,
              labelStyle: theme.textTheme.labelSmall,
            ),
      onTap: onTap,
    );
  }
}
