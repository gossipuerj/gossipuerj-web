import "package:dio/dio.dart";

class FeedRemoteDataSource {
  FeedRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getPosts({
    String? category,
    int page = 0,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      "/api/v1/posts",
      queryParameters: {
        "category": category,
        "page": page,
        "pageSize": pageSize,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    final response = await _dio.post(
      "/api/v1/posts",
      data: {"title": title, "content": content, "category": category},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deletePost(String postId) async {
    await _dio.delete("/api/v1/posts/$postId");
  }

  Future<void> likePost(String postId) async {
    await _dio.post("/api/v1/posts/$postId/likes");
  }

  Future<void> unlikePost(String postId) async {
    await _dio.delete("/api/v1/posts/$postId/likes");
  }

  Future<Map<String, dynamic>> getComments(
    String postId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      "/api/v1/posts/$postId/comments",
      queryParameters: {"page": page, "pageSize": pageSize},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createComment({
    required String postId,
    required String content,
  }) async {
    final response = await _dio.post(
      "/api/v1/posts/$postId/comments",
      data: {"content": content},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    await _dio.delete("/api/v1/posts/$postId/comments/$commentId");
  }
}
