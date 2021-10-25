import 'package:khalti_core/khalti_core.dart';
import 'package:khalti_core/src/config/url.dart';
import 'package:khalti_core/src/core/http_client/http_response.dart';
import 'package:khalti_core/src/core/http_client/khalti_client.dart';
import 'package:khalti_core/src/helper/payment_type.dart';
import 'package:khalti_core/src/model/bank_model.dart';
import 'package:khalti_core/src/model/payload_model.dart';

class KhaltiService {
  final String _baseUrl = 'https://khalti.com';
  final int _apiVersion = 2;

  final KhaltiClient _client;

  static bool enableDebugging = false;
  static String? _publicKey;

  static String get publicKey {
    assert(
      _publicKey != null,
      'Provide a public key using "KhaltiService.publicKey = <khalti-pk>;"',
    );
    return _publicKey!;
  }

  static set publicKey(String key) => _publicKey = key;

  static KhaltiConfig config = KhaltiConfig.sourceOnly();

  KhaltiService({required KhaltiClient client}) : _client = client;

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

  String buildBankUrl({
    required String bankId,
    required String mobile,
    required int amount,
    required String productIdentity,
    required String productName,
    required PaymentType paymentType,
    String? productUrl,
    Map<String, Object>? additionalData,
    String returnUrl = 'khalti://pay/kpg',
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
    return '${_baseUrl}/api/v$_apiVersion/$path';
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
    if (KhaltiService.enableDebugging) print('[$name] $message');
  }

  void _divider() {
    if (KhaltiService.enableDebugging) print('-' * 140);
  }
}
