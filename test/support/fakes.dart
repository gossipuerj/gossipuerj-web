import "package:flutter_app/core/storage/token_store.dart";
import "package:flutter_app/domain/models/university_event.dart";
import "package:flutter_app/domain/models/user_profile.dart";
import "package:flutter_app/domain/repositories/auth_repository.dart";

class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore({this.initialToken});

  final String? initialToken;
  String? _token;

  @override
  Future<void> clear() async {
    _token = null;
  }

  @override
  Future<String?> read() async {
    return _token ?? initialToken;
  }

  @override
  Future<void> write(String token) async {
    _token = token;
  }
}

class FakeAuthRepository implements AuthRepository {
  final user = const UserProfile(
    id: "user-123",
    username: "aluna",
    email: "aluna@graduacao.uerj.br",
    firstName: "Aluna",
    lastName: "UERJ",
  );

  @override
  Future<UserProfile> getCurrentUser() async => user;

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({required String firstName, required String lastName, required String email, String? personalEmail}) async {}

  @override
  Future<void> requestLoginMagicLink(String email) async {}

  @override
  Future<UserProfile> updateCurrentUser({String? username, String? course, String? bio, String? avatarUrl, String? gender, String? orientation, bool? showInGallery}) async {
    return user.copyWith(
      username: username,
      course: course,
      bio: bio,
      avatarUrl: avatarUrl,
      gender: gender,
      orientation: orientation,
      showInGallery: showInGallery,
    );
  }

  @override
  Future<String> verifyMagicLink(String token) async => token;
}

UniversityEvent fakeEvent() {
  return const UniversityEvent(
    id: "x",
    title: "Novo",
    category: "Social",
    location: "Campus",
    time: "20:00",
    description: "Teste",
  );
}
