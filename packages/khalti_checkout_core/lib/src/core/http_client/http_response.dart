// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'khalti_client.dart';

/// The response for [KhaltiClient].
class HttpResponse {
  const HttpResponse._({this.data, this.statusCode, this.message});

  /// The [data] received.
  final Object? data;

  /// The [statusCode] of response.
  final int? statusCode;

  /// The error [message].
  final String? message;

  /// Factory for [SuccessHttpResponse].
  factory HttpResponse.success({
    required Object data,
    required int statusCode,
  }) = SuccessHttpResponse._;

  /// Factory for [FailureHttpResponse].
  factory HttpResponse.failure({
    required Object data,
    required int statusCode,
  }) = FailureHttpResponse._;

  /// Factory for [ExceptionHttpResponse].
  factory HttpResponse.exception({
    required String message,
    required int code,
    required StackTrace stackTrace,
    Object? detail,
    bool isSocketException,
  }) = ExceptionHttpResponse._;
}

/// The success response for [KhaltiClient].
class SuccessHttpResponse extends HttpResponse {
  const SuccessHttpResponse._({
    required Object data,
    required int statusCode,
  }) : super._(data: data, statusCode: statusCode);

  @override
  String toString() {
    return 'SuccessHttpResponse{data: $data, statusCode: $statusCode}';
  }
}

/// The failure response for [KhaltiClient].
class FailureHttpResponse extends HttpResponse {
  const FailureHttpResponse._({
    required Object data,
    required int statusCode,
  }) : super._(data: data, statusCode: statusCode);

  @override
  String toString() {
    return 'FailureHttpResponse{data: $data, statusCode: $statusCode}';
  }
}

/// The exception for [KhaltiClient].
class ExceptionHttpResponse extends HttpResponse {
  /// The error [code].
  final int code;

  /// The [stackTrace] of the exception.
  final StackTrace stackTrace;

  /// The exception detail
  final Object? detail;

  /// Defines whether the exception is socket exception or not.
  final bool isSocketException;

  const ExceptionHttpResponse._({
    required String message,
    required this.code,
    required this.stackTrace,
    this.detail,
    this.isSocketException = false,
  }) : super._(message: message, statusCode: code);

  @override
  String toString() {
    return 'ExceptionHttpResponse{message: $message, code: $code, stackTrace: $stackTrace, detail: $detail, isSocketException: $isSocketException}';
  }
}
