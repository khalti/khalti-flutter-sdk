// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'package:khalti_checkout_core/src/core/http_client/http_response.dart';
import 'package:test/test.dart';

void main() {
  group('HttpResponse tests | ', () {
    test('success factory', () {
      final response = HttpResponse.success(
        data: 'data',
        statusCode: 200,
      );

      expect(response, isA<SuccessHttpResponse>());
      expect(
        response.toString(),
        'SuccessHttpResponse{data: data, statusCode: 200}',
      );
    });

    test('failure factory', () {
      final response = HttpResponse.failure(
        data: 'Unauthorized',
        statusCode: 403,
      );

      expect(response, isA<FailureHttpResponse>());
      expect(
        response.toString(),
        'FailureHttpResponse{data: Unauthorized, statusCode: 403}',
      );
    });

    test('exception factory', () {
      final response = HttpResponse.exception(
        message: 'No connection',
        code: 7,
        stackTrace: StackTrace.empty,
        detail: 'Could not reach the server',
        isSocketException: true,
      );

      expect(response, isA<ExceptionHttpResponse>());
      expect(
        response.toString(),
        'ExceptionHttpResponse{message: No connection, code: 7, stackTrace: , detail: Could not reach the server, isSocketException: true}',
      );
    });
  });
}
