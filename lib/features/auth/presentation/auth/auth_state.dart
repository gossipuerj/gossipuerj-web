import "package:equatable/equatable.dart";

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.idle,
    this.message,
    this.fieldErrors = const {},
    this.email,
  });

  final AuthStatus status;
  final String? message;
  final Map<String, String> fieldErrors;
  final String? email;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    Map<String, String>? fieldErrors,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, message, fieldErrors, email];
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
