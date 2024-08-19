import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../database/login_database.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginDatabaseHelper _databaseHelper;

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
      } else {
        emit(state.copyWith(status: LoginStatus.error, message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
    }
  }

  void _onLogout(Logout event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
