import 'package:khalti_core/khalti_core.dart';
import 'package:test/test.dart';

void main() {
  group('BankModel tests | ', () {
    test('correct stringification for bank model', () {
      final bankModel = BankModel(
        idx: 'idx',
        logo: 'logo',
        name: 'name',
        shortName: 'short',
      );

      expect(
        bankModel.toString(),
        'BankModel{idx: idx, logo: logo, name: name, shortName: short}',
      );

      expect(
        bankModel.hashCode,
        _hashCodeFromStrings(['idx', 'logo', 'name', 'short']),
      );
    });

    test('correct stringification for bank list model', () {
      final bankListModel = BankListModel.fromMap({
        'records': 'invalid',
        'next': 'next',
        'previous': 'previous',
      });

      expect(
        bankListModel.toString(),
        'BankListModel{banks: [], currentPage: 1, recordRange: [], totalPages: 1, totalRecords: 0, next: next, previous: previous}',
      );
    });
  });
}

int _hashCodeFromStrings(List<String> values) {
  return values.fold(0, (o, n) => o.hashCode ^ n.hashCode);
}
