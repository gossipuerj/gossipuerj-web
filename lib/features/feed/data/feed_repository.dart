import "../../../domain/models/gossip_post.dart";

abstract class FeedRepository {
  List<GossipPost> load();
}

class InMemoryFeedRepository implements FeedRepository {
  const InMemoryFeedRepository(this.seedData);

  final List<GossipPost> seedData;

  @override
  List<GossipPost> load() => List<GossipPost>.from(seedData);
}
