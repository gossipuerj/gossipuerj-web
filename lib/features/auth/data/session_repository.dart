import "../../../domain/models/user_profile.dart";

abstract class SessionRepository {
  UserProfile? initialUser();
}

class MockSessionRepository implements SessionRepository {
  const MockSessionRepository({required this.seedUser});

  final UserProfile seedUser;

  @override
  UserProfile? initialUser() => seedUser;
}
