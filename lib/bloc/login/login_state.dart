import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, error, loggedOut }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final String message;

  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.message = '',
  });

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? message,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [email, password, status, message];
}