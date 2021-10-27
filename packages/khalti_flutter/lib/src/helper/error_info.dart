import 'package:flutter/widgets.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/assets.dart';

class ErrorInfo {
  ErrorInfo._({
    required this.primary,
    required this.secondary,
    required this.asset,
    required this.data,
  });

  final String primary;
  final String? secondary;
  final String asset;
  final Map<String, dynamic> data;

  factory ErrorInfo.from(BuildContext context, Object e) {
    var assetName = a_generalError;
    var primary = context.loc.anErrorOccurred;
    String? secondary;
    Map<String, Object?> _data = {};

    if (e is FailureHttpResponse) {
      final errorData = e.data;

      if (errorData is Map<String, dynamic> &&
          errorData.containsKey('detail')) {
        _data = errorData;
        secondary = errorData['detail'];
      } else {
        secondary = e.message;
      }
    } else if (e is ExceptionHttpResponse && e.isSocketException) {
      assetName = a_noInternet;

      if (e.code == 7) {
        primary = context.loc.noInternet;
        secondary = context.loc.noInternetMessage;
      } else if (e.code == 101) {
        primary = context.loc.networkUnreachable;
        secondary = context.loc.networkUnreachableMessage;
      } else {
        primary = context.loc.noConnection;
        secondary = context.loc.noConnectionMessage;
      }
    }

    return ErrorInfo._(
      primary: primary,
      secondary: secondary,
      asset: assetName,
      data: _data,
    );
  }
}
