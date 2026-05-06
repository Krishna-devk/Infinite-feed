import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_intern_work/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/post_provider.dart';
import 'package:flutter_intern_work/features/feed/presentation/widgets/like_button.dart';
import 'mocks.dart';

void main() {
  late MockFeedRepository mockRepository;
  late PostEntity testPost;

  setUp(() {
    mockRepository = MockFeedRepository();
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
    
    registerFallbackValue(testPost.id);
    when(() => mockRepository.toggleLike(any())).thenAnswer((_) async {});
  });

  testWidgets('Spam Click: Rapidly tapping 5 times calls backend exactly ONCE', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          feedRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
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

    // Tap 5 times rapidly
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byType(LikeButton));
      await tester.pump(); // Update UI
    }
    
    // UI should show liked state (10 + 1 because net delta is odd)
    expect(find.text('11'), findsOneWidget);
    
    // Advance time for debounce
    await tester.pump(const Duration(milliseconds: 600));
    
    // Verify backend called exactly ONCE
    verify(() => mockRepository.toggleLike('1')).called(1);
  });

  testWidgets('Spam Click: Rapidly tapping 4 times calls backend ZERO times', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          feedRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
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

    // Tap 4 times rapidly
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.byType(LikeButton));
      await tester.pump();
    }
    
    // UI should show original state (10 because net delta is even)
    expect(find.text('10'), findsOneWidget);
    
    // Advance time for debounce
    await tester.pump(const Duration(milliseconds: 600));
    
    // Verify backend NOT called
    verifyNever(() => mockRepository.toggleLike('1'));
  });
}
