import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/error/app_exception.dart";
import "../../../../domain/models/user_profile.dart";
import "../../../../core/storage/token_store.dart";
import "../../../../domain/repositories/auth_repository.dart";
import "session_state.dart";

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._authRepository, this._tokenStore)
    : super(const SessionState.initial());

  final AuthRepository _authRepository;
  final TokenStore _tokenStore;

  Future<void> start() async {
    emit(const SessionState.loading());
    final token = await _tokenStore.read();
    if (token == null || token.isEmpty) {
      emit(const SessionState.unauthenticated());
      return;
    }
    await refreshUser();
  }

  Future<void> refreshUser() async {
    emit(const SessionState.loading());
    try {
      final user = await _authRepository.getCurrentUser();
      emit(SessionState.authenticated(user));
    } on AppException catch (error) {
      await _tokenStore.clear();
      emit(SessionState.unauthenticated(message: error.message));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const SessionState.unauthenticated());
  }

  void setAuthenticatedUser(UserProfile user) {
    emit(SessionState.authenticated(user));
  }
}
