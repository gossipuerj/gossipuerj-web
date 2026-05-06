import "../../../../domain/models/gossip_post.dart";

class FeedPostsPage {
  const FeedPostsPage({
    required this.posts,
    required this.page,
    required this.totalPages,
    required this.totalElements,
  });

  final List<GossipPost> posts;
  final int page;
  final int totalPages;
  final int totalElements;

  bool get hasMore => page + 1 < totalPages;
}
