// import 'package:equatable/equatable.dart';
//
// enum LoginStatus { initial, loading, success, error, loggedOut }
//
// class LoginState {
//   final String email;
//   final String password;
//   final LoginStatus status;
//   final String message;
//
//   const LoginState({
//     this.email = '',
//     this.password = '',
//     this.status = LoginStatus.initial,
//     this.message = '',
//   });
//
//   LoginState copyWith({
//     String? email,
//     String? password,
//     LoginStatus? status,
//     String? message,
//   }) {
//     return LoginState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       status: status ?? this.status,
//       message: message ?? this.message,
//     );
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is LoginState &&
//               runtimeType == other.runtimeType &&
//               email == other.email &&
//               password == other.password &&
//               status == other.status &&
//               message == other.message;
//
//   @override
//   int get hashCode =>
//       email.hashCode ^
//       password.hashCode ^
//       status.hashCode ^
//       message.hashCode;
// }
//
//
// // enum LoginStatus { initial, loading, success, error, loggedOut }
// //
// // class LoginState extends Equatable {
// //   final String email;
// //   final String password;
// //   final LoginStatus status;
// //   final String message;
// //
// //   const LoginState({
// //     this.email = '',
// //     this.password = '',
// //     this.status = LoginStatus.initial,
// //     this.message = '',
// //   });
// //
// //   LoginState copyWith({
// //     String? email,
// //     String? password,
// //     LoginStatus? status,
// //     String? message,
// //   }) {
// //     return LoginState(
// //       email: email ?? this.email,
// //       password: password ?? this.password,
// //       status: status ?? this.status,
// //       message: message ?? this.message,
// //     );
// //   }
// //
// //   @override
// //   List<Object> get props => [email, password, status, message];
// // }


// auth_state.dart
abstract class AuthState {}

class LoggedOutState extends AuthState {}

class LoggedInState extends AuthState {}

class LoginFailedState extends AuthState {
  final String message;
  LoginFailedState(this.message);
}
