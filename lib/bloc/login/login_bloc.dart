import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../database/login_database.dart';
import '../../view/login/login_screen.dart';
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

        // Start the auto-logout timer
        _startAutoLogoutTimer();
      } else {
        emit(state.copyWith(status: LoginStatus.error, message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
    }
  }




  // void _onLogout(Logout event, Emitter<LoginState> emit) {
  //   // Cancel the timer when the user logs out manually or automatically
  //   _logoutTimer?.cancel();
  //   emit(state.copyWith(status: LoginStatus.loggedOut, message: 'Logged out'));
  // }
  void _startAutoLogoutTimer() {
    _logoutTimer?.cancel();
    print("Starting auto-logout timer for 3 minutes...");
    _logoutTimer = Timer(const Duration(minutes: 1), () {
      print("Auto-logout triggered.");
      add(Logout());
    });
  }

  void _onLogout(Logout event, Emitter<LoginState> emit) {
    print("Logout event received.");
    _logoutTimer?.cancel();
    emit(state.copyWith(status: LoginStatus.loggedOut, message: 'Logged out'));
  }


  // void _startAutoLogoutTimer() {
  //   // Cancel any existing timer
  //   _logoutTimer?.cancel();
  //
  //   // Debug log
  //   print("Starting auto-logout timer for 3 minutes...");
  //
  //   // Start a new timer for 3 minutes
  //   _logoutTimer = Timer(const Duration(minutes: 1), () {
  //     // Dispatch the logout event after 3 minutes
  //     print("Auto-logout triggered.");
  //     add(Logout());
  //   });
  // }


  @override
  Future<void> close() {
    // Cancel the timer when the bloc is closed
    _logoutTimer?.cancel();
    return super.close();
  }
}
