


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';

class TimerManager {
  Timer? _inactivityTimer;
  Timer? _logoutTimer;
  int _remainingTime;
  final BuildContext context;
  final VoidCallback onTick; // Callback to trigger UI update

  TimerManager({
    required this.context,
    required int initialTime,
    required this.onTick,
  }) : _remainingTime = initialTime;

  // Start the inactivity timer which will start logout timer after 1 minute of inactivity
  void startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(minutes: 1), () {
      // Start logout timer after 1 minute of inactivity
      startLogoutTimer();
    });
  }

  // Cancels inactivity and logout timers
  void resetTimers() {
    _inactivityTimer?.cancel();
    _logoutTimer?.cancel();
    _remainingTime = 60; // Reset remaining time
  }

  // Start the logout timer for countdown
  void startLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        onTick(); // Trigger UI update
      } else {
        // Logout when time runs out
        timer.cancel();
        context.read<AuthBloc>().add(LogoutEvent());
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }

  void dispose() {
    _inactivityTimer?.cancel();
    _logoutTimer?.cancel();
  }

  int get remainingTime => _remainingTime;
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/login/login_bloc.dart';
// import '../bloc/login/login_event.dart';
//
//
// class TimerManager {
//   Timer? _logoutTimer;
//   int _remainingTime;
//   final BuildContext context;
//   final VoidCallback onTick; // Callback to trigger UI update
//
//   TimerManager({required this.context, required int initialTime, required this.onTick})
//       : _remainingTime = initialTime;
//
//   void startLogoutTimer() {
//     _logoutTimer?.cancel();
//     _logoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingTime > 0) {
//         _remainingTime--;
//         onTick(); // Trigger UI update
//       } else {
//         timer.cancel();
//         context.read<AuthBloc>().add(LogoutEvent());
//         Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//       }
//     });
//   }
//
//   void cancelTimer() {
//     _logoutTimer?.cancel();
//   }
//
//   int get remainingTime => _remainingTime;
// }
//
//
// // class TimerManager {
// //   Timer? _logoutTimer;
// //   int _remainingTime;
// //   final BuildContext context;
// //
// //   TimerManager({required this.context, required int initialTime}) : _remainingTime = initialTime;
// //
// //   void startLogoutTimer() {
// //     _logoutTimer?.cancel();
// //     _logoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (_remainingTime > 0) {
// //         _remainingTime--;
// //         _updateRemainingTimeDisplay();
// //       } else {
// //         timer.cancel();
// //         context.read<AuthBloc>().add(LogoutEvent());
// //         Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
// //       }
// //     });
// //   }
// //
// //   void _updateRemainingTimeDisplay() {
// //     // If you want to display the remaining time in the UI, you can use a callback or other methods to update the UI.
// //   }
// //
// //   void cancelTimer() {
// //     _logoutTimer?.cancel();
// //   }
// //
// //   int get remainingTime => _remainingTime;
// // }
