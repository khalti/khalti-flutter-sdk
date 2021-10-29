// Copyright (c) 2021 The Khalti Authors. All rights reserved.

/// The payment type to determine the non-wallet payment method.
enum PaymentType {
  /// Connect IPS
  connectIPS,

  /// E-Banking
  eBanking,

  /// Mobile Banking
  mobileCheckout,

  /// SCT Card payment
  sct,
}

/// Extension for [PaymentType] to extract payment type keyword.
extension PaymentTypeExt on PaymentType {
  /// THe payment type keyword.
  String get value {
    switch (this) {
      case PaymentType.connectIPS:
        return 'connectips';
      case PaymentType.eBanking:
        return 'ebanking';
      case PaymentType.mobileCheckout:
        return 'mobilecheckout';
      case PaymentType.sct:
        return 'sct';
    }
  }
}
