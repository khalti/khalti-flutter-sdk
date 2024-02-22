import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: 'live_secret_key_68791341fdd94846a146f0457ff7b455',
      pidx: 'uhn5Bne5iGWGbYib6iVhJ4',
      returnUrl: Uri.parse('https://khalti.com'),
      environment: Environment.test,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult) {
        log(paymentResult.toString());
      },
      onMessage: ({description, statusCode}) async {
        log(
          'Super Description: $description, Super Status Code: $statusCode',
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
                    SvgPicture.asset(
                      'assets/khalti.svg',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text('Pay with Khalti')
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
