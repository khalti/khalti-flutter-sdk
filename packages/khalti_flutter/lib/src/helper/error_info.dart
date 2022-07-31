// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/assets.dart';

/// The error information extracted from error object.
class ErrorInfo {
  ErrorInfo._({
    required this.primary,
    required this.secondary,
    required this.asset,
    required this.data,
  });

  /// The [primary] error message.
  final String primary;

  /// The [secondary]; detailed error message.
  final String? secondary;

  /// The [asset] name associated with the error.
  final String asset;

  /// The [data] object associated with the error.
  final Map<String, dynamic> data;

  /// Factory for creating [ErrorInfo] from the [error].
  factory ErrorInfo.from(BuildContext context, Object error) {
    var assetName = a_generalError;
    var primary = context.loc.anErrorOccurred;
    String? secondary;
    Map<String, Object?> data = {};

    if (error is FailureHttpResponse) {
      final errorData = error.data;

      if (errorData is Map<String, dynamic> &&
          errorData.containsKey('detail')) {
        data = errorData;
        secondary = errorData['detail'];
      } else {
        secondary = error.message;
      }
    } else if (error is ExceptionHttpResponse && error.isSocketException) {
      assetName = a_noInternet;

      if (error.code == 7) {
        primary = context.loc.noInternet;
        secondary = context.loc.noInternetMessage;
      } else if (error.code == 101) {
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
      data: data,
    );
  }
}
