import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_palette.dart';
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
    final palette = context.palette;
    final results = ref.watch(foodSearchProvider(_q));
    final info = ref.watch(foodSourceInfoProvider).value;
    final hint = TextStyle(fontSize: 14, color: palette.muted);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.nutritionAddTo(l.meal(widget.meal))),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              key: const Key('food-search'),
              controller: _query,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded, color: palette.muted),
                hintText: l.foodSearchHint,
                hintStyle: hint,
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.close,
                        icon: const Icon(Icons.close_rounded),
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
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  if (_q.isEmpty && foods.isNotEmpty)
                    _Header(l.foodRecent)
                  else if (_q.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(l.foodRecentEmpty, style: hint),
                    )
                  else if (foods.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(l.foodNoResult, style: hint),
                    ),
                  if (foods.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            for (var i = 0; i < foods.length; i++) ...[
                              if (i > 0) const Divider(height: 1),
                              _FoodTile(food: foods[i], onTap: () => _pick(foods[i])),
                            ],
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _Header(l.fmOtherWays),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _ActionRow(
                          key: const Key('food-add-custom'),
                          icon: Icons.qr_code_2_rounded,
                          label: l.foodAddCustom,
                          onTap: _custom,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ActionRow(
                          key: const Key('food-add-manual'),
                          icon: Icons.edit_note_rounded,
                          label: l.foodAddManual,
                          onTap: _manual,
                        ),
                      ],
                    ),
                  ),
                  if (info != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        l.foodSourceAttribution(
                          info.name,
                          info.publisher,
                          Fmt.isoDate(info.retrieved),
                        ),
                        style: TextStyle(fontSize: 12, color: palette.muted),
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
    padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: context.palette.muted,
      ),
    ),
  );
}

/// Aksi alternatif (makanan dari label / catat manual).
class _ActionRow extends StatelessWidget {
  const _ActionRow({super.key, required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: palette.accentSoft, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            Icon(Icons.chevron_right_rounded, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

/// Baris hasil: nama + label sumber, kategori, kcal per 100 g.
class _FoodTile extends StatelessWidget {
  const _FoodTile({required this.food, required this.onTap});

  final Food food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final (badge, fg, bg) = switch (food) {
      Food(origin: FoodOrigin.custom) => (
        l.foodCustomBadge,
        theme.colorScheme.primary,
        palette.accentSoft,
      ),
      Food(quality: NutritionQuality.inconsistent) => (
        l.foodInconsistentBadge,
        palette.warning,
        palette.warning.withValues(alpha: 0.15),
      ),
      _ => (l.fmSourceTkpi, palette.muted, palette.surface2),
    };
    return InkWell(
      key: Key('food-${food.id}'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          food.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
                        ),
                      ),
                    ],
                  ),
                  if (food.category != null) ...[
                    const SizedBox(height: 2),
                    Text(food.category!, style: TextStyle(fontSize: 12, color: palette.muted)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Fmt.integer(food.per100g.kcal),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
                Text(l.fmKcalPer100, style: TextStyle(fontSize: 11, color: palette.muted)),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.add_circle_outline_rounded, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
