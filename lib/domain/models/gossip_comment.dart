class GossipComment {
  const GossipComment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.authorId,
  });

  final String id;
  final String content;
  final DateTime createdAt;
  final String? authorId;

  GossipComment copyWith({
    String? content,
    DateTime? createdAt,
    String? authorId,
  }) {
    return GossipComment(
      id: id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
    );
  }
}
