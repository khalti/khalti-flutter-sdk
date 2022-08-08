import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khalti/khalti.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

typedef _MethodUnderTestCaller = Future<HttpResponse> Function(
  String,
  Map<String, Object>,
);

const _testUrl = 'www.url.com';
const _testParams = {'key': 'value'};
const _testResponseBody = '{"message": "Fake Response"}';

void _runSuccessOrFailureTest({
  required int statusCode,
  required Future<http.Response> Function() stubMethod,
  required _MethodUnderTestCaller caller,
}) async {
  final response = _ResponseMock();

  when(() => response.statusCode).thenReturn(statusCode);
  when(() => response.body).thenReturn(_testResponseBody);
  when(stubMethod).thenAnswer((_) async => response);

  final result = await caller(_testUrl, _testParams);

  expect(
    result,
    isA<HttpResponse>()
        .having((e) => e.data, 'data', jsonDecode(_testResponseBody))
        .having((e) => e.statusCode, 'status code', statusCode),
  );
}

void _runExceptionTest({
  required Exception exception,
  required Future<http.Response> Function() stubMethod,
  required _MethodUnderTestCaller caller,
}) async {
  when(stubMethod).thenThrow(exception);

  final result = await caller(_testUrl, _testParams);

  expect(
    result,
    isA<HttpResponse>()
        .having((e) => e.data, 'data', isNull)
        .having((e) => e.statusCode, 'status code', 0)
        .having((e) => e.message, 'exception', 'Exception'),
  );
}

void main() {
  final mockHttp = _HttpMock();
  late KhaltiHttpClient khaltiHttpClient;

  setUp(
    () {
      khaltiHttpClient = KhaltiHttpClient(client: mockHttp);
    },
  );

  setUpAll(() {
    registerFallbackValue(_UriFake());
  });

  group(
    'KhaltiHttpClient constructor',
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
      group(
        'get():',
        () {
          test(
            'should return HttpResponse.success() if the status code is >= 200 and < 300',
            () {
              _runSuccessOrFailureTest(
                statusCode: 200,
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.failure() if the status code is not >= 200 and < 300',
            () {
              _runSuccessOrFailureTest(
                statusCode: 404,
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if HttpException is thrown',
            () {
              _runExceptionTest(
                exception: const HttpException('Exception'),
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if ClientException is thrown',
            () {
              _runExceptionTest(
                exception: http.ClientException('Exception'),
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if SocketException is thrown',
            () {
              _runExceptionTest(
                exception: const SocketException('Exception'),
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if FormatException is thrown',
            () {
              _runExceptionTest(
                exception: const FormatException('Exception'),
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if any Exception is thrown',
            () {
              _runExceptionTest(
                exception: Exception(),
                stubMethod: () => mockHttp.get(
                  any(),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.get(url, params),
              );
            },
          );
        },
      );

      group(
        'post():',
        () {
          test(
            'should return HttpResponse.success() if the status code is >= 200 and < 300',
            () {
              _runSuccessOrFailureTest(
                statusCode: 200,
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.failure() if the status code is not >= 200 and < 300',
            () {
              _runSuccessOrFailureTest(
                statusCode: 404,
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if HttpException is thrown',
            () {
              _runExceptionTest(
                exception: const HttpException('Exception'),
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if ClientException is thrown',
            () {
              _runExceptionTest(
                exception: http.ClientException('Exception'),
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if SocketException is thrown',
            () {
              _runExceptionTest(
                exception: const SocketException('Exception'),
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if FormatException is thrown',
            () {
              _runExceptionTest(
                exception: const FormatException('Exception'),
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );

          test(
            'should return HttpResponse.exception() if any Exception is thrown',
            () {
              _runExceptionTest(
                exception: Exception(),
                stubMethod: () => mockHttp.post(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                ),
                caller: (url, params) => khaltiHttpClient.post(url, params),
              );
            },
          );
        },
      );
    },
  );
}

class _HttpMock extends Mock implements http.Client {}

class _ResponseMock extends Mock implements http.Response {}

class _UriFake extends Fake implements Uri {}
