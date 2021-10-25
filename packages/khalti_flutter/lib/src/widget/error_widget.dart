import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/helper/error_info.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/image.dart';

class KhaltiErrorWidget extends StatelessWidget {
  const KhaltiErrorWidget({
    Key? key,
    required this.error,
  }) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    final errorInfo = ErrorInfo.from(error);

    final titleStyle = Theme.of(context).textTheme.subtitle1?.copyWith(
          color: Theme.of(context).primaryColor,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 64),
          KhaltiImage.asset(asset: errorInfo.asset, height: 175),
          const SizedBox(height: 40),
          Text(errorInfo.primary, style: titleStyle),
          const SizedBox(height: 16),
          if (errorInfo.secondary != null)
            Text(
              errorInfo.secondary!,
              style: TextStyle(color: KhaltiColor.of(context).surface.shade100),
            ),
        ],
      ),
    );
  }
}
