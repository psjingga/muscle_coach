import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

/// Komponen form wizard. Semua stateless terhadap data: nilai awal dari
/// state wizard, perubahan dilaporkan lewat callback.

/// Indikator langkah bersegmen (satu batang per langkah; yang sudah dilalui
/// berwarna aksen).
class StepSegments extends StatelessWidget {
  const StepSegments({super.key, required this.current, required this.total});

  /// Indeks langkah aktif (0-based).
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final track = context.palette.surface2;
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 6,
              decoration: BoxDecoration(
                color: i <= current ? accent : track,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Chip pilihan gaya desain: pill surface-2, terpilih = isi aksen.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      backgroundColor: context.palette.surface2,
      selectedColor: scheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      labelStyle: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: selected ? scheme.onPrimary : scheme.onSurface,
      ),
    );
  }
}

/// Baris centang di atas latar surface-2 (daftar panjang & persetujuan).
class CheckTile extends StatelessWidget {
  const CheckTile({super.key, required this.title, required this.value, required this.onChanged});

  final Widget title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: context.palette.surface2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radius)),
      title: title,
      value: value,
      onChanged: onChanged,
    ),
  );
}

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
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          if (helper case final h?) ...[
            const SizedBox(height: 4),
            Text(
              h,
              style: TextStyle(fontSize: 13, height: 18 / 13, color: context.palette.muted),
            ),
          ],
          const SizedBox(height: 10),
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
          _Pill(label: labelOf(o), selected: o == selected, onTap: () => onSelected(o)),
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
          _Pill(
            label: labelOf(o),
            selected: selected.contains(o),
            onTap: () => onChanged(
              !selected.contains(o)
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
          CheckTile(
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
        borderRadius: BorderRadius.circular(AppTheme.radius),
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.palette.accentSoft,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
