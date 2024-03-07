import 'package:khalti_flutter/khalti_flutter.dart';

/// Helper function that handles exception when verify api is called.
Future<void> handleException({
  required String pidx,
  required Future<PaymentVerificationResponseModel> Function(String) caller,
  required OnPaymentResult onPaymentResult,
  required OnMessage onMessage,
}) async {
  try {
    final result = await caller(pidx);
    return onPaymentResult(
      PaymentResult(
        status: result.status,
        payload: PaymentPayload(
          pidx: result.pidx,
          amount: result.totalAmount,
          transactionId: result.transactionId,
        ),
      ),
    );
  } on ExceptionHttpResponse catch (e) {
    return onMessage(
      statusCode: e.statusCode,
      description: e.detail,
    );
  } on FailureHttpResponse catch (e) {
    return onMessage(
      statusCode: e.statusCode,
      description: e.data,
    );
  }
}
