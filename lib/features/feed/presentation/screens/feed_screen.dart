import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/feed_provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/post_card.dart';
import 'post_detail_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedProvider.notifier).fetchNextPage();
    });
  }

  void _onScroll() {
    // We are now using index-based loading in the ListView.builder
    // for more precise "last 5th post" logic.
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(syncServiceProvider);
    final feedState = ref.watch(feedProvider);
    final isDark = ref.watch(appThemeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FEED',
          style: TextStyle(
            letterSpacing: 6,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 150, 30)),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.colorScheme.primary),
            tooltip: 'Refresh Feed',
            onPressed: () => ref.read(feedProvider.notifier).refresh(),
          ),
          // 🌗 Dark/Light mode toggle
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: IconButton(
                key: ValueKey(isDark),
                icon: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: isDark ? Colors.amber : theme.colorScheme.primary,
                ),
                tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                onPressed: () =>
                    ref.read(appThemeModeProvider.notifier).toggle(),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context, feedState, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    FeedState feedState,
    ThemeData theme,
  ) {
    if (feedState.postIds.isEmpty) {
      if (feedState.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        );
      }

      if (feedState.errorMessage != null) {
        final errorText = feedState.errorMessage!.toLowerCase();
        final isOffline =
            errorText.contains('network') ||
            errorText.contains('socket') ||
            errorText.contains('connection');

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOffline
                      ? Icons.wifi_off_rounded
                      : Icons.error_outline_rounded,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  isOffline ? 'Connection Error' : 'Error',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOffline
                      ? 'No cached posts available. Please check your connection.'
                      : 'Something went wrong. Please try again.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref.read(feedProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 56,
              color: theme.hintColor,
            ),
            const SizedBox(height: 16),
            const Text('No posts found.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref.read(feedProvider.notifier).refresh(),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: theme.colorScheme.primary,
      onRefresh: () => ref.read(feedProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: feedState.postIds.length + (feedState.hasMore ? 1 : 0),
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemBuilder: (context, index) {
          if (index == feedState.postIds.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          }

          final postId = feedState.postIds[index];

          // Trigger loading when reaching the last 5th post
          if (index == feedState.postIds.length - 5 &&
              !feedState.isLoading &&
              feedState.hasMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(feedProvider.notifier).fetchNextPage();
            });
          }

          return PostCard(
            key: ValueKey('post_${index}_$postId'), // Unique key for each instance
            postId: postId,
            index: index, // Pass index for unique Hero tags
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(initialIndex: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
