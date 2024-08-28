import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/login_database.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginDatabaseHelper _databaseHelper;
  Timer? _logoutTimer;

  LoginBloc(this._databaseHelper) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<Logout>(_onLogout);
    on<ResetTimerEvent>(_onResetTimerEvent);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final user = await _databaseHelper.getUser(state.email, state.password);
      if (user != null) {
        emit(state.copyWith(status: LoginStatus.success, message: 'Login successful'));
        add(ResetTimerEvent());
      } else {
        emit(state.copyWith(status: LoginStatus.error, message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
    }
  }

  void _onResetTimerEvent(ResetTimerEvent event, Emitter<LoginState> emit) {
    _logoutTimer?.cancel(); // Cancel any existing timer

    const inactivityDuration = Duration(seconds: 20); // Set your desired inactivity time

    _logoutTimer = Timer(inactivityDuration, () {
      add(Logout()); // Trigger the logout event after the timer expires
    });

    print('Timer reset after login');
  }


  void _onLogout(Logout event, Emitter<LoginState> emit) async {
    await _databaseHelper.clearSessionData();
    print('Session data after logout: ${await _databaseHelper.getSessionData()}');
    emit(state.copyWith(status: LoginStatus.loggedOut));
    // Optionally print a message here to ensure this code path is executed
    print("Logout event processed");
  }




// void _onLogout(Logout event, Emitter<LoginState> emit) async {
  //   _logoutTimer?.cancel(); // Cancel the timer on logout
  //
  //   // Clear any session data, such as authentication tokens
  //   await _databaseHelper.clearSessionData();
  //
  //   // Reset the state and clear user information
  //   emit(LoginState(
  //     email: '',
  //     password: '',
  //     status: LoginStatus.loggedOut, // Set to logged out status
  //     message: 'Logged out successfully',
  //   ));
  //
  //   print('Log out successful');
  // }
}
