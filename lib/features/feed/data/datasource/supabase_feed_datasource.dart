import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

abstract class FeedDatasource {
  Future<List<PostModel>> getPosts({required int limit, required int offset});
  Future<void> toggleLike(String postId);
}

class SupabaseFeedDatasource implements FeedDatasource {
  final SupabaseClient _client;

  SupabaseFeedDatasource(this._client);

  @override
  Future<List<PostModel>> getPosts({required int limit, required int offset}) async {
    final response = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((json) => PostModel.fromJson(json)).toList();
  }

  @override
  Future<void> toggleLike(String postId) async {
    final userId = _client.auth.currentUser?.id ?? 'test_user_123';

    await _client.rpc('toggle_like', params: {
      'p_post_id': postId,
      'p_user_id': userId,
    });
  }
}
