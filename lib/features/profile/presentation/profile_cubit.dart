import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/error/app_exception.dart";
import "../../../domain/repositories/auth_repository.dart";
import "../../auth/presentation/session/session_cubit.dart";
import "profile_state.dart";

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository, this._sessionCubit)
    : super(const ProfileState());

  final AuthRepository _authRepository;
  final SessionCubit _sessionCubit;

  void setUserFromSession() {
    emit(state.copyWith(user: _sessionCubit.state.user, message: null));
  }

  Future<void> updateProfile({
    required String username,
    required String course,
    required String bio,
    required String avatarUrl,
    required String gender,
    required String orientation,
    required bool showInGallery,
  }) async {
    emit(state.copyWith(isSaving: true, message: null, fieldErrors: const {}));
    try {
      final user = await _authRepository.updateCurrentUser(
        username: username.isEmpty ? null : username,
        course: course == "Não informado" ? null : course,
        bio: bio.isEmpty ? null : bio,
        avatarUrl: avatarUrl.isEmpty ? null : avatarUrl,
        gender: gender,
        orientation: orientation,
        showInGallery: showInGallery,
      );
      _sessionCubit.setAuthenticatedUser(user);
      emit(
        state.copyWith(
          user: user,
          isSaving: false,
          message: "Perfil atualizado com sucesso.",
        ),
      );
    } on ValidationException catch (error) {
      emit(
        state.copyWith(
          isSaving: false,
          message: error.message,
          fieldErrors: error.fieldErrors,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(isSaving: false, message: error.message));
    }
  }

  void clearFeedback() {
    emit(state.copyWith(message: null, fieldErrors: const {}));
  }
}
