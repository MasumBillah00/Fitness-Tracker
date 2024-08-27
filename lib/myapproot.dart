import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/login/login_event.dart';
import 'bloc/login/login_state.dart';
import 'package:fitness_tracker_app/view/login/login_screen.dart';
import 'package:fitness_tracker_app/view/screen/home_screen.dart';
import 'package:fitness_tracker_app/widget/theme/apptheme.dart';

class MyAppRoot extends StatefulWidget {
  @override
  MyAppRootState createState() => MyAppRootState();
}

class MyAppRootState extends State<MyAppRoot> {
  Timer? _rootTimer;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  void initializeTimer() {
    _rootTimer?.cancel(); // Cancel any existing timer
    const time = Duration(seconds: 20); // Set your desired inactivity time
    _rootTimer = Timer(time, () {
      logOutUser();
    });
  }

  void logOutUser() {
    _rootTimer?.cancel();
    context.read<LoginBloc>().add(Logout());

    // Use navigator key to navigate to the login screen
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker App',
      theme: AppTheme.lightTheme,
      navigatorKey: _navigatorKey,
      home: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            initializeTimer(); // Start or reset the timer after each login
            _navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state.status == LoginStatus.loggedOut) {
            logOutUser();
          } else if (state.status == LoginStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
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
    );
  }


//   void initializeTimer() {
//     _rootTimer?.cancel();
//     const time = Duration(seconds: 20); // Adjust the time as needed
//     _rootTimer = Timer(time, () {
//       logOutUser();
//     });
//   }
//
//   void logOutUser() {
//     _rootTimer?.cancel();
//     context.read<LoginBloc>().add(Logout());
//
//     // Use navigator key to navigate to the login screen
//     _navigatorKey.currentState?.pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//           (route) => false, // Remove all previous routes
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Fitness Tracker App',
//       theme: AppTheme.lightTheme,
//       navigatorKey: _navigatorKey,
//       home: BlocListener<LoginBloc, LoginState>(
//         listener: (context, state) {
//           if (state.status == LoginStatus.success) {
//             initializeTimer(); // Start the timer after successful login
//             _navigatorKey.currentState?.pushReplacement(
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//             );
//           } else if (state.status == LoginStatus.loggedOut) {
//             logOutUser(); // Ensure this logic is consistent
//           } else if (state.status == LoginStatus.error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: BlocBuilder<LoginBloc, LoginState>(
//           builder: (context, state) {
//             if (state.status == LoginStatus.success) {
//               return const HomeScreen();
//             } else {
//               return const LoginScreen();
//             }
//           },
//         ),
//       ),
//     );
//   }
//
  @override
  void dispose() {
    _rootTimer?.cancel();
    super.dispose();
  }
}
