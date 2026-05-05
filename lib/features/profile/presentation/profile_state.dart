import "package:equatable/equatable.dart";

import "../../../domain/models/user_profile.dart";

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.isSaving = false,
    this.message,
    this.fieldErrors = const {},
  });

  final UserProfile? user;
  final bool isSaving;
  final String? message;
  final Map<String, String> fieldErrors;

  ProfileState copyWith({
    UserProfile? user,
    bool? isSaving,
    String? message,
    Map<String, String>? fieldErrors,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isSaving: isSaving ?? this.isSaving,
      message: message,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [user, isSaving, message, fieldErrors];
}
