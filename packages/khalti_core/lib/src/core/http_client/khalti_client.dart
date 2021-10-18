import 'http_response.dart';

abstract class KhaltiClient {
  Future<HttpResponse> get(String url, Map<String, Object> params);

  Future<HttpResponse> post(String url, Map<String, Object?> data);
}
