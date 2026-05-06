import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/error/app_exception.dart";
import "../../../../domain/repositories/auth_repository.dart";
import "../session/session_cubit.dart";
import "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._sessionCubit)
    : super(const AuthState());

  final AuthRepository _authRepository;
  final SessionCubit _sessionCubit;

  Future<void> login(String email) async {
    emit(const AuthState(status: AuthStatus.submitting));
    try {
      await _authRepository.requestLoginMagicLink(email);
      emit(AuthState(status: AuthStatus.magicLinkSent, email: email));
    } on ValidationException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.validationFailure,
          message: error.message,
          fieldErrors: error.fieldErrors,
        ),
      );
    } on AppException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          message: error.message,
          statusCode: error.statusCode,
        ),
      );
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    String? personalEmail,
  }) async {
    emit(const AuthState(status: AuthStatus.submitting));
    try {
      await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        personalEmail: personalEmail,
      );
      emit(AuthState(status: AuthStatus.registrationSubmitted, email: email));
    } on ValidationException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.validationFailure,
          message: error.message,
          fieldErrors: error.fieldErrors,
        ),
      );
    } on AppException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          message: error.message,
          statusCode: error.statusCode,
        ),
      );
    }
  }

  Future<void> verify(String token) async {
    emit(const AuthState(status: AuthStatus.submitting));
    try {
      await _authRepository.verifyMagicLink(token);
      await _sessionCubit.refreshUser();
      emit(const AuthState(status: AuthStatus.verified));
    } on AppException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          message: error.message,
          statusCode: error.statusCode,
        ),
      );
    }
  }

  void clearFeedback() {
    emit(const AuthState());
  }
}
