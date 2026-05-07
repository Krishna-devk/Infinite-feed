import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/post_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_intern_work/features/feed/data/models/post_model.dart';

part 'feed_provider.g.dart';

class FeedState extends Equatable {
  final List<String> postIds;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;

  const FeedState({
    required this.postIds,
    required this.isLoading,
    required this.hasMore,
    this.errorMessage,
  });

  const FeedState.initial()
      : postIds = const [],
        isLoading = false,
        hasMore = true,
        errorMessage = null;

  FeedState copyWith({
    List<String>? postIds,
    bool? isLoading,
    bool? hasMore,
    String? errorMessage,
  }) {
    return FeedState(
      postIds: postIds ?? this.postIds,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        postIds,
        isLoading,
        hasMore,
        errorMessage,
      ];
}

@Riverpod(keepAlive: true)
class Feed extends _$Feed {
  /// Number of posts shown per batch
  static const int _batchSize = 10;

  /// Stable randomized queue
  List<String> _feedQueue = [];

  /// Current reading position inside queue
  int _queueIndex = 0;

  @override
  FeedState build() {
    return const FeedState.initial();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      /// 1. Initial Load: Load all posts only if queue is empty
      if (_feedQueue.isEmpty) {
        final repository = ref.read(feedRepositoryProvider);
        final posts = await repository.getPosts(
          limit: 100,
          offset: 0,
        );

        final cacheBox = Hive.box('posts_cache');
        for (final post in posts) {
          cacheBox.put(
            post.id,
            PostModel.fromEntity(post).toJson(),
          );
          ref.read(postProvider(post.id).notifier).setPost(post);
        }

        _feedQueue = posts.map<String>((e) => e.id).toList();
        _queueIndex = 0;
      }
      /// 2. Reset index after full exhaustion for circularity
      else if (_queueIndex >= _feedQueue.length) {
        _queueIndex = 0;
      }

      /// 3. Serve sequential batch from circular queue
      final List<String> nextBatch = [];
      while (nextBatch.length < _batchSize && _feedQueue.isNotEmpty) {
        final remainingInQueue = _feedQueue.length - _queueIndex;
        final toTake = min(_batchSize - nextBatch.length, remainingInQueue);
        
        nextBatch.addAll(_feedQueue.skip(_queueIndex).take(toTake));
        _queueIndex += toTake;

        if (_queueIndex >= _feedQueue.length) {
          _queueIndex = 0; // Wrap around
        }
      }

      state = state.copyWith(
        postIds: [...state.postIds, ...nextBatch],
        isLoading: false,
        hasMore: true,
      );
    } catch (e) {
      /// Offline fallback
      if (state.postIds.isEmpty) {
        final cacheBox = Hive.box('posts_cache');

        if (cacheBox.isNotEmpty) {
          final cachedIds = cacheBox.keys
              .cast<String>()
              .toList();

          final selectedIds = cachedIds
              .take(_batchSize)
              .toList();

          for (final id in selectedIds) {
            final json = Map<String, dynamic>.from(
              cacheBox.get(id),
            );

            final post = PostModel
                .fromJson(json)
                .toEntity();

            ref
                .read(postProvider(id).notifier)
                .setPost(post);
          }

          state = state.copyWith(
            postIds: selectedIds,
            isLoading: false,
            hasMore: true,
          );

          return;
        }
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    /// Reset queue completely
    _feedQueue.clear();
    _queueIndex = 0;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      postIds: [], // Clear existing posts on refresh
    );

    await fetchNextPage();
  }
}