import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/post_provider.dart';

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
  List<Object?> get props => [postIds, isLoading, hasMore, errorMessage];
}

@Riverpod(keepAlive: true)
class Feed extends _$Feed {
  int _currentOffset = 0;
  static const int _pageSize = 10;

  @override
  FeedState build() => const FeedState.initial();

  Future<void> fetchNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(feedRepositoryProvider);
      final posts = await repository.getPosts(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (posts.isEmpty && _currentOffset > 0) {
        // We reached the absolute end of the DB, loop back to start
        _currentOffset = 0;
        state = state.copyWith(isLoading: false);
        return fetchNextPage();
      }

      // Shuffle for randomness
      final shuffledPosts = List<dynamic>.from(posts)..shuffle();

      // Update individual post providers
      for (final post in shuffledPosts) {
        ref.read(postProvider(post.id).notifier).setPost(post);
      }

      state = state.copyWith(
        postIds: [...state.postIds, ...shuffledPosts.map((e) => e.id)],
        isLoading: false,
        hasMore: true, // Always true for infinite looping
      );

      // Advance offset or loop back
      if (posts.length < _pageSize) {
        _currentOffset = 0;
      } else {
        _currentOffset += _pageSize;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    _currentOffset = 0;
    state = const FeedState.initial();
    await fetchNextPage();
  }
}
