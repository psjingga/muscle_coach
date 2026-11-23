import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/progress_models.dart';
import '../providers/progress_providers.dart';
import '../widgets/body_widgets.dart';

/// Bandingkan dua foto dengan pose sama dari tanggal berbeda, berdampingan,
/// beserta berat tercatat pada tanggal itu (bila ada).
class PhotoCompareScreen extends ConsumerStatefulWidget {
  const PhotoCompareScreen({super.key});

  @override
  ConsumerState<PhotoCompareScreen> createState() => _PhotoCompareScreenState();
}

class _PhotoCompareScreenState extends ConsumerState<PhotoCompareScreen> {
  PhotoPose? _pose;
  String? _before;
  String? _after;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photos = ref.watch(progressPhotosProvider).value ?? const <ProgressPhoto>[];
    final dir = ref.watch(photoDirectoryProvider).value;
    final weights = {
      for (final w in ref.watch(weightsProvider).value ?? const <WeightEntry>[]) w.date: w.kg,
    };

    /// Foto terakhir per tanggal untuk tiap pose.
    final byPose = <PhotoPose, Map<String, ProgressPhoto>>{};
    for (final p in photos) {
      (byPose[p.pose] ??= {})[p.date] = p;
    }
    final poses = [
      for (final p in PhotoPose.values)
        if ((byPose[p]?.length ?? 0) >= 2) p,
    ];
    final pose = poses.contains(_pose) ? _pose! : poses.firstOrNull;
    final dates = pose == null ? const <String>[] : (byPose[pose]!.keys.toList()..sort());
    final before = dates.contains(_before) ? _before! : dates.firstOrNull;
    final after = dates.contains(_after) ? _after! : dates.lastOrNull;

    Widget side(String label, String? date, ValueChanged<String?> onChanged) {
      final photo = date == null ? null : byPose[pose]![date];
      final kg = date == null ? null : weights[date];
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            DropdownButton<String>(
              isExpanded: true,
              value: date,
              items: [
                for (final d in dates) DropdownMenuItem(value: d, child: Text(Fmt.isoDate(d))),
              ],
              onChanged: onChanged,
            ),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: photo == null || dir == null
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () => showPhotoViewer(context, photo: photo, directory: dir),
                        child: PhotoImage(photo: photo, directory: dir),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            if (kg != null) Text(l.photoWeightOn(Fmt.one(kg)), textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.photoCompareTitle)),
      body: pose == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l.photoCompareNeedTwo, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SegmentedButton<PhotoPose>(
                  segments: [
                    for (final p in PhotoPose.values)
                      ButtonSegment(value: p, label: Text(l.pose(p)), enabled: poses.contains(p)),
                  ],
                  selected: {pose},
                  onSelectionChanged: (s) => setState(() {
                    _pose = s.first;
                    _before = _after = null;
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    side(l.photoBefore, before, (d) => setState(() => _before = d)),
                    const SizedBox(width: 12),
                    side(l.photoAfter, after, (d) => setState(() => _after = d)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l.photosPrivacy, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
    );
  }
}
