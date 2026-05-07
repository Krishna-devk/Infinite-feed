import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;

import '../providers/feed_provider.dart';
import '../providers/post_provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const PostDetailScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    final postIds = feedState.postIds;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: postIds.length,
        onPageChanged: (index) {
          // Trigger infinite scroll in detail view
          if (index >= postIds.length - 3) {
            ref.read(feedProvider.notifier).fetchNextPage();
          }
        },
        itemBuilder: (context, index) {
          return _PostDetailPage(postId: postIds[index], index: index);
        },
      ),
    );
  }
}

/// Individual page for a single post in the swipeable detail view.
class _PostDetailPage extends ConsumerStatefulWidget {
  final String postId;
  final int index;
  const _PostDetailPage({required this.postId, required this.index});

  @override
  ConsumerState<_PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<_PostDetailPage> {
  bool _isPopping = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final post = ref.read(postProvider(widget.postId)).post;
    if (post != null) {
      precacheImage(CachedNetworkImageProvider(post.mediaMobileUrl), context);
      precacheImage(CachedNetworkImageProvider(post.mediaThumbUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postProvider(widget.postId));
    final post = postState.post;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (post == null) return const ColoredBox(color: Colors.black);

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF0F0F8),
      body: Stack(
        children: [
          // ── Background: blurred version of the image ──
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: CachedNetworkImage(
                imageUrl: post.mediaThumbUrl,
                fit: BoxFit.cover,
                // Use memory cache — avoids the reload/blur on swipe
                memCacheWidth: 200,
                fadeInDuration: Duration.zero, // No fade = no blur transition
                fadeOutDuration: Duration.zero,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.55),
            ),
          ),

          // ── Scrollable Content ──
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              // Swipe down to dismiss: when pulled down beyond -60 pixels
              if (notification.metrics.pixels < -60 && !_isPopping) {
                _isPopping = true;
                Navigator.of(context).pop();
                return true;
              }
              return false;
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
              SliverAppBar(
                expandedHeight: screenHeight * 0.52,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Hero thumbnail (instant from feed cache)
                      Hero(
                        tag: 'post_image_${widget.index}_${post.id}',
                        child: CachedNetworkImage(
                          imageUrl: post.mediaThumbUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                        ),
                      ),
                      // Mobile-res overlay (pre-cached, loads instantly)
                      CachedNetworkImage(
                        imageUrl: post.mediaMobileUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: Duration.zero,
                        placeholder: (context, url) => const SizedBox.shrink(),
                      ),
                      // Bottom gradient
                      Positioned(
                        bottom: -1,
                        left: 0,
                        right: 0,
                        height: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                                Colors.black.withValues(alpha: 0.95),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Glassmorphic Info Card ──
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.white.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.white.withValues(alpha: 0.9),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Author + Like
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.secondary,
                                          ],
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(post.authorAvatarUrl),
                                        radius: 24,
                                        backgroundColor: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.authorName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.3,
                                              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _formatDate(post.createdAt),
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white54
                                                  : Colors.black45,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _LikeButton(postId: widget.postId),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Divider
                                Divider(
                                  color: isDark ? Colors.white12 : Colors.black12,
                                  height: 1,
                                ),
                                const SizedBox(height: 20),
                                // Content
                                Text(
                                  post.content,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.65,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.88)
                                        : const Color(0xFF2A2A3E),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (post.mediaRawUrl != null) ...[
                                  const SizedBox(height: 32),
                                  _DownloadButton(url: post.mediaRawUrl!),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }
}

// ── Animated Like Button ──────────────────────────────────────────────────────

class _LikeButton extends ConsumerWidget {
  final String postId;
  const _LikeButton({required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postProvider(postId));
    final post = postState.post;
    if (post == null) return const SizedBox.shrink();

    final isLiked = post.isLiked;

    return GestureDetector(
      onTap: () => ref.read(postProvider(postId).notifier).toggleLike(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isLiked
              ? Colors.redAccent.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: isLiked ? Colors.redAccent : Colors.white30,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isLiked),
                color: isLiked ? Colors.redAccent : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${post.likeCount}',
              style: TextStyle(
                color: isLiked ? Colors.redAccent : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Download Button ───────────────────────────────────────────────────────────

class _DownloadButton extends StatefulWidget {
  final String url;
  const _DownloadButton({required this.url});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isDownloading = false;

  Future<void> _downloadAndSave() async {
    setState(() => _isDownloading = true);
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) throw Exception('Failed to fetch image');
      await Gal.putImageBytes(response.bodyBytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Saved to gallery!'),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(
              label: 'VIEW',
              textColor: Colors.white,
              onPressed: () => Gal.open(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: _isDownloading ? null : _downloadAndSave,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isDownloading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        key: ValueKey('label'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Save to Gallery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
