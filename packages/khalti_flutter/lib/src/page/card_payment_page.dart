// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/helper/assets.dart';
import 'package:khalti_flutter/src/helper/payment_config_scope.dart';
import 'package:khalti_flutter/src/util/url_launcher_util.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';
import 'package:khalti_flutter/src/widget/responsive_box.dart';

/// The page for making payments using SCT Cards or Connect IPS.
class CardPaymentPage extends StatefulWidget {
  /// Creates [CardPaymentPage] with the provided [paymentType].
  const CardPaymentPage({
    Key? key,
    required this.paymentType,
  }) : super(key: key);

  /// The [PaymentType].
  final PaymentType paymentType;

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage>
    with AutomaticKeepAliveClientMixin {
  String? _mobile;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final config = PaymentConfigScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ResponsiveBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: KhaltiImage.asset(
                asset: widget.paymentType == PaymentType.connectIPS
                    ? a_connectIpsLogo
                    : a_sctLogo,
                height: 100,
              ),
            ),
            MobileField(onChanged: (mobile) => _mobile = mobile),
            const SizedBox(height: 24),
            PayButton(
              amount: config.amount,
              onPressed: () async {
                final url = Khalti.service.buildBankUrl(
                  bankId: widget.paymentType.value,
                  mobile: _mobile!,
                  amount: config.amount,
                  productIdentity: config.productIdentity,
                  productName: config.productName,
                  paymentType: widget.paymentType,
                  productUrl: config.productUrl,
                  additionalData: config.additionalData,
                  returnUrl: config.returnUrl,
                );
                await urlLauncher.launch(url);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
