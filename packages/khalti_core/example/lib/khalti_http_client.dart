import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khalti_core/khalti_core.dart';

class KhaltiHttpClient extends KhaltiClient {
  @override
  Future<HttpResponse> get(String url, Map<String, Object> params) async {
    return _handleExceptions(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: params);
        final response = await http.get(uri);
        final statusCode = response.statusCode;
        final responseData = jsonDecode(response.body);

        if (_isStatusValid(statusCode)) {
          return HttpResponse.success(
            data: responseData,
            statusCode: statusCode,
          );
        }
        return HttpResponse.failure(data: responseData, statusCode: statusCode);
      },
    );
  }

  @override
  Future<HttpResponse> post(String url, Map<String, Object?> data) {
    return _handleExceptions(
      () async {
        final uri = Uri.parse(url);
        final response = await http.post(uri, body: data);
        final statusCode = response.statusCode;
        final responseData = jsonDecode(response.body);

        if (_isStatusValid(statusCode)) {
          return HttpResponse.success(
            data: responseData,
            statusCode: statusCode,
          );
        }
        return HttpResponse.failure(data: responseData, statusCode: statusCode);
      },
    );
  }

  bool _isStatusValid(int statusCode) => statusCode >= 200 && statusCode < 300;

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
