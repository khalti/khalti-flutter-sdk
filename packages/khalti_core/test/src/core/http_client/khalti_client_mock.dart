// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:khalti_core/khalti_core.dart';

class KhaltiClientMock implements KhaltiClient {
  late HttpResponse _response;

  set response(HttpResponse response) => _response = response;

  @override
  Future<HttpResponse> get(String url, Map<String, Object> params) async {
    return _response;
  }

  @override
  Future<HttpResponse> post(String url, Map<String, Object?> data) async {
    return _response;
  }
}
