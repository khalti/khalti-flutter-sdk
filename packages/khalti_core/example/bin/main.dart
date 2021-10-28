//ignore_for_file: avoid_print

import 'dart:io';

import 'package:khalti_core/khalti_core.dart';
import 'package:khalti_core_example/khalti_http_client.dart';

final service = KhaltiService(client: KhaltiHttpClient());

Future<void> main() async {
  KhaltiService.enableDebugging = true;
  KhaltiService.publicKey = 'test_public_key_dc74e0fd57cb46cd93832aee0a507256';

  print('[1] Wallet Payment');
  print('[2] List EBanking Banks');
  print('[3] List MBanking Banks');
  print('[4] Build Bank Payment Url');

  stdout.write('Choose option: ');
  final option = stdin.readLineSync() ?? '';

  switch (option) {
    case '1':
      _walletPayment();
      break;
    case '2':
      _printEBankingBanks();
      break;
    case '3':
      _printMBankingBanks();
      break;
    case '4':
      _buildBankPaymentUrl();
      break;
    default:
      print('Not a valid option!');
  }
}

Future<void> _walletPayment() async {
  stdout.write('Enter Khalti Mobile Number: ');
  final mobile = stdin.readLineSync() ?? '';
  stdout.write('Enter Khalti MPIN: ');
  final mPin = stdin.readLineSync() ?? '';

  print('Initiating Transaction ...');
  final initiationModel = await service.initiatePayment(
    request: PaymentInitiationRequestModel(
      amount: 1000,
      mobile: mobile,
      productIdentity: 'mac-mini',
      productName: 'Apple Mac Mini',
      transactionPin: mPin,
      productUrl: 'https://khalti.com/bazaar/mac-mini-16-512-m1',
      additionalData: {
        'vendor': 'Oliz Store',
        'manufacturer': 'Apple Inc.',
      },
    ),
  );

  stdout.write('Enter OTP Code: ');
  final token = stdin.readLineSync() ?? '';

  print('Confirming Transaction ...');
  final model = await service.confirmPayment(
    request: PaymentConfirmationRequestModel(
      confirmationCode: token,
      token: initiationModel.token,
      transactionPin: mPin,
    ),
  );
  print(model);
}

Future<void> _printEBankingBanks() async {
  final model = await service.getBanks(paymentType: PaymentType.eBanking);
  print('EBanking Banks');
  print(model.banks.join('\n'));
}

Future<void> _printMBankingBanks() async {
  final model = await service.getBanks(
    paymentType: PaymentType.mobileCheckout,
  );
  print('MBanking Banks');
  print(model.banks.join('\n'));
}

void _buildBankPaymentUrl() {
  stdout.write('Enter Khalti Mobile Number: ');
  final mobile = stdin.readLineSync() ?? '';

  final url = service.buildBankUrl(
    bankId: '1234567890',
    amount: 1000,
    mobile: mobile,
    productIdentity: 'macbook-pro-21',
    productName: 'Macbook Pro 2021',
    paymentType: PaymentType.eBanking,
    returnUrl: 'https://khalti.com',
  );
  print(url);
}
