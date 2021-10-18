enum BankPaymentType {
  eBanking,
  mobileCheckout,
}

extension BankPaymentTypeExt on BankPaymentType {
  String get value {
    switch (this) {
      case BankPaymentType.eBanking:
        return 'ebanking';
      case BankPaymentType.mobileCheckout:
        return 'mobilecheckout';
    }
  }
}
