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
      debugPrint("CachedImage: No URL provided");
      return _buildPlaceholder();
    }

    final displayUrl = useLowResForFeed ? _getLowResUrl(imageUrl!) : imageUrl!;

    debugPrint("CachedImage: Loading from URL -> $displayUrl");

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: displayUrl,
        height: height,
        width: width,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholderFadeInDuration: const Duration(milliseconds: 200),
        placeholder: (context, url) {
          debugPrint("CachedImage: Showing placeholder for $url");
          return _buildLoading();
        },
        errorWidget: (context, url, error) {
          debugPrint("CachedImage: Error loading $url -> $error");
          return _buildError();
        },
      ),
    );
  }

  String _getLowResUrl(String originalUrl) {
    // You could modify this if your storage supports low-res variants
    return originalUrl;
  }

  Widget _buildLoading() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
