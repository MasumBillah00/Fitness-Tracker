
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database.dart';
import 'login_event.dart';
import 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Timer? _logoutTimer;
  Timer? _inactivityTimer;
  static const inactivityDuration = Duration(minutes: 1); // Set inactivity time (1 minute)

  AuthBloc() : super(LoggedOutState()) {
    on<LoginEvent>((event, emit) async {
      final user = await _databaseHelper.getUser(event.email);
      if (user != null && user['password'] == event.password) {
        emit(LoggedInState());
        _startInactivityTimer(); // Start inactivity timer
      } else {
        emit(LoginFailedState('Invalid email or password'));
      }
    });

    on<LogoutEvent>((event, emit) {
      _cancelTimers(); // Cancel both timers on logout
      emit(LoggedOutState());
    });

    // If user is inactive, logout automatically
    on<InactivityLogoutEvent>((event, emit) {
      _cancelTimers(); // Cancel both timers on inactivity logout
      emit(LoggedOutState());
    });
  }

  // Start a timer that logs the user out after inactivity
  void _startInactivityTimer() {
    _cancelTimers(); // Cancel any existing timers
    _inactivityTimer = Timer(inactivityDuration, () {
      // Trigger logout event after inactivity duration
      add(InactivityLogoutEvent());
    });
  }

  // Reset the inactivity timer when user performs an activity
  void resetInactivityTimer() {
    _startInactivityTimer();
  }

  // Cancel all timers
  void _cancelTimers() {
    _logoutTimer?.cancel();
    _inactivityTimer?.cancel();
  }

  @override
  Future<void> close() {
    _cancelTimers(); // Ensure timers are canceled when bloc is closed
    return super.close();
  }
}



//
// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../database.dart';
// import 'login_event.dart';
// import 'login_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//   Timer? _logoutTimer;
//
//
//
//   void _startLogoutTimer() {
//     _logoutTimer?.cancel();
//     _logoutTimer = Timer(Duration(seconds: 60), () {
//       add(LogoutEvent());
//     });
//   }
//
//   AuthBloc() : super(LoggedOutState()) {
//     on<LoginEvent>((event, emit) async {
//       final user = await _databaseHelper.getUser(event.email);
//       if (user != null && user['password'] == event.password) {
//         emit(LoggedInState());
//         _startLogoutTimer();
//       } else {
//         emit(LoginFailedState('Invalid email or password'));
//       }
//     });
//
//     on<LogoutEvent>((event, emit) {
//       _logoutTimer?.cancel();
//       //await _clearSession(); // Custom method to clear session data
//       //emit(LoggedOutState());
//       emit(LoggedOutState());
//     });
//   }
//
//   @override
//   Future<void> close() {
//     _logoutTimer?.cancel();
//     return super.close();
//   }
// }
//
//
// // import 'dart:async';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../database/login_database.dart';
// // import 'login_event.dart';
// // import 'login_state.dart';
// //
// // class LoginBloc extends Bloc<LoginEvent, LoginState> {
// //   final LoginDatabaseHelper _databaseHelper;
// //   Timer? _logoutTimer;
// //
// //   LoginBloc(this._databaseHelper) : super(const LoginState()) {
// //     on<EmailChanged>(_onEmailChanged);
// //     on<PasswordChanged>(_onPasswordChanged);
// //     on<LoginSubmitted>(_onLoginSubmitted);
// //     on<Logout>(_onLogout);
// //     on<ResetTimerEvent>(_onResetTimerEvent);
// //   }
// //
// //   void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
// //     emit(state.copyWith(email: event.email));
// //   }
// //
// //   void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
// //     emit(state.copyWith(password: event.password));
// //   }
// //
// //   Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
// //     emit(state.copyWith(status: LoginStatus.loading));
// //
// //     try {
// //       final user = await _databaseHelper.getUser(state.email, state.password);
// //       if (user != null) {
// //         emit(state.copyWith(status: LoginStatus.success, message: 'Login successful'));
// //         add(ResetTimerEvent());
// //       } else {
// //         emit(state.copyWith(status: LoginStatus.error, message: 'Invalid email or password'));
// //       }
// //     } catch (e) {
// //       emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
// //     }
// //   }
// //
// //   void _onResetTimerEvent(ResetTimerEvent event, Emitter<LoginState> emit) {
// //     _logoutTimer?.cancel(); // Cancel any existing timer
// //
// //     const inactivityDuration = Duration(seconds: 20); // Set your desired inactivity time
// //
// //     _logoutTimer = Timer(inactivityDuration, () {
// //       add(Logout()); // Trigger the logout event after the timer expires
// //     });
// //
// //     print('Timer reset after login');
// //   }
// //
// //
// //   void _onLogout(Logout event, Emitter<LoginState> emit) async {
// //     await _databaseHelper.clearSessionData();
// //     print('Session data after logout: ${await _databaseHelper.getSessionData()}');
// //     emit(state.copyWith(status: LoginStatus.loggedOut));
// //     // Optionally print a message here to ensure this code path is executed
// //     print("Logout event processed");
// //   }
// //
// //
// //
// //
// // // void _onLogout(Logout event, Emitter<LoginState> emit) async {
// //   //   _logoutTimer?.cancel(); // Cancel the timer on logout
// //   //
// //   //   // Clear any session data, such as authentication tokens
// //   //   await _databaseHelper.clearSessionData();
// //   //
// //   //   // Reset the state and clear user information
// //   //   emit(LoginState(
// //   //     email: '',
// //   //     password: '',
// //   //     status: LoginStatus.loggedOut, // Set to logged out status
// //   //     message: 'Logged out successfully',
// //   //   ));
// //   //
// //   //   print('Log out successful');
// //   // }
// // }
//
//
// // import 'dart:async';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../database.dart';
// // import 'login_event.dart';
// // import 'login_state.dart';
// //
// // import 'dart:async';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../database/login_database.dart';
// // import 'login_event.dart';
// // import 'login_state.dart';
// // class AuthBloc extends Bloc<AuthEvent, AuthState> {
// //   final LoginDatabaseHelper _databaseHelper = LoginDatabaseHelper.instance;
// //   Timer? _logoutTimer;
// //
// //   AuthBloc() : super(LoggedOutState()) {
// //     on<LoginEvent>(_onLoginEvent);
// //     on<LogoutEvent>(_onLogoutEvent);
// //   }
// //
// //   Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
// //     try {
// //       // Check if user exists with the given email
// //       final userExists = await _databaseHelper.userExists(event.email);
// //       if (!userExists) {
// //         emit(LoginFailedState('User does not exist'));
// //         return;
// //       }
// //
// //       // Check if the password is correct
// //       final user = await _databaseHelper.getUser(event.email, event.password);
// //       if (user != null) {
// //         emit(LoggedInState());
// //         _startLogoutTimer();
// //       } else {
// //         emit(LoginFailedState('Invalid email or password'));
// //       }
// //     } catch (e) {
// //       emit(LoginFailedState('An error occurred: ${e.toString()}'));
// //     }
// //   }
// //
// //   void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) {
// //     _logoutTimer?.cancel();
// //     emit(LoggedOutState());
// //   }
// //
// //   void _startLogoutTimer() {
// //     _logoutTimer?.cancel();
// //     _logoutTimer = Timer(Duration(seconds: 10), () {
// //       add(LogoutEvent());
// //     });
// //   }
// //
// //   @override
// //   Future<void> close() {
// //     _logoutTimer?.cancel();
// //     return super.close();
// //   }
// // }
//
//
