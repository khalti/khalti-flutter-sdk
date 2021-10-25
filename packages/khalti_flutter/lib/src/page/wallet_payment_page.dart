import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/helper/payment_config_provider.dart';
import 'package:khalti_flutter/src/page/confirmation_page.dart';
import 'package:khalti_flutter/src/widget/dialogs.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';

class WalletPaymentPage extends StatefulWidget {
  const WalletPaymentPage({Key? key}) : super(key: key);

  @override
  State<WalletPaymentPage> createState() => _WalletPaymentPageState();
}

class _WalletPaymentPageState extends State<WalletPaymentPage>
    with AutomaticKeepAliveClientMixin {
  String? _mobile, _mPin;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final config = PaymentConfigScope.of(context);

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: KhaltiImage.asset(asset: 'logo/khalti.svg', height: 72),
        ),
        MobileField(
          onChanged: (mobile) => _mobile = mobile,
        ),
        const SizedBox(height: 24),
        PINField(
          onChanged: (pin) => _mPin = pin,
        ),
        const SizedBox(height: 24),
        PayButton(
          amount: config.amount,
          onPressed: () async {
            showProgressDialog(context, message: 'Initiating Payment');
            try {
              final response = await Khalti.service.initiatePayment(
                request: PaymentInitiationRequestModel(
                  mobile: _mobile!,
                  transactionPin: _mPin!,
                  amount: config.amount,
                  productIdentity: config.productIdentity,
                  productName: config.productName,
                  productUrl: config.productUrl,
                  additionalData: config.additionalData,
                ),
              );
              Navigator.pop(context);
              showSuccessDialog(
                context,
                title: 'Success',
                subtitle:
                    'Khalti has sent a confirmation code in your Khalti registered number and email address.',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Theme(
                        data: Theme.of(context),
                        child: ConfirmationPage(
                          mobileNo: _mobile!,
                          mPin: _mPin!,
                          token: response.token,
                        ),
                      ),
                    ),
                  );
                },
              );
            } catch (e) {
              Navigator.pop(context);
              showErrorDialog(
                context,
                error: e,
                onPressed: () => Navigator.pop(context),
              );
            }
          },
        ),
        const SizedBox(height: 40),
        Text(
          'Forgot Khalti MPIN?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF5B5B5B),
          ),
        ),
        const SizedBox(height: 8),
        const _ResetMPINSection(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ResetMPINSection extends StatelessWidget {
  const _ResetMPINSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(144, 40),
          textStyle: Theme.of(context).textTheme.button?.copyWith(
                fontSize: 14,
              ),
        ),
        child: Text('RESET KHALTI MPIN'),
        onPressed: () {},
      ),
    );
  }
}
