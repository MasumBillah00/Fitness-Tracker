import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../bloc/workout_event.dart';
import '../model/workout_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class WorkoutList extends StatelessWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout List'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            return SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')), // New column for Date
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Duration')),
                  DataColumn(label: Text('Calories')),
                  DataColumn(label: Text('Action')),
                ],
                rows: state.workouts.map((workout) {
                  return DataRow(cells: [
                    DataCell(Text(DateFormat('MM-dd').format(workout.date))), // Display formatted date
                    DataCell(Text(workout.type)),
                    DataCell(Text('${workout.duration} min')),
                    DataCell(Text('${workout.calories}')),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<WorkoutBloc>().add(DeleteWorkout(workout.id!));
                        },
                      ),
                    ),
                  ]);
                }).toList()
                  ..add(
                    DataRow(
                      cells: [
                        const DataCell(Text('Total')),
                        const DataCell(Text('')), // Empty cell for the Date column
                        DataCell(Text('${state.workouts.fold(0, (sum, workout) => sum + workout.duration)} min')),
                        DataCell(Text('${state.workouts.fold(0, (sum, workout) => sum + workout.calories)}')),
                        const DataCell(Text('')),
                      ],
                    ),
                  ),
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
