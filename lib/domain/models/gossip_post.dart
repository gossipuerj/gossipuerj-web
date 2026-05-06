import "gossip_comment.dart";

class GossipPost {
  const GossipPost({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.category,
    this.authorId,
    this.likesCount = 0,
    this.imageUrl,
    this.comments = const [],
  });

  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final String category;
  final String? authorId;
  final int likesCount;
  final String? imageUrl;
  final List<GossipComment> comments;

  GossipPost copyWith({
    String? title,
    String? content,
    DateTime? timestamp,
    String? category,
    String? authorId,
    int? likesCount,
    String? imageUrl,
    List<GossipComment>? comments,
  }) {
    return GossipPost(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      likesCount: likesCount ?? this.likesCount,
      imageUrl: imageUrl ?? this.imageUrl,
      comments: comments ?? this.comments,
    );
  }
}
