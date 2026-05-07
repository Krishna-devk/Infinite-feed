import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_intern_work/features/feed/domain/entities/post_entity.dart';

part 'posts_store_provider.g.dart';

@Riverpod(keepAlive: true)
class PostsStore extends _$PostsStore {
  @override
  Map<String, PostEntity> build() {
    return {};
  }

  void setPost(PostEntity post) {
    if (state.containsKey(post.id)) return;

    // Check if we already have a similar post in the store (same image or content)
    // This ensures that even with different IDs, they inherit the session state.
    PostEntity postToAdd = post;
    final similarPost = state.values.where((p) => 
      p.mediaThumbUrl == post.mediaThumbUrl
    ).firstOrNull;

    if (similarPost != null) {
      postToAdd = post.copyWith(
        isLiked: similarPost.isLiked,
        likeCount: similarPost.likeCount,
      );
    }

    state = {
      ...state,
      post.id: postToAdd,
    };
  }

  void updatePost(PostEntity post) {
    // Update all posts in the store that share the same media URL
    // to ensure "similar" posts stay in sync.
    final newState = Map<String, PostEntity>.from(state);
    
    newState.forEach((id, existingPost) {
      // Match ONLY by image URL to ensure unique posts with same text stay separate
      if (existingPost.mediaThumbUrl == post.mediaThumbUrl) {
        newState[id] = existingPost.copyWith(
          isLiked: post.isLiked,
          likeCount: post.likeCount,
        );
      }
    });

    // Ensure the specific post being updated is also set (just in case of ID mismatch)
    newState[post.id] = post;
    
    state = newState;
  }
}