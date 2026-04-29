import "gossip_comment.dart";

class GossipPost {
  const GossipPost({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.category,
    required this.authorId,
    this.target,
    this.imageUrl,
    this.isFollowing = false,
    this.comments = const [],
  });

  final String id;
  final String content;
  final DateTime timestamp;
  final String category;
  final String authorId;
  final String? target;
  final String? imageUrl;
  final bool isFollowing;
  final List<GossipComment> comments;

  GossipPost copyWith({
    String? content,
    DateTime? timestamp,
    String? category,
    String? target,
    String? imageUrl,
    bool? isFollowing,
    List<GossipComment>? comments,
  }) {
    return GossipPost(
      id: id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      authorId: authorId,
      target: target ?? this.target,
      imageUrl: imageUrl ?? this.imageUrl,
      isFollowing: isFollowing ?? this.isFollowing,
      comments: comments ?? this.comments,
    );
  }
}
