import 'package:fitness_tracker_app/reposotiry/workoutrepository.dart';
import 'package:fitness_tracker_app/view/home_screen.dart';
import 'package:fitness_tracker_app/widget/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/workout_bloc.dart';
import 'bloc/workout_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker App',
      theme: AppTheme.lightTheme,  // Use the defined theme
      home: RepositoryProvider(
        create: (context) => WorkoutRepository(),
        child: BlocProvider(
          create: (context) =>
          WorkoutBloc(context.read<WorkoutRepository>())..add(LoadWorkouts()),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
