// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:khalti_core/src/core/khalti_request_model.dart';
import 'package:khalti_core/src/data/khalti_service.dart';
import 'package:khalti_core/src/helper/model_helpers.dart';

class _PayloadModel extends KhaltiRequestModel {
  _PayloadModel({
    required this.amount,
    required this.mobile,
    required this.productIdentity,
    required this.productName,
    this.productUrl,
    this.additionalData,
  });

  final int amount;
  final String mobile;
  final String productIdentity;
  final String productName;
  final String? productUrl;
  final Map<String, Object?>? additionalData;

  @override
  Map<String, Object?> toMap() {
    return {
      'amount': amount.toString(),
      'mobile': mobile,
      'product_identity': productIdentity,
      'product_name': productName,
      'public_key': KhaltiService.publicKey,
      if (productUrl != null) 'product_url': productUrl,
      if (additionalData != null) ...additionalData!.map(_addMerchantPrefix),
    };
  }

  MapEntry<String, Object?> _addMerchantPrefix(String key, Object? value) {
    return MapEntry('merchant_$key', value);
  }
}

/// A request model for payment initiation.
class PaymentInitiationRequestModel extends _PayloadModel {
  /// Default constructor for [PaymentInitiationRequestModel].
  PaymentInitiationRequestModel({
    required int amount,
    required String mobile,
    required String productIdentity,
    required String productName,
    required this.transactionPin,
    String? productUrl,
    Map<String, Object>? additionalData,
  }) : super(
          amount: amount,
          mobile: mobile,
          productIdentity: productIdentity,
          productName: productName,
          productUrl: productUrl,
          additionalData: additionalData,
        );

  /// The Khalti MPIN.
  final String transactionPin;

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      'transaction_pin': transactionPin,
    };
  }

  @override
  String toString() {
    return 'PaymentInitiationRequestModel:\n${toJson(beautify: true)}';
  }
}

/// A response model for payment initiation.
class PaymentInitiationResponseModel {
  /// Default constructor for [PaymentInitiationResponseModel].
  PaymentInitiationResponseModel({
    required this.token,
    required this.pinCreated,
    required this.pinCreatedMessage,
  });

  /// The [token] required for confirming transaction using [PaymentConfirmationRequestModel].
  final String token;

  /// Whether or not a new PIN was created.
  final bool pinCreated;

  /// The message related to PIN creation.
  final String pinCreatedMessage;

  /// Factory to create [PaymentInitiationResponseModel] instance from [map].
  factory PaymentInitiationResponseModel.fromMap(Map<String, Object?> map) {
    return PaymentInitiationResponseModel(
      token: map.getString('token'),
      pinCreated: map.getBool('pin_created'),
      pinCreatedMessage: map.getString('pin_created_message'),
    );
  }

  @override
  String toString() {
    return 'PaymentInitiationResponseModel{token: $token, pinCreated: $pinCreated, pinCreatedMessage: $pinCreatedMessage}';
  }
}

/// A request model for payment initiation.
class PaymentConfirmationRequestModel extends KhaltiRequestModel {
  /// Default constructor for [PaymentConfirmationRequestModel].
  PaymentConfirmationRequestModel({
    required this.confirmationCode,
    required this.token,
    required this.transactionPin,
  });

  /// The [confirmationCode] received as SMS in registered mobile number or email address.
  final String confirmationCode;

  /// The [token] received in payment initiation step.
  ///
  /// One from [PaymentInitiationResponseModel.token].
  final String token;

  /// The Khalti MPIN.
  final String transactionPin;

  @override
  Map<String, Object?> toMap() {
    return {
      'confirmation_code': confirmationCode,
      'public_key': KhaltiService.publicKey,
      'token': token,
      'transaction_pin': transactionPin,
    };
  }

  @override
  String toString() {
    return 'PaymentConfirmationRequestModel:\n${toJson(beautify: true)}';
  }
}

/// The model received on successful payment confirmation.
class PaymentSuccessModel {
  /// Default constructor for [PaymentSuccessModel].
  PaymentSuccessModel({
    required this.idx,
    required this.amount,
    required this.mobile,
    required this.productIdentity,
    required this.productName,
    required this.token,
    required this.productUrl,
    required this.additionalData,
  });

  /// A unique identification string representing the transaction.
  final String idx;

  /// The [amount] of transaction in paisa.
  final int amount;

  /// The Khalti ID on behalf of which the payment was made.
  final String mobile;

  /// A unique string to identify the product.
  final String productIdentity;

  /// Descriptive name for the product.
  final String productName;

  /// The payment confirmation token.
  ///
  /// The [token] should be used to perform server verification.
  ///
  /// See [Server Verification](https://docs.khalti.com/api/verification/).
  final String token;

  /// The product URL.
  final String? productUrl;

  /// An [additionalData] sent alongside the payment configuration.
  final Map<String, Object?>? additionalData;

  /// Factory to create [PaymentSuccessModel] instance from [map].
  factory PaymentSuccessModel.fromMap(Map<String, Object?> map) {
    return PaymentSuccessModel(
      idx: map.getString('idx'),
      amount: map.getInt('amount'),
      mobile: map.getString('mobile'),
      productIdentity: map.getString('product_identity'),
      productName: map.getString('product_name'),
      token: map.getString('token'),
      productUrl: map.getString('product_url'),
      additionalData: {
        for (final entry in map.entries)
          if (entry.key.startsWith('merchant_')) ...{
            entry.key.substring(9): entry.value,
          },
      },
    );
  }

  @override
  String toString() {
    return 'PaymentSuccessModel{idx: $idx, amount: $amount, mobile: $mobile, productIdentity: $productIdentity, productName: $productName, token: $token, additionalData: $additionalData}';
  }
}

/// The model received on failure in payment confirmation.
class PaymentFailureModel {
  /// Default constructor for [PaymentFailureModel].
  PaymentFailureModel({
    required this.message,
    required this.data,
  });

  /// The failure [message].
  final String message;

  /// The [data] associated with the failure.
  final Map<String, dynamic> data;
}
