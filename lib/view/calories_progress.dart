import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CaloriesProgressChart extends StatelessWidget {
  final Map<String, int> dailyCalories;

  const CaloriesProgressChart({super.key, required this.dailyCalories});

  @override
  Widget build(BuildContext context) {
    if (dailyCalories.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final sortedEntries = dailyCalories.entries.toList()
      ..sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.key).compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));

    final spots = sortedEntries.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = entry.value.value.toDouble();
      return FlSpot(index, value);
    }).toList();

    final maxY = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final dateIndex = value.toInt();
                if (dateIndex >= 0 && dateIndex < sortedEntries.length) {
                  final dateKey = sortedEntries[dateIndex].key;
                  return Text(
                    DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateKey)),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                } else {
                  return const Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: (sortedEntries.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 2,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
