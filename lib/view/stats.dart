import 'package:fitness_tracker_app/view/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../model/workout_model.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Stats'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            final workoutData = _aggregateWorkoutData(state.workouts);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Daily Workout Stats',
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
                        barGroups: _createBarGroups(workoutData),
                        gridData: FlGridData(show: false),
                      ),
                    ),
                  ),

                  TextButton(onPressed:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WeeklyChart(workouts: [])),
                    );
                  },
                      child: Text('WeeklyChart'))
                  //WeeklyChart(workouts: state.workouts),

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

  Map<String, int> _aggregateWorkoutData(List<Workout> workouts) {
    final Map<String, int> data = {};

    for (var workout in workouts) {
      if (data.containsKey(workout.type)) {
        data[workout.type] = data[workout.type]! + workout.duration;
      } else {
        data[workout.type] = workout.duration;
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
            color: Colors.blue,
            width: 16,
          ),
        ],
      );
    }).toList();
  }
}
