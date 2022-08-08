import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khalti/khalti.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

typedef Caller = Future<HttpResponse> Function(String, Map<String, Object>);

class _MockHttp extends Mock implements http.Client {}

class _MockResponse extends Mock implements http.Response {}

class _FakeUri extends Fake implements Uri {}

void main() {
  late _MockHttp _mockHttp;
  late KhaltiHttpClient _khaltiHttpClient;

  setUp(
    () {
      _mockHttp = _MockHttp();
      _khaltiHttpClient = KhaltiHttpClient(httpClient: _mockHttp);
    },
  );

  setUpAll(() {
    registerFallbackValue(_FakeUri());
  });

  group(
    'constructor',
    () {
      test(
        'instantiates internal httpClient when not injected',
        () {
          expect(KhaltiHttpClient(), isNotNull);
        },
      );
    },
  );
  group(
    'KhaltiHttpClient |',
    () {
      const testUrl = 'url';
      const testParams = {'key': 'value'};
      const testResponseBody = '{"message": "Fake Response"}';

      void runSuccessOrFailureTest({
        required int statusCode,
        required Future<http.Response> Function() stubMethod,
        required Caller caller,
      }) async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(statusCode);
        when(() => response.body).thenReturn(testResponseBody);
        when(stubMethod).thenAnswer((_) async => response);
        final result = await caller(testUrl, testParams);
        expect(
          result,
          isA<HttpResponse>()
              .having((e) => e.data, 'data', jsonDecode(testResponseBody))
              .having((e) => e.statusCode, 'status code', statusCode),
        );
      }

      void runExceptionTest({
        required Exception exception,
        required Future<http.Response> Function() stubMethod,
        required Caller caller,
      }) async {
        when(stubMethod).thenThrow(exception);
        final result = await caller(testUrl, testParams);
        expect(
          result,
          isA<HttpResponse>()
              .having((e) => e.data, 'data', isNull)
              .having((e) => e.statusCode, 'status code', 0)
              .having((e) => e.message, 'exception', 'Exception'),
        );
      }

      test(
        'get(): should return HttpResponse.success() if the status code is >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 200,
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.failure() if the status code is not >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 404,
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if HttpException is thrown',
        () => runExceptionTest(
          exception: const HttpException('Exception'),
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if ClientException is thrown',
        () => runExceptionTest(
          exception: http.ClientException('Exception'),
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if SocketException is thrown',
        () => runExceptionTest(
          exception: const SocketException('Exception'),
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if FormatException is thrown',
        () => runExceptionTest(
          exception: const FormatException('Exception'),
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if any Exception is thrown',
        () => runExceptionTest(
          exception: Exception(),
          stubMethod: () => _mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.success() if the status code is >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 200,
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.failure() if the status code is not >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 404,
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if HttpException is thrown',
        () => runExceptionTest(
          exception: const HttpException('Exception'),
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if ClientException is thrown',
        () => runExceptionTest(
          exception: http.ClientException('Exception'),
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if SocketException is thrown',
        () => runExceptionTest(
          exception: const SocketException('Exception'),
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if FormatException is thrown',
        () => runExceptionTest(
          exception: const FormatException('Exception'),
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if any Exception is thrown',
        () => runExceptionTest(
          exception: Exception(),
          stubMethod: () => _mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => _khaltiHttpClient.post(url, params),
        ),
      );
    },
  );
}
