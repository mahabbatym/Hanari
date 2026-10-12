import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Responsive cultural imagery with bundled-first rendering and a persistent
/// cache for remote-only images (for example, user profile avatars).
class CulturalImage extends StatelessWidget {
  const CulturalImage({
    super.key,
    this.assetPath,
    this.imageUrl,
    required this.semanticsLabel,
    required this.fallbackIcon,
    this.width,
    this.height,
    this.aspectRatio = 1,
    this.fit = BoxFit.cover,
    this.circular = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? assetPath;
  final String? imageUrl;
  final String semanticsLabel;
  final IconData fallbackIcon;
  final double? width;
  final double? height;
  final double aspectRatio;
  final BoxFit fit;
  final bool circular;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final image = _image(context);
    final clipped = ClipRRect(
      borderRadius: circular ? BorderRadius.zero : BorderRadius.circular(16),
      child: circular ? ClipOval(child: image) : image,
    );
    final sized = width != null || height != null
        ? SizedBox(width: width, height: height, child: clipped)
        : AspectRatio(aspectRatio: aspectRatio, child: clipped);
    return Semantics(
      image: true,
      label: semanticsLabel,
      child: ExcludeSemantics(child: sized),
    );
  }

  Widget _image(BuildContext context) {
    final asset = assetPath;
    if (asset != null) {
      return Image.asset(
        asset,
        fit: fit,
        cacheWidth: _cacheWidth(context),
        errorBuilder: (context, error, stackTrace) =>
            _networkOrFallback(context),
      );
    }
    return _networkOrFallback(context);
  }

  Widget _networkOrFallback(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) return _fallbackFor(context);
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: _cacheWidth(context),
      placeholder: (context, _) => _loadingFor(context),
      errorWidget: (context, _, _) => _fallbackFor(context),
    );
  }

  Color _backgroundColor(BuildContext context) =>
      backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;

  Color _foregroundColor(BuildContext context) =>
      foregroundColor ?? Theme.of(context).colorScheme.primary;

  int? _cacheWidth(BuildContext context) {
    final requestedWidth = width;
    final logicalWidth = requestedWidth != null && requestedWidth.isFinite
        ? requestedWidth
        : MediaQuery.sizeOf(context).width;
    return (logicalWidth * MediaQuery.devicePixelRatioOf(context)).round();
  }

  Widget _fallbackFor(BuildContext context) => ColoredBox(
    color: _backgroundColor(context),
    child: Center(
      child: Icon(fallbackIcon, color: _foregroundColor(context), size: 36),
    ),
  );

  Widget _loadingFor(BuildContext context) => ColoredBox(
    color: _backgroundColor(context),
    child: Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _foregroundColor(context),
        ),
      ),
    ),
  );
}
