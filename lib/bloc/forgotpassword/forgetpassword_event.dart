import 'package:equatable/equatable.dart';


abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailSubmitted extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordEmailSubmitted(this.email);

  @override
  List<Object> get props => [email];
}

class OtpSubmitted extends ForgotPasswordEvent {
  final String email;
  final String otp;

  const OtpSubmitted(this.email, this.otp);

  @override
  List<Object> get props => [email, otp];
}

class NewPasswordSubmitted extends ForgotPasswordEvent {
  final String email;
  final String newPassword;

  const NewPasswordSubmitted(this.email, this.newPassword);

  @override
  List<Object> get props => [email, newPassword];
}


// abstract class ForgotPasswordEvent extends Equatable {
//   const ForgotPasswordEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ForgotPasswordEmailSubmitted extends ForgotPasswordEvent {
//   final String email;
//
//   const ForgotPasswordEmailSubmitted(this.email);
//
//   @override
//   List<Object> get props => [email];
// }
//
// class OtpSubmitted extends ForgotPasswordEvent {
//   final String email;
//   final String otp;
//
//   const OtpSubmitted(this.email, this.otp);
//
//   @override
//   List<Object> get props => [email, otp];
// }
//
// class NewPasswordSubmitted extends ForgotPasswordEvent {
//   final String email;
//   final String newPassword;
//
//   const NewPasswordSubmitted(this.email, this.newPassword);
//
//   @override
//   List<Object> get props => [email, newPassword];
// }