import "../models/user_profile.dart";

abstract class AuthRepository {
  Future<void> requestLoginMagicLink(String email);

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    String? personalEmail,
  });

  Future<String> verifyMagicLink(String token);
  Future<UserProfile> getCurrentUser();
  Future<UserProfile> updateCurrentUser({
    String? username,
    String? course,
    String? bio,
    String? avatarUrl,
    String? gender,
    String? orientation,
    bool? showInGallery,
  });
  Future<void> logout();
}
