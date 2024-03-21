import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

/// Helper function that handles exception when verify api is called.
Future<void> handleException({
  required Future<PaymentVerificationResponseModel> Function() caller,
  required OnPaymentResult onPaymentResult,
  required OnMessage onMessage,
  required Khalti khalti,
}) async {
  try {
    final result = await caller();
    return onPaymentResult(
      PaymentResult(
        status: result.status,
        payload: PaymentPayload(
          pidx: result.pidx,
          amount: result.totalAmount,
          transactionId: result.transactionId,
        ),
      ),
      khalti,
    );
  } on ExceptionHttpResponse catch (e) {
    return onMessage(
      statusCode: e.statusCode,
      description: e.detail,
      event: KhaltiEvent.networkFailure,
      needsPaymentConfirmation: true,
      khalti,
    );
  } on FailureHttpResponse catch (e) {
    return onMessage(
      statusCode: e.statusCode,
      description: e.data,
      event: KhaltiEvent.paymentLookupfailure,
      needsPaymentConfirmation: false,
      khalti,
    );
  }
}
