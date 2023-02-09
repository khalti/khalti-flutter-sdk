// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/assets.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_config_scope.dart';
import 'package:khalti_flutter/src/page/confirmation_page.dart';
import 'package:khalti_flutter/src/util/url_launcher_util.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/dialogs.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';
import 'package:khalti_flutter/src/widget/responsive_box.dart';

/// The page for making payments using Khalti wallet balance.
class WalletPaymentPage extends StatefulWidget {
  /// Creates [WalletPaymentPage].
  const WalletPaymentPage({Key? key}) : super(key: key);

  @override
  State<WalletPaymentPage> createState() => _WalletPaymentPageState();
}

class _WalletPaymentPageState extends State<WalletPaymentPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late final ValueNotifier<int> _remainingAttempts;

  String? _mobile, _mPin;

  @override
  void initState() {
    super.initState();
    _remainingAttempts = ValueNotifier(-1);
  }

  @override
  void dispose() {
    _remainingAttempts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final subtitle1 = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: KhaltiColor.of(context).surface.shade300,
          fontWeight: FontWeight.w300,
        );

    final config = PaymentConfigScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ResponsiveBox(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: KhaltiImage.asset(asset: a_khaltiLogo, height: 72),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _remainingAttempts,
                builder: (context, remainingAttempts, _) {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: remainingAttempts.isNegative
                        ? Container(height: 1)
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Text(
                              KhaltiLocalizations.of(context).attemptsRemaining(
                                remainingAttempts,
                              ),
                              style: subtitle1,
                            ),
                          ),
                  );
                },
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
                onPressed: () => _initiatePayment(config),
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _initiatePayment(PaymentConfig config) async {
    if (_formKey.currentState?.validate() ?? false) {
      showProgressDialog(
        context,
        message: context.loc.initiatingPayment,
      );

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
        _remainingAttempts.value = -1;
        if (!mounted) return;
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
                  isDark: Theme.of(context).brightness == Brightness.dark,
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
        _showRemainingAttempts(e);
        Navigator.pop(context);
        showErrorDialog(
          context,
          error: e,
          onPressed: () => Navigator.pop(context),
        );
      }
    }
  }

  void _showRemainingAttempts(Object e) {
    if (e is FailureHttpResponse) {
      final data = e.data;
      if (data is Map && data.containsKey('tries_remaining')) {
        _remainingAttempts.value = int.tryParse(data['tries_remaining']) ?? -1;
      }
    }
  }
}

class _ResetMPINSection extends StatefulWidget {
  const _ResetMPINSection({Key? key}) : super(key: key);

  @override
  State<_ResetMPINSection> createState() => _ResetMPINSectionState();
}

class _ResetMPINSectionState extends State<_ResetMPINSection> {
  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).textTheme.labelLarge;

    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(144, 40),
          textStyle: buttonStyle?.copyWith(fontSize: 14),
        ),
        child: Text(context.loc.resetKhaltiMPIN.toUpperCase()),
        onPressed: () async {
          final appInstalled = await urlLauncher.launchMPINSetting();

          if (!appInstalled && mounted) {
            showInfoDialog(
              context,
              title: context.loc.resetKhaltiMPIN,
              body: _ResetMPINDialogBody(parentContext: context),
            );
          }
        },
      ),
    );
  }
}

class _ResetMPINDialogBody extends StatelessWidget {
  const _ResetMPINDialogBody({
    Key? key,
    required this.parentContext,
  }) : super(key: key);

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.loc.khaltiNotInstalledMessage),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () async {
            urlLauncher.openStoreToInstallKhalti(
              Theme.of(context).platform,
            );
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
            urlLauncher.openResetPinPageInBrowser();
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
            foregroundColor: KhaltiColor.of(parentContext).surface.shade100,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(context.loc.cancel.toUpperCase()),
        ),
      ],
    );
  }
}
