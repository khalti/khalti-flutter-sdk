// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/helper/error_info.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/image.dart';

/// The widget to show error with illustration.
class KhaltiErrorWidget extends StatelessWidget {
  /// Create [KhaltiErrorWidget] with the provided values.
  const KhaltiErrorWidget({
    Key? key,
    required this.error,
    this.title,
    this.subtitle,
  }) : super(key: key);

  /// The [error] object.
  final Object error;

  /// The error [title].
  final String? title;

  /// The error [subtitle].
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final errorInfo = ErrorInfo.from(context, error);

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
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
