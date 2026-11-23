import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/food_log.dart';
import '../../domain/food_scan.dart';
import '../providers/food_scan_providers.dart';
import '../widgets/nutrition_labels.dart';

/// Tinjau hasil scan makanan sebelum dicatat: ubah gram, hapus item, pilih
/// waktu makan. Gizi item TKPI dari katalog; sisanya estimasi AI.
class FoodScanScreen extends ConsumerStatefulWidget {
  const FoodScanScreen({super.key});

  @override
  ConsumerState<FoodScanScreen> createState() => _FoodScanScreenState();
}

class _FoodScanScreenState extends ConsumerState<FoodScanScreen> {
  bool _saving = false;

  Future<void> _save(FoodScanDraft d) async {
    final l = context.l10n;
    setState(() => _saving = true);
    try {
      final count = await ref.read(foodScanDraftControllerProvider.notifier).save();
      if (!mounted) return;
      context.showSnack(l.scanSaved(count, l.meal(d.meal)));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      context.showSnack(failureMessage(l, e));
    }
  }

  Future<void> _discard() async {
    await ref.read(foodScanDraftControllerProvider.notifier).discard();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final d = ref.watch(foodScanDraftControllerProvider);
    final c = ref.read(foodScanDraftControllerProvider.notifier);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        // Kembali tanpa menyimpan = batal: hapus foto sementara.
        if (didPop && !_saving) c.discard();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.scanReviewTitle),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
          ),
        ),
        body: d == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _Header(draft: d),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in MealSlot.values)
                        ChoiceChip(
                          key: Key('scan-review-meal-${m.name}'),
                          label: Text(l.meal(m)),
                          selected: d.meal == m,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            color: d.meal == m ? theme.colorScheme.onPrimary : null,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) => c.setMeal(m),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: palette.surface2,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: palette.muted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l.scanReviewHint,
                            style: TextStyle(fontSize: 12, color: palette.muted),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (d.items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        l.scanEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: palette.muted),
                      ),
                    )
                  else
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (final (i, item) in d.items.indexed) ...[
                            if (i > 0) Divider(height: 1, color: theme.colorScheme.outlineVariant),
                            _ItemRow(
                              key: ValueKey('scan-item-$i-${item.name}'),
                              index: i,
                              item: item,
                              onGrams: (g) => c.setGrams(i, g),
                              onRemove: () => c.remove(i),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
        bottomNavigationBar: d == null
            ? null
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            key: const Key('scan-discard'),
                            style: FilledButton.styleFrom(
                              backgroundColor: palette.surface2,
                              foregroundColor: theme.colorScheme.onSurface,
                            ),
                            onPressed: _saving ? null : _discard,
                            child: Text(l.scanDiscard),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            key: const Key('scan-save'),
                            onPressed: _saving || d.items.isEmpty ? null : () => _save(d),
                            child: Text(l.scanSave(d.items.length)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.draft});

  final FoodScanDraft draft;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final t = draft.totals;
    final file = File(draft.imagePath);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  child: SizedBox.square(
                    dimension: 72,
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      cacheWidth: 216,
                      errorBuilder: (_, _, _) => ColoredBox(
                        color: palette.surface2,
                        child: Icon(Icons.restaurant_rounded, color: palette.muted),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: palette.accentSoft,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          l.obAiDraftPill,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        draft.result.dishName.isEmpty ? l.scanFood : draft.result.dishName,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (draft.result.notes case final n?) ...[
              const SizedBox(height: 10),
              Text(n, style: TextStyle(fontSize: 13, color: palette.muted)),
            ],
            const SizedBox(height: 14),
            Text(l.scanTotal, style: TextStyle(fontSize: 12, color: palette.muted)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  Fmt.integer(t.kcal),
                  key: const Key('scan-total-kcal'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: tabular,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'kcal',
                  style: TextStyle(color: palette.muted, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  l.macros(t),
                  style: TextStyle(fontSize: 13, fontFeatures: tabular, color: palette.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatefulWidget {
  const _ItemRow({
    super.key,
    required this.index,
    required this.item,
    required this.onGrams,
    required this.onRemove,
  });

  final int index;
  final FoodScanItem item;
  final ValueChanged<double> onGrams;
  final VoidCallback onRemove;

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  late final _grams = TextEditingController(text: Fmt.integer(widget.item.grams));

  @override
  void dispose() {
    _grams.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final item = widget.item;
    final n = item.nutrients;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.isTkpi ? palette.surface2 : palette.accentSoft,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        item.isTkpi ? l.scanSourceTkpi : l.entryAiEstimate,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.isTkpi ? palette.muted : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.isTkpi && item.displayName != item.name)
                  Text(
                    l.scanMatchedAs(item.displayName),
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${l.kcal(n.kcal)} · ${l.macros(n)}',
                  key: ValueKey('scan-item-kcal-${widget.index}'),
                  style: TextStyle(fontSize: 12, fontFeatures: tabular, color: palette.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: TextField(
              key: ValueKey('scan-grams-${widget.index}'),
              controller: _grams,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontWeight: FontWeight.w800, fontFeatures: tabular),
              decoration: InputDecoration(
                isDense: true,
                suffixText: 'g',
                labelText: l.scanGramsLabel,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
              onChanged: (v) {
                final g = double.tryParse(v);
                if (g != null && g > 0) widget.onGrams(g);
              },
            ),
          ),
          IconButton(
            key: ValueKey('scan-remove-${widget.index}'),
            tooltip: l.scanRemove,
            icon: Icon(Icons.close_rounded, color: palette.muted),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
