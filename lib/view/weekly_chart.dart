import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/workout_model.dart';

class WeeklyChart extends StatelessWidget {
  final List<Workout> workouts;

  const WeeklyChart({super.key,  required this.workouts});

  @override
  Widget build(BuildContext context) {
    final weeklyData = _aggregateWeeklyData(workouts);

    return SafeArea(
      child: Scaffold(
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
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: false),
                   // barGroups: _createBarGroups(workoutData),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      // leftTitles: SideTitles(showTitles: true),
                      // bottomTitles: SideTitles(
                      //   showTitles: true,
                      //   getTitlesWidget: (value, meta) {
                      //     if (value.toInt() >= 0 && value.toInt() < weeklyData.keys.length) {
                      //       return Text(weeklyData.keys.elementAt(value.toInt()));
                      //     }
                      //     return const Text('');
                      //   },
                      // ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _createBarGroups(weeklyData),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }

  // Aggregate workout data by week
  Map<String, double> _aggregateWeeklyData(List<Workout> workouts) {
    final Map<String, double> data = {};

    for (var workout in workouts) {
      final date = workout.date;
      final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
      final week = '${startOfWeek.month}/${startOfWeek.day}';

      if (data.containsKey(week)) {
        data[week] = data[week]! + workout.duration.toDouble();
      } else {
        data[week] = workout.duration.toDouble();
      }
    }
    return data;
  }

  List<BarChartGroupData> _createBarGroups(Map<String, double> data) {
    return data.entries.map((entry) {
      return BarChartGroupData(
        x: data.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.green, // Different color for distinction
            width: 16,
          ),
        ],
      );
    }).toList();
  }
}
