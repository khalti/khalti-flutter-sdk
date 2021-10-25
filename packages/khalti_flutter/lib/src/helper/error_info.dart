import 'package:khalti/khalti.dart';

class ErrorInfo {
  ErrorInfo._({
    required this.primary,
    required this.secondary,
    required this.asset,
  });

  final String primary;
  final String? secondary;
  final String asset;

  factory ErrorInfo.from(Object e) {
    var assetName = 'error/general-error.svg';
    var primary = 'An Error Occurred';
    String? secondary;

    if (e is FailureHttpResponse) {
      final errorData = e.data;

      if (errorData is Map && errorData.containsKey('detail')) {
        secondary = errorData['detail'];
      } else {
        secondary = e.message;
      }
    } else if (e is ExceptionHttpResponse && e.isSocketException) {
      assetName = 'error/no-internet.svg';

      if (e.code == 7) {
        primary = 'No Internet';
        secondary = 'You are not connected to the internet.'
            ' Please check your connection.';
      } else if (e.code == 101) {
        primary = 'Network Unreachable';
        secondary = 'Your connection could not be established.';
      } else {
        primary = 'No Connection';
        secondary = 'Slow or no internet connection.'
            ' Please check your internet & try again.';
      }
    }

    return ErrorInfo._(
      primary: primary,
      secondary: secondary,
      asset: assetName,
    );
  }
}
