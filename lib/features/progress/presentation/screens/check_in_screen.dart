import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../nutrition/presentation/providers/nutrition_providers.dart';
import '../../../nutrition/presentation/widgets/nutrition_labels.dart';
import '../../data/progress_repository.dart';
import '../../domain/progress_models.dart';
import '../providers/progress_providers.dart';
import '../widgets/progress_forms.dart';

/// Check-in harian: berat (opsional), tidur, energi, suasana hati, nyeri,
/// catatan. Status latihan & asupan diambil otomatis dari catatan.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key, required this.date});

  final String date;

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _form = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _sleep = TextEditingController();
  final _discomfort = TextEditingController();
  final _notes = TextEditingController();
  int? _energy;
  int? _mood;
  bool _loaded = false;

  @override
  void dispose() {
    _weight.dispose();
    _sleep.dispose();
    _discomfort.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _load(DailyCheckIn? c, WeightEntry? w) {
    if (_loaded) return;
    _loaded = true;
    if (w != null) _weight.text = Fmt.one(w.kg);
    if (c == null) return;
    if (c.sleepHours != null) _sleep.text = Fmt.one(c.sleepHours!);
    _discomfort.text = c.discomfort ?? '';
    _notes.text = c.notes ?? '';
    _energy = c.energy;
    _mood = c.mood;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final l = context.l10n;
    final actions = ref.read(progressActionsProvider.notifier);
    final kg = Fmt.parseDecimal(_weight.text);
    var ok = await actions.saveCheckIn(
      DailyCheckIn(
        date: widget.date,
        sleepHours: Fmt.parseDecimal(_sleep.text),
        energy: _energy,
        mood: _mood,
        discomfort: _discomfort.text,
        notes: _notes.text,
      ),
    );
    if (ok && kg != null) ok = await actions.saveWeight(widget.date, kg);
    if (!mounted) return;
    if (ok) {
      context.showSnack(l.checkInSaved);
      Navigator.pop(context);
    } else {
      context.showSnack(l.errorUnknown);
    }
  }

  /// Judul + tanggal redup, garis bawah tipis.
  PreferredSizeWidget _appBar(BuildContext context) {
    final l = context.l10n;
    final d = DateTime.tryParse(widget.date);
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.checkInTitle),
          Text(
            d == null ? widget.date : DateFormat.MMMMEEEEd('id').format(d),
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.palette.muted,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final checkIns = ref.watch(checkInsProvider);
    final weights = ref.watch(weightsProvider);
    final training = ref.watch(trainingDaysProvider).value ?? const [];
    final day = ref.watch(dayNutritionProvider(widget.date)).value;
    if (!checkIns.hasValue || !weights.hasValue) {
      return Scaffold(
        appBar: _appBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    _load(
      checkIns.value!.where((c) => c.date == widget.date).firstOrNull,
      weights.value!.where((w) => w.date == widget.date).firstOrNull,
    );
    final trained = training.any((t) => t.date == widget.date);
    String? numError(String? v, double max, String msg) {
      if ((v ?? '').trim().isEmpty) return null;
      final x = Fmt.parseDecimal(v!);
      return x == null || x < 0 || x > max ? msg : null;
    }

    const numStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFeatures: tabular);
    InputDecoration numDecoration(String suffix) => InputDecoration(
      suffixText: suffix,
      suffixStyle: TextStyle(fontSize: 13, color: palette.muted),
      errorMaxLines: 2,
    );

    return Scaffold(
      appBar: _appBar(context),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _SummaryTile(
                      icon: Icons.fitness_center_rounded,
                      iconColor: theme.colorScheme.primary,
                      label: l.fmCheckInWorkoutLabel,
                      value: trained ? l.fmCheckInWorkoutDone : l.fmCheckInWorkoutNone,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SummaryTile(
                      icon: Icons.restaurant_rounded,
                      iconColor: palette.carbs,
                      label: l.fmCheckInIntakeLabel,
                      value: day == null
                          ? '–'
                          : l.fmCheckInIntakeValue(
                              Fmt.integer(day.consumed.kcal),
                              day.target == null ? '–' : l.kcal(day.target!.kcal),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Labeled(
                            label: l.fmCheckInWeight,
                            child: TextFormField(
                              key: const Key('checkin-weight'),
                              controller: _weight,
                              style: numStyle,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                              ],
                              decoration: numDecoration('kg'),
                              validator: (v) {
                                if ((v ?? '').trim().isEmpty) return null;
                                final x = Fmt.parseDecimal(v!);
                                return x == null ||
                                        x < LocalProgressRepository.minWeightKg ||
                                        x > LocalProgressRepository.maxWeightKg
                                    ? l.weightRangeError
                                    : null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Labeled(
                            label: l.fmCheckInSleep,
                            child: TextFormField(
                              key: const Key('checkin-sleep'),
                              controller: _sleep,
                              style: numStyle,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                              ],
                              decoration: numDecoration(l.fmCheckInHours),
                              validator: (v) => numError(v, 24, l.checkInSleepError),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ScalePicker(
                      keyPrefix: 'energy',
                      label: l.checkInEnergy,
                      value: _energy,
                      onChanged: (v) => setState(() => _energy = v),
                    ),
                    const SizedBox(height: 20),
                    ScalePicker(
                      keyPrefix: 'mood',
                      label: l.checkInMood,
                      value: _mood,
                      onChanged: (v) => setState(() => _mood = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Labeled(
                      label: l.checkInDiscomfort,
                      child: TextFormField(
                        key: const Key('checkin-discomfort'),
                        controller: _discomfort,
                        maxLength: LocalProgressRepository.maxTextLength,
                        minLines: 1,
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (_discomfort.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _WarningCallout(text: l.checkInDiscomfortWarning),
                      const SizedBox(height: 12),
                    ],
                    _Labeled(
                      label: l.checkInNotes,
                      child: TextFormField(
                        key: const Key('checkin-notes'),
                        controller: _notes,
                        maxLength: LocalProgressRepository.maxTextLength,
                        minLines: 1,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: FilledButton(
              key: const Key('checkin-save'),
              onPressed: _save,
              child: Text(l.save),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ringkasan kecil (latihan / asupan hari itu).
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.palette.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFeatures: tabular,
            ),
          ),
        ],
      ),
    );
  }
}

/// Label kecil redup di atas kolom isian.
class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.palette.muted),
      ),
      const SizedBox(height: 6),
      child,
    ],
  );
}

/// Kotak peringatan bertint warning dengan ikon.
class _WarningCallout extends StatelessWidget {
  const _WarningCallout({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.health_and_safety_outlined, size: 18, color: palette.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, height: 17 / 12)),
          ),
        ],
      ),
    );
  }
}
