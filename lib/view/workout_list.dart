import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../bloc/workout_event.dart';
import 'package:intl/intl.dart'; // For date formatting

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

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
            return LayoutBuilder(
              builder: (context, constraints) {
                // Allocate width proportionately or use flexible widgets
                final width = constraints.maxWidth;
                //final columnWidth = width / 15;
                final dateWidth = width * .09;   // 15% for date
                final typeWidth = width * 0.17;   // 25% for type
                final durationWidth = width * 0.12; // 20% for duration
                final caloriesWidth = width * 0.15; // 20% for calories
                final actionWidth = width * 0.2;  // 20% for action

                return SingleChildScrollView(
                  child: Column(

                    children: [
                      DataTable(
                        columnSpacing: 20,
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              width: dateWidth,
                              child: const Text('Date', textAlign: TextAlign.center),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: typeWidth,
                              child: const Text('Type', textAlign: TextAlign.center),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: durationWidth,
                              child: const Text('Duration', textAlign: TextAlign.center),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: caloriesWidth,
                              child: const Text('Calories', textAlign: TextAlign.center),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: actionWidth,
                              child: const Text('Action', textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                        rows: state.workouts.map((workout) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: dateWidth,
                                  child: Text(
                                    DateFormat('MM-dd').format(workout.date),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: typeWidth,
                                  child: Text(
                                    workout.type,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: durationWidth,
                                  child: Text(
                                    '${workout.duration} min',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: caloriesWidth,
                                  child: Text(
                                    '${workout.calories}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: actionWidth,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      context
                                          .read<WorkoutBloc>()
                                          .add(DeleteWorkout(workout.id!));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList()
                          ..add(
                            DataRow(
                              cells: [
                                const DataCell(SizedBox(width: 0)), // Spacer
                                const DataCell(Text('Total', textAlign: TextAlign.center)),
                                DataCell(
                                  Text(
                                    '${state.workouts.fold(0, (sum, workout) => sum + workout.duration)} min',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${state.workouts.fold(0, (sum, workout) => sum + workout.calories)}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const DataCell(SizedBox(width: 0)), // Spacer
                              ],
                            ),
                          ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
