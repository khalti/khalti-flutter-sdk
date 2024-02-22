import 'package:equatable/equatable.dart';

/// The result after making either a successful or unsuccessful payment.
class PaymentResult extends Equatable {
  /// Constructor for [PaymentResult].
  ///
  /// The result after making either a successful or unsuccessful payment.
  const PaymentResult({
    required this.status,
    this.message,
    this.payload,
  });

  /// A string representation of payment status.
  final String status;

  /// A short description to know why the payment was unsuccessful.
  final String? message;

  /// Payload regarding the product purchased.
  final PaymentPayload? payload;

  @override
  List<Object?> get props => [status, message, payload];

  @override
  bool get stringify => true;
}

/// Extra information passed as payload to [PaymentResult].
class PaymentPayload extends Equatable {
  /// Constructor for [PaymentPayload]
  ///
  /// Extra information passed as payload to [PaymentResult].
  const PaymentPayload({
    required this.pidx,
    required this.amount,
    required this.transactionId,
  });

  /// Unique produt identifier.
  final String pidx;

  /// The amount associated with the product when the payment is made.
  final int amount;

  /// Unique transaction id for the transaction carried out.
  final String transactionId;

  @override
  List<Object?> get props => [pidx, amount, transactionId];

  @override
  bool get stringify => true;
}
