// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:khalti_core/khalti_core.dart';
import 'package:khalti_core/src/config/url.dart';
import 'package:meta/meta.dart';

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

  /// Member to hold [KhaltiConfig] object and pass it as a header in map representation.
  @internal
  static KhaltiConfig config = KhaltiConfig.platformOnly();

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
