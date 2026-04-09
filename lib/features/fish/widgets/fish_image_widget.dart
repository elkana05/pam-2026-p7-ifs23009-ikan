import 'dart:typed_data';

import 'package:flutter/material.dart';

class FishImageWidget extends StatelessWidget {
  const FishImageWidget({
    super.key,
    required this.imagePath,
    this.imageBytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imagePath;
  final Uint8List? imageBytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget image;
    if (imageBytes != null) {
      image = Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            _ImageFallback(width: width, height: height),
      );
    } else {
      image = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            _ImageFallback(width: width, height: height),
      );
    }

    if (borderRadius == null) return image;

    return ClipRRect(
      borderRadius: borderRadius!,
      child: ColoredBox(color: colorScheme.primaryContainer, child: image),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      color: colorScheme.primaryContainer,
      child: Icon(Icons.set_meal, color: colorScheme.primary, size: 36),
    );
  }
}
