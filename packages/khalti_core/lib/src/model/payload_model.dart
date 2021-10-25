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

class PaymentInitiationRequestModel extends _PayloadModel {
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

class PaymentInitiationResponseModel {
  PaymentInitiationResponseModel({
    required this.token,
    required this.pinCreated,
    required this.pinCreatedMessage,
  });

  final String token;
  final bool pinCreated;
  final String pinCreatedMessage;

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

class PaymentConfirmationRequestModel extends KhaltiRequestModel {
  PaymentConfirmationRequestModel({
    required this.confirmationCode,
    required this.token,
    required this.transactionPin,
  });

  final String confirmationCode;
  final String token;
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

class PaymentSuccessModel {
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

  final String idx;
  final int amount;
  final String mobile;
  final String productIdentity;
  final String productName;
  final String token;
  final String? productUrl;
  final Map<String, Object?>? additionalData;

  factory PaymentSuccessModel.fromMap(Map<String, Object?> map) {
    return PaymentSuccessModel(
      idx: map.getString('idx'),
      amount: map.getInt('amount'),
      mobile: map.getString('mobile'),
      productIdentity: map.getString('product_identity'),
      productName: map.getString('product_name'),
      token: map.getString('token'),
      productUrl: map.getString('productUrl'),
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

class PaymentFailureModel {
  PaymentFailureModel({
    required this.message,
    required this.data,
  });

  final String message;
  final Map<String, dynamic> data;
}
