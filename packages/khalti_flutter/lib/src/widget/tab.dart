// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';

import 'image.dart';

/// The tab widget.
class KhaltiTab extends StatelessWidget implements PreferredSizeWidget {
  /// Creates [KhaltiTab] with the provided properties.
  const KhaltiTab({
    Key? key,
    required this.label,
    this.iconAsset,
    this.horizontalPadding = 0,
  }) : super(key: key);

  /// The tab [label].
  final String label;

  /// The icon asset name.
  final String? iconAsset;

  /// The horizontal padding for tab.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 8),
      icon: iconAsset == null
          ? null
          : KhaltiImage.asset(asset: iconAsset!, inheritIconTheme: true),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(label.toUpperCase()),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
