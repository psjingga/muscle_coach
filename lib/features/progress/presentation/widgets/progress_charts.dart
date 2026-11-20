import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// "20/11" dari `YYYY-MM-DD`.
String shortDate(String iso) {
  final d = DateTime.parse(iso);
  return '${d.day}/${d.month}';
}

int _dayIndex(String iso, String origin) =>
    DateTime.parse(iso).difference(DateTime.parse(origin)).inDays;

TextStyle _axis(BuildContext context) =>
    Theme.of(context).textTheme.labelSmall!
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

FlTitlesData _titles(
  BuildContext context, {
  required String Function(double) bottom,
  double? bottomInterval,
  double? leftInterval,
  double leftReserved = 40,
}) => FlTitlesData(
  topTitles: const AxisTitles(),
  rightTitles: const AxisTitles(),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: leftReserved,
      interval: leftInterval,
      getTitlesWidget: (v, meta) => SideTitleWidget(
        meta: meta,
        child: Text(Fmt.one(v), style: _axis(context)),
      ),
    ),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 24,
      interval: bottomInterval,
      getTitlesWidget: (v, meta) => SideTitleWidget(
        meta: meta,
        child: Text(bottom(v), style: _axis(context)),
      ),
    ),
  ),
);

FlGridData _grid(BuildContext context) => FlGridData(
  drawVerticalLine: false,
  getDrawingHorizontalLine: (_) =>
      FlLine(color: Theme.of(context).colorScheme.outlineVariant, strokeWidth: 0.5),
);

/// Berat harian (titik) + rata-rata 7 hari (garis).
class WeightChart extends StatelessWidget {
  const WeightChart({
    super.key,
    required this.points,
    required this.average,
    required this.semanticLabel,
  });

  final List<({String date, double kg})> points;
  final List<({String date, double kg})> average;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final origin = points.first.date;
    final all = [...points.map((p) => p.kg), ...average.map((p) => p.kg)];
    final minY = (all.reduce(math.min) - 1).floorToDouble();
    final maxY = (all.reduce(math.max) + 1).ceilToDouble();
    final span = math.max(1, _dayIndex(points.last.date, origin));
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              minX: 0,
              maxX: span.toDouble(),
              gridData: _grid(context),
              borderData: FlBorderData(show: false),
              titlesData: _titles(
                context,
                bottomInterval: math.max(1, (span / 4).ceilToDouble()),
                leftInterval: math.max(1, ((maxY - minY) / 4).ceilToDouble()),
                bottom: (v) =>
                    shortDate(Fmt.toIsoDate(DateTime.parse(origin).add(Duration(days: v.round())))),
              ),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (final p in points) FlSpot(_dayIndex(p.date, origin).toDouble(), p.kg),
                  ],
                  barWidth: 0,
                  color: Colors.transparent,
                  dotData: FlDotData(
                    getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                      radius: 3,
                      color: scheme.primary.withValues(alpha: 0.5),
                      strokeWidth: 0,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: [
                    for (final p in average) FlSpot(_dayIndex(p.date, origin).toDouble(), p.kg),
                  ],
                  barWidth: 3,
                  color: scheme.primary,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Batang kalori harian + garis target.
class IntakeChart extends StatelessWidget {
  const IntakeChart({
    super.key,
    required this.days,
    required this.targetKcal,
    required this.semanticLabel,
  });

  /// Urut tanggal; kcal 0 = belum ada catatan.
  final List<({String date, double kcal})> days;
  final double? targetKcal;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxKcal = math.max(targetKcal ?? 0, days.fold<double>(0, (m, d) => math.max(m, d.kcal)));
    final maxY = math.max(500, (maxKcal * 1.15 / 500).ceil() * 500).toDouble();
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              gridData: _grid(context),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(enabled: false),
              titlesData: _titles(
                context,
                leftReserved: 44,
                leftInterval: maxY / 4,
                bottom: (v) {
                  final i = v.round();
                  return i % 3 == 0 && i < days.length ? shortDate(days[i].date) : '';
                },
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  if (targetKcal != null)
                    HorizontalLine(
                      y: targetKcal!,
                      color: scheme.tertiary,
                      strokeWidth: 2,
                      dashArray: [6, 4],
                    ),
                ],
              ),
              barGroups: [
                for (final (i, d) in days.indexed)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: d.kcal,
                        width: 10,
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Batang volume mingguan.
class VolumeChart extends StatelessWidget {
  const VolumeChart({super.key, required this.weeks, required this.semanticLabel});

  final List<({String weekStart, double volumeKg, int sessions})> weeks;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxV = weeks.fold<double>(0, (m, w) => math.max(m, w.volumeKg));
    final step = maxV <= 0 ? 1000.0 : math.max(500.0, (maxV / 4 / 500).ceil() * 500.0);
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          height: 170,
          child: BarChart(
            BarChartData(
              maxY: step * 4,
              gridData: _grid(context),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(enabled: false),
              titlesData: _titles(
                context,
                leftReserved: 48,
                leftInterval: step,
                bottom: (v) {
                  final i = v.round();
                  return i < weeks.length && i.isEven ? shortDate(weeks[i].weekStart) : '';
                },
              ),
              barGroups: [
                for (final (i, w) in weeks.indexed)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: w.volumeKg,
                        width: 16,
                        color: scheme.secondary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Beban set terberat per sesi untuk satu gerakan.
class ExerciseChart extends StatelessWidget {
  const ExerciseChart({super.key, required this.points, required this.semanticLabel});

  final List<({String date, double weightKg, int reps})> points;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ys = points.map((p) => p.weightKg);
    final minY = math.max(0, ys.reduce(math.min) - 2).floorToDouble();
    final maxY = (ys.reduce(math.max) + 2).ceilToDouble();
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          height: 170,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              minX: 0,
              maxX: math.max(1, points.length - 1).toDouble(),
              gridData: _grid(context),
              borderData: FlBorderData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              titlesData: _titles(
                context,
                bottomInterval: math.max(1, (points.length / 4).ceilToDouble()),
                leftInterval: math.max(1, ((maxY - minY) / 4).ceilToDouble()),
                bottom: (v) {
                  final i = v.round();
                  return i >= 0 && i < points.length ? shortDate(points[i].date) : '';
                },
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: [for (final (i, p) in points.indexed) FlSpot(i.toDouble(), p.weightKg)],
                  barWidth: 3,
                  color: scheme.tertiary,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
