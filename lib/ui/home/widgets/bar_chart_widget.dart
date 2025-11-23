import 'package:financas/domain/entities/day/day_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key, required this.days});

  final List<Day> days;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY:
              days.map((day) => day.valor).reduce((a, b) => a > b ? a : b) + 10,
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          barGroups: days.asMap().entries.map((entry) {
            int index = entry.key;
            Day dia = entry.value;
            return BarChartGroupData(x: index, barRods: [
              BarChartRodData(
                toY: dia.valor,
                color: dia.valor < 0 ? Colors.red : Colors.green,
                width: 20,
              )
            ]);
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  Widget text;
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    text = Text(
                      days[value.toInt()].id,
                      style: style,
                    );
                  } else {
                    text = const Text(
                      '',
                      style: style,
                    );
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const style = TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    );
                    Widget text;
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      text = Text(
                        days[value.toInt()].id,
                        style: style,
                      );
                    } else {
                      text = const Text(
                        '',
                        style: style,
                      );
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8,
                      child: text,
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
