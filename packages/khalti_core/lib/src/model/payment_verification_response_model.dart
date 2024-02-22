// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:equatable/equatable.dart';

/// Response model for payment verification lookup.
class PaymentVerificationResponseModel extends Equatable {
  /// Default constructor for [PaymentVerificationResponseModel].
  const PaymentVerificationResponseModel({
    required this.pidx,
    required this.totalAmount,
    required this.status,
    required this.transactionId,
    required this.fee,
    required this.refunded,
  });

  /// The product idx for the associated payment.
  final String pidx;

  /// Total Amount associated with the payment made.
  final int totalAmount;

  /// The transaction status for the payment made.
  ///
  /// Can be: Completed, Pending, Failed, Initiated, Refunded or Expired
  final String status;

  /// Unique transaction id.
  final String transactionId;

  /// The service charge for the payment.
  final int fee;

  /// Denotes if refund was made in case of any failure.
  final bool refunded;

  @override
  List<Object?> get props => [
        pidx,
        totalAmount,
        status,
        transactionId,
        fee,
        refunded,
      ];

  /// Factory to create [PaymentVerificationResponseModel] instance from [map].
  factory PaymentVerificationResponseModel.fromJson(
    Map<String, dynamic> map,
  ) {
    return PaymentVerificationResponseModel(
      pidx: map['pidx'] as String,
      totalAmount: map['total_amount'] as int,
      status: map['status'] as String,
      transactionId: map['transaction_id'] as String,
      fee: map['fee'] as int,
      refunded: map['refunded'] as bool,
    );
  }
}
