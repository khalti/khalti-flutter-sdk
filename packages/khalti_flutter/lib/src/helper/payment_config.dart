// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:khalti/khalti.dart';

/// The payment configuration to configure gateway widgets and
/// create khalti configuration to be sent to the server.
class PaymentConfig {
  /// Creates [PaymentConfig] from the provided objects.
  PaymentConfig({
    required this.amount,
    required this.productIdentity,
    required this.productName,
    this.productUrl,
    this.additionalData,
    this.mobile,
    this.mobileReadOnly = false,
    String? returnUrl,
  })  : _returnUrl = returnUrl,
        assert(
          mobile == null || RegExp(r'(^[9][678][0-9]{8}$)').hasMatch(mobile),
          '\n\n"mobile" should be valid mobile number.\n',
        ),
        assert(
          !mobileReadOnly || mobile != null,
          '\n\nPlease provide mobile number if you want to make the field read only.\n',
        );

  /// The payment [amount] in paisa.
  final int amount;

  /// A unique string to identify the product.
  final String productIdentity;

  /// Descriptive name for the product.
  final String productName;

  /// The product URL.
  final String? productUrl;

  /// An [additionalData] sent alongside the payment configuration.
  final Map<String, Object>? additionalData;

  /// A [mobile] number to preset in Khalti Mobile Number field.
  final String? mobile;

  /// Makes the mobile field non-editable, if true.
  ///
  /// Default is false.
  final bool mobileReadOnly;

  final String? _returnUrl;

  /// A redirection url after successful payment.
  /// The redirected URL will be in the following format.
  /// ```
  /// <returnUrl>/?<data>
  /// ```
  ///
  /// By default, web platform will have the base url as the [returnUrl].
  /// And other platforms will have `kpg://{your package name}/kpg` as the returnUrl.
  ///
  /// The default [returnUrl] can be overridden with [PaymentConfig.returnUrl].
  String get returnUrl {
    if (_returnUrl == null) {
      if (kIsWeb) {
        final baseUrl = Uri.base.toString();
        return baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl;
      }
      return 'kpg://${KhaltiService.config.packageName}/kpg';
    }
    return _returnUrl!;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentConfig &&
            runtimeType == other.runtimeType &&
            amount == other.amount &&
            productIdentity == other.productIdentity &&
            productName == other.productName &&
            productUrl == other.productUrl &&
            additionalData == other.additionalData &&
            returnUrl == other.returnUrl &&
            mobile == other.mobile &&
            mobileReadOnly &&
            other.mobileReadOnly;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        productIdentity.hashCode ^
        productName.hashCode ^
        productUrl.hashCode ^
        additionalData.hashCode ^
        returnUrl.hashCode ^
        mobile.hashCode ^
        mobileReadOnly.hashCode;
  }
}
