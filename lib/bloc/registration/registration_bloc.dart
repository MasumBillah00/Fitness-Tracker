
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/login_database.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final LoginDatabaseHelper databaseHelper;

  RegistrationBloc({required this.databaseHelper}) : super(const RegistrationState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<RegistrationSubmitted>(_onRegistrationSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onRegistrationSubmitted(RegistrationSubmitted event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(status: RegistrationStatus.loading));
    try {
      // Check if user already exists
      final userExists = await databaseHelper.userExists(state.email);
      if (userExists) {
        emit(state.copyWith(status: RegistrationStatus.error, message: 'User already exists'));
        return;
      }

      // Register user
      await databaseHelper.insertUser(state.email, state.password);
      emit(state.copyWith(status: RegistrationStatus.success));
    } catch (e) {
      emit(state.copyWith(status: RegistrationStatus.error, message: e.toString()));
    }
  }
}
