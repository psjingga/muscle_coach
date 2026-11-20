import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/food.dart';
import '../../domain/food_log.dart';
import 'nutrition_labels.dart';

/// Hasil lembar porsi/manual. `delete` = pengguna memilih hapus.
typedef PortionResult = ({double grams, MealSlot meal, bool delete});
typedef ManualResult = ({String name, Nutrients nutrients, MealSlot meal, bool delete});

const _maxGrams = 5000.0;

Widget _sheetFrame(BuildContext context, List<Widget> children) => Padding(
  padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
  child: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    ),
  ),
);

Widget _mealField(BuildContext context, MealSlot value, ValueChanged<MealSlot> onChanged) {
  final l = context.l10n;
  return DropdownButtonFormField<MealSlot>(
    key: const Key('portion-meal'),
    initialValue: value,
    decoration: InputDecoration(labelText: l.portionMeal),
    items: [for (final s in MealSlot.values) DropdownMenuItem(value: s, child: Text(l.meal(s)))],
    onChanged: (v) => v == null ? null : onChanged(v),
  );
}

/// Lembar porsi: gram + waktu makan, pratinjau gizi dihitung dari katalog.
Future<PortionResult?> showPortionSheet(
  BuildContext context, {
  required Food food,
  required MealSlot meal,
  double? initialGrams,
  double? lastGrams,
  bool allowDelete = false,
}) => showModalBottomSheet<PortionResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _PortionSheet(
    food: food,
    meal: meal,
    initialGrams: initialGrams,
    lastGrams: lastGrams,
    allowDelete: allowDelete,
  ),
);

class _PortionSheet extends StatefulWidget {
  const _PortionSheet({
    required this.food,
    required this.meal,
    this.initialGrams,
    this.lastGrams,
    required this.allowDelete,
  });

  final Food food;
  final MealSlot meal;
  final double? initialGrams;
  final double? lastGrams;
  final bool allowDelete;

  @override
  State<_PortionSheet> createState() => _PortionSheetState();
}

class _PortionSheetState extends State<_PortionSheet> {
  late final _grams = TextEditingController(
    text: gramsText(widget.initialGrams ?? widget.lastGrams ?? widget.food.defaultGrams ?? 100),
  );
  late MealSlot _meal = widget.meal;

  double? get _value {
    final v = Fmt.parseDecimal(_grams.text);
    return v != null && v > 0 && v <= _maxGrams ? v : null;
  }

  @override
  void dispose() {
    _grams.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final food = widget.food;
    final g = _value;
    final n = g == null ? null : food.per100g.forGrams(g);
    final presets = <double>{?widget.lastGrams, ?food.defaultGrams, 50, 100, 150, 200}.toList();
    final edible = food.ediblePct;
    return _sheetFrame(context, [
      Text(food.name, style: theme.textTheme.titleLarge),
      const SizedBox(height: 4),
      Text(
        '${l.foodPer100(Fmt.integer(food.per100g.kcal))} · ${l.macros(food.per100g)}',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 16),
      TextField(
        key: const Key('portion-grams'),
        controller: _grams,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        decoration: InputDecoration(
          labelText: l.portionGrams,
          suffixText: 'g',
          errorText: g == null ? l.portionGramsError : null,
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final p in presets)
            ActionChip(
              label: Text(
                p == widget.lastGrams ? l.portionLast(gramsText(p)) : l.gramValue(gramsText(p)),
              ),
              onPressed: () => setState(() => _grams.text = gramsText(p)),
            ),
        ],
      ),
      const SizedBox(height: 12),
      _mealField(context, _meal, (v) => setState(() => _meal = v)),
      const SizedBox(height: 16),
      if (n != null)
        Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(l.kcal(n.kcal), style: theme.textTheme.titleLarge),
                const SizedBox(width: 12),
                Expanded(child: Text(l.macros(n), textAlign: TextAlign.end)),
              ],
            ),
          ),
        ),
      if (edible != null && edible < 100) ...[
        const SizedBox(height: 8),
        Text(l.portionEdible(Fmt.integer(edible)), style: theme.textTheme.bodySmall),
      ],
      if (food.quality == NutritionQuality.inconsistent) ...[
        const SizedBox(height: 8),
        Text(
          l.portionInconsistent,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
        ),
      ],
      const SizedBox(height: 16),
      Row(
        children: [
          if (widget.allowDelete)
            TextButton.icon(
              key: const Key('portion-delete'),
              onPressed: () => Navigator.pop(context, (grams: 0.0, meal: _meal, delete: true)),
              icon: const Icon(Icons.delete_outline),
              label: Text(l.delete),
            ),
          const Spacer(),
          FilledButton(
            key: const Key('portion-save'),
            style: FilledButton.styleFrom(minimumSize: const Size(120, 48)),
            onPressed: g == null
                ? null
                : () => Navigator.pop(context, (grams: g, meal: _meal, delete: false)),
            child: Text(l.save),
          ),
        ],
      ),
    ]);
  }
}

String? _numberError(BuildContext context, String text, {bool required = true}) {
  final l = context.l10n;
  if (text.trim().isEmpty) return required ? l.customFoodRequired : null;
  final v = Fmt.parseDecimal(text);
  return v == null || v < 0 || v > _maxGrams ? l.customFoodNumber : null;
}

double _num(String text) => Fmt.parseDecimal(text) ?? 0;

/// Kolom angka gizi (kcal/protein/karbo/lemak) yang dipakai bersama.
class _NutrientFields extends StatelessWidget {
  const _NutrientFields({required this.controllers, required this.onChanged});

  final List<TextEditingController> controllers;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = [l.customFoodKcal, l.customFoodProtein, l.customFoodCarbs, l.customFoodFat];
    const keys = ['kcal', 'protein', 'carbs', 'fat'];
    return Column(
      children: [
        for (var i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              key: Key('nutrient-${keys[i]}'),
              controller: controllers[i],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: InputDecoration(labelText: labels[i]),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => _numberError(context, v ?? '', required: i == 0),
              onChanged: (_) => onChanged(),
            ),
          ),
      ],
    );
  }
}

/// Peringatan bila energi label jauh dari 4/4/9 × makro (tidak memblokir).
String? _mismatchNote(BuildContext context, List<TextEditingController> c) {
  final kcal = _num(c[0].text);
  final computed = 4 * _num(c[1].text) + 4 * _num(c[2].text) + 9 * _num(c[3].text);
  if (kcal <= 0 || computed <= 0) return null;
  return (computed - kcal).abs() > 0.25 * kcal + 15
      ? context.l10n.customFoodMismatch(Fmt.integer(computed))
      : null;
}

/// Lembar catatan manual (kalori/makro saja).
Future<ManualResult?> showManualEntrySheet(
  BuildContext context, {
  required MealSlot meal,
  String? name,
  Nutrients? initial,
  bool allowDelete = false,
}) => showModalBottomSheet<ManualResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _ManualSheet(meal: meal, name: name, initial: initial, allowDelete: allowDelete),
);

class _ManualSheet extends StatefulWidget {
  const _ManualSheet({required this.meal, this.name, this.initial, required this.allowDelete});

  final MealSlot meal;
  final String? name;
  final Nutrients? initial;
  final bool allowDelete;

  @override
  State<_ManualSheet> createState() => _ManualSheetState();
}

class _ManualSheetState extends State<_ManualSheet> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.name ?? '');
  late final _fields = [
    for (final v in [
      widget.initial?.kcal,
      widget.initial?.protein,
      widget.initial?.carbs,
      widget.initial?.fat,
    ])
      TextEditingController(text: v == null ? '' : Fmt.one(v)),
  ];
  late MealSlot _meal = widget.meal;

  @override
  void dispose() {
    _name.dispose();
    for (final c in _fields) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(context, (
      name: _name.text.trim(),
      meal: _meal,
      delete: false,
      nutrients: Nutrients(
        kcal: _num(_fields[0].text),
        protein: _num(_fields[1].text),
        carbs: _num(_fields[2].text),
        fat: _num(_fields[3].text),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mismatch = _mismatchNote(context, _fields);
    return Form(
      key: _form,
      child: _sheetFrame(context, [
        Text(l.manualTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('manual-name'),
          controller: _name,
          maxLength: 80,
          decoration: InputDecoration(labelText: l.manualName, hintText: l.manualNameHint),
          validator: (v) => (v ?? '').trim().isEmpty ? l.customFoodRequired : null,
        ),
        _NutrientFields(controllers: _fields, onChanged: () => setState(() {})),
        if (mismatch != null) ...[const SizedBox(height: 8), Text(mismatch)],
        const SizedBox(height: 12),
        _mealField(context, _meal, (v) => setState(() => _meal = v)),
        const SizedBox(height: 16),
        Row(
          children: [
            if (widget.allowDelete)
              TextButton.icon(
                onPressed: () => Navigator.pop(context, (
                  name: '',
                  meal: _meal,
                  delete: true,
                  nutrients: Nutrients.zero,
                )),
                icon: const Icon(Icons.delete_outline),
                label: Text(l.delete),
              ),
            const Spacer(),
            FilledButton(
              key: const Key('manual-save'),
              style: FilledButton.styleFrom(minimumSize: const Size(120, 48)),
              onPressed: _save,
              child: Text(l.save),
            ),
          ],
        ),
      ]),
    );
  }
}

/// Data makanan dari label: nama, basis gram, gizi per basis.
typedef CustomFoodInput = ({String name, Nutrients per100g, double basisGrams});

/// Layar penuh untuk memasukkan makanan dari label kemasan.
class CustomFoodScreen extends StatefulWidget {
  const CustomFoodScreen({super.key});

  @override
  State<CustomFoodScreen> createState() => _CustomFoodScreenState();
}

class _CustomFoodScreenState extends State<CustomFoodScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _basis = TextEditingController(text: '100');
  final _fields = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    _name.dispose();
    _basis.dispose();
    for (final c in _fields) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final basis = _num(_basis.text);
    final perBasis = Nutrients(
      kcal: _num(_fields[0].text),
      protein: _num(_fields[1].text),
      carbs: _num(_fields[2].text),
      fat: _num(_fields[3].text),
    );
    Navigator.pop<CustomFoodInput>(context, (
      name: _name.text.trim(),
      per100g: perBasis.scale(100 / basis),
      basisGrams: basis,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mismatch = _mismatchNote(context, _fields);
    return Scaffold(
      appBar: AppBar(title: Text(l.customFoodTitle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('custom-name'),
              controller: _name,
              maxLength: 80,
              decoration: InputDecoration(labelText: l.customFoodName),
              validator: (v) => (v ?? '').trim().isEmpty ? l.customFoodRequired : null,
            ),
            TextFormField(
              key: const Key('custom-basis'),
              controller: _basis,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l.customFoodBasis,
                helperText: l.customFoodBasisHelp,
                suffixText: 'g',
              ),
              validator: (v) {
                final x = Fmt.parseDecimal(v ?? '');
                return x == null || x <= 0 || x > _maxGrams ? l.portionGramsError : null;
              },
            ),
            _NutrientFields(controllers: _fields, onChanged: () => setState(() {})),
            if (mismatch != null) ...[const SizedBox(height: 8), Text(mismatch)],
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('custom-save'),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: _save,
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}
