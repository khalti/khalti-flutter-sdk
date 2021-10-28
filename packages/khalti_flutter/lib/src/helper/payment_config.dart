class PaymentConfig {
  PaymentConfig({
    required this.amount,
    required this.productIdentity,
    required this.productName,
    this.productUrl,
    this.additionalData,
  });

  final int amount;
  final String productIdentity;
  final String productName;
  final String? productUrl;
  final Map<String, Object>? additionalData;

  String get returnUrl => 'khalti://pay/kpg';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentConfig &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          productIdentity == other.productIdentity &&
          productName == other.productName &&
          productUrl == other.productUrl &&
          additionalData == other.additionalData;

  @override
  int get hashCode =>
      amount.hashCode ^
      productIdentity.hashCode ^
      productName.hashCode ^
      productUrl.hashCode ^
      additionalData.hashCode;
}
