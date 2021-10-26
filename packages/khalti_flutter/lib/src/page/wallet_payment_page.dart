import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/payment_config_provider.dart';
import 'package:khalti_flutter/src/page/confirmation_page.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/dialogs.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class WalletPaymentPage extends StatefulWidget {
  const WalletPaymentPage({Key? key}) : super(key: key);

  @override
  State<WalletPaymentPage> createState() => _WalletPaymentPageState();
}

class _WalletPaymentPageState extends State<WalletPaymentPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? _mobile, _mPin;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final config = PaymentConfigScope.of(context);

    return Form(
      key: _formKey,
      child: ListView(
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
              if (_formKey.currentState?.validate() ?? false) {
                showProgressDialog(context,
                    message: context.loc.initiatingPayment);
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
                    title: context.loc.success,
                    subtitle: context.loc.paymentInitiationSuccessMessage,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KhaltiColor(
                            isDark:
                                Theme.of(context).brightness == Brightness.dark,
                            child: Theme(
                              data: Theme.of(context),
                              child: ConfirmationPage(
                                mobileNo: _mobile!,
                                mPin: _mPin!,
                                token: response.token,
                              ),
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
              }
            },
          ),
          const SizedBox(height: 40),
          Text(
            context.loc.forgotPin,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: KhaltiColor.of(context).surface.shade300,
            ),
          ),
          const SizedBox(height: 8),
          const _ResetMPINSection(),
        ],
      ),
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
        child: Text(context.loc.resetKhaltiMPIN.toUpperCase()),
        onPressed: () async {
          try {
            await launcher.launch('khalti://go/?t=mpin');
          } on PlatformException {
            showInfoDialog(
              context,
              title: context.loc.resetKhaltiMPIN,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(context.loc.khaltiNotInstalledMessage),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () async {
                      final platform = Theme.of(context).platform;
                      if (platform == TargetPlatform.android) {
                        launcher.launch(
                          'https://play.google.com/store/apps/details?id=com.khalti',
                        );
                      } else if (platform == TargetPlatform.iOS) {
                        launcher.launch(
                          'https://apps.apple.com/us/app/khalti-digital-wallet-nepal/id1263400741',
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(context.loc.installKhalti.toUpperCase()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  TextButton(
                    onPressed: () {
                      launcher.launch(
                        'https://khalti.com/#/account/transaction_pin',
                      );
                      Navigator.pop(context);
                    },
                    child: Text(context.loc.proceedUsingBrowser.toUpperCase()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: KhaltiColor.of(context).surface.shade100,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.loc.cancel.toUpperCase()),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
