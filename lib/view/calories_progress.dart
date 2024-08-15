// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
//
// import '../model/workout_model.dart';
//
// class CaloriesProgressChart extends StatelessWidget {
//   final List<Workout> workouts;
//
//   const CaloriesProgressChart({super.key, required this.workouts});
//
//   @override
//   Widget build(BuildContext context) {
//     final dailyCalories = _aggregateCaloriesByDate(workouts);
//
//     if (dailyCalories.isEmpty) {
//       return const Center(
//         child: Text(
//           'No data available',
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       );
//     }
//
//     final sortedEntries = dailyCalories.entries.toList()
//       ..sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.key).compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));
//
//     final spots = sortedEntries.asMap().entries.map((entry) {
//       final index = entry.key.toDouble();
//       final value = entry.value.value.toDouble();
//       return FlSpot(index, value);
//     }).toList();
//
//     final maxY = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();
//
//     return LineChart(
//       LineChartData(
//         gridData: const FlGridData(show: false),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) => Text(
//                 value.toInt().toString(),
//                 style: const TextStyle(
//                   color: Colors.black54,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 final dateIndex = value.toInt();
//                 if (dateIndex >= 0 && dateIndex < sortedEntries.length) {
//                   final dateKey = sortedEntries[dateIndex].key;
//                   return Text(
//                     DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateKey)),
//                     style: const TextStyle(
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 10,
//                     ),
//                   );
//                 } else {
//                   return const Text('');
//                 }
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(
//             color: const Color(0xff37434d),
//             width: 1,
//           ),
//         ),
//         minX: 0,
//         maxX: (sortedEntries.length - 1).toDouble(),
//         minY: 0,
//         maxY: maxY,
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             color: Colors.blueAccent,
//             barWidth: 2,
//             dotData: const FlDotData(show: true),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to aggregate calories burned by date
//   Map<String, int> _aggregateCaloriesByDate(List<Workout> workouts) {
//     final Map<String, int> dailyCalories = {};
//
//     for (var workout in workouts) {
//       final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
//       if (dailyCalories.containsKey(workoutDate)) {
//         dailyCalories[workoutDate] = dailyCalories[workoutDate]! + workout.calories;
//       } else {
//         dailyCalories[workoutDate] = workout.calories;
//       }
//     }
//
//     return dailyCalories;
//   }
// }
// //
// // // Mock Workout model (replace this with your actual model)
// // class Workout {
// //   final DateTime date;
// //   final int calories;
// //
// //   Workout(this.date, this.calories);
// // }
