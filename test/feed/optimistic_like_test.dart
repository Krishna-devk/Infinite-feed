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

  testWidgets('Optimistic Like: UI updates immediately before backend call', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          feedRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) {
                // Initialize post
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

    await tester.pump(); // Let post be set
    await tester.pump(); // Render LikeButton

    expect(find.text('10'), findsOneWidget);
    
    // Tap Like
    await tester.tap(find.byType(LikeButton));
    
    // UI should update immediately
    await tester.pump();
    expect(find.text('11'), findsOneWidget);
    
    // Verify repository NOT called yet (due to debounce)
    verifyNever(() => mockRepository.toggleLike('1'));
    
    // Advance time for debounce
    await tester.pump(const Duration(milliseconds: 600));
    
    // Verify repository called
    verify(() => mockRepository.toggleLike('1')).called(1);
  });
}
