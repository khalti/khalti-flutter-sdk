enum PaymentType {
  connectIPS,
  eBanking,
  mobileCheckout,
  sct,
}

extension PaymentTypeExt on PaymentType {
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
