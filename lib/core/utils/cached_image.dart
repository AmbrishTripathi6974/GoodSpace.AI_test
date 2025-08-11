import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final bool useLowResForFeed;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.useLowResForFeed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      debugPrint("CachedImage: Empty URL");
      return _buildPlaceholder();
    }

    final uri = Uri.tryParse(imageUrl!);
    if (uri == null || !uri.hasScheme) {
      debugPrint("CachedImage: Invalid URL -> $imageUrl");
      return _buildError();
    }

    final displayUrl = useLowResForFeed ? _getLowResUrl(imageUrl!) : imageUrl!;

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: displayUrl,
        memCacheHeight: _safeCacheSize(height),
        memCacheWidth: _safeCacheSize(width),
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (_, __) => _buildLoading(),
        errorWidget: (_, __, ___) => _buildError(),
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
      ),
    );
  }

  int? _safeCacheSize(double? size) {
    if (size == null || size.isNaN || size.isInfinite) return null;
    return size.floor(); // ensures a valid int
  }

  String _getLowResUrl(String url) {
    try {
      if (url.contains("firebasestorage.googleapis.com")) {
        return "$url&alt=media";
      }
    } catch (_) {}
    return url;
  }

  Widget _buildLoading() => Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );

  Widget _buildError() => Container(
        height: height,
        width: width,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );

  Widget _buildPlaceholder() => Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.image, color: Colors.grey),
      );
}
