class GossipComment {
  const GossipComment({
    required this.id,
    required this.text,
    required this.author,
    this.authorId,
  });

  final String id;
  final String text;
  final String author;
  final String? authorId;
}
