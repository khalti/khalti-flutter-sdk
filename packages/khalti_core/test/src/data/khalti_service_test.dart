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

    test('getBanks() : success', () async {
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
      final response = await service.getBanks(
        paymentType: PaymentType.eBanking,
      );
      expect(response.banks, [
        BankModel(
          idx: '',
          logo: '',
          name: 'NIC Asia Bank Limited',
          shortName: 'NICA',
        ),
        BankModel(
          idx: '',
          logo: '',
          name: 'Himalayan Bank Limited',
          shortName: 'HBL',
        ),
      ]);
    });

    test('getBanks() : failure', () async {
      mockClient.response = HttpResponse.failure(
        data: 'Could not fetch banks',
        statusCode: 403,
      );
      expect(
        () => service.getBanks(
          paymentType: PaymentType.eBanking,
        ),
        throwsA(isA<FailureHttpResponse>()),
      );
    });

    test('getBanks() : exception', () async {
      mockClient.response = HttpResponse.exception(
        message: 'No internet',
        code: 4,
        stackTrace: StackTrace.empty,
      );
      expect(
        () => service.getBanks(
          paymentType: PaymentType.eBanking,
        ),
        throwsA(isA<ExceptionHttpResponse>()),
      );
    });

    test('initiatePayment() : success', () async {
      mockClient.response = HttpResponse.success(
        data: {
          'token': 'test-token',
        },
        statusCode: 200,
      );
      final response = await service.initiatePayment(
        request: PaymentInitiationRequestModel(
          amount: 1000,
          mobile: '9810023456',
          productIdentity: 'test-product',
          productName: 'test product',
          transactionPin: '0000',
          additionalData: {
            'vendor': 'Khalti',
          },
        ),
      );
      expect(response.token, 'test-token');
    });

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

    test('buildBankUrl() builds correct bank payment URL', () async {
      KhaltiService.config = KhaltiConfig(
        platform: 'iOS',
        osVersion: '15.2',
        deviceModel: 'iOS',
        deviceManufacturer: 'Apple Inc.',
        packageName: 'com.khalti.test',
        packageVersion: '3.0.0',
      );

      final url = service.buildBankUrl(
        bankId: 'sct',
        mobile: '9841000000',
        amount: 10000,
        productIdentity: 'test-product',
        productName: 'Test Product',
        paymentType: PaymentType.sct,
        returnUrl: 'khalti://pay',
        productUrl: 'https://khalti.com/bazaar/test-product',
        additionalData: {
          'image_url': 'https://cdn.khalti.com/image.png',
        },
      );

      final uri = Uri.parse(url);

      expect(uri.scheme, 'https');
      expect(uri.authority, 'khalti.com');
      expect(uri.path, '/ebanking/initiate/');
      expect(
        uri.queryParameters,
        {
          'bank': 'sct',
          'public_key': 'test-public-key',
          'amount': '10000',
          'mobile': '9841000000',
          'product_identity': 'test-product',
          'product_name': 'Test Product',
          'source': 'custom',
          'checkout-version': KhaltiConfig.platformOnly().version,
          'checkout-platform': 'iOS',
          'checkout-os-version': '15.2',
          'checkout-device-model': 'iOS',
          'checkout-device-manufacturer': 'Apple Inc.',
          'merchant-package-name': 'com.khalti.test',
          'merchant-package-version': '3.0.0',
          'product_url': 'https://khalti.com/bazaar/test-product',
          'merchant_image_url': 'https://cdn.khalti.com/image.png',
          'return_url': 'khalti://pay',
          'payment_type': 'sct'
        },
      );
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
            await service.getBanks(
              paymentType: PaymentType.eBanking,
            );
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
