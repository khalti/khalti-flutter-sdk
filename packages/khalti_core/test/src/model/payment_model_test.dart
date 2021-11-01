import 'package:khalti_core/khalti_core.dart';
import 'package:test/test.dart';

void main() {
  group('Payment Model tests | ', () {
    test('correct stringification for payment initiation request model', () {
      final model = PaymentInitiationResponseModel.fromMap(
        {'token': 'test-token'},
      );

      expect(
        model.toString(),
        'PaymentInitiationResponseModel{token: test-token, pinCreated: false, pinCreatedMessage: }',
      );
    });

    test('correct stringification for payment success model', () {
      final model = PaymentSuccessModel.fromMap(
        {'idx': 'test-idx'},
      );

      expect(
        model.toString(),
        'PaymentSuccessModel{idx: test-idx, amount: 0, mobile: , productIdentity: , productName: , token: , additionalData: {}}',
      );
    });

    test('payment failure model', () {
      final failureModel = PaymentFailureModel(
        message: 'message',
        data: {'id': 'test-id'},
      );

      expect(failureModel.message, 'message');
      expect(failureModel.data['id'], 'test-id');
    });
  });
}
