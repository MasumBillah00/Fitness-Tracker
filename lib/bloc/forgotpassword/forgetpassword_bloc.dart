import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import '../../database/login_database.dart';
import 'forgetpassword_event.dart';
import 'forgetpassword_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final LoginDatabaseHelper _databaseHelper;

  ForgotPasswordBloc(this._databaseHelper) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailSubmitted>(_onForgotPasswordEmailSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<NewPasswordSubmitted>(_onNewPasswordSubmitted);
  }

  Future<void> _onForgotPasswordEmailSubmitted(ForgotPasswordEmailSubmitted event, Emitter<ForgotPasswordState> emit) async {
    try {
      final userExists = await _databaseHelper.userExists(event.email);
      if (userExists) {
        final otp = _generateOtp();
        await _databaseHelper.updateUserOtp(event.email, otp);
        print('OTP sent to email: $otp');  // Print OTP to console for testing
        emit(ForgotPasswordEmailSent());
      } else {
        emit(ForgotPasswordFailure('User not found'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  Future<void> _onOtpSubmitted(OtpSubmitted event, Emitter<ForgotPasswordState> emit) async {
    try {
      final user = await _databaseHelper.getUserByEmail(event.email);
      if (user != null && user['otp'] == event.otp) {
        emit(OtpVerified());
      } else {
        emit(ForgotPasswordFailure('Invalid OTP'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  Future<void> _onNewPasswordSubmitted(NewPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    try {
      final user = await _databaseHelper.getUserByEmail(event.email);
      if (user != null) {
        await _databaseHelper.updateUserPassword(event.email, event.newPassword);
        emit(PasswordResetSuccess());
      } else {
        emit(ForgotPasswordFailure('User not found'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  String _generateOtp() {
    final random = Random();
    const length = 6;
    const characters = '0123456789';
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
  }
}
