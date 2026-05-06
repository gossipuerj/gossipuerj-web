import "../../../../domain/models/gossip_comment.dart";

class GossipCommentResponseDto {
  const GossipCommentResponseDto({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String? authorId;
  final String content;
  final DateTime createdAt;

  factory GossipCommentResponseDto.fromJson(Map<String, dynamic> json) {
    return GossipCommentResponseDto(
      id: json["id"].toString(),
      authorId: json["authorId"]?.toString(),
      content: json["content"]?.toString() ?? "",
      createdAt: DateTime.parse(json["createAt"].toString()).toLocal(),
    );
  }

  GossipComment toDomain() {
    return GossipComment(
      id: id,
      content: content,
      createdAt: createdAt,
      authorId: authorId,
    );
  }
}
