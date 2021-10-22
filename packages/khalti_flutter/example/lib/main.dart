import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

const String testPublicKey = 'test_public_key_dc74e0fd57cb46cd93832aee0a507256';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: testPublicKey,
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
          debugShowCheckedModeBanner: false,
          navigatorKey: navKey,
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = PaymentConfig(
      amount: 1000,
      productIdentity: 'test-product',
      productName: 'Test Product',
      productUrl: 'https://khalti.com',
      additionalData: {
        'vendor': 'Khalti Bazaar',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Khalti Payment Gateway'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          KhaltiButton(
            config: config,
            onSuccess: onSuccess,
            onFailure: onFailure,
          ),
          GestureDetector(
            onTap: () {
              KhaltiScope.of(context).pay(
                config: config,
                preferences: [
                  PaymentPreference.khalti,
                  PaymentPreference.eBanking,
                ],
                onSuccess: onSuccess,
                onFailure: onFailure,
                onCancel: onCancel,
              );
            },
            child: Material(
              shape: StadiumBorder(),
              color: Colors.orange,
              child: SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    'CUSTOM PAY',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    print('Success: $success');
  }

  void onFailure(PaymentFailureModel failure) {
    print('Failure; $failure');
  }

  void onCancel() {
    print('Cancelled');
  }
}
