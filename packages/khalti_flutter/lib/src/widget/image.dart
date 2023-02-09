// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khalti_flutter/src/widget/color.dart';

/// The image widget capable of rendering network images and SVG assets.
abstract class KhaltiImage extends StatelessWidget {
  /// Creates [KhaltiImage].
  const KhaltiImage({
    Key? key,
    this.inheritIconTheme = false,
  }) : super(key: key);

  /// Whether to inherit icon theme for the image or not.
  final bool inheritIconTheme;

  /// Creates [KhaltiImage] from SVG assets.
  const factory KhaltiImage.asset({
    Key? key,
    required String asset,
    double? height,
    bool inheritIconTheme,
  }) = _AssetSVGImage;

  /// Creates [KhaltiImage] from network image urls.
  const factory KhaltiImage.network({
    Key? key,
    required String url,
    double? height,
    bool inheritIconTheme,
  }) = _NetworkImage;

  Color? _imageColor(BuildContext context) {
    return inheritIconTheme ? IconTheme.of(context).color : null;
  }
}

class _AssetSVGImage extends KhaltiImage {
  const _AssetSVGImage({
    Key? key,
    required this.asset,
    this.height,
    bool inheritIconTheme = false,
  }) : super(key: key, inheritIconTheme: inheritIconTheme);

  final String asset;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final color = _imageColor(context);

    return SvgPicture.asset(
      'assets/$asset',
      package: 'khalti_flutter',
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
      height: height,
    );
  }
}

class _NetworkImage extends KhaltiImage {
  const _NetworkImage({
    Key? key,
    required this.url,
    this.height,
    bool inheritIconTheme = false,
  }) : super(key: key, inheritIconTheme: inheritIconTheme);

  final String url;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final khaltiColor = KhaltiColor.of(context);

    return Image.network(
      url,
      color: _imageColor(context),
      height: height,
      loadingBuilder: (_, child, chunkEvent) {
        if (chunkEvent == null) return child;

        return Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              color: khaltiColor.surface[10],
              backgroundColor: khaltiColor.surface[5],
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}
