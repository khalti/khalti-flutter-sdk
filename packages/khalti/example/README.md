# Khalti Payment Gateway Example

```dart
import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Khalti.init(
    publicKey: 'test_public_key_dc74e0fd57cb46cd93832aee0a507256',
    enabledDebugging: false,
  );

  runApp(
    MaterialApp(
      home: KhaltiExampleApp(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    ),
  );
}

class KhaltiExampleApp extends StatelessWidget {
  const KhaltiExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('KPG Example'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Wallet Payment'),
              Tab(text: 'EBanking'),
              Tab(text: 'MBanking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WalletPayment(),
            Banking(paymentType: BankPaymentType.eBanking),
            Banking(paymentType: BankPaymentType.mobileCheckout),
          ],
        ),
      ),
    );
  }
}

class WalletPayment extends StatefulWidget {
  const WalletPayment({Key? key}) : super(key: key);

  @override
  State<WalletPayment> createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  late final TextEditingController _mobileController, _pinController;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: InputDecoration(
              label: Text('Mobile Number'),
            ),
            controller: _mobileController,
          ),
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: InputDecoration(
              label: Text('Khalti MPIN'),
            ),
            controller: _pinController,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (!(_formKey.currentState?.validate() ?? false)) return;

              final initiationModel = await Khalti.service.initiatePayment(
                request: PaymentInitiationRequestModel(
                  amount: 1000,
                  mobile: _mobileController.text,
                  productIdentity: 'mac-mini',
                  productName: 'Apple Mac Mini',
                  transactionPin: _pinController.text,
                  productUrl: 'https://khalti.com/bazaar/mac-mini-16-512-m1',
                  additionalData: {
                    'vendor': 'Oliz Store',
                    'manufacturer': 'Apple Inc.',
                  },
                ),
              );

              final otpCode = await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  String? _otp;
                  return AlertDialog(
                    title: Text('OTP Sent!'),
                    content: TextField(
                      decoration: InputDecoration(
                        label: Text('OTP Code'),
                      ),
                      onChanged: (v) => _otp = v,
                    ),
                    actions: [
                      SimpleDialogOption(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context, _otp),
                      )
                    ],
                  );
                },
              );

              if (otpCode != null) {
                try {
                  final model = await Khalti.service.confirmPayment(
                    request: PaymentConfirmationRequestModel(
                      confirmationCode: otpCode,
                      token: initiationModel.token,
                      transactionPin: _pinController.text,
                    ),
                  );

                  print(model);
                } catch (e) {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: Text('PAY Rs. 10'),
          ),
        ],
      ),
    );
  }
}

class Banking extends StatefulWidget {
  const Banking({Key? key, required this.paymentType}) : super(key: key);

  final BankPaymentType paymentType;

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BankListModel>(
      future: Khalti.service.getBanks(paymentType: widget.paymentType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final banks = snapshot.data!.banks;
          return ListView.builder(
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final bank = banks[index];

              return ListTile(
                leading: SizedBox.square(
                  dimension: 40,
                  child: Image.network(bank.logo),
                ),
                title: Text(bank.name),
                subtitle: Text(bank.shortName),
                onTap: () async {
                  final mobile = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String? _mobile;
                      return AlertDialog(
                        title: Text('Enter Mobile Number'),
                        content: TextField(
                          decoration: InputDecoration(
                            label: Text('Mobile Number'),
                          ),
                          onChanged: (v) => _mobile = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: Text('OK'),
                            onPressed: () => Navigator.pop(context, _mobile),
                          )
                        ],
                      );
                    },
                  );

                  if (mobile != null) {
                    final url = Khalti.service.buildBankUrl(
                      bankId: bank.idx,
                      amount: 1000,
                      mobile: mobile,
                      productIdentity: 'macbook-pro-21',
                      productName: 'Macbook Pro 2021',
                      paymentType: widget.paymentType,
                    );

                    print(url);
                    urlLauncher.launch(url);
                  }
                },
              );
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

```
