import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_intern_work/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/post_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/widgets/like_button.dart';
import 'package:flutter_intern_work/features/feed/presentation/observers/rollback_observer.dart';
import 'package:flutter_intern_work/features/feed/data/mocks/failing_feed_repository.dart';

void main() {
  late PostEntity testPost;

  setUp(() {
    testPost = PostEntity(
      id: '1',
      authorName: 'Test User',
      authorAvatarUrl: '',
      content: 'Test Content',
      mediaThumbUrl: '',
      mediaMobileUrl: '',
      likeCount: 10,
      isLiked: false,
      createdAt: DateTime.now(),
    );
  });

  testWidgets('Offline Rollback: UI rolls back and shows SnackBar on failure', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        observers: [RollbackObserver()],
        overrides: [
          feedRepositoryProvider.overrideWithValue(FailingFeedRepository()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(postProvider('1').notifier).setPost(testPost);
                });
                
                final state = ref.watch(postProvider('1'));
                if (state.post == null) return const SizedBox();
                
                return LikeButton(
                  isLiked: state.post!.isLiked,
                  likesCount: state.post!.likeCount,
                  onTap: () => ref.read(postProvider('1').notifier).toggleLike(),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('10'), findsOneWidget);
    
    // Tap Like
    await tester.tap(find.byType(LikeButton));
    await tester.pump();
    
    // Optimistic update
    expect(find.text('11'), findsOneWidget);
    
    // Advance time for debounce and failure
    await tester.pump(const Duration(milliseconds: 600));
    // Wait for the repo delay + async operation
    await tester.pump(const Duration(milliseconds: 400));
    
    // UI should roll back to 10
    expect(find.text('10'), findsOneWidget);
    
    // Verify SnackBar
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Failed to sync like. Rolling back...'), findsOneWidget);
  });
}
