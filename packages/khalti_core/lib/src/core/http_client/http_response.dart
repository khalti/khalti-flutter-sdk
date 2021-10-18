class HttpResponse {
  const HttpResponse._({this.data, this.statusCode, this.message});

  final Object? data;
  final int? statusCode;
  final String? message;

  factory HttpResponse.success({
    required Object data,
    required int statusCode,
  }) = SuccessHttpResponse;

  factory HttpResponse.failure({
    required Object data,
    required int statusCode,
  }) = FailureHttpResponse;

  factory HttpResponse.exception({
    required String message,
    required int code,
    required StackTrace stackTrace,
    Object? detail,
  }) = ExceptionHttpResponse;
}

class SuccessHttpResponse extends HttpResponse {
  final Object data;
  final int statusCode;

  const SuccessHttpResponse({required this.data, required this.statusCode})
      : super._(data: data, statusCode: statusCode);

  @override
  String toString() {
    return 'SuccessHttpResponse{data: $data, statusCode: $statusCode}';
  }
}

class FailureHttpResponse extends HttpResponse {
  final Object data;
  final int statusCode;

  const FailureHttpResponse({required this.data, required this.statusCode})
      : super._(data: data, statusCode: statusCode);

  @override
  String toString() {
    return 'FailureHttpResponse{data: $data, statusCode: $statusCode}';
  }
}

class ExceptionHttpResponse extends HttpResponse {
  final String message;
  final int code;
  final StackTrace stackTrace;
  final Object? detail;

  const ExceptionHttpResponse({
    required this.message,
    required this.code,
    required this.stackTrace,
    this.detail,
  }) : super._(message: message, statusCode: code);

  @override
  String toString() {
    return 'ExceptionHttpResponse{message: $message, code: $code, stackTrace: $stackTrace, detail: $detail}';
  }
}
