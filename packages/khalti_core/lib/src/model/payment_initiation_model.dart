import 'package:khalti_core/src/core/khalti_request_model.dart';
import 'package:khalti_core/src/data/khalti_service.dart';
import 'package:khalti_core/src/helper/model_helpers.dart';

class PaymentInitiationRequestModel extends KhaltiRequestModel {
  PaymentInitiationRequestModel({
    required this.amount,
    required this.mobile,
    required this.productIdentity,
    required this.productName,
    required this.transactionPin,
    this.productUrl,
    this.additionalData,
  });

  final int amount;
  final String mobile;
  final String productIdentity;
  final String productName;
  final String transactionPin;
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
      'transaction_pin': transactionPin,
      if (productUrl != null) 'product_url': productUrl,
      if (additionalData != null) ...additionalData!.map(_addMerchantPrefix),
    };
  }

  MapEntry<String, Object?> _addMerchantPrefix(String key, Object? value) {
    return MapEntry('merchant_$key', value);
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
