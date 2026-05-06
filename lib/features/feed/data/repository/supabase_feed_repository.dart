import '../datasource/supabase_feed_datasource.dart';
import '../../domain/entities/post_entity.dart';
import 'feed_repository.dart';

class SupabaseFeedRepository implements FeedRepository {
  final FeedDatasource _datasource;

  SupabaseFeedRepository(this._datasource);

  @override
  Future<List<PostEntity>> getPosts({required int limit, required int offset}) async {
    final models = await _datasource.getPosts(limit: limit, offset: offset);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> toggleLike(String postId) async {
    await _datasource.toggleLike(postId);
  }
}
