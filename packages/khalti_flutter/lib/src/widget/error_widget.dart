import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/widget/image.dart';

class KhaltiErrorWidget extends StatelessWidget {
  const KhaltiErrorWidget({
    Key? key,
    required this.error,
  }) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    var assetName = 'error/general-error.svg';
    var title = 'An Error Occurred';
    String? subtitle;

    final _error = error;

    if (_error is FailureHttpResponse) {
      final errorData = _error.data;

      if (errorData is Map && errorData.containsKey('detail')) {
        subtitle = errorData['detail'];
      } else {
        subtitle = _error.message;
      }
    } else if (_error is ExceptionHttpResponse && _error.isSocketException) {
      assetName = 'error/no-internet.svg';

      if (_error.code == 7) {
        title = 'No Internet';
        subtitle = 'You are not connected to the internet.'
            ' Please check your connection.';
      } else if (_error.code == 101) {
        title = 'Network Unreachable';
        subtitle = 'Your connection could not be established.';
      } else {
        title = 'No Connection';
        subtitle = 'Slow or no internet connection.'
            ' Please check your internet & try again.';
      }
    }

    final titleStyle = Theme.of(context).textTheme.subtitle1?.copyWith(
          color: Theme.of(context).primaryColor,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 64),
          KhaltiImage.asset(asset: assetName, height: 175),
          const SizedBox(height: 40),
          Text(title, style: titleStyle),
          const SizedBox(height: 16),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(color: Color(0xFF848484)),
            ),
        ],
      ),
    );
  }
}
