import 'package:fitness_tracker_app/view/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/workout_bloc.dart';
import '../../bloc/workout_state.dart';
import '../../model/workout_model.dart';
import 'package:intl/intl.dart';

import '../calories_progress.dart';

class TotalWorkoutStats extends StatelessWidget {
  const TotalWorkoutStats({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Total Workout Status'),
        ),
        body: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkoutsLoaded) {
              final caloriesData = _aggregateCaloriesData(state.workouts);

              if (caloriesData.isEmpty) {
                return const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(caloriesData.keys.elementAt(value.toInt()));
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: _createBarGroups(caloriesData),
                          gridData: const FlGridData(show: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Calories Burned by Type (Pie Chart)',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: _createPieSections(caloriesData),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 5,
                                centerSpaceRadius: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildLegend(caloriesData),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }

  Map<String, int> _aggregateCaloriesData(List<Workout> workouts) {
    final Map<String, int> data = {};

    for (var workout in workouts) {
      if (data.containsKey(workout.type)) {
        data[workout.type] = data[workout.type]! + workout.calories;
      } else {
        data[workout.type] = workout.calories;
      }
    }
    return data;
  }

  List<BarChartGroupData> _createBarGroups(Map<String, int> data) {
    return data.entries.map((entry) {
      return BarChartGroupData(
        x: data.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blueGrey.shade700,
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  // List<PieChartSectionData> _createPieSections(Map<String, int> data) {
  //   final colors = [
  //     Colors.redAccent.shade700,
  //     Colors.purple.shade700,
  //     Colors.tealAccent.shade700,
  //     Colors.orangeAccent.shade700,
  //
  //
  //
  //   ];
  //
  //   return data.entries.toList().asMap().entries.map((entry) {
  //     final index = entry.key;
  //     final item = entry.value;
  //     final color = colors[index % colors.length];
  //
  //     return PieChartSectionData(
  //       value: item.value.toDouble(),
  //       title: '',
  //       color: color,
  //       radius: 90,
  //
  //     );
  //   }).toList();
  // }

  // List<PieChartSectionData> _createPieSections(Map<String, int> data) {
  //   final colors = [
  //     Colors.redAccent.shade700,
  //     Colors.purple.shade700,
  //     Colors.tealAccent.shade700,
  //     Colors.orangeAccent.shade700,
  //   ];
  //
  //   final total = data.values.fold(0, (sum, value) => sum + value);
  //
  //   return data.entries.toList().asMap().entries.map((entry) {
  //     final index = entry.key;
  //     final item = entry.value;
  //     final color = colors[index % colors.length];
  //     final percentage = (item.value / total * 100).toStringAsFixed(1); // Calculate percentage
  //
  //     return PieChartSectionData(
  //       value: item.value.toDouble(),
  //       title: '$percentage%', // Display percentage in the middle of the pie element
  //       color: color,
  //       radius: 90,
  //       titleStyle: const TextStyle(
  //         fontSize: 16,
  //         color: Colors.white, // Make sure the text is readable on the pie element
  //       ),
  //     );
  //   }).toList();
  // }

  List<PieChartSectionData> _createPieSections(Map<String, int> data) {
    final colors = [
      Colors.redAccent.shade700,
      Colors.purple.shade700,
      Colors.tealAccent.shade700,
      Colors.orangeAccent.shade700,
    ];

    final total = data.values.fold(0, (sum, value) => sum + value);

    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final color = colors[index % colors.length];
      final percentage = (item.value / total * 100).toStringAsFixed(1);
      final double percentageValue = item.value / total * 100;

      return PieChartSectionData(
        value: item.value.toDouble(),
        title: percentageValue >= 5 ? '$percentage%' : '', // Show only if >= 5%
        color: color,
        radius: 90,
        titleStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white, // Make sure the text is readable on the pie element
        ),
      );
    }).toList();
  }



  List<Widget> _buildLegend(Map<String, int> data) {
    final colors = [
      Colors.redAccent.shade700,
      Colors.purple.shade700,
      Colors.tealAccent.shade700,
      Colors.orangeAccent.shade700,
    ];

    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final workoutType = entry.value.key;
      final color = colors[index % colors.length];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              workoutType,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }
}
