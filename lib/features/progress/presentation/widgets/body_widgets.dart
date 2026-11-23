import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../data/body_repository.dart';
import '../../data/photo_picker.dart';
import '../../domain/progress_models.dart';
import '../providers/progress_providers.dart';
import 'progress_charts.dart';
import 'progress_section.dart';

extension BodyLabels on AppLocalizations {
  String site(BodySite s) => switch (s) {
    BodySite.waist => siteWaist,
    BodySite.chest => siteChest,
    BodySite.arm => siteArm,
    BodySite.thigh => siteThigh,
    BodySite.hip => siteHip,
  };

  String pose(PhotoPose p) => switch (p) {
    PhotoPose.front => poseFront,
    PhotoPose.side => poseSide,
    PhotoPose.back => poseBack,
  };
}

// ---------------------------------------------------------------------------
// Lingkar badan
// ---------------------------------------------------------------------------

/// Kartu lingkar badan: pilih titik ukur, nilai terakhir, perubahan, grafik.
class MeasurementsCard extends ConsumerStatefulWidget {
  const MeasurementsCard({super.key});

  @override
  ConsumerState<MeasurementsCard> createState() => _MeasurementsCardState();
}

class _MeasurementsCardState extends ConsumerState<MeasurementsCard> {
  BodySite? _site;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final all = ref.watch(measurementsProvider).value ?? const <BodyMeasurement>[];
    final sites = [
      for (final s in BodySite.values)
        if (all.any((m) => m.of(s) != null)) s,
    ];
    final site = sites.contains(_site) ? _site! : sites.firstOrNull;
    final points = site == null
        ? const <({String date, double kg})>[]
        : [
            for (final m in all)
              if (m.of(site) case final v?) (date: m.date, kg: v),
          ];

    Future<void> log() async {
      final today = ref.read(clockProvider)();
      final res = await showMeasurementSheet(
        context,
        today: today,
        existing: (String date) => all.where((m) => m.date == date).firstOrNull,
      );
      if (res == null || !context.mounted) return;
      final ok = await ref.read(progressActionsProvider.notifier).saveMeasurement(res);
      if (context.mounted) context.showSnack(ok ? l.measurementSaved : l.errorUnknown);
    }

    return ProgressSection(
      title: l.measurementsTitle,
      trailing: FilledButton.tonalIcon(
        key: const Key('measurement-log'),
        style: FilledButton.styleFrom(minimumSize: AppTheme.compactButtonSize),
        onPressed: log,
        icon: const Icon(Icons.add),
        label: Text(l.measurementsLog),
      ),
      children: [
        if (site == null)
          Text(l.measurementsEmpty)
        else ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final s in sites)
                ChoiceChip(
                  label: Text(l.site(s)),
                  selected: s == site,
                  onSelected: (_) => setState(() => _site = s),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.measurementLatest(Fmt.one(points.last.kg), Fmt.isoDate(points.last.date)),
            key: const Key('measurement-latest'),
            style: theme.textTheme.titleSmall,
          ),
          if (points.length >= 2)
            Text(
              l.measurementChange(
                Fmt.signed(points.last.kg - points.first.kg),
                Fmt.isoDate(points.first.date),
              ),
            ),
          if (points.length >= 2) ...[
            const SizedBox(height: 12),
            WeightChart(
              points: points,
              average: points,
              semanticLabel: l.measurementChartLabel(l.site(site).toLowerCase()),
            ),
          ],
        ],
        const SizedBox(height: 8),
        mutedText(context, l.measurementsNote),
      ],
    );
  }
}

/// Lembar catat lingkar badan untuk satu tanggal. [existing] memberi nilai
/// yang sudah tersimpan pada tanggal terpilih (untuk diedit).
Future<BodyMeasurement?> showMeasurementSheet(
  BuildContext context, {
  required DateTime today,
  required BodyMeasurement? Function(String date) existing,
}) => showModalBottomSheet<BodyMeasurement>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _MeasurementSheet(today: today, existing: existing),
);

class _MeasurementSheet extends StatefulWidget {
  const _MeasurementSheet({required this.today, required this.existing});

  final DateTime today;
  final BodyMeasurement? Function(String date) existing;

  @override
  State<_MeasurementSheet> createState() => _MeasurementSheetState();
}

class _MeasurementSheetState extends State<_MeasurementSheet> {
  late DateTime _date = widget.today;
  final _fields = {for (final s in BodySite.values) s: TextEditingController()};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final m = widget.existing(Fmt.toIsoDate(_date));
    for (final e in _fields.entries) {
      final v = m?.of(e.key);
      e.value.text = v == null ? '' : Fmt.one(v);
    }
  }

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// `null` = kosong; `NaN` = tidak valid.
  double? _value(BodySite s) {
    final text = _fields[s]!.text.trim();
    if (text.isEmpty) return null;
    final v = Fmt.parseDecimal(text);
    return v != null && v >= LocalBodyRepository.minCm && v <= LocalBodyRepository.maxCm
        ? v
        : double.nan;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final values = {for (final s in BodySite.values) s: _value(s)};
    final invalid = values.values.any((v) => v != null && v.isNaN);
    final filled = {
      for (final e in values.entries)
        if (e.value case final v? when !v.isNaN) e.key: v,
    };
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.measurementSheetTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(l.measurementSheetHint, style: Theme.of(context).textTheme.bodySmall),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(l.measurementDate),
                subtitle: Text(Fmt.date(_date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: widget.today.subtract(const Duration(days: 365)),
                    lastDate: widget.today,
                  );
                  if (picked != null) {
                    setState(() {
                      _date = picked;
                      _load();
                    });
                  }
                },
              ),
              for (final s in BodySite.values) ...[
                TextField(
                  key: Key('measurement-${s.name}'),
                  controller: _fields[s],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  decoration: InputDecoration(
                    labelText: l.site(s),
                    suffixText: l.unitCm,
                    errorText: values[s]?.isNaN ?? false ? l.measurementRangeError : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              FilledButton(
                key: const Key('measurement-save'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                // Tanggal tanpa ukuran sama sekali boleh disimpan bila sebelumnya
                // ada data (menghapus catatan tanggal itu).
                onPressed:
                    invalid || (filled.isEmpty && widget.existing(Fmt.toIsoDate(_date)) == null)
                    ? null
                    : () => Navigator.pop(
                        context,
                        BodyMeasurement(date: Fmt.toIsoDate(_date), cm: filled),
                      ),
                child: Text(l.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Foto progres
// ---------------------------------------------------------------------------

/// Kartu foto progres: tambah foto, daftar per tanggal, bandingkan.
class PhotosCard extends ConsumerWidget {
  const PhotosCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final photos = ref.watch(progressPhotosProvider).value ?? const <ProgressPhoto>[];
    final dir = ref.watch(photoDirectoryProvider).value;
    final byDate = <String, List<ProgressPhoto>>{};
    for (final p in photos.reversed) {
      byDate.putIfAbsent(p.date, () => []).add(p);
    }
    final canCompare = PhotoPose.values.any(
      (pose) => photos.where((p) => p.pose == pose).map((p) => p.date).toSet().length >= 2,
    );

    Future<void> add() async {
      final req = await showAddPhotoSheet(context, today: ref.read(clockProvider)());
      if (req == null || !context.mounted) return;
      final ok = await ref
          .read(progressActionsProvider.notifier)
          .addPhoto(date: req.date, pose: req.pose, source: req.source);
      if (ok == null || !context.mounted) return;
      context.showSnack(ok ? l.photoSaved : l.photoFailed);
    }

    return ProgressSection(
      title: l.photosTitle,
      trailing: FilledButton.tonalIcon(
        key: const Key('photo-add'),
        style: FilledButton.styleFrom(minimumSize: AppTheme.compactButtonSize),
        onPressed: add,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text(l.photosAdd),
      ),
      children: [
        if (photos.isEmpty)
          Text(l.photosEmpty)
        else if (dir != null) ...[
          for (final e in byDate.entries.take(4)) ...[
            Text(Fmt.isoDate(e.key), style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: e.value.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final p = e.value[i];
                  return PhotoThumb(
                    photo: p,
                    directory: dir,
                    onTap: () => showPhotoViewer(context, photo: p, directory: dir),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (canCompare)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                key: const Key('photo-compare'),
                onPressed: () => context.push(Routes.photoCompare),
                icon: const Icon(Icons.compare),
                label: Text(l.photoCompare),
              ),
            ),
        ],
        const SizedBox(height: 8),
        mutedText(context, l.photosPrivacy),
      ],
    );
  }
}

File photoFile(Directory dir, ProgressPhoto p) => File('${dir.path}/${p.fileName}');

/// Gambar foto dari folder privat (placeholder bila berkas hilang).
class PhotoImage extends StatelessWidget {
  const PhotoImage({
    super.key,
    required this.photo,
    required this.directory,
    this.fit = BoxFit.cover,
    this.cacheWidth,
  });

  final ProgressPhoto photo;
  final Directory directory;
  final BoxFit fit;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) => Image.file(
    photoFile(directory, photo),
    fit: fit,
    cacheWidth: cacheWidth,
    errorBuilder: (context, _, _) => ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            context.l10n.photoMissing,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    ),
  );
}

class PhotoThumb extends StatelessWidget {
  const PhotoThumb({super.key, required this.photo, required this.directory, this.onTap});

  final ProgressPhoto photo;
  final Directory directory;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      button: true,
      label: l.photoOpenLabel(l.pose(photo.pose), Fmt.isoDate(photo.date)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 90,
                child: PhotoImage(photo: photo, directory: directory, cacheWidth: 216),
              ),
            ),
            const SizedBox(height: 2),
            Text(l.pose(photo.pose), style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

/// Tampilan penuh satu foto dengan zoom & hapus.
Future<void> showPhotoViewer(
  BuildContext context, {
  required ProgressPhoto photo,
  required Directory directory,
}) => showDialog<void>(
  context: context,
  builder: (dialogContext) => Consumer(
    builder: (context, ref, _) {
      final l = context.l10n;
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text('${l.pose(photo.pose)} · ${Fmt.isoDate(photo.date)}'),
            actions: [
              IconButton(
                key: const Key('photo-delete'),
                tooltip: l.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: Text(l.photoDeleteTitle),
                      content: Text(l.photoDeleteMessage),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
                        FilledButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: Text(l.delete),
                        ),
                      ],
                    ),
                  );
                  if (!(ok ?? false)) return;
                  final done = await ref
                      .read(progressActionsProvider.notifier)
                      .deletePhoto(photo.id);
                  if (!context.mounted) return;
                  Navigator.pop(dialogContext);
                  context.showSnack(done ? l.photoDeleted : l.errorUnknown);
                },
              ),
            ],
          ),
          body: InteractiveViewer(
            maxScale: 4,
            child: Center(
              child: PhotoImage(photo: photo, directory: directory, fit: BoxFit.contain),
            ),
          ),
        ),
      );
    },
  ),
);

/// Permintaan tambah foto.
typedef AddPhotoRequest = ({String date, PhotoPose pose, PhotoSource source});

Future<AddPhotoRequest?> showAddPhotoSheet(BuildContext context, {required DateTime today}) =>
    showModalBottomSheet<AddPhotoRequest>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AddPhotoSheet(today: today),
    );

class _AddPhotoSheet extends StatefulWidget {
  const _AddPhotoSheet({required this.today});

  final DateTime today;

  @override
  State<_AddPhotoSheet> createState() => _AddPhotoSheetState();
}

class _AddPhotoSheetState extends State<_AddPhotoSheet> {
  PhotoPose _pose = PhotoPose.front;
  late DateTime _date = widget.today;

  void _pick(PhotoSource source) =>
      Navigator.pop(context, (date: Fmt.toIsoDate(_date), pose: _pose, source: source));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.photoSheetTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(l.photoPose, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            SegmentedButton<PhotoPose>(
              segments: [
                for (final p in PhotoPose.values) ButtonSegment(value: p, label: Text(l.pose(p))),
              ],
              selected: {_pose},
              onSelectionChanged: (s) => setState(() => _pose = s.first),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(l.photoDate),
              subtitle: Text(Fmt.date(_date)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: widget.today.subtract(const Duration(days: 365 * 2)),
                  lastDate: widget.today,
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            mutedText(context, l.photosPrivacy),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    key: const Key('photo-camera'),
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                    onPressed: () => _pick(PhotoSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(l.photoCamera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('photo-gallery'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                    onPressed: () => _pick(PhotoSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l.photoGallery),
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
