// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
//
// import '../bloc/workout_bloc.dart';
// import '../bloc/workout_state.dart';
// import '../model/workout_model.dart';
//
// class ProgressChart extends StatelessWidget {
//   const ProgressChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<WorkoutBloc, WorkoutState>(
//       builder: (context, state) {
//         if (state is WorkoutsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is WorkoutsLoaded) {
//           final dailyProgress = _aggregateProgressData(state.workouts);
//
//           if (dailyProgress.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No data available',
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             );
//           }
//
//           final sortedEntries = dailyProgress.entries.toList()..sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.key).compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));
//
//           final spots = sortedEntries.asMap().entries.map((entry) {
//             final index = entry.key.toDouble(); // Convert the index to double
//             final value = entry.value.value.toDouble();
//             // final value = (entry.value as int).toDouble(); // Convert the value to double
//             return FlSpot(index, value);
//           }).toList();
//
//           final maxY = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();
//
//           return LineChart(
//             LineChartData(
//               gridData: const FlGridData(show: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) => Text(
//                       value.toInt().toString(),
//                       style: const TextStyle(
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       final dateIndex = value.toInt();
//                       if (dateIndex >= 0 && dateIndex < sortedEntries.length) {
//                         final dateKey = sortedEntries[dateIndex].key;
//                         return Text(
//                           DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateKey)),
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 10,
//                           ),
//                         );
//                       } else {
//                         return const Text('');
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(
//                 show: true,
//                 border: Border.all(
//                   color: const Color(0xff37434d),
//                   width: 1,
//                 ),
//               ),
//               minX: 0,
//               maxX: (sortedEntries.length - 1).toDouble(),
//               minY: 0,
//               maxY: maxY,
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: spots,
//                   isCurved: true,
//                   color: Colors.blueAccent,
//                   barWidth: 2,
//                   dotData: const FlDotData(show: true),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return const Center(child: Text('Something went wrong!'));
//         }
//       },
//     );
//   }
//
//   // Function to aggregate workout progress data (e.g., calories burned)
//   Map<String, int> _aggregateProgressData(List<Workout> workouts) {
//     final Map<String, int> dailyProgress = {};
//
//     for (var workout in workouts) {
//       final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
//       if (dailyProgress.containsKey(workoutDate)) {
//         dailyProgress[workoutDate] = dailyProgress[workoutDate]! + workout.calories;
//       } else {
//         dailyProgress[workoutDate] = workout.calories;
//       }
//     }
//
//     return dailyProgress;
//   }
// }
