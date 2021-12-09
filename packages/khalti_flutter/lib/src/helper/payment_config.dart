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
    String? returnUrl,
  }) : _returnUrl = returnUrl;

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
        final _baseUrl = Uri.base.toString();
        return _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
      }
      return 'kpg://${KhaltiService.config.packageName}/kpg';
    }
    return _returnUrl!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentConfig &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          productIdentity == other.productIdentity &&
          productName == other.productName &&
          productUrl == other.productUrl &&
          additionalData == other.additionalData &&
          returnUrl == other.returnUrl;

  @override
  int get hashCode =>
      amount.hashCode ^
      productIdentity.hashCode ^
      productName.hashCode ^
      productUrl.hashCode ^
      additionalData.hashCode ^
      returnUrl.hashCode;
}
