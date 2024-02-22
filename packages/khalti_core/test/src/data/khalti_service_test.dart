// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'dart:async';

import 'package:khalti_core/khalti_core.dart';
import 'package:test/test.dart';

import '../core/http_client/khalti_client_mock.dart';

void main() {
  final mockClient = KhaltiClientMock();
  final service = KhaltiService(client: mockClient);

  setUp(() {
    KhaltiService.publicKey = 'test-public-key';
  });

  group(
    'KhaltiService tests | ',
    () {
      test(
        'throws assertion error if public key was not set before accessing',
        () {
          KhaltiService.publicKey = '';

          expect(() => KhaltiService.publicKey, throwsA(isA<AssertionError>()));
        },
      );

      test(
        'verify() : success',
        () async {
          mockClient.response = HttpResponse.success(
            data: {
              "pidx": "eBjn5R4iUB82JnKCHjE7eG",
              "total_amount": 1000,
              "status": "Pending",
              "transaction_id": 'Ax12NiopxWpalol7rI',
              "fee": 0,
              "refunded": false
            },
            statusCode: 200,
          );
          final response = await service.verify('pidx-1234');

          expect(
            response,
            isA<PaymentVerificationResponseModel>()
                .having((model) => model.pidx, 'pidx', 'eBjn5R4iUB82JnKCHjE7eG')
                .having((model) => model.totalAmount, 'Total Amount', 1000)
                .having((model) => model.status, 'Status', 'Pending')
                .having((model) => model.fee, 'Fee', 0)
                .having((model) => model.refunded, 'Refunded', false)
                .having(
                  (model) => model.transactionId,
                  'TransactionId',
                  'Ax12NiopxWpalol7rI',
                ),
          );
        },
      );
    },
  );

  group(
    'KhaltiService log tests | ',
    () {
      test(
        'calling service methods logs the network calls if enableDebugging is true',
        () {
          final logs = <String>[];

          Zone.current.fork(
            specification: ZoneSpecification(
              print: (_, __, ___, String msg) {
                logs.add(msg);
              },
            ),
          ).run<void>(
            () async {
              KhaltiService.enableDebugging = true;

              mockClient.response = HttpResponse.success(
                data: {
                  "pidx": "eBjn5R4iUB82JnKCHjE7eG",
                  "total_amount": 1000,
                  "status": "Pending",
                  "transaction_id": 'Ax12NiopxWpalol7rI',
                  "fee": 0,
                  "refunded": false
                },
                statusCode: 200,
              );

              await service.verify('CMPrCaLxUFB8hiTcNmngr4');

              expect(
                logs.contains(
                  '[POST] https://khalti.com/api/v2/epayment/lookup/',
                ),
                true,
              );

              expect(
                logs.contains(
                  '[Request Data] CMPrCaLxUFB8hiTcNmngr4',
                ),
                true,
              );
            },
          );
        },
      );
    },
  );
}
