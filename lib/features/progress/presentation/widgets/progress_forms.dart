import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/progress_repository.dart';

/// Lembar catat berat: tanggal (hari ini/sebelumnya) + kg.
Future<({String date, double kg})?> showWeightSheet(
  BuildContext context, {
  required DateTime today,
  double? initialKg,
}) => showModalBottomSheet<({String date, double kg})>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _WeightSheet(today: today, initialKg: initialKg),
);

class _WeightSheet extends StatefulWidget {
  const _WeightSheet({required this.today, this.initialKg});

  final DateTime today;
  final double? initialKg;

  @override
  State<_WeightSheet> createState() => _WeightSheetState();
}

class _WeightSheetState extends State<_WeightSheet> {
  late final _kg = TextEditingController(
    text: widget.initialKg == null ? '' : Fmt.one(widget.initialKg!),
  );
  late DateTime _date = widget.today;

  double? get _value {
    final v = Fmt.parseDecimal(_kg.text);
    return v != null &&
            v >= LocalProgressRepository.minWeightKg &&
            v <= LocalProgressRepository.maxWeightKg
        ? v
        : null;
  }

  @override
  void dispose() {
    _kg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = _value;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.weightSheetTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                key: const Key('weight-kg'),
                controller: _kg,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                decoration: InputDecoration(
                  labelText: l.weightField,
                  suffixText: 'kg',
                  errorText: _kg.text.isNotEmpty && v == null ? l.weightRangeError : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(l.weightDate),
                subtitle: Text(Fmt.date(_date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: widget.today.subtract(const Duration(days: 365)),
                    lastDate: widget.today,
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              const SizedBox(height: 8),
              FilledButton(
                key: const Key('weight-save'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: v == null
                    ? null
                    : () => Navigator.pop(context, (date: Fmt.toIsoDate(_date), kg: v)),
                child: Text(l.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pilihan skala 1–5 (energi/suasana hati).
class ScalePicker extends StatelessWidget {
  const ScalePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.keyPrefix,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final caption = TextStyle(fontSize: 11, color: palette.muted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 1; i <= 5; i++) ...[
              if (i > 1) const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  button: true,
                  selected: value == i,
                  child: Material(
                    color: value == i ? scheme.primary : palette.surface2,
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      key: Key('$keyPrefix-$i'),
                      onTap: () => onChanged(value == i ? null : i),
                      child: SizedBox(
                        height: 48,
                        child: Center(
                          child: Text(
                            '$i',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFeatures: tabular,
                              color: value == i ? scheme.onPrimary : scheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 = ${l.checkInScaleLow}', style: caption),
            Text('5 = ${l.checkInScaleHigh}', style: caption),
          ],
        ),
      ],
    );
  }
}
