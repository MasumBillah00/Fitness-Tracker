import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/workout_model.dart';

class WeeklyChart extends StatelessWidget {
  final List<Workout> workouts;

  const WeeklyChart({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    // Aggregate data and print for debugging
    final weeklyData = _aggregateWeeklyData(workouts);
    print("Aggregated Weekly Data: $weeklyData");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weekly Workout Stats'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Weekly Workout Stats',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Guard against out-of-range index
                            if (value.toInt() < weeklyData.keys.length) {
                              return Text(weeklyData.keys.elementAt(value.toInt()));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _createBarGroups(weeklyData),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Aggregate workout data by week and type
  Map<String, Map<String, double>> _aggregateWeeklyData(List<Workout> workouts) {
    final Map<String, Map<String, double>> data = {};
    final today = DateTime.now();
    final recentWeeks = List.generate(4, (i) => today.subtract(Duration(days: i * 7)));

    for (var workout in workouts) {
      final startOfWeek = workout.date.subtract(Duration(days: workout.date.weekday - 1));
      if (!recentWeeks.any((date) => date.isAtSameMomentAs(startOfWeek))) {
        continue;
      }

      final week = '${startOfWeek.month}/${startOfWeek.day}';
      if (!data.containsKey(week)) {
        data[week] = {};
      }

      if (data[week]!.containsKey(workout.type)) {
        data[week]![workout.type] = data[week]![workout.type]! + workout.calories.toDouble();
      } else {
        data[week]![workout.type] = workout.calories.toDouble();
      }
    }

    return Map.fromEntries(data.entries.take(4).toList().reversed); // Keep recent 4 weeks
  }

  List<BarChartGroupData> _createBarGroups(Map<String, Map<String, double>> data) {
    final colors = {
      'Running': Colors.red,
      'Walking': Colors.green,
      'PushUP': Colors.blue,
      'Endurance': Colors.orange,
    };

    return data.entries.map((entry) {
      final weekIndex = data.keys.toList().indexOf(entry.key);
      final workoutTypes = ['Running', 'Walking', 'PushUP', 'Endurance'];

      return BarChartGroupData(
        x: weekIndex,
        barRods: workoutTypes.map((type) {
          final value = entry.value[type] ?? 0.0;
          return BarChartRodData(
            toY: value,
            color: colors[type],
            width: 16,
          );
        }).toList(),
      );
    }).toList();
  }
}
