import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/post_provider.dart';
import 'like_button.dart';
import 'post_image.dart';

class PostCard extends ConsumerWidget {
  final String postId;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.postId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postProvider(postId));
    final post = postState.post;

    if (post == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // 1. Isolated RepaintBoundary for expensive shadow
          const RepaintBoundary(
            child: _CardShadow(),
          ),

          // 2. Main content with glassmorphism
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PostHeader(post: post),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: PostImage(
                          imageUrl: post.mediaThumbUrl,
                          heroTag: 'post_image_${post.id}',
                        ),
                      ),
                      _PostContent(post: post),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: LikeButton(
                          isLiked: post.isLiked,
                          likesCount: post.likeCount,
                          isSyncing: postState.isSyncing,
                          onTap: () => ref
                              .read(postProvider(postId).notifier)
                              .toggleLike(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShadow extends StatelessWidget {
  const _CardShadow();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      margin: const EdgeInsets.all(4),
      height: 380, // Approximate height
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostEntity post;
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(post.authorAvatarUrl),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Text(
            post.authorName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostContent extends StatelessWidget {
  final PostEntity post;
  const _PostContent({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        post.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, color: Colors.white70),
      ),
    );
  }
}
