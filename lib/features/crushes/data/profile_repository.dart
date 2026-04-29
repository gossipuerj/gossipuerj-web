import "../../../domain/models/user_profile.dart";

abstract class ProfileRepository {
  List<UserProfile> load();
}

class InMemoryProfileRepository implements ProfileRepository {
  const InMemoryProfileRepository(this.seedData);

  final List<UserProfile> seedData;

  @override
  List<UserProfile> load() => List<UserProfile>.from(seedData);
}
