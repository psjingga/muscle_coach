import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/formatters.dart';

/// Komponen form wizard. Semua stateless terhadap data: nilai awal dari
/// state wizard, perubahan dilaporkan lewat callback.

class FieldBlock extends StatelessWidget {
  const FieldBlock({super.key, required this.label, this.helper, this.error, required this.child});

  final String label;
  final String? helper;
  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          if (helper case final h?) ...[
            const SizedBox(height: 4),
            Text(
              h,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 8),
          child,
          if (error case final e?) ...[
            const SizedBox(height: 6),
            Text(e, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          ],
        ],
      ),
    );
  }
}

/// Pilihan tunggal berbentuk chip.
class ChoiceGroup<T> extends StatelessWidget {
  const ChoiceGroup({
    super.key,
    required this.label,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    this.helper,
    this.error,
  });

  final String label;
  final List<T> options;
  final String Function(T) labelOf;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String? helper;
  final String? error;

  @override
  Widget build(BuildContext context) => FieldBlock(
    label: label,
    helper: helper,
    error: error,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(labelOf(o)),
            selected: o == selected,
            onSelected: (_) => onSelected(o),
          ),
      ],
    ),
  );
}

/// Pilihan ganda berbentuk chip.
class MultiChoiceGroup<T> extends StatelessWidget {
  const MultiChoiceGroup({
    super.key,
    required this.label,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    this.helper,
    this.error,
  });

  final String label;
  final List<T> options;
  final String Function(T) labelOf;
  final List<T> selected;
  final ValueChanged<List<T>> onChanged;
  final String? helper;
  final String? error;

  @override
  Widget build(BuildContext context) => FieldBlock(
    label: label,
    helper: helper,
    error: error,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          FilterChip(
            label: Text(labelOf(o)),
            selected: selected.contains(o),
            onSelected: (on) => onChanged(
              on
                  ? [...selected, o]
                  : [
                      for (final s in selected)
                        if (s != o) s,
                    ],
            ),
          ),
      ],
    ),
  );
}

/// Daftar centang (untuk pertanyaan yang butuh kalimat panjang).
class CheckList<T> extends StatelessWidget {
  const CheckList({
    super.key,
    required this.label,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    this.helper,
  });

  final String label;
  final List<T> options;
  final String Function(T) labelOf;
  final List<T> selected;
  final ValueChanged<List<T>> onChanged;
  final String? helper;

  @override
  Widget build(BuildContext context) => FieldBlock(
    label: label,
    helper: helper,
    child: Column(
      children: [
        for (final o in options)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(labelOf(o)),
            value: selected.contains(o),
            onChanged: (on) => onChanged(
              (on ?? false)
                  ? [...selected, o]
                  : [
                      for (final s in selected)
                        if (s != o) s,
                    ],
            ),
          ),
      ],
    ),
  );
}

/// Input angka dengan satuan. Menerima koma atau titik desimal.
class NumberInput extends StatelessWidget {
  const NumberInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.unit,
    this.prefix,
    this.helper,
    this.error,
    this.decimal = true,
  });

  final String label;
  final num? value;
  final ValueChanged<num?> onChanged;
  final String? unit;
  final String? prefix;
  final String? helper;
  final String? error;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: v == null ? '' : (decimal ? Fmt.one(v) : v.toInt().toString()),
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        inputFormatters: [
          FilteringTextInputFormatter.allow(decimal ? RegExp(r'[0-9.,]') : RegExp('[0-9]')),
          LengthLimitingTextInputFormatter(decimal ? 6 : 9),
        ],
        textInputAction: TextInputAction.next,
        onChanged: (s) => onChanged(decimal ? Fmt.parseDecimal(s) : Fmt.parseInt(s)),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          prefixText: prefix,
          helperText: helper,
          helperMaxLines: 3,
          errorText: error,
        ),
      ),
    );
  }
}

/// Input teks bebas opsional (dibatasi panjangnya).
class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.maxLength = 300,
    this.maxLines = 3,
  });

  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final int maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      initialValue: value ?? '',
      maxLength: maxLength,
      minLines: 1,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, hintText: hint),
    ),
  );
}

/// Pemilih tanggal (kalender) dengan tampilan seperti field.
class DateInput extends StatelessWidget {
  const DateInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    this.hint,
    this.helper,
    this.error,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;
  final String? hint;
  final String? helper;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: v ?? initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            initialDatePickerMode: DatePickerMode.year,
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            helperText: helper,
            errorText: error,
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          isEmpty: v == null,
          child: Text(v == null ? (hint ?? '') : Fmt.date(v)),
        ),
      ),
    );
  }
}

/// Teks penjelasan kecil di dalam langkah.
class StepNote extends StatelessWidget {
  const StepNote(this.text, {super.key, this.icon = Icons.info_outline});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
