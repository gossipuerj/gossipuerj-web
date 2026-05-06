class FeedPageResponseDto<T> {
  const FeedPageResponseDto({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  static FeedPageResponseDto<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    final rawContent = json["content"] as List<dynamic>? ?? const [];
    return FeedPageResponseDto<T>(
      content: rawContent
          .whereType<Map<String, dynamic>>()
          .map(itemFromJson)
          .toList(),
      page: (json["page"] as num?)?.toInt() ?? 0,
      size: (json["size"] as num?)?.toInt() ?? 0,
      totalElements: (json["totalElements"] as num?)?.toInt() ?? 0,
      totalPages: (json["totalPages"] as num?)?.toInt() ?? 0,
    );
  }
}
