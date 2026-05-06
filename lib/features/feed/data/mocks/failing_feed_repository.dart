import 'dart:io';
import '../../domain/entities/post_entity.dart';
import '../repository/feed_repository.dart';

class FailingFeedRepository implements FeedRepository {
  @override
  Future<List<PostEntity>> getPosts({required int limit, required int offset}) async {
    throw const SocketException('No Internet Connection');
  }

  @override
  Future<void> toggleLike(String postId) async {
    // Delay to simulate network latency
    await Future.delayed(const Duration(milliseconds: 300));
    throw const SocketException('Network timeout');
  }
}
