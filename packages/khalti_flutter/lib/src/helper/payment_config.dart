import 'package:flutter/foundation.dart';

class PaymentConfig {
  PaymentConfig({
    required this.amount,
    required this.productIdentity,
    required this.productName,
    this.productUrl,
    this.additionalData,
    String? returnUrl,
  }) : _returnUrl = returnUrl;

  final int amount;
  final String productIdentity;
  final String productName;
  final String? productUrl;
  final Map<String, Object>? additionalData;
  final String? _returnUrl;

  String get returnUrl {
    if (_returnUrl == null) {
      if (kIsWeb) {
        final _baseUrl = Uri.base.toString();
        return _baseUrl.endsWith('/')
            ? _baseUrl.substring(0, _baseUrl.length - 1)
            : _baseUrl;
      }
      return 'khalti://pay/kpg';
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
