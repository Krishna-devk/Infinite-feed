import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_work/core/utils/device_utils.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final bool isThumbnail;
  final BoxFit fit;

  const PostImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.isThumbnail = true,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final cacheWidth = isThumbnail ? DeviceUtils.getCacheWidth(context) : null;

    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        // Animate the RAM-cached thumbnail during flight
        return fromHeroContext.widget;
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        memCacheWidth: cacheWidth,
        fit: fit,
        placeholder: (context, url) => Container(
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
