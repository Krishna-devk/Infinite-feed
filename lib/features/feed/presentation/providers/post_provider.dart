import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_intern_work/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';
import 'package:flutter_intern_work/core/errors/optimistic_rollback_exception.dart';

part 'post_provider.g.dart';

class PostState {
  final PostEntity? post;
  final bool isSyncing;

  const PostState({this.post, this.isSyncing = false});

  PostState copyWith({PostEntity? post, bool? isSyncing}) {
    return PostState(
      post: post ?? this.post,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

@Riverpod(keepAlive: true)
class Post extends _$Post {
  int _clickDelta = 0;
  Timer? _debounceTimer;
  PostEntity? _rollbackSnapshot;
  dynamic _keepAliveLink;

  @override
  PostState build(String id) {
    // In Riverpod 3.x, ref.onDispose is used for cleanup
    ref.onDispose(() {
      _debounceTimer?.cancel();
      _keepAliveLink?.close();
    });
    return const PostState();
  }

  void setPost(PostEntity post) {
    state = state.copyWith(post: post);
  }

  void toggleLike() {
    final currentPost = state.post;
    if (currentPost == null) return;

    if (_clickDelta == 0) {
      _rollbackSnapshot = currentPost;
      _keepAliveLink ??= ref.keepAlive();
    }

    _clickDelta++;
    
    final newIsLiked = !currentPost.isLiked;
    final newLikeCount = newIsLiked 
        ? currentPost.likeCount + 1 
        : currentPost.likeCount - 1;

    state = state.copyWith(
      post: currentPost.copyWith(
        isLiked: newIsLiked,
        likeCount: newLikeCount,
      ),
    );

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _syncWithBackend);
  }

  Future<void> _syncWithBackend() async {
    if (_clickDelta % 2 == 0) {
      _cleanup(success: true);
      return;
    }

    state = state.copyWith(isSyncing: true);

    try {
      final repository = ref.read(feedRepositoryProvider);
      await repository.toggleLike(id); // Use 'id' from build argument
      _cleanup(success: true);
    } catch (e) {
      _rollback();
    }
  }

  void _rollback() {
    if (_rollbackSnapshot != null) {
      state = state.copyWith(
        post: _rollbackSnapshot,
        isSyncing: false,
      );
    }
    final errorPostId = id;
    _cleanup(success: false);
    
    throw OptimisticRollbackException(
      message: 'Failed to sync like. Rolling back...',
      postId: errorPostId,
    );
  }

  void _cleanup({required bool success}) {
    _clickDelta = 0;
    _rollbackSnapshot = null;
    state = state.copyWith(isSyncing: false);
    
    _keepAliveLink?.close();
    _keepAliveLink = null;
  }
}
