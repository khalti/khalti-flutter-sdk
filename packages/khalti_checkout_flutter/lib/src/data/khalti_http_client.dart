// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khalti_checkout_core/khalti_checkout_core.dart';

/// Typedef for http.Client that is used internally.
typedef InnerClient = http.Client;

/// The default [KhaltiClient] implementation.
///
/// Uses [http](https://pub.dev/packages/http) package under-the-hood.
class KhaltiHttpClient extends KhaltiClient {
  /// The HTTP client used to make HTTP requests.
  KhaltiHttpClient({
    InnerClient? client,
  }) : _client = client ?? InnerClient();

  final InnerClient _client;

  @override
  Future<HttpResponse> get(
    String url,
    Map<String, Object> params,
  ) async {
    return _handleExceptions(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: params);
        final response = await _client.get(
          uri,
          headers: {
            ..._tokenHeader,
            // ignore: invalid_use_of_internal_member
            ...KhaltiService.config.raw
          },
        );
        final statusCode = response.statusCode;
        final responseData = jsonDecode(response.body);

        if (_isStatusValid(statusCode)) {
          return HttpResponse.success(
            data: responseData,
            statusCode: statusCode,
          );
        }
        return HttpResponse.failure(
          data: responseData,
          statusCode: statusCode,
        );
      },
    );
  }

  @override
  Future<HttpResponse> post(
    String url,
    Map<String, Object?> data,
  ) {
    return _handleExceptions(
      () async {
        final uri = Uri.parse(url);
        final response = await _client.post(
          uri,
          body: data,
          headers: {
            ..._tokenHeader,
            // ignore: invalid_use_of_internal_member
            ...KhaltiService.config.raw
          },
        );
        final statusCode = response.statusCode;
        final responseData = jsonDecode(response.body);

        if (_isStatusValid(statusCode)) {
          return HttpResponse.success(
            data: responseData,
            statusCode: statusCode,
          );
        }
        return HttpResponse.failure(
          data: responseData,
          statusCode: statusCode,
        );
      },
    );
  }

  bool _isStatusValid(int statusCode) => statusCode >= 200 && statusCode < 300;

  /// Helper getter for passing auth token as a header.
  Map<String, String> get _tokenHeader {
    return {'Authorization': 'Key ${KhaltiService.publicKey}'};
  }

  Future<HttpResponse> _handleExceptions(
    Future<HttpResponse> Function() caller,
  ) async {
    try {
      return await caller();
    } on HttpException catch (e, s) {
      return HttpResponse.exception(
        message: e.message,
        code: 0,
        stackTrace: s,
        detail: e.uri,
      );
    } on http.ClientException catch (e, s) {
      return HttpResponse.exception(
        message: e.message,
        code: 0,
        stackTrace: s,
        detail: e.uri,
      );
    } on SocketException catch (e, s) {
      return HttpResponse.exception(
        message: e.message,
        code: e.osError?.errorCode ?? 0,
        stackTrace: s,
        detail: e.osError?.message,
        isSocketException: true,
      );
    } on FormatException catch (e, s) {
      return HttpResponse.exception(
        message: e.message,
        code: 0,
        stackTrace: s,
        detail: e.source,
      );
    } catch (e, s) {
      return HttpResponse.exception(
        message: e.toString(),
        code: 0,
        stackTrace: s,
      );
    }
  }
}
