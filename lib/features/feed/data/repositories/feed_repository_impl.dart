import "../../../../core/error/error_mapper.dart";
import "../../../../domain/models/gossip_comment.dart";
import "../../../../domain/models/gossip_post.dart";
import "../datasources/feed_remote_data_source.dart";
import "../dtos/feed_page_response_dto.dart";
import "../dtos/gossip_comment_response_dto.dart";
import "../dtos/gossip_post_response_dto.dart";
import "../feed_repository.dart";
import "../models/feed_posts_page.dart";

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final FeedRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  Future<GossipComment> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      final json = await _remoteDataSource.createComment(
        postId: postId,
        content: content,
      );
      return GossipCommentResponseDto.fromJson(json).toDomain();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<GossipPost> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    try {
      final json = await _remoteDataSource.createPost(
        title: title,
        content: content,
        category: category,
      );
      return GossipPostResponseDto.fromJson(json).toDomain();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _remoteDataSource.deleteComment(postId: postId, commentId: commentId);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _remoteDataSource.deletePost(postId);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      await _remoteDataSource.likePost(postId);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<FeedPostsPage> load({
    String? category,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final json = await _remoteDataSource.getPosts(
        category: category,
        page: page,
        pageSize: pageSize,
      );
      final pageData = FeedPageResponseDto.fromJson(
        json,
        GossipPostResponseDto.fromJson,
      );
      final posts = pageData.content.map((item) => item.toDomain()).toList();
      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return FeedPostsPage(
        posts: posts,
        page: pageData.page,
        totalPages: pageData.totalPages,
        totalElements: pageData.totalElements,
      );
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<List<GossipComment>> loadComments(
    String postId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final json = await _remoteDataSource.getComments(
        postId,
        page: page,
        pageSize: pageSize,
      );
      final pageData = FeedPageResponseDto.fromJson(
        json,
        GossipCommentResponseDto.fromJson,
      );
      final comments = pageData.content.map((item) => item.toDomain()).toList();
      comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return comments;
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    try {
      await _remoteDataSource.unlikePost(postId);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }
}
