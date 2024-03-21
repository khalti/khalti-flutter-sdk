import 'package:khalti_checkout_core/src/core/khalti_request_model.dart';
import 'package:test/test.dart';

void main() {
  final model = TestRequestModel(id: 101);

  group('KhaltiRequestModel tests | ', () {
    test('conversion to map', () {
      expect(
        model.toMap(),
        {'id': 101},
      );
    });

    test('conversion to json string', () {
      expect(
        model.toJson(),
        '{"id":101}',
      );
    });

    test('conversion to beautified json string', () {
      expect(
        model.toJson(beautify: true),
        '''
{
  "id": 101
}''',
      );
    });
  });
}

class TestRequestModel extends KhaltiRequestModel {
  TestRequestModel({required this.id});
  final int id;

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
    };
  }
}
