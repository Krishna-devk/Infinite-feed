import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int likesCount;
  final VoidCallback onTap;
  final bool isSyncing;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.likesCount,
    required this.onTap,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(isLiked),
              color: isLiked ? Colors.redAccent : Colors.white70,
              size: 26,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            likesCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isSyncing) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
