import 'package:flutter/material.dart';

import 'image.dart';

class KhaltiTab extends StatelessWidget implements PreferredSizeWidget {
  const KhaltiTab({
    Key? key,
    required this.label,
    this.iconAsset,
    this.horizontalPadding = 0,
  }) : super(key: key);

  final String label;
  final String? iconAsset;
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
