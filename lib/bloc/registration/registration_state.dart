import 'package:equatable/equatable.dart';

enum RegistrationStatus { initial, success, error, loading }

class RegistrationState extends Equatable {
  final String email;
  final String password;
  final String message;
  final RegistrationStatus status;

  const RegistrationState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.status = RegistrationStatus.initial,
  });

  RegistrationState copyWith({
    String? email,
    String? password,
    String? message,
    RegistrationStatus? status,
  }) {
    return RegistrationState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, message, status];
}