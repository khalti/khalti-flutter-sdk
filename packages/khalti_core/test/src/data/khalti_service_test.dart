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

  group('KhaltiService tests | ', () {
    test(
      'throws assertion error if public key was not set before accessing',
      () {
        KhaltiService.publicKey = '';

        expect(() => KhaltiService.publicKey, throwsA(isA<AssertionError>()));
      },
    );

    test('confirmPayment() : success', () async {
      mockClient.response = HttpResponse.success(
        data: {
          'token': 'test-token',
          'merchant_image_url': 'https://cdn.khalti.com/image.png',
          'product_name': 'Test Product',
          'product_identity': 'test-product',
          'product_url': 'https://khalti.com/bazaar/test-product',
          'amount': 1000,
          'mobile': '9810000000',
        },
        statusCode: 200,
      );
      final response = await service.confirmPayment(
        request: PaymentConfirmationRequestModel(
          transactionPin: '0000',
          confirmationCode: '123456',
          token: 'test-token',
        ),
      );
      expect(response.token, 'test-token');
      expect(
        response.additionalData,
        {'image_url': 'https://cdn.khalti.com/image.png'},
      );
      expect(response.productName, 'Test Product');
      expect(response.productIdentity, 'test-product');
      expect(response.productUrl, 'https://khalti.com/bazaar/test-product');
      expect(response.amount, 1000);
      expect(response.mobile, '9810000000');
    });
  });

  group('KhaltiService log tests | ', () {
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
                'records': [
                  {
                    'name': 'NIC Asia Bank Limited',
                    'short_name': 'NICA',
                  },
                  {
                    'name': 'Himalayan Bank Limited',
                    'short_name': 'HBL',
                  },
                ],
              },
              statusCode: 200,
            );
            // await service.getBanks(
            //   paymentType: PaymentType.eBanking,
            // );
            expect(logs[1], '[GET] https://khalti.com/api/v2/bank/');
            expect(
              logs[2],
              '[Query Parameters] {page: 1, page_size: 200, payment_type: ebanking}',
            );
            expect(
              logs[6],
              '[Response] SuccessHttpResponse{data: {records: [{name: NIC Asia Bank Limited, short_name: NICA}, {name: Himalayan Bank Limited, short_name: HBL}]}, statusCode: 200}',
            );
          },
        );
      },
    );
  });
}
