import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final checkIns = ref.watch(checkInsProvider);
    final weights = ref.watch(weightsProvider);
    final training = ref.watch(trainingDaysProvider).value ?? const [];
    final day = ref.watch(dayNutritionProvider(widget.date)).value;
    if (!checkIns.hasValue || !weights.hasValue) {
      return Scaffold(
        appBar: AppBar(title: Text(l.checkInTitle)),
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

    return Scaffold(
      appBar: AppBar(title: Text(l.checkInTitle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(Fmt.isoDate(widget.date), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trained ? l.checkInWorkoutDone : l.checkInWorkoutNone),
                    if (day != null)
                      Text(
                        l.checkInIntake(
                          l.kcal(day.consumed.kcal),
                          day.target == null ? '–' : l.kcal(day.target!.kcal),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('checkin-weight'),
              controller: _weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: InputDecoration(labelText: l.checkInWeight, suffixText: 'kg'),
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
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('checkin-sleep'),
              controller: _sleep,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: InputDecoration(labelText: l.checkInSleep, suffixText: 'jam'),
              validator: (v) => numError(v, 24, l.checkInSleepError),
            ),
            const SizedBox(height: 16),
            ScalePicker(
              keyPrefix: 'energy',
              label: l.checkInEnergy,
              value: _energy,
              onChanged: (v) => setState(() => _energy = v),
            ),
            const SizedBox(height: 16),
            ScalePicker(
              keyPrefix: 'mood',
              label: l.checkInMood,
              value: _mood,
              onChanged: (v) => setState(() => _mood = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('checkin-discomfort'),
              controller: _discomfort,
              maxLength: LocalProgressRepository.maxTextLength,
              maxLines: 2,
              decoration: InputDecoration(labelText: l.checkInDiscomfort),
              onChanged: (_) => setState(() {}),
            ),
            if (_discomfort.text.trim().isNotEmpty)
              Card(
                color: theme.colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.health_and_safety_outlined),
                  title: Text(l.checkInDiscomfortWarning),
                ),
              ),
            TextFormField(
              key: const Key('checkin-notes'),
              controller: _notes,
              maxLength: LocalProgressRepository.maxTextLength,
              maxLines: 3,
              decoration: InputDecoration(labelText: l.checkInNotes),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('checkin-save'),
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
