import 'package:fitness_tracker_app/view/stats/total_workout_stats.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/workout_bloc.dart';
import '../../bloc/workout_state.dart';
import '../../model/workout_model.dart';
import 'package:intl/intl.dart';
import '../calories_progress.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     // appBar: AppBar(title: Text('Daile Stats'),),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            final workoutData = _aggregateWorkoutData(state.workouts);  // Data for the first chart
            final caloriesByTypeToday = _aggregateCaloriesByTypeToday(state.workouts);  // Data for the second chart

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Stats By Time',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  workoutData.isEmpty
                      ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                      : Expanded(
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(workoutData.keys.elementAt(value.toInt()));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _createBarGroups(workoutData),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Calories Burned',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  caloriesByTypeToday.isEmpty
                      ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                      : Expanded(
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(caloriesByTypeToday.keys.elementAt(value.toInt()));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _createBarGroups(caloriesByTypeToday),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (newContext) => BlocProvider.value(
                              value: BlocProvider.of<WorkoutBloc>(context),
                              child: const TotalWorkoutStats(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Total Workout Stats'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  // First chart data aggregation: Today's workout durations by type
  Map<String, int> _aggregateWorkoutData(List<Workout> workouts) {
    final Map<String, int> data = {};
    final currentDate = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (workoutDate == today) {
        if (data.containsKey(workout.type)) {
          data[workout.type] = data[workout.type]! + workout.duration;
        } else {
          data[workout.type] = workout.duration;
        }
      }
    }
    return data;
  }

  // Second chart data aggregation: Today's calories burned by workout type
  Map<String, int> _aggregateCaloriesByTypeToday(List<Workout> workouts) {
    final Map<String, int> data = {};
    final currentDate = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (workoutDate == today) {
        if (data.containsKey(workout.type)) {
          data[workout.type] = data[workout.type]! + workout.calories;
        } else {
          data[workout.type] = workout.calories;
        }
      }
    }
    return data;
  }

  // Create bar groups for both charts
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
}
