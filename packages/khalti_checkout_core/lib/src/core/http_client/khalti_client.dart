// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'http_response.dart';

/// The base http client to make request to Khalti server.
abstract class KhaltiClient {
  /// GET request
  ///
  /// [url] is the full URL for the API.
  /// [params] is the query parameters to be sent with the request.
  Future<HttpResponse> get(String url, Map<String, Object> params);

  /// POST request
  ///
  /// [url] is the full URL for the API.
  /// [data] is the body to be sent with the request.
  Future<HttpResponse> post(String url, Map<String, Object?> data);
}
