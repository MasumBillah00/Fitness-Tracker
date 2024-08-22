import 'package:fitness_tracker_app/reposotiry/workoutrepository.dart';
import 'package:fitness_tracker_app/view/screen/home_screen.dart';
import 'package:fitness_tracker_app/view/login/login_screen.dart';
import 'package:fitness_tracker_app/widget/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/forgotpassword/forgetpassword_bloc.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/login/login_state.dart';
import 'bloc/registration/registration_bloc.dart';
import 'bloc/workout_bloc.dart';
import 'bloc/workout_event.dart';
import 'database/login_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = LoginDatabaseHelper.instance;
  final existingUser = await dbHelper.getUser('m.billahkst@gmail.com', '12345');

  if (existingUser == null) {
    await dbHelper.insertUser('m.billahkst@gmail.com', '12345');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WorkoutRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RegistrationBloc>(
            create: (context) => RegistrationBloc(
              databaseHelper: LoginDatabaseHelper.instance,
            ),
          ),
          BlocProvider(
            create: (context) => WorkoutBloc(context.read<WorkoutRepository>())
              ..add(LoadWorkouts()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(LoginDatabaseHelper.instance),
          ),
          BlocProvider(
            create: (context) => ForgotPasswordBloc(LoginDatabaseHelper.instance),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fitness Tracker App',
          theme: AppTheme.lightTheme,
          home: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.loggedOut) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state.status == LoginStatus.success) {
                  return const HomeScreen();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
