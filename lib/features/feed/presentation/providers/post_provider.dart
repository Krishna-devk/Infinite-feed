import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_intern_work/core/errors/optimistic_rollback_exception.dart';
import 'package:flutter_intern_work/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/posts_store_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/sync_provider.dart';
import 'package:equatable/equatable.dart';

part 'post_provider.g.dart';

class PostState extends Equatable {
  final PostEntity? post;
  final bool isSyncing;

  const PostState({
    this.post,
    this.isSyncing = false,
  });

  PostState copyWith({
    PostEntity? post,
    bool? isSyncing,
  }) {
    return PostState(
      post: post ?? this.post,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  @override
  List<Object?> get props => [
        post,
        isSyncing,
      ];
}

@Riverpod(keepAlive: true)
class Post extends _$Post {
  Timer? _debounceTimer;

  int _clickDelta = 0;

  PostEntity? _rollbackSnapshot;

  dynamic _keepAliveLink;

  @override
  PostState build(String id) {
    // Watch the global store to react to any post updates
    final posts = ref.watch(postsStoreProvider);
    final post = posts[id];

    // Preserve isSyncing state when the global store updates
    final wasSyncing = stateOrNull?.isSyncing ?? false;

    ref.onDispose(() {
      _debounceTimer?.cancel();
      _keepAliveLink?.close();
    });

    return PostState(post: post, isSyncing: wasSyncing);
  }

  /// Inject/update post globally
  void setPost(PostEntity post) {
    ref
        .read(postsStoreProvider.notifier)
        .setPost(post);
  }

  /// Optimistic like toggle
  void toggleLike() {
    final currentPost = state.post;

    if (currentPost == null) return;

    if (_clickDelta == 0) {
      _rollbackSnapshot = currentPost;
      _keepAliveLink ??= ref.keepAlive();
    }

    _clickDelta++;

    final updatedPost = currentPost.copyWith(
      isLiked: !currentPost.isLiked,
      likeCount: currentPost.isLiked
          ? currentPost.likeCount - 1
          : currentPost.likeCount + 1,
    );

    /// GLOBAL IMMUTABLE UPDATE
    /// This updates the shared store. Since every Post provider watches this store,
    /// all instances (including those with different IDs but same content) will update.
    ref.read(postsStoreProvider.notifier).updatePost(updatedPost);

    _debounceTimer?.cancel();

    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      _syncWithBackend,
    );
  }

  Future<void> _syncWithBackend() async {
    // If the user toggled the like an even number of times, the final state is unchanged.
    // We avoid an unnecessary network request.
    if (_clickDelta % 2 == 0) {
      _cleanup();
      return;
    }

    state = state.copyWith(isSyncing: true);

    try {
      final repository = ref.read(
        feedRepositoryProvider,
      );

      // The backend toggle_like RPC should be idempotent per user/post.
      await repository.toggleLike(id);

      _cleanup();
    } catch (e) {
      final error =
          e.toString().toLowerCase();

      /// Offline support
      if (error.contains('socket') ||
          error.contains('network') ||
          error.contains('connection')) {
        ref
            .read(syncServiceProvider.notifier)
            .queueAction(id);

        _cleanup();
        return;
      }

      _rollback();
    }
  }

  void _rollback() {
    if (_rollbackSnapshot != null) {
      ref
          .read(postsStoreProvider.notifier)
          .updatePost(_rollbackSnapshot!);
    }

    state = state.copyWith(isSyncing: false);

    final errorPostId = id;

    _cleanup();

    throw OptimisticRollbackException(
      message:
          'Failed to sync like. Rolling back...',
      postId: errorPostId,
    );
  }

  void _cleanup() {
    _clickDelta = 0;
    _rollbackSnapshot = null;

    state = state.copyWith(isSyncing: false);

    _keepAliveLink?.close();
    _keepAliveLink = null;
  }
}