import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() {
  runApp(const KhaltiSDKDemo());
}

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti> khalti;

  String pidx = 'BpKSTiKUMigAaEcx6gUUA7';

  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: 'live_public_key_979320ffda734d8e9f7758ac39ec775f',
      pidx: pidx,
      returnUrl: Uri.parse(
        'https://webhook.site/ed508278-3ce3-4f6d-98f1-0b6084c5c5cd',
      ),
      environment: Environment.test,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult) {
        log(paymentResult.toString());
        setState(() {
          this.paymentResult = paymentResult;
        });
      },
      onMessage: ({
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<Khalti>(
          future: khalti,
          builder: (context, snapshot) {
            final khalti = snapshot.data;
            if (khalti == null) {
              return const CircularProgressIndicator.adaptive();
            }
            return Center(
              child: GestureDetector(
                onTap: () => khalti.start(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/seru.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 120),
                    const Text(
                      'Rs. 22',
                      style: TextStyle(fontSize: 25),
                    ),
                    const Text('1 day fee'),
                    OutlinedButton(
                      onPressed: () => khalti.start(context),
                      child: const Text('Pay with Khalti'),
                    ),
                    const SizedBox(height: 120),
                    paymentResult == null
                        ? Text(
                            'pidx: $pidx',
                            style: const TextStyle(fontSize: 15),
                          )
                        : Column(
                            children: [
                              Text(
                                'pidx: ${paymentResult!.payload?.pidx}',
                              ),
                              Text('Status: ${paymentResult!.status}'),
                              Text(
                                'Amount Paid: ${paymentResult!.payload?.amount}',
                              ),
                              Text(
                                'Transaction ID: ${paymentResult!.payload?.transactionId}',
                              ),
                            ],
                          ),
                    const SizedBox(height: 120),
                    const Text(
                      'This is a demo application developed by some merchant.',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
