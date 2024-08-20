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
        emit(ForgotPasswordEmailSent());
        // Here you can generate and store a mock OTP
        // In a real scenario, you'd send an OTP to the user's email
      } else {
        emit(ForgotPasswordFailure('User not found'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  Future<void> _onOtpSubmitted(OtpSubmitted event, Emitter<ForgotPasswordState> emit) async {
    try {
      // Simulate OTP verification
      // In a real scenario, validate the OTP here
      emit(OtpVerified());
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  Future<void> _onNewPasswordSubmitted(NewPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    try {
      final user = await _databaseHelper.getUser(event.email, '');
      if (user != null) {
        await _databaseHelper.updateUserPassword(user['id'], event.newPassword);
        emit(PasswordResetSuccess());
      } else {
        emit(ForgotPasswordFailure('User not found'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }
}



// class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
//
//
//   ForgotPasswordBloc(this._databaseHelper) : super(ForgotPasswordInitial()) {
//     on<ForgotPasswordEmailSubmitted>(_onForgotPasswordEmailSubmitted);
//     on<OtpSubmitted>(_onOtpSubmitted);
//     on<NewPasswordSubmitted>(_onNewPasswordSubmitted);
//   }
//
//   Future<void> _onForgotPasswordEmailSubmitted(
//       ForgotPasswordEmailSubmitted event, Emitter<ForgotPasswordState> emit) async {
//     try {
//       final user = await _databaseHelper.getUserByEmail(event.email);
//       if (user != null) {
//         final otp = _generateOtp();
//         await _databaseHelper.updateUserOtp(event.email, otp);
//         // Print OTP to console for testing
//         print('OTP sent to email: $otp');
//         emit(ForgotPasswordEmailSent());
//       } else {
//         emit(ForgotPasswordFailure('Email not found'));
//       }
//     } catch (e) {
//       emit(ForgotPasswordFailure(e.toString()));
//     }
//   }
//
//   Future<void> _onOtpSubmitted(OtpSubmitted event, Emitter<ForgotPasswordState> emit) async {
//     try {
//       final user = await _databaseHelper.getUserByEmail(event.email);
//       if (user != null && user['otp'] == event.otp) {
//         emit(OtpVerified());
//       } else {
//         emit(ForgotPasswordFailure('Invalid OTP'));
//       }
//     } catch (e) {
//       emit(ForgotPasswordFailure(e.toString()));
//     }
//   }
//
//   Future<void> _onNewPasswordSubmitted(NewPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
//     try {
//       await _databaseHelper.updatePassword(event.email, event.newPassword);
//       emit(PasswordResetSuccess());
//     } catch (e) {
//       emit(ForgotPasswordFailure(e.toString()));
//     }
//   }
//
//   String _generateOtp() {
//     final random = Random();
//     const length = 6;
//     const characters = '0123456789';
//     return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
//   }
// }