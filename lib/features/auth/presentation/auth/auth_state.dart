import "package:equatable/equatable.dart";

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.idle,
    this.message,
    this.fieldErrors = const {},
    this.email,
    this.statusCode,
  });

  final AuthStatus status;
  final String? message;
  final Map<String, String> fieldErrors;
  final String? email;
  final int? statusCode;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    Map<String, String>? fieldErrors,
    String? email,
    int? statusCode,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      email: email ?? this.email,
      statusCode: statusCode,
    );
  }

  @override
  List<Object?> get props => [status, message, fieldErrors, email, statusCode];
}

enum AuthStatus {
  idle,
  submitting,
  magicLinkSent,
  registrationSubmitted,
  verified,
  failure,
  validationFailure,
}
