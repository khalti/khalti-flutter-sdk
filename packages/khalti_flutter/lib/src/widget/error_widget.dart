import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/helper/error_info.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/image.dart';

class KhaltiErrorWidget extends StatelessWidget {
  const KhaltiErrorWidget({
    Key? key,
    required this.error,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final Object error;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final errorInfo = ErrorInfo.from(error);

    final titleStyle = Theme.of(context).textTheme.subtitle1?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 64),
          KhaltiImage.asset(asset: errorInfo.asset, height: 175),
          const SizedBox(height: 40),
          Text(title ?? errorInfo.primary, style: titleStyle),
          const SizedBox(height: 16),
          if (subtitle != null || errorInfo.secondary != null)
            Text(
              subtitle ?? errorInfo.secondary!,
              style: TextStyle(color: KhaltiColor.of(context).surface.shade100),
            ),
        ],
      ),
    );
  }
}
