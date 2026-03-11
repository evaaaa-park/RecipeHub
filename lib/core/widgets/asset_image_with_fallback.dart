import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipehub/core/constants/app_assets.dart';

class AssetImageWithFallback extends StatefulWidget {
  const AssetImageWithFallback({
    super.key,
    required this.imageName,
    this.height = 220,
    this.fit = BoxFit.cover,
  });

  final String imageName;
  final double height;
  final BoxFit fit;

  @override
  State<AssetImageWithFallback> createState() => _AssetImageWithFallbackState();
}

class _AssetImageWithFallbackState extends State<AssetImageWithFallback> {
  late Future<String?> _assetFuture;

  @override
  void initState() {
    super.initState();
    _assetFuture = _resolveAssetPath();
  }

  @override
  void didUpdateWidget(covariant AssetImageWithFallback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageName != widget.imageName) {
      _assetFuture = _resolveAssetPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _assetFuture,
      builder: (context, snapshot) {
        final String? resolvedPath = snapshot.data;
        if (resolvedPath == null) {
          return _fallback();
        }
        return Image.asset(
          resolvedPath,
          height: widget.height,
          width: double.infinity,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => _fallback(),
        );
      },
    );
  }

  Future<String?> _resolveAssetPath() async {
    final String trimmed = widget.imageName.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final List<String> candidates = <String>[
      if (trimmed.endsWith('.jpg')) '${AppAssets.imageDirectory}$trimmed',
      if (!trimmed.endsWith('.jpg')) '${AppAssets.imageDirectory}$trimmed.jpg',
      '${AppAssets.imageDirectory}$trimmed',
    ];

    for (final String path in candidates) {
      if (await _assetExists(path)) {
        return path;
      }
    }
    return null;
  }

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Widget _fallback() {
    return Container(
      height: widget.height,
      color: Colors.black12,
      alignment: Alignment.center,
      child: const Text('Image unavailable'),
    );
  }
}
