import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      home: KhaltiSDKDemo(),
    ),
  );
}

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti?> khalti;

  String pidx =
      'GM8tsmvxwQvZq2soX3V4BW'; // Should be generated via a server-side POST request.

  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: 'live_public_key_979320ffda734d8e9f7758ac39ec775f',
      pidx: pidx,
      returnUrl: Uri.parse('https://docs.khalti.com/khalti-epayment/'),
      environment: Environment.test,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log(paymentResult.toString());
        setState(() {
          this.paymentResult = paymentResult;
        });
        khalti.close(context);
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        khalti.close(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: khalti,
          initialData: null,
          builder: (context, snapshot) {
            final khaltiSnapshot = snapshot.data;
            if (khaltiSnapshot == null) {
              return const CircularProgressIndicator.adaptive();
            }
            return Column(
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
                  onPressed: () => khaltiSnapshot.open(context),
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
            );
          },
        ),
      ),
    );
  }
}
