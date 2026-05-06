import "../../../../domain/models/gossip_post.dart";

class GossipPostResponseDto {
  const GossipPostResponseDto({
    required this.id,
    required this.title,
    required this.authorId,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.likesCount,
  });

  final String id;
  final String title;
  final String? authorId;
  final String content;
  final String category;
  final DateTime createdAt;
  final int likesCount;

  factory GossipPostResponseDto.fromJson(Map<String, dynamic> json) {
    return GossipPostResponseDto(
      id: json["id"].toString(),
      title: json["title"]?.toString() ?? "",
      authorId: json["authorId"]?.toString(),
      content: json["content"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "GOSSIP",
      createdAt: DateTime.parse(json["createAt"].toString()).toLocal(),
      likesCount: (json["likesCount"] as num?)?.toInt() ?? 0,
    );
  }

  GossipPost toDomain() {
    return GossipPost(
      id: id,
      title: title,
      content: content,
      timestamp: createdAt,
      category: category,
      authorId: authorId,
      likesCount: likesCount,
      comments: const [],
    );
  }
}
