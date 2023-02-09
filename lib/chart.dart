import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'emoji.dart';

class EmojiBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<EmojiProvider>();
    return Material(
      child: BarChart(
        BarChartData(
          barTouchData: ,
          titlesData: EmojiBarFlTitlesData(p.emojis),
          maxY: p.largestCount.toDouble() + 1,
          barGroups: p.emojis.mapIndexed(
            (index, emoji) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: emoji.count.length.toDouble(),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  FlTitlesData EmojiBarFlTitlesData(List<Emoji> emojis) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 50,
        showTitles: true,
        getTitlesWidget: (value, meta) => Text(
          emojis[value.toInt()].emoji,
          style: const TextStyle(fontFamily: "NotoColorEmoji", fontSize: 30),
        ),
      )),
    );
  }
}
