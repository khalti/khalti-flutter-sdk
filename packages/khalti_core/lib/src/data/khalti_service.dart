// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:khalti_core/khalti_core.dart';
import 'package:khalti_core/src/config/url.dart';

/// The wrapper class to access Khalti Payment Gateway API.
class KhaltiService {
  /// Default constructor for [KhaltiService] to initialize [KhaltiClient].
  KhaltiService({required KhaltiClient client}) : _client = client;

  final String _baseUrl = 'https://khalti.com';
  final int _apiVersion = 2;
  final KhaltiClient _client;

  /// Enabling [enableDebugging] will print network logs.
  static bool enableDebugging = false;
  static String? _publicKey;

  /// The [publicKey] configured using [KhaltiService.publicKey].
  static String get publicKey {
    assert(
      _publicKey != null && _publicKey!.isNotEmpty,
      'Provide a public key using "KhaltiService.publicKey = <khalti-pk>;"',
    );
    return _publicKey!;
  }

  static set publicKey(String key) => _publicKey = key;

  /// The default platform only configuration.
  static KhaltiConfig config = KhaltiConfig.platformOnly();

  /// Fetches the list for available banks that supports [paymentType].
  ///
  /// See: https://docs.khalti.com/checkout/diy-ebanking/#1-get-bank-list
  Future<BankListModel> getBanks({required PaymentType paymentType}) async {
    final params = {
      'page': '1',
      'page_size': '200',
      'payment_type': paymentType.value,
    };

    final url = _buildUrl(banks);
    final logger = _Logger('GET', url);

    logger.request(params);
    final response = await _client.get(url, params);
    logger.response(response);

    return _handleError(
      response,
      converter: (data) => BankListModel.fromMap(data),
    );
  }

  /// Initiates the payment.
  ///
  /// e.g. When the user clicks Pay button,
  /// you will need to prompt for their Khalti registered mobile number,
  /// and call this API once the payer submits.
  ///
  /// See: https://docs.khalti.com/checkout/diy-wallet/#1-initiate-transaction
  Future<PaymentInitiationResponseModel> initiatePayment({
    required PaymentInitiationRequestModel request,
  }) async {
    final url = _buildUrl(initiateTransaction);
    final logger = _Logger('POST', url);

    logger.request(request);
    final response = await _client.post(url, request.toMap());
    logger.response(response);

    return _handleError(
      response,
      converter: (data) => PaymentInitiationResponseModel.fromMap(data),
    );
  }

  /// Confirms the payment.
  ///
  /// See: https://docs.khalti.com/checkout/diy-wallet/#2-confirm-transaction
  Future<PaymentSuccessModel> confirmPayment({
    required PaymentConfirmationRequestModel request,
  }) async {
    final url = _buildUrl(confirmTransaction);
    final logger = _Logger('POST', url);

    logger.request(request);
    final response = await _client.post(url, request.toMap());
    logger.response(response);

    return _handleError(
      response,
      converter: (data) => PaymentSuccessModel.fromMap(data),
    );
  }

  /// Constructs a bank payment URL.
  ///
  /// [bankId] is the unique bank identifier which can be obtained from the bank list API
  ///
  /// [mobile] : The Khalti registered mobile number of payer
  ///
  /// [amount] : The amount value of payment.
  /// Amount must be in paisa and greater than equal to 1000 i.e Rs 10
  ///
  /// [productIdentity] : A unique string to identify the product
  ///
  /// [productName] : Descriptive name for the product
  ///
  /// [paymentType] is one of the  available [PaymentType]
  ///
  /// [returnUrl] is the redirection url after successful payment.
  /// The redirected URL will be in the following format.
  /// ```
  /// <returnUrl>/?<data>
  /// ```
  ///
  /// An [additionalData] to be sent alongside the payment configuration.
  /// This is only for reporting purposes.
  ///
  /// See: https://docs.khalti.com/checkout/diy-ebanking/#2-initiate-transaction
  String buildBankUrl({
    required String bankId,
    required String mobile,
    required int amount,
    required String productIdentity,
    required String productName,
    required PaymentType paymentType,
    required String returnUrl,
    String? productUrl,
    Map<String, Object>? additionalData,
  }) {
    final params = {
      'bank': bankId,
      'public_key': publicKey,
      'amount': amount.toString(),
      'mobile': mobile,
      'product_identity': productIdentity,
      'product_name': productName,
      'source': 'custom',
      ...config.raw,
      if (productUrl != null) 'product_url': productUrl,
      if (additionalData != null) ...additionalData.map(_stringifyValue),
      'return_url': returnUrl,
      'payment_type': paymentType.value,
    };
    final uri = Uri.https('khalti.com', 'ebanking/initiate/', params);
    return uri.toString();
  }

  T _handleError<T>(
    HttpResponse response, {
    required T Function(Map<String, dynamic>) converter,
  }) {
    if (response is ExceptionHttpResponse || response is FailureHttpResponse) {
      throw response;
    }

    return converter(response.data as Map<String, dynamic>);
  }

  String _buildUrl(String path) {
    return '$_baseUrl/api/v$_apiVersion/$path';
  }

  MapEntry<String, String> _stringifyValue(String key, Object value) {
    return MapEntry('merchant_$key', value.toString());
  }
}

class _Logger {
  _Logger(this.method, this.url);

  final String method;
  final String url;

  void request(Object? data) {
    _divider();
    _logHeading();
    _log(
      data.toString(),
      name: method == 'GET' ? 'Query Parameters' : 'Request Data',
    );
    _divider();
  }

  void response(HttpResponse response) {
    _divider();
    _logHeading();
    _log(response.toString(), name: 'Response');
    _divider();
  }

  void _logHeading() => _log(url, name: method);

  void _log(String message, {required String name}) {
    if (KhaltiService.enableDebugging) _debugPrint('[$name] $message');
  }

  void _divider() {
    if (KhaltiService.enableDebugging) _debugPrint('-' * 140);
  }

  void _debugPrint(String message) {
    assert(() {
      // ignore: avoid_print
      print(message);
      return true;
    }());
  }
}
