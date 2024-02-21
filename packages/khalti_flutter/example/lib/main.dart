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

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: '',
      pidx: 'Aq6WSKPKwKxHFum6ufGDCS',
      returnUrl: Uri.parse('https://khalti.com'),
      environment: Environment.test,
    );

    khalti = Khalti.init(
      payConfig: payConfig,
      onPaymentResult: print,
      onMessage: ({description, statusCode}) async {
        print('Description: $description, Status Code: $statusCode');
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
              child: TextButton(
                onPressed: () {
                  khalti.start(context);
                },
                child: const Text('Pay with Khalti'),
              ),
            );
          },
        ),
      ),
    );
  }
}
