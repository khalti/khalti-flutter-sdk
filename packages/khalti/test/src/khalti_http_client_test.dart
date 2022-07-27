import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khalti/khalti.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

typedef Caller = Future<HttpResponse> Function(String, Map<String, Object>);

class MockHttp extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttp mockHttp;
  late KhaltiHttpClient khaltiHttpClient;

  setUp(
    () {
      mockHttp = MockHttp();
      khaltiHttpClient = KhaltiHttpClient(httpClient: mockHttp);
    },
  );

  setUpAll(() {
    registerFallbackValue(FakeUri());
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
        final response = MockResponse();
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
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.failure() if the status code is not >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 404,
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if HttpException is thrown',
        () => runExceptionTest(
          exception: const HttpException('Exception'),
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if ClientException is thrown',
        () => runExceptionTest(
          exception: http.ClientException('Exception'),
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if SocketException is thrown',
        () => runExceptionTest(
          exception: const SocketException('Exception'),
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if FormatException is thrown',
        () => runExceptionTest(
          exception: const FormatException('Exception'),
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'get(): should return HttpResponse.exception() if any Exception is thrown',
        () => runExceptionTest(
          exception: Exception(),
          stubMethod: () => mockHttp.get(
            any(),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.get(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.success() if the status code is >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 200,
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.failure() if the status code is not >= 200 and < 300',
        () => runSuccessOrFailureTest(
          statusCode: 404,
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if HttpException is thrown',
        () => runExceptionTest(
          exception: const HttpException('Exception'),
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if ClientException is thrown',
        () => runExceptionTest(
          exception: http.ClientException('Exception'),
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if SocketException is thrown',
        () => runExceptionTest(
          exception: const SocketException('Exception'),
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if FormatException is thrown',
        () => runExceptionTest(
          exception: const FormatException('Exception'),
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );

      test(
        'post(): should return HttpResponse.exception() if any Exception is thrown',
        () => runExceptionTest(
          exception: Exception(),
          stubMethod: () => mockHttp.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
          caller: (url, params) => khaltiHttpClient.post(url, params),
        ),
      );
    },
  );
}
