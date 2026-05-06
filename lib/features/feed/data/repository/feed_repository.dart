import '../../domain/entities/post_entity.dart';

abstract class FeedRepository {
  Future<List<PostEntity>> getPosts({required int limit, required int offset});
  Future<void> toggleLike(String postId);
}
